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
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, copy) void (^animation)(SInt64 userTime);

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
        
        self.preferredFramesPerSecond = 30;
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView)];
        self.displayLink.frameInterval = MAX(1, 60.0f / _preferredFramesPerSecond);
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)loadModel:(TYLive2DModel *)model {
    live2d::Live2D::init();
    
    _live2DModel = live2d::Live2DModelIPhone::loadModel([model.modelPath UTF8String]);
    
    _model = model;
    
    for (int i = 0; i < model.texturePaths.count; ++i) {
        
        GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:model.texturePaths[i] options:@{ GLKTextureLoaderApplyPremultiplication: @(YES), GLKTextureLoaderGenerateMipmaps: @(YES) } error:nil];
        int textureNumber = textureInfo.name;
        _live2DModel->setTexture(i, textureNumber);
        [_textures addObject:@(textureNumber)];
    }
}

- (void)startAnimation:(void (^)(SInt64 userTime))animation {
    self.animation = animation;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentView.frame = self.bounds;
}

#pragma mark -
- (void)setPreferredFramesPerSecond:(NSInteger)preferredFramesPerSecond {
    _preferredFramesPerSecond = preferredFramesPerSecond;
    self.displayLink.frameInterval = MAX(1, 60.0f / _preferredFramesPerSecond);
}

- (BOOL)isPaused {
    return self.displayLink.paused;
}

- (void)setPaused:(BOOL)paused {
    self.displayLink.paused = paused;
}

- (void)drawView {
    [self.contentView display];
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    CGFloat modelWidth = _live2DModel->getCanvasWidth();
    CGFloat modelHeight = _live2DModel->getCanvasHeight();
    
    glLoadIdentity();
    
    glOrthof(0, modelWidth, modelHeight, 0, 0.5f, -0.5f);
    
    if (_animation) {
        _animation(live2d::UtSystem::getUserTimeMSec());
    }
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

- (CGSize)canvasSize {
    return CGSizeMake(_live2DModel->getCanvasWidth(), _live2DModel->getCanvasHeight());
}

@end
