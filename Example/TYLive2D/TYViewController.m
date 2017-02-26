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

@end

@implementation TYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TYLive2DModel *model = [[TYLive2DModel alloc] initWithPlistPath:[[NSBundle mainBundle] pathForResource:@"model" ofType:@"plist" inDirectory:@"Haru"]];
    _live2DView = [[TYLive2DView alloc] init];
    [_live2DView loadModel:model];
    [self.view addSubview:_live2DView];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _live2DView.frame = self.view.bounds;
}

@end
