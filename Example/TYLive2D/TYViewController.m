//
//  TYViewController.m
//  TYLive2D
//
//  Created by luckytianyiyan on 02/24/2017.
//  Copyright (c) 2017 luckytianyiyan. All rights reserved.
//

#import "TYViewController.h"
#import <TYLive2D/TYLive2DModel.h>
#import <TYLive2D/TYLive2DView.h>

@interface TYViewController ()

@property (nonatomic, strong) TYLive2DView *live2DView;
@property (nonatomic, assign) BOOL isEyeClosing;
@property (nonatomic, assign) CGFloat eyeSpeed;

@end

@implementation TYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isEyeClosing = NO;
    
    TYLive2DModel *model = [[TYLive2DModel alloc] initWithPlistPath:[[NSBundle mainBundle] pathForResource:@"model" ofType:@"plist" inDirectory:@"Haru"]];
    _live2DView = [[TYLive2DView alloc] init];
    [_live2DView loadModel:model];
    [self.view addSubview:_live2DView];
    
    NSDictionary *params = @{@"PARAM_EYE_L_SMILE": @1, @"PARAM_EYE_R_SMILE": @1, @"PARAM_ARM_L_A": @(-1.f), @"PARAM_ARM_R_A": @(-1.f)};
    NSDictionary *parts = @{@"PARTS_01_ARM_L_B_001": @0, @"PARTS_01_ARM_R_B_001": @0};
    [_live2DView setParamsWithDictionary:params];
    [_live2DView setPartsWithDictionary:parts];
//    _live2DView.layer.borderWidth = 0.5f;
//    _live2DView.layer.borderColor = [UIColor redColor].CGColor;
    
    [_live2DView startAnimation:^(SInt64 userTime) {
        double globalTime = userTime / 1000.0;
        NSDictionary *params = @{@"PARAM_ANGLE_Z": @(30.0 * sin(globalTime)),
                                 @"PARAM_BODY_ANGLE_Z": @(10.0 * sin(globalTime)),
                                 @"PARAM_HAIR_FRONT": @(sin(globalTime)),
                                 @"PARAM_HAIR_BACK": @(sin(globalTime)),
                                 @"PARAM_BREATH": @((cos(globalTime) + 1.0) / 2.0),
                                 @"PARAM_BUST_Y": @(cos(globalTime))};
        
        [_live2DView setParamsWithDictionary:params];
        if ((sin(globalTime) + 1.0) >= 1.9 && !self.isEyeClosing) {
            self.isEyeClosing = YES;
            self.eyeSpeed = (arc4random() % 200 + 100);
        }
        else if (self.isEyeClosing) {
            double eyeTime = userTime / self.eyeSpeed;
            [_live2DView setValue:sin(eyeTime) + 1.0 forParam:@"PARAM_EYE_L_OPEN"];
            [_live2DView setValue:sin(eyeTime) + 1.0 forParam:@"PARAM_EYE_R_OPEN"];
            if ((sin(eyeTime) + 1.0) >= 1.9) {
                self.isEyeClosing = NO;
            }
        }

    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat width;
    CGFloat height;
    CGFloat modelWidth = _live2DView.canvasSize.width;
    CGFloat modelHeight = _live2DView.canvasSize.height;
    CGFloat fullWidth = CGRectGetWidth(self.view.bounds);
    CGFloat fullHeight = CGRectGetHeight(self.view.bounds);
    if (fullHeight / fullWidth > modelHeight / modelWidth) {
        width = fullWidth;
        height = width * modelHeight / modelWidth;
    } else {
        height = fullHeight;
        width = height * modelWidth / modelHeight;
    }
    _live2DView.frame = CGRectMake((fullWidth - width) / 2.f, (fullHeight - height) / 2.f, width, height);
}

@end
