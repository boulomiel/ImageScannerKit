//
//  Corners.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 27/03/2025.
//

#import <Foundation/Foundation.h>
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

#import "PointToCGConverter.hpp"
#import "Corners.h"

using namespace cv;
using namespace std;


@implementation Corners

double getDistance(cv::Point p1, cv::Point p2) {
  return hypot(p1.x - p2.x, p1.y - p2.y);
}

int getMaxContourIndex(vector<vector<cv::Point>> contours) {
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
}

vector<Point2f> getCornerPoints(const vector<cv::Point> contour) {
    vector<Point2f> points;
    RotatedRect rect = minAreaRect(contour);
    Point2f center = rect.center;

    Point2f topLeftPoint;
    double topLeftDistance = 0;

    Point2f topRightPoint;
    double topRightDistance = 0;

    Point2f bottomLeftPoint;
    double bottomLeftDistance = 0;

    Point2f bottomRightPoint;
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
}


cv::Mat getImageReadyForDetection(cv::Mat result) {
    
    cv::Mat kernal = cv::getStructuringElement(MORPH_RECT, cv::Size(5, 5));
    
    cv::Mat dilated;
    cv::dilate(result, dilated, kernal);

    cv::Mat blur;
    cv::GaussianBlur(dilated, blur, cv::Size(5, 5), 0, cv::BORDER_REPLICATE);
    
    cv::Mat gray, imageOpen, imageClosed;
    cv::cvtColor(blur, gray, cv::COLOR_BGR2GRAY);

    cv::morphologyEx(gray, imageOpen, cv::MORPH_OPEN, kernal);
    cv::morphologyEx(imageOpen, imageClosed, cv::MORPH_CLOSE, kernal);
    
    cv::Mat thres;
    cv::threshold(imageClosed, thres, 0, 255, THRESH_BINARY | THRESH_OTSU);
    
    cv::Mat edged;
    cv::Canny(thres, edged, 75, 200);
    
    cv:: Mat imgdilate;
    cv::dilate(edged, imgdilate, kernal);

    return imgdilate;
}


cv::Mat testImage (cv::Mat inputImage) {
    
    cv::Mat mat = getImageReadyForDetection(inputImage);
    // Step 4: Find contours
    vector<vector<cv::Point> > contours;
    vector<cv::Vec4i> hierarchy;
    cv::findContours(mat, contours, hierarchy, RETR_CCOMP, CHAIN_APPROX_SIMPLE);
    
    int index = getMaxContourIndex(contours);
    
    cv::Mat drawing = cv::Mat::zeros(mat.size(), CV_8UC3);

    if (index >= 0) {
        vector<cv::Point2f> approx;
        cv::approxPolyDP(contours[index], approx, arcLength(contours[index], true) * 0.02, true);
        cv::drawContours(drawing, contours, index, Scalar(0, 255, 0));
    }

    return drawing;
}


vector<cv::Point2f> findDocumentCorners(Mat inputImage) {
    vector<cv::Point2f> corners;
    try {
        cv::Mat edges = getImageReadyForDetection(inputImage);
        vector<vector<cv::Point> > contours;
        vector<cv::Vec4i> hierarchy;
        cv::findContours(edges, contours, hierarchy, RETR_CCOMP, CHAIN_APPROX_SIMPLE);
        
        if (!contours.empty()) {
            int index = getMaxContourIndex(contours);
            if (index > -1) {
                return getCornerPoints(contours[index]);
            }
        }
        return corners;
    } catch (Exception e) {
        cout << "findDocumentCorners:" << e.err;
    }

    return corners;
}

- (NSArray<NSValue *> *)corners:(UIImage *)image {
    Mat mat;
    UIImageToMat(image, mat);
    PointToCGConverter *converter = [[PointToCGConverter alloc] init];
    auto detectedCorners = findDocumentCorners(mat);
    NSArray<NSValue*> *convertedPoints = [converter convertPoint2f:detectedCorners];
    return convertedPoints;
}

@end
