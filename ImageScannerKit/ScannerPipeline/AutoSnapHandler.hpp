//
//  AutoSnapHandler.hpp
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 10/03/2025.
//

#ifndef AutoSnapHandler_hpp
#define AutoSnapHandler_hpp
#include <stdio.h>
#include <opencv2/opencv.hpp>
#include "FrameValidator.hpp"
#include "PointSorter.hpp"

class AutoSnapHandlerProtocol {
    public:
    using SnapCallback = std::function<void(const std::vector<cv::Point>, const cv::Mat mat)>;
    
    virtual void setSnapCallBack(SnapCallback onSnap) = 0;
    virtual void addPoints(std::vector<cv::Point> points, cv::Mat mat) = 0;
};

class AutoSnapHandler: public AutoSnapHandlerProtocol {
    
public:
    AutoSnapHandler(std::optional<SnapCallback> onSnap): onSnap(onSnap) {};
    
    void setSnapCallBack(SnapCallback onSnap) {
        this->onSnap = onSnap;
    };
    
    void addPoints(std::vector<cv::Point> points, cv::Mat mat) {
        if (currentMapKey == 4) { return; };
        
        while (currentPointsMap[currentMapKey].size() > 3) {
            currentMapKey += 1;
        };
        
        currentPointsMap[currentMapKey].push_back(points);
        
        if (currentMapKey == 4) {
            check(mat);
        };
    };
    
private:
    //MARK: - Properties
    int currentMapKey = 0 ;
    std::map<int, std::vector<std::vector<cv::Point>>> currentPointsMap;
    std::optional<SnapCallback> onSnap;
    
    void check(cv::Mat mat) {
        PointSorter *sorter = new PointSorter(currentMapKey, currentPointsMap);
        auto sortedPoints = sorter->sort();
        
        FrameValidator *validator = new FrameValidator(sortedPoints);
        auto isFrameValid = validator->validate();
        
        if (isFrameValid) {
            std::vector<cv::Point> points = currentPointsMap[currentMapKey][0];
            if (onSnap.has_value()) {
                onSnap.value()(points, mat);
            };
        }
        currentPointsMap.clear();
        currentMapKey = 0;
    };
};

#endif /* AutoSnapHandler_hpp */
