//
//  TYLive2DModel.h
//  Pods
//
//  Created by luckytianyiyan on 2017/2/24.
//
//

#import <Foundation/Foundation.h>

@interface TYLive2DModel : NSObject

- (instancetype)initWithPlistPath:(NSString *)plistPath;

@property (nonatomic, copy) NSString *modelPath;
@property (nonatomic, strong) NSArray<NSString *> *texturePaths;
@property (nonatomic, strong) NSArray<NSString *> *parameters;
@property (nonatomic, strong) NSArray<NSString *> *parts;

@end
