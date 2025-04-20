//
//  EASTLoader.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 17/04/2025.
//
#include <iostream>
#include <fstream>
#include <TensorFlowLiteCMetal/TensorFlowLiteCMetal.h>
#include <TensorFlowLiteC/TensorFlowLiteC.h>
//#include "tensorflow/lite/delegates/gpu/metal_delegate.h"
//#include "tensorflow/lite/delegates/gpu/metal_delegate_internal.h"
#import <TensorFlowLiteCCoreML/TensorFlowLiteCCoreML.h>
#include <opencv2/imgproc.hpp>

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>
#import <opencv2/dnn/dnn.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "EASTDetector.h"

using namespace cv;
using namespace dnn;


struct TextBox {
    std::vector<cv::Point2f> boxPoints;
    float score;
};

@implementation EASTDetector

TfLiteDelegate* coremlDelegate;
TfLiteInterpreter* interpreter;
TfLiteModel* model;
TfLiteDelegate* gpuDelegate;

-(void) initDetector {
    model = [self makeModel];
    NSAssert(model != NULL, @"Could not load model");
    
    ///MARK: GPU
    TfLiteInterpreterOptions* options = TfLiteInterpreterOptionsCreate();
    gpuDelegate = TFLGpuDelegateCreate(nil);  // GPU delegate
    TfLiteInterpreterOptionsAddDelegate(options, gpuDelegate);
    
    interpreter = TfLiteInterpreterCreate(model, options);
 //   TfLiteInterpreter::ModifyGraphWithDelegate(gpuDelegate);
//    ModifyGraphWithDelegate(gpuDelegate);
    //interpreter->ModifyGraphWithDelegate(gpuDelegate);
    TfLiteInterpreterOptionsDelete(options);
    TfLiteInterpreterAllocateTensors(interpreter);
}

-(void) dispose {
    ///MARK: GPU
    if (interpreter) TfLiteInterpreterDelete(interpreter);
    if (gpuDelegate) TFLGpuDelegateDelete(gpuDelegate);
    if (model) TfLiteModelDelete(model);
}

//-(void) start: (Mat&) inputMat {
//    float xScale = static_cast<float>(inputMat.cols) / 320.0f;
//    float yScale = static_cast<float>(inputMat.rows) / 320.0f;
//    
//    Mat formatted = [self formatInput:inputMat];
//    TfLiteTensor *inputTensor = TfLiteInterpreterGetInputTensor(interpreter, 0);
//    size_t expectedBytes = TfLiteTensorByteSize(inputTensor);
//    size_t matBytes = formatted.total() * formatted.elemSize();
//    NSAssert(expectedBytes == matBytes, @"Input tensor size mismatch!");
//    TfLiteTensorCopyFromBuffer(inputTensor, formatted.data, matBytes);
//    TfLiteInterpreterInvoke(interpreter);
//    getTextBoxes(inputMat);
//}

-(void) run: (CVPixelBufferRef) pixelBuffer {
    
}


-(TfLiteModel*) makeModel {
    NSString* modelPath = [self loadModel];
    const char *modelPathChar = [modelPath cStringUsingEncoding:[NSString defaultCStringEncoding]];
    return TfLiteModelCreateFromFile(modelPathChar);
}

void getTextBoxes(Mat& inputMat) {
    const TfLiteTensor* scoreTensor = TfLiteInterpreterGetOutputTensor(interpreter, 0);
    const TfLiteTensor* geoTensor = TfLiteInterpreterGetOutputTensor(interpreter, 1);
    size_t scoreBuffer = TfLiteTensorByteSize(scoreTensor);
    size_t geoBuffer = TfLiteTensorByteSize(geoTensor);
    
    float* scoreData = static_cast<float*>(malloc(scoreBuffer));
    float* geoData = static_cast<float*>(malloc(geoBuffer));
    
    TfLiteTensorCopyToBuffer(scoreTensor,scoreData, TfLiteTensorByteSize(scoreTensor));
    TfLiteTensorCopyToBuffer(geoTensor, geoData, TfLiteTensorByteSize(geoTensor));
    
    int outH = TfLiteTensorDim(scoreTensor, 1);
    int outW = TfLiteTensorDim(scoreTensor, 2);

    auto boxes = decodeEASTOutput(scoreData, geoData, outW, outH);
    NSLog(@"boxes %d", boxes.size());
    
    for (const auto& box : boxes) {
        NSMutableString *pointsString = [NSMutableString stringWithString:@"["];
        for (const auto& pt : box.boxPoints) {
            [pointsString appendFormat:@"(%.2f, %.2f), ", pt.x, pt.y];
        }
        [pointsString appendString:@"]"];
        NSLog(@"Box points: %@", pointsString);
    }
//    
//    free(scoreData);
//    free(geoData);
    
    drawBoxes(inputMat, boxes, outW, outH, inputMat.cols, inputMat.rows);
    
}


