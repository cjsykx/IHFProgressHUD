//
//  IHFFlashingLabel.m
//  IHFProgressHUD
//
//  Created by chenjiasong on 16/8/31.
//  Copyright © 2016年 Cjson. All rights reserved.
//

#import "IHFFlashingLabel.h"

@interface IHFFlashingLabel ()

@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *maskLabel;
@property (strong, nonatomic) CAGradientLayer *maskLayer;
@property (assign, nonatomic) CGSize charSize;
@property (assign, nonatomic) CATransform3D startT, endT;   // flasing range [startT, endT]
@property (strong, nonatomic) CABasicAnimation *transformAnimation;
@property (strong, nonatomic) CABasicAnimation *alphaAnimation;

@end

@implementation IHFFlashingLabel

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 200, 300);
        [self configureView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    [self addSubview:self.contentLabel];
    [self addSubview:self.maskLabel];
    self.layer.masksToBounds = true;
    self.startT = CATransform3DIdentity;
    self.endT = CATransform3DIdentity;
    self.charSize = CGSizeMake(0, 0);
    self.flashingType = IHFFlashingTypeOfDirectionLeftToRight;
    self.repeat = true;
    self.flashingWidth = 20;
    self.flashingRadius = 20;
    self.flashingColor = [UIColor whiteColor];
    self.durationTime = 2;
    
    // Enter foreground to restore flashing
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoredAsWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 刷新布局
    self.contentLabel.frame = self.bounds;
    self.maskLabel.frame = self.bounds;
    
    self.maskLayer.frame = CGRectMake(0, 0, self.charSize.width, self.charSize.height);
}

#pragma mark - property setter and getter

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _contentLabel.font = [UIFont systemFontOfSize:17];
        _contentLabel.textColor = [UIColor darkGrayColor];
    }
    return _contentLabel;
}

- (UILabel *)maskLabel {
    if (_maskLabel == nil) {
        _maskLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _maskLabel.font = [UIFont systemFontOfSize:17];
        _maskLabel.textColor = [UIColor darkGrayColor];
        _maskLabel.hidden = YES;
    }
    return _maskLabel;
}

- (CALayer *)maskLayer {
    if (_maskLayer == nil) {
        _maskLayer = [[CAGradientLayer alloc] init];
        _maskLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self refreshMaskLayer];
    }
    return _maskLayer;
}

- (void)setText:(NSString *)text {
    if (_text == text) return ;
    
    _text = text;
    self.contentLabel.text = text;
    self.charSize = [self.contentLabel.text boundingRectWithSize:self.contentLabel.frame.size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.contentLabel.font} context:nil].size;
    [self restartFlasingIfNeed];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    if (_textAlignment == textAlignment) return ;
    
    _textAlignment = textAlignment;
    _maskLabel.textAlignment = textAlignment;
    _contentLabel.textAlignment = textAlignment;
}

- (void)setFont:(UIFont *)font {
    if (_font == font) return ;
    
    _font = font;
    self.contentLabel.font = font;
    self.charSize = [self.contentLabel.text boundingRectWithSize:self.contentLabel.frame.size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.contentLabel.font} context:nil].size;
    [self restartFlasingIfNeed];
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor == textColor) return ;
    
    _textColor = textColor;
    self.contentLabel.textColor = textColor;
    [self restartFlasingIfNeed];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    if (_attributedText == attributedText) return;
    
    _attributedText = attributedText;
    self.contentLabel.attributedText = attributedText;
    [self restartFlasingIfNeed];
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    if (_numberOfLines == numberOfLines) return ;
    
    _numberOfLines = numberOfLines;
    self.contentLabel.numberOfLines = numberOfLines;
    [self restartFlasingIfNeed];
}

- (void)setFlashingType:(IHFFlashingType)flashingType {
    if (_flashingType == flashingType) return;
    _flashingType = flashingType;
    [self restartFlasingIfNeed];
}

- (void)setRepeat:(BOOL)repeat {
    if (_repeat == repeat) return;
    
    _repeat = repeat;
    [self restartFlasingIfNeed];
}

- (void)setFlashingWidth:(CGFloat)flashingWidth {
    if (_flashingWidth == flashingWidth) return;
    
    _flashingWidth = flashingWidth;
    [self restartFlasingIfNeed];
}

- (void)setFlashingRadius:(CGFloat)flashingRadius {
    if (_flashingRadius == flashingRadius) return;
    
    _flashingRadius = flashingRadius;
    [self restartFlasingIfNeed];
}

- (void)setFlashingColor:(UIColor *)flashingColor {
    if (_flashingColor == flashingColor) return;
    
    _flashingColor = flashingColor;
    self.maskLabel.textColor = flashingColor;
    [self restartFlasingIfNeed];
}

- (void)setDurationTime:(NSTimeInterval)durationTime {
    if (_durationTime == durationTime) return;
    
    _durationTime = durationTime;
    [self restartFlasingIfNeed];
}

