//
//  TYLive2DView.h
//  Pods
//
//  Created by luckytianyiyan on 2017/2/24.
//
//

#import <UIKit/UIKit.h>

@class TYLive2DModel;

@interface TYLive2DView : UIView

- (void)loadModel:(TYLive2DModel *)model;

- (void)setValue:(CGFloat)value forParam:(NSString *)param;

- (CGFloat)valueForParam:(NSString *)param;

- (void)setValue:(CGFloat)value forPart:(NSString *)part;

- (CGFloat)valueForPart:(NSString *)part;

@end
