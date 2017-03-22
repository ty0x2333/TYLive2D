//
//  TYLive2D.m
//  Pods
//
//  Created by luckytianyiyan on 2017/3/22.
//
//

#import "TYLive2D.h"
#import "Live2D.h"

@implementation TYLive2D

+ (NSString *)live2DVersion {
    return [NSString stringWithUTF8String:live2d::Live2D::getVersionStr()];
}

+ (NSUInteger)live2DVersionNumber {
    return live2d::Live2D::getVersionNo();
}

@end