- (CABasicAnimation *)transformAnimation {
    if (_transformAnimation == nil) {
        _transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    }
    _transformAnimation.duration = self.durationTime;
    _transformAnimation.repeatCount = self.repeat == YES ? MAXFLOAT : 0;
    _transformAnimation.autoreverses = self.flashingType == IHFFlashingTypeOfAutoreverses ? true : false;
    
    return _transformAnimation;
}

- (CABasicAnimation *)alphaAnimation {
    if (_alphaAnimation == nil) {
        _alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _alphaAnimation.repeatCount = MAXFLOAT;
        _alphaAnimation.autoreverses = YES;
        _alphaAnimation.fromValue = @(0.0);
        _alphaAnimation.toValue = @(1.0);
    }
    _alphaAnimation.duration = self.durationTime;
    
    return _alphaAnimation;
}
#pragma mark - support tool

/** refresh maskLayer transform value */
- (void)refreshMaskLayer {
    if (self.flashingType != IHFFlashingTypeOfOverallFlashing) {
        _maskLayer.backgroundColor = [UIColor clearColor].CGColor;
        _maskLayer.startPoint = CGPointMake(0, 0.5);
        _maskLayer.endPoint = CGPointMake(1, 0.5);
        _maskLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor clearColor].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, (id)[UIColor clearColor].CGColor];
        
        CGFloat w = 1.0;
        CGFloat sw = 1.0;
        if (self.charSize.width >= 1) {
            w = self.flashingWidth / self.charSize.width * 0.5;
            sw = self.flashingRadius / self.charSize.width;
        }
        _maskLayer.locations = @[@(0.0), @(0.5 - w - sw), @(0.5 - w), @(0.5 + w), @(0.5 + w + sw), @(1)];
        CGFloat startX = self.charSize.width * (0.5 - w - sw);
        CGFloat endX = self.charSize.width * (0.5 + w + sw);
        self.startT = CATransform3DMakeTranslation(-endX, 0, 1);
        self.endT = CATransform3DMakeTranslation(self.charSize.width - startX, 0, 1);
    } else {
        _maskLayer.backgroundColor = self.flashingColor.CGColor;
        _maskLayer.colors = nil;
        _maskLayer.locations = nil;
    }
}


- (void)copyLabel:(UILabel *)copyLabel from:(UILabel *)fromLabel {
    copyLabel.attributedText = fromLabel.attributedText;
    copyLabel.text = fromLabel.text;
    copyLabel.font = fromLabel.font;
    copyLabel.numberOfLines = fromLabel.numberOfLines;
}

#pragma mark - start or stop flashing
- (void)startFlashing {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isFlashing) return ;
        _isFlashing = YES;
        
        [self copyLabel:self.maskLabel from:self.contentLabel];
        self.maskLabel.hidden = NO;
        [self.maskLayer removeFromSuperlayer];
        [self refreshMaskLayer];
        [self.maskLabel.layer addSublayer:self.maskLayer];
        self.maskLabel.layer.mask = self.maskLayer;
        
        switch (self.flashingType) {
            case IHFFlashingTypeOfDirectionLeftToRight: {
                self.maskLayer.transform = self.startT;
                self.transformAnimation.fromValue = [NSValue valueWithCATransform3D:self.startT];
                self.transformAnimation.toValue = [NSValue valueWithCATransform3D:self.endT];
                [self.maskLayer removeAllAnimations];
                [self.maskLayer addAnimation:self.transformAnimation forKey:@"start"];
                break;
            }
            case IHFFlashingTypeOfDirectionRightToLeft: {
                self.maskLayer.transform = self.endT;
                self.transformAnimation.fromValue = [NSValue valueWithCATransform3D:self.endT];
                self.transformAnimation.toValue = [NSValue valueWithCATransform3D:self.startT];
                [self.maskLayer removeAllAnimations];
                [self.maskLayer addAnimation:self.transformAnimation forKey:@"start"];
                break;
            }
            case IHFFlashingTypeOfAutoreverses : {
                self.maskLayer.transform = self.startT;
                self.transformAnimation.fromValue = [NSValue valueWithCATransform3D:self.startT];
                self.transformAnimation.toValue = [NSValue valueWithCATransform3D:self.endT];
                [self.maskLayer removeAllAnimations];
                [self.maskLayer addAnimation:self.transformAnimation forKey:@"start"];
                break;
            }
            case IHFFlashingTypeOfOverallFlashing : {
                self.maskLayer.transform = CATransform3DIdentity;
                [self.maskLayer removeAllAnimations];
                [self.maskLayer addAnimation:self.alphaAnimation forKey:@"start"];
                break;
            }
            default: break;
        }
    });
}

- (void)stopFlashing {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!self.isFlashing) return ;
        _isFlashing = NO;
        
        [self.maskLayer removeAllAnimations];
        [self.maskLayer removeFromSuperlayer];
        self.maskLabel.hidden = YES;
    });
}

- (void)restoredAsWillEnterForeground {
    dispatch_async(dispatch_get_main_queue(), ^{
        _isFlashing = YES;
        [self startFlashing];
    });
}

- (void)restartFlasingIfNeed {
    if (self.isFlashing) {       
        [self stopFlashing];
        [self startFlashing];
    }
}

@end