// Assuming 'boxes' is the result from 'decodeEASTOutput'
void drawBoxes(cv::Mat& inputMat, const std::vector<TextBox>& boxes,
               int outW, int outH, int originalWidth, int originalHeight)
{
    // Calculate scaling factors
    float scaleX = static_cast<float>(originalWidth) / outW;
    float scaleY = static_cast<float>(originalHeight) / outH;

    // Loop through the boxes and draw them on the original image
    for (const auto& box : boxes) {
        // Scale the vertices to the original image size
        std::vector<cv::Point2f> scaledVertices;
        for (const auto& pt : box.boxPoints) {
            float scaledX = pt.x * scaleX;
            float scaledY = pt.y * scaleY;
            scaledVertices.push_back(cv::Point2f(scaledX, scaledY));
        }

        // Draw the bounding box (a polygon)
        for (size_t i = 0; i < scaledVertices.size(); ++i) {
            cv::line(inputMat, scaledVertices[i], scaledVertices[(i + 1) % 4],
                     cv::Scalar(0, 255, 0), 2);  // Green box
        }

        // Optionally, draw the score (confidence) near the box
        std::string scoreText = "Score: " + std::to_string(box.score);
        cv::putText(inputMat, scoreText, scaledVertices[0], cv::FONT_HERSHEY_SIMPLEX,
                    0.6, cv::Scalar(0, 255, 0), 1);
    }
}

-(Mat) formatInput: (Mat) inputMat {
    Mat rgbMat, resizedMat, floatMat;
    cv::cvtColor(inputMat, rgbMat, cv::COLOR_BGR2RGB);
    // Resize to match model input size
    resize(rgbMat, resizedMat, cv::Size(320, 320));
    resizedMat.convertTo(floatMat, CV_32FC3, 1.0 / 255.0);
    return floatMat;
}

- (NSString*) loadModel {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSAssert(bundle != NULL, @"EASTLoader, Bundle could not be loaded");
    NSURL *url = [bundle URLForResource: @"east" withExtension: @"tflite" subdirectory:NULL localization:NULL];
    return url.path;
}

std::vector<TextBox> decodeEASTOutput(const float* scoreMap, const float* geoMap,
                                      int outW, int outH, float scoreThresh = 0.8f) {
    std::vector<TextBox> results;

    int featureW = outW;
    int featureH = outH;

    for (int y = 0; y < featureH; ++y) {
        for (int x = 0; x < featureW; ++x) {
            int index = y * featureW + x;
            float score = scoreMap[index];

            if (score < scoreThresh) continue;

            // Each geo entry has 5 floats: [top, right, bottom, left, angle]
            const float* geoData = geoMap + index * 5;
            float dTop = geoData[0];
            float dRight = geoData[1];
            float dBottom = geoData[2];
            float dLeft = geoData[3];
            float angle = geoData[4];

            // Calculate rotated rectangle
            float offsetX = x * 4.0f;  // scale factor
            float offsetY = y * 4.0f;

            float cosA = cos(angle);
            float sinA = sin(angle);

            float h = dTop + dBottom;
            float w = dLeft + dRight;

            cv::Point2f center(offsetX + cosA * dRight - sinA * dBottom,
                               offsetY + sinA * dRight + cosA * dBottom);

            cv::RotatedRect rect(center, cv::Size2f(w, h), -angle * 180.0f / CV_PI);

            // Convert to 4 corner points
            std::vector<cv::Point2f> vertices(4);
            rect.points(vertices.data());

            results.push_back({ vertices, score });
        }
    }

    return results;
}


@end
