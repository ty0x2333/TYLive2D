//
//  TYLive2DModel.m
//  Pods
//
//  Created by luckytianyiyan on 2017/2/24.
//
//

#import "TYLive2DModel.h"

NSString * const TYLive2DModelTexturesKey = @"ModelTextures";
NSString * const TYLive2DModelNameKey = @"ModelName";
NSString * const TYLive2DModelParamKey = @"ModelParam";
NSString * const TYLive2DModelPartKey = @"ModelPart";

NSString * const TYLive2DModelMaxKey = @"Max";
NSString * const TYLive2DModelMinKey = @"Min";

@implementation TYLive2DModel

- (instancetype)initWithPlistPath:(NSString *)plistPath {
    if (self = [super init]) {
        NSDictionary *infos = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSString *basePath = [plistPath stringByReplacingOccurrencesOfString:plistPath.lastPathComponent withString:@""];
        NSMutableArray *texturePaths = [NSMutableArray arrayWithCapacity:0];
        for (NSString *texture in infos[TYLive2DModelTexturesKey]) {
            [texturePaths addObject:[basePath stringByAppendingPathComponent:texture]];
        }
        _texturePaths = [texturePaths copy];
        
        _modelPath = [basePath stringByAppendingPathComponent:infos[TYLive2DModelNameKey]];
        
        NSMutableArray *params = [NSMutableArray arrayWithCapacity:[infos[TYLive2DModelParamKey] count]];
        [infos[TYLive2DModelParamKey] enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *obj, BOOL * _Nonnull stop) {
            TYLive2DParameterModel *param = [[TYLive2DParameterModel alloc] init];
            param.name = key;
            param.min = [obj[TYLive2DModelMinKey] floatValue];
            param.max = [obj[TYLive2DModelMaxKey] floatValue];
            
            [params addObject:param];
        }];
        _parameters = [params copy];
        _parts = infos[TYLive2DModelPartKey];
    }
    return self;
}

@end


@implementation TYLive2DParameterModel

@end
