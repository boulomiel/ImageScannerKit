//
//  CLAHEProcessor.swift
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 15/03/2025.
//


#include <opencv2/opencv.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>

class Clahe: public ScannerStep {
    
public:
    void handle(cv::Mat &mat) override {
//        cv::Ptr<cv::CLAHE> clahe = cv::createCLAHE(3.0, cv::Size(8,8));
//        clahe->apply(mat, mat);
//        if(next){
//            next->handle(mat);
//        }
        Mat labImage;
        cv::cvtColor(mat, labImage, cv::COLOR_BGR2Lab);

        // Split LAB channels
        std::vector<cv::Mat> labChannels;
        cv::split(labImage, labChannels);

        // Apply CLAHE only to the L channel (brightness)
        cv::Ptr<cv::CLAHE> clahe = cv::createCLAHE(3.0, cv::Size(8, 8));
        clahe->apply(labChannels[0], labChannels[0]);

        // Merge LAB channels back
        cv::merge(labChannels, labImage);

        // Convert back to BGR
        cv::cvtColor(labImage, mat, cv::COLOR_Lab2BGR);
        
        if(next){
            next->handle(mat);
        }
    };
};
