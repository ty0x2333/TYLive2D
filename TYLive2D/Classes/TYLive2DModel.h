//
//  TYLive2DModel.h
//  Pods
//
//  Created by luckytianyiyan on 2017/2/24.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const TYLive2DModelTexturesKey;
FOUNDATION_EXPORT NSString * const TYLive2DModelNameKey;
FOUNDATION_EXPORT NSString * const TYLive2DModelParamKey;
FOUNDATION_EXPORT NSString * const TYLive2DModelPartKey;

FOUNDATION_EXPORT NSString * const TYLive2DModelMaxKey;
FOUNDATION_EXPORT NSString * const TYLive2DModelMinKey;

@interface TYLive2DParameterModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat min;
@property (nonatomic, assign) CGFloat max;

@end

@interface TYLive2DModel : NSObject

- (instancetype)initWithPlistPath:(NSString *)plistPath;

@property (nonatomic, copy) NSString *modelPath;
@property (nonatomic, strong) NSArray<NSString *> *texturePaths;
@property (nonatomic, strong) NSArray<TYLive2DParameterModel *> *parameters;
@property (nonatomic, strong) NSArray<NSString *> *parts;

@end
