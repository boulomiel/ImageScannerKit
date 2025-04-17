//
//  PointSorter.hpp
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 11/03/2025.
//

struct PointSorter {
    
private:
    int currentMapKey;
    std::map<int, std::vector<std::vector<cv::Point>>> currentPointsMap;
    
public:
    PointSorter(int currentMapKey, std::map<int, std::vector<std::vector<cv::Point>>> currentPointsMap): currentPointsMap(currentPointsMap), currentMapKey(currentMapKey) {}
    
    std::vector<std::vector<cv::Point>> sort() {
        auto copyMap(currentPointsMap);
        std::vector<std::vector<cv::Point>> sortedIndexPoints = { {}, {}, {}, {} };
        for (int k = 0; k < 4; k++) {
            auto pair = copyMap[k];
            for (int i = 0; i < 4; i++) {
                auto point = *pair[i].begin();
                sortedIndexPoints[i].push_back(point);
            }
        };
        return sortedIndexPoints;
    };
};
