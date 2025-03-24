//
//  DetectPolygon.hpp
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 04/03/2025.
//

#include "ScannerStep.hpp"
#include <opencv2/opencv.hpp>

using namespace cv;

class DetectPolygon: public ScannerStep {
    
public:
    using PointCallback = std::function<void(const std::vector<cv::Point>&)>;
    
    DetectPolygon(PointCallback callback): pointCallback(callback) {
        maxDistance = 80.0;
        minAreaThres = 1/5;
    }
    
    void handle(cv::Mat &mat) override {
        Point2f imageCenter(mat.size().width / 2 , mat.size().height / 2);
        double minArea = (mat.size().width * mat.size().height) * 0.25;
        std::vector<std::vector<cv::Point>> contours;
        std::vector<cv::Vec4i> hierarchy;
        findContours(mat, contours, hierarchy, RETR_LIST, CHAIN_APPROX_SIMPLE);
        contours = filterContours(50.0, minArea, imageCenter, contours);
        
        if (contours.empty()) {
            pointCallback({});
            return;
        }
        int index = getMaxContourIndex(contours);
        
        if (index < 0) {
            pointCallback({});
            return;
        }
        std::vector<cv::Point> hullContour = getConvexContour(contours[index]);
        std::vector<cv::Point2f> points = getCornerPoints(hullContour);
        points = sortCorners(points);
        
        if (points.size() < 4) {
            pointCallback({});
            return;
        }

        std::vector<cv::Point> intPoints;
        for (const auto& pt : points) {
            intPoints.emplace_back(cv::Point(cvRound(pt.x), cvRound(pt.y)));
        }
        
        //std::cout << "DetectPolygon" << intPoints << std::endl;
        

        auto iterator = std::find_if(intPoints.begin(), intPoints.end(), [](cv::Point point){
            return (point.x == 0 || point.y == 0);
        });
        
        if (iterator != intPoints.end()) {
            pointCallback({});
            return;
        }

        pointCallback(intPoints);
    };
    
    private:
        PointCallback pointCallback;
        double maxDistance;
        double minAreaThres;
    
    int getMaxContourIndex(std::vector<std::vector<cv::Point>> contours) {
        double maxArea = 0;
        int maxContourIndex = -1;

        for (int i = 0; i < contours.size(); ++i) {
            double area = contourArea(contours[i]);
            if (area > maxArea) {
                maxArea = area;
                maxContourIndex = i;
            }
        }
        return maxContourIndex;
    };
    
    double getDistance(cv::Point p1, cv::Point p2) {
      return hypot(p1.x - p2.x, p1.y - p2.y);
    };
    
    std::vector<std::vector<cv::Point>> filterContours(double maxDistance, double minArea, Point2f imageCenter, std::vector<std::vector<cv::Point>>& contours) {
        std::vector<std::vector<cv::Point>> result;
        std::copy_if(contours.begin(), contours.end(), std::back_inserter(result), [imageCenter, maxDistance, minArea](std::vector<cv::Point> contour){
            cv::Rect bbox = cv::boundingRect(contour);
            cv::Point2f bboxCenter(bbox.x + bbox.width / 2.0, bbox.y + bbox.height / 2.0);
            double area = bbox.area();
            double distance = norm(bboxCenter - imageCenter);
            return (distance > maxDistance && area > minArea);
        });
        return result;
    };
    
    std::vector<cv::Point> getConvexContour(std::vector<cv::Point> contour) {
        double closedPerimeter = arcLength(contour, true);
        std::vector<cv::Point> approxContour;
        approxPolyDP(contour, approxContour, closedPerimeter * 0.02, true);
        std::vector<cv::Point> hullContour;
        convexHull(approxContour, hullContour, true);
        return hullContour;
    };
    
    std::vector<cv::Point2f> getCornerPoints(const std::vector<cv::Point> contour) {
        std::vector<cv::Point2f> points;
        RotatedRect rect = minAreaRect(contour);
        cv::Point2f center = rect.center;

        cv:: Point2f topLeftPoint;
        double topLeftDistance = 0;

        cv::Point2f topRightPoint;
        double topRightDistance = 0;

        cv::Point2f bottomLeftPoint;
        double bottomLeftDistance = 0;

        cv::Point2f bottomRightPoint;
        double bottomRightDistance = 0;

        for (const cv::Point& point : contour) {
            double distance = getDistance(point, center);
            if (point.x < center.x && point.y < center.y) {
                if (distance > topLeftDistance) {
                    topLeftPoint = point;
                    topLeftDistance = distance;
                }
            } else if (point.x > center.x && point.y < center.y) {
                if (distance > topRightDistance) {
                    topRightPoint = point;
                    topRightDistance = distance;
                }
            } else if (point.x < center.x && point.y > center.y) {
                if (distance > bottomLeftDistance) {
                    bottomLeftPoint = point;
                    bottomLeftDistance = distance;
                }
            } else if (point.x > center.x && point.y > center.y) {
                if (distance > bottomRightDistance) {
                    bottomRightPoint = point;
                    bottomRightDistance = distance;
                }
            }
        }

        points.push_back(topLeftPoint);
        points.push_back(topRightPoint);
        points.push_back(bottomRightPoint);
        points.push_back(bottomLeftPoint);

        return points;
    };
    
    std::vector<cv::Point2f> sortCorners(std::vector<cv::Point2f> points) {
        std::sort(points.begin(), points.end(), [](cv::Point2f a, cv::Point2f b) {
            return a.y < b.y;
        });

        std::vector<cv::Point2f> top = {points[0], points[1]};
        std::vector<cv::Point2f> bottom = {points[2], points[3]};

        std::sort(top.begin(), top.end(), [](cv::Point2f a, cv::Point2f b) {
            return a.x < b.x;
        });

        std::sort(bottom.begin(), bottom.end(), [](cv::Point2f a, cv::Point2f b) {
            return a.x < b.x;
        });

        return {top[0], top[1], bottom[1], bottom[0]}; // TL, TR, BR, BL
    }
};
