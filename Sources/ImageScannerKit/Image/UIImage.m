//
//  UIImage.m
//  ImageScannerKit
//
//  Created by Ruben Mimoun on 11/03/2025.
//

#import "OCVWrapper.hpp"

@implementation UIImage(OpencvExtension)

-(bool) hasFourChannels: (UIImage *) image {
    @autoreleasepool {
        return [OCVWrapper hasFourChannels:self];
    }
    return true;
}

-(UIImage *)crop: (NSArray<NSValue *> *) toPoints {
    @autoreleasepool {
        return [OCVWrapper crop:self andPoints: toPoints];
    }
}

-(UIImage *)perspectiveTransform: (NSArray<NSValue *> *) sourcePoints with: (UIImage *) sourceImage toDestination:(UIImage *) destination {
    @autoreleasepool {
        return [OCVWrapper perspectiveTransform:sourcePoints with:sourceImage toDestination:destination];
    }
}

- (UIImage *)rotate: (int)flag {
    @autoreleasepool {
        return [OCVWrapper rotate:self withFlag:flag];
    }
}

- (UIImage *)rotateToAngle: (float)angle {
    @autoreleasepool {
        return [OCVWrapper rotate:self toangle:angle];
    }
}

-(UIImage*) toAdaptiveBinary {
    @autoreleasepool {
        return [OCVWrapper toAdaptiveBinary:self];
    }
}

-(UIImage*) toBinary: (float) threshold {
    @autoreleasepool {
        return [OCVWrapper toBinary:self withThreshold:threshold];
    }
}

-(UIImage*) contrast: (float) alpha andBeta:(float) beta {
    @autoreleasepool {
        return [OCVWrapper contrast:self andAlpha:alpha andBeta:beta];
    }
}

-(UIImage*) brightness:(float) value {
    @autoreleasepool {
        return [OCVWrapper brightness:self andValue:value];
    }
}

- (UIImage *)sharpness:(float) strength {
    @autoreleasepool {
        return [OCVWrapper sharpness:self withStrength:strength];
    }
}

-(UIImage *)detailEnhance:(float)strength {
    @autoreleasepool {
        return [OCVWrapper detailEnhance:self withStrength:strength];
    }
}

- (NSArray<NSValue*> *) corners {
    @autoreleasepool {
        return [OCVWrapper corners:self];
    }
}

@end
