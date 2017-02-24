//
//  TYLive2DView.h
//  Pods
//
//  Created by luckytianyiyan on 2017/2/24.
//
//

#import <UIKit/UIKit.h>

@interface TYLive2DView : UIView

@property (nonatomic, copy) NSString *modelPath;
@property (nonatomic, strong) NSArray<NSString *> *textureNames;

- (void)loadModel;

@end
