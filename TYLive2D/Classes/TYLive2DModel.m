//
//  TYLive2DModel.m
//  Pods
//
//  Created by luckytianyiyan on 2017/2/24.
//
//

#import "TYLive2DModel.h"

@implementation TYLive2DModel

- (instancetype)initWithPlistPath:(NSString *)plistPath {
    if (self = [super init]) {
        NSString *bundlePath = [NSBundle mainBundle].bundlePath;
        NSDictionary *infos = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSString *basePath = [plistPath stringByReplacingOccurrencesOfString:plistPath.lastPathComponent withString:@""];
        NSMutableArray *texturePaths = [NSMutableArray arrayWithCapacity:0];
        for (NSString *texture in infos[@"ModelTextures"]) {
            [texturePaths addObject:[basePath stringByAppendingPathComponent:texture]];
        }
        _texturePaths = [texturePaths copy];
        
        _modelPath = [basePath stringByAppendingPathComponent:infos[@"ModelName"]];
        
        _parameters = [infos[@"ModelParam"] allKeys];
        _parts = infos[@"ModelPart"];
    }
    return self;
}

@end
