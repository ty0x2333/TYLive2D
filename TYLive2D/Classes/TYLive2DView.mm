//
//  TYLive2DView.m
//  Pods
//
//  Created by luckytianyiyan on 2017/2/24.
//
//

#import "TYLive2DView.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <GLKit/GLKit.h>
#import "Live2D.h"
#import "UtSystem.h"
#import "Live2DModelIPhone.h"
#import "TYLive2DModel.h"

@interface TYLive2DView ()<GLKViewDelegate>

@property (nonatomic, strong) NSMutableArray *textures;
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, assign) live2d::Live2DModelIPhone *live2DModel;
@property (nonatomic, strong) TYLive2DModel *model;

@property (nonatomic, strong) GLKView *contentView;

@end

@implementation TYLive2DView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        if (!_context || ![EAGLContext setCurrentContext:_context]) {
            return nil;
        }
        
        _contentView = [[GLKView alloc] init];
        _contentView.delegate = self;
        _contentView.context = _context;
        _contentView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
        [self addSubview:_contentView];
    }
    return self;
}

- (void)loadModel:(TYLive2DModel *)model {
    live2d::Live2D::init();
    
    _live2DModel = live2d::Live2DModelIPhone::loadModel([model.modelPath UTF8String]);
    
    for (NSInteger i = 0; i < model.texturePaths.count; ++i) {
        
        GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:model.texturePaths[i] options:@{ GLKTextureLoaderApplyPremultiplication: @(YES), GLKTextureLoaderGenerateMipmaps: @(YES) } error:nil];
        int textureNumber = textureInfo.name;
        _live2DModel->setTexture(i, textureNumber);
        [_textures addObject:@(textureNumber)];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentView.frame = self.bounds;
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glLoadIdentity();
    float modelWidth = _live2DModel->getCanvasWidth();
    glOrthof(0, modelWidth, modelWidth * CGRectGetHeight(self.bounds) / CGRectGetWidth(self.bounds), 0, 0.5f, -0.5f);
    
    self.live2DModel->update();
    self.live2DModel->draw();
}

#pragma mark - Setter / Getter

- (void)setValue:(CGFloat)value forParam:(NSString *)param {
    for (TYLive2DParameterModel *p in self.model.parameters) {
        if ([p.name isEqualToString:param]) {
            CGFloat v = value;
            if (value < p.min) {
                v = p.min;
            } else if (value > p.max) {
                v = p.max;
            }
            self.live2DModel->setParamFloat(param.UTF8String, v);
        }
    }
}

- (CGFloat)valueForParam:(NSString *)param {
    return self.live2DModel->getParamFloat(param.UTF8String);
}

- (void)setValue:(CGFloat)value forPart:(NSString *)part {
    self.live2DModel->setPartsOpacity(part.UTF8String, value);
}

- (CGFloat)valueForPart:(NSString *)part {
    return self.live2DModel->getPartsOpacity(part.UTF8String);
}

- (void)setParamsWithDictionary:(NSDictionary<NSString *, NSNumber *> *)params {
    [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        [self setValue:[obj floatValue] forParam:key];
    }];
}

- (void)setPartsWithDictionary:(NSDictionary<NSString *, NSNumber *> *)parts {
    [parts enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        [self setValue:[obj floatValue] forPart:key];
    }];
}

@end
