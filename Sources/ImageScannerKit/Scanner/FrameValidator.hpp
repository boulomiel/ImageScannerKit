//
//  FrameValidator.hpp
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 11/03/2025.
//


struct FrameValidator {
    
private:
    std::vector<std::vector<cv::Point>> sortedPoints;
    
public:
    FrameValidator(std::vector<std::vector<cv::Point>> sortedPoints): sortedPoints(sortedPoints) {}
    
    bool validate() {
        for (int i = 0; i < sortedPoints.size(); i++) {
            auto points = sortedPoints[i];
            
            if (points.size() < 4) { return false; };
            
            double xSum = 0;
            double ySum = 0;
            
            for (int j = 0; j < points.size(); j++) {
                auto point = points[j];
                xSum += point.x;
                ySum += point.y;
            }
            
            double currentAverageX = xSum / points.size();
            double currentAverageY = ySum / points.size();
            double minX = points[0].x;
            double minY = points[0].y;
            double maxX = minX * 1.1;
            double maxY = minY * 1.1;
            
            if (currentAverageX > maxX || currentAverageY > maxY) {
                return false;
            } else {
                std::cout << "Valid Frame" << "SNAP !" << std::endl;
                return true;
            }
        };
        std::cout << "Valid Frame" << "SNAP !" << std::endl;
        return true;
    };
};
