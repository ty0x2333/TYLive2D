//
//  TYLive2DModel.m
//  Pods
//
//  Created by luckytianyiyan on 2017/2/24.
//
//

#import "TYLive2DModel.h"

static NSString * const TYLive2DModelTexturesKey = @"ModelTextures";
static NSString * const TYLive2DModelNameKey = @"ModelName";
static NSString * const TYLive2DModelParamKey = @"ModelParam";
static NSString * const TYLive2DModelPartKey = @"ModelPart";

@implementation TYLive2DModel

- (instancetype)initWithPlistPath:(NSString *)plistPath {
    if (self = [super init]) {
        NSString *bundlePath = [NSBundle mainBundle].bundlePath;
        NSDictionary *infos = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSString *basePath = [plistPath stringByReplacingOccurrencesOfString:plistPath.lastPathComponent withString:@""];
        NSMutableArray *texturePaths = [NSMutableArray arrayWithCapacity:0];
        for (NSString *texture in infos[TYLive2DModelTexturesKey]) {
            [texturePaths addObject:[basePath stringByAppendingPathComponent:texture]];
        }
        _texturePaths = [texturePaths copy];
        
        _modelPath = [basePath stringByAppendingPathComponent:infos[TYLive2DModelNameKey]];
        
        _parameters = [infos[TYLive2DModelParamKey] allKeys];
        _parts = infos[TYLive2DModelPartKey];
    }
    return self;
}

@end
