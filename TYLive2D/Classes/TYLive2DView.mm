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

@interface TYLive2DView ()

@property (nonatomic, strong) NSMutableArray *textures;
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, assign) GLint deviceWidth;
@property (nonatomic, assign) GLint deviceHeight;
@property (nonatomic, assign) GLuint defaultFramebuffer;
@property (nonatomic, assign) GLuint colorRenderbuffer;
@property (nonatomic, assign) live2d::Live2DModelIPhone *live2DModel;
@property (nonatomic, strong) TYLive2DModel *model;

@end

@implementation TYLive2DView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        self.contentScaleFactor = [UIScreen mainScreen].scale ;
        eaglLayer.opaque = TRUE;
        
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!_context || ![EAGLContext setCurrentContext:_context]) {
            return nil;
        }
        glGenFramebuffersOES(1, &_defaultFramebuffer);
        glGenRenderbuffersOES(1, &_defaultFramebuffer);
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, _defaultFramebuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, _defaultFramebuffer);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _defaultFramebuffer);

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

- (void)drawView {
    [EAGLContext setCurrentContext:_context];
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glClear(GL_COLOR_BUFFER_BIT);
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE , GL_ONE_MINUS_SRC_ALPHA );
    glDisable(GL_DEPTH_TEST) ;
    glDisable(GL_CULL_FACE) ;
    
    _live2DModel->update();
    _live2DModel->draw();
    
    [_context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer *)self.layer];
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_deviceWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_deviceHeight);
    
    glViewport(0, 0, _deviceWidth, _deviceHeight);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
    float modelWidth = _live2DModel->getCanvasWidth();

    glOrthof(
             0,
             modelWidth,
             modelWidth * _deviceHeight / _deviceWidth,
             0,
             0.5f, -0.5f
             );
    
    [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)(1 / 60)
                                     target:self
                                   selector:@selector(drawView)
                                   userInfo:nil repeats:TRUE];
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
