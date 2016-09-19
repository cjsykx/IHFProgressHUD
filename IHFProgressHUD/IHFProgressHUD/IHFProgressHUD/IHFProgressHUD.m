//
//  IHFProgressHUD.m
//  IHFProgressHUD
//
//  Created by chenjiasong on 16/9/1.
//  Copyright © 2016年 Cjson. All rights reserved.
//
#import "IHFProgressHUD.h"
#import "IHFCheckErrorView.h"
#import "IHFCheckMarkView.h"
#import "IHFFlashingLabel.h"
#import "IHFProgressHorizontalBar.h"
#import "IHFProgressCircleBar.h"
static CGFloat const _kIndicatorHeight = 50.f; // Is also the min HUD width
static CGFloat const _kIndicatorWidth = _kIndicatorHeight;

@interface IHFProgressHUD ()

@property (weak, nonatomic) UIView * indicativeView;
@property (weak, nonatomic) UIView * indicator; // is subview in indicativeView

@property (weak, nonatomic) UILabel * textLabel;

@property (strong, nonatomic) UIView * maskView;

@property (assign, nonatomic) CGSize textSize;
@property (assign, nonatomic) CGSize flashingTextSize;
@property (assign, nonatomic) CGSize superViewSize;

@property (strong, nonatomic) NSTimer * hideTimer; // After delay hide timer

@property (assign, nonatomic) BOOL isShowing;
@end

@implementation IHFProgressHUD

#pragma mark - Single instance

+ (instancetype)shareProgressHUD {
    
    static id shareProgressHUD;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareProgressHUD = [[IHFProgressHUD alloc] init];
    });
    return shareProgressHUD;
}

#pragma mark - system method
- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self configureParamters];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self configureParamters];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureParamters];
        [self setupView];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    [super willMoveToSuperview:newSuperview];
    self.superViewSize = newSuperview.bounds.size;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // indicate view frame
    CGRect indicateFrame = CGRectZero;

    CGFloat indicateViewH = _kIndicatorHeight + 2 * _verticalMargin;
    CGFloat indicateViewW = MAX(self.textSize.width, _kIndicatorWidth) + 2 * _horizontalMargin;
    
    // If Not the type of bar or circle , the HUD width juege by text size . Otherwise by the bar or circle width in 
    
    CGFloat labelW = self.textSize.width; // If the type is bar or circle , if need change by bar width
    
    // the condision not have the indicate view !
    if (self.type == IHFProgressHUDTypeOnlyText) {
        indicateViewH = 0;
        self.indicator.frame = CGRectZero;
    } else if (self.type == IHFProgressHUDTypeCustomView) {
        if (!_customView) {
            self.indicator.frame = CGRectZero;
            indicateViewH = 0;
        }
    } else if (self.type == IHFProgressHUDTypeFlashingLabel) {
        
        // If type is flashing , indicateFrame according to flashing text
        
        indicateViewH = self.flashingTextSize.height + 5 * _verticalMargin;
        indicateViewW = self.flashingTextSize.width + 3 * _horizontalMargin;
        
        // Not need Text label
        _text = nil;

    } else if (self.type == IHFProgressHUDTypeHorizontalBar) {
        
        // If type is flashing , indicateFrame according to flashing text
        CGFloat barW = _indicator.frame.size.width;
        CGFloat barH = _indicator.frame.size.height;
        
        indicateViewH = barH + 4 * _verticalMargin;
        indicateViewW = barW + 2 * _horizontalMargin;
        
        labelW = barW; // equal to bar width

    } else if (self.type == IHFProgressHUDTypeCircleBar) {
        
        // If type is flashing , indicateFrame according to flashing text
        CGFloat barW = _indicator.frame.size.width;
        CGFloat barH = _indicator.frame.size.height;
        
        indicateViewH = barH + 4 * _verticalMargin;
        indicateViewW = barW + 4 * _horizontalMargin;
        
        labelW = barW; // equal to bar width
    }
    
    CGFloat labelTopMargin = (indicateViewH == 0) ? _verticalMargin * 0.5 : _verticalMargin  * -0.5;  // Only text let label have top margin , else -margin to let close to invicator !

    CGFloat labelBottomMargin = _text ? _verticalMargin : 0 ;

    indicateFrame.size.height = indicateViewH;
    indicateFrame.size.width =  indicateViewW;

    _indicativeView.frame = indicateFrame;
    
    // Text label frame
    CGRect labelFrame = CGRectZero;
    
    labelFrame.size.width = MAX(labelW, _kIndicatorWidth);
    labelFrame.size.height = MIN(self.textSize.height, _maxHUDHeight - indicateViewH - _verticalMargin);
    labelFrame.origin.x = (indicateViewW - labelFrame.size.width) * 0.5;
    labelFrame.origin.y = indicateViewH + labelTopMargin;

    _textLabel.frame = labelFrame;
    
    // New Self frame
    CGFloat newH = MIN(indicateViewH + CGRectGetHeight(labelFrame) + labelBottomMargin,_maxHUDHeight);  // labelBottomMargin is add Label margin to supview
    CGFloat newW = indicateFrame.size.width;
    CGFloat newY = (_superViewSize.height - newH) * 0.5; // center
    CGFloat newX = (_superViewSize.width - newW) * 0.5;

    self.frame = CGRectMake(newX, newY, newW, newH);
    
    if(self.type == IHFProgressHUDTypeFlashingLabel) {
        CGFloat indicatorH = 35;
        CGFloat indicatorY = (newH - indicatorH) * 0.5;
        self.indicator.frame = CGRectMake(0, indicatorY, indicateViewW, indicatorH);
    } else {
        self.indicator.center = _indicativeView.center;
    }
}

#pragma mark - custom method

- (void)setupView {
    
    self.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1.0];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;

    
    UIView *indicativeView = [[UIView alloc] init];
    indicativeView.backgroundColor = [UIColor clearColor];

    [self addSubview:indicativeView];
    _indicativeView = indicativeView;
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor colorWithRed:69 / 255.0 green:69 / 255.0 blue:69 / 255.0 alpha:1.0];
    [self addSubview:label];
    _textLabel = label;
    
    [self updateIndicateView];
}

- (void)configureParamters {
    self.maxHUDWidth = 200;
    self.horizontalMargin = 25;
    self.verticalMargin = 10;
    self.maxHUDHeight = 300;
}

- (void)updateIndicateView {
    
    UIView *indicator = self.indicator;
    
    if(_type == IHFProgressHUDTypeIndicatorView) {
        
        if([indicator isKindOfClass:[UIActivityIndicatorView class]]) {
            [(UIActivityIndicatorView *)indicator startAnimating];
        } else {
            [indicator removeFromSuperview];
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            indicator.color = [UIColor grayColor];
            [indicator startAnimating];
            [_indicativeView addSubview:indicator];
            _indicator = indicator;
        }
    } else if(_type == IHFProgressHUDTypeCheckMark) {
        
        if([indicator isKindOfClass:[IHFCheckMarkView class]]) {
            [(IHFCheckMarkView *)indicator animate];
        }else {
            [indicator removeFromSuperview];
            IHFCheckMarkView *indicator = [[IHFCheckMarkView alloc] initWithFrame:CGRectMake(0, 0, _kIndicatorWidth, _kIndicatorHeight)];
            [_indicativeView addSubview:indicator];
            _indicator = indicator;
        }
    } else if(_type == IHFProgressHUDTypeCheckError) {
        
        if([indicator isKindOfClass:[IHFCheckErrorView class]]) {
            [(IHFCheckErrorView *)indicator animate];
        } else {
            [indicator removeFromSuperview];
            IHFCheckErrorView *indicator = [[IHFCheckErrorView alloc] initWithFrame:CGRectMake(0, 0, _kIndicatorWidth, _kIndicatorHeight)];
            [_indicativeView addSubview:indicator];
            _indicator = indicator;
        }
    } else if(_type == IHFProgressHUDTypeFlashingLabel) {
        
        if ([indicator isKindOfClass:[IHFFlashingLabel class]]) {
            IHFFlashingLabel *label = (IHFFlashingLabel *)indicator;
            label.text = _flashingText;
            [label stopFlashing];
            [label startFlashing];
        } else {
            [indicator removeFromSuperview];
            IHFFlashingLabel *indicator = [[IHFFlashingLabel alloc] init];
            indicator.text = _flashingText;
            indicator.textColor = [UIColor grayColor];
            indicator.font = [UIFont systemFontOfSize:30];
            indicator.flashingType = IHFFlashingTypeOfAutoreverses;
            indicator.flashingWidth = 20;
            indicator.flashingRadius = 20;
            indicator.flashingColor = [UIColor yellowColor];
            indicator.textAlignment = NSTextAlignmentCenter;
            [indicator startFlashing];
            [_indicativeView addSubview:indicator];

            _indicator = indicator;
        }
    } else if (_type == IHFProgressHUDTypeOnlyText) {
        [indicator removeFromSuperview];
    } else if (_type == IHFProgressHUDTypeHorizontalBar) {
        if([indicator isKindOfClass:[IHFProgressHorizontalBar class]]) {
            IHFProgressHorizontalBar *bar = (IHFProgressHorizontalBar *)indicator;
            bar.progress = 0.f;
        } else {
            [indicator removeFromSuperview];
            IHFProgressHorizontalBar *indicator = [[IHFProgressHorizontalBar alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
            [_indicativeView addSubview:indicator];
            _indicator = indicator;
        }
    } else if(_type == IHFProgressHUDTypeCircleBar) {
        if([indicator isKindOfClass:[IHFProgressCircleBar class]]) {
            IHFProgressCircleBar *bar = (IHFProgressCircleBar *)indicator;
            bar.progress = 0.f;
        } else {
            [indicator removeFromSuperview];
            IHFProgressCircleBar *indicator = [[IHFProgressCircleBar alloc] initWithFrame:CGRectMake(0, 0, 37.f, 37.f)];
            [_indicativeView addSubview:indicator];
            _indicator = indicator;
        }
    } else if(_type == IHFProgressHUDTypeCustomView) {
        
        [indicator removeFromSuperview];

        if(_customView) {
            [_indicativeView addSubview:_customView];
            _indicator = _customView;
        }
    }
}

#pragma mark - setter and getter

- (CGSize)textSize {
    
    if (!_text) return CGSizeZero;
    
    CGSize size = CGSizeMake(self.maxHUDWidth - 2 * _horizontalMargin, MAXFLOAT);
        
    NSDictionary *attributes = @ {NSFontAttributeName:_textLabel.font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    return [_text boundingRectWithSize:size options:options attributes:attributes context:NULL].size;
}

- (CGSize)flashingTextSize {
    
    if (!_flashingText) return CGSizeZero;
    
    CGSize size = CGSizeMake(self.maxHUDWidth - 2 * _horizontalMargin, MAXFLOAT);
    
    IHFFlashingLabel *flashingLabel = (IHFFlashingLabel *)_indicator;
    NSDictionary *attributes = @ {NSFontAttributeName:flashingLabel.font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    return [_flashingText boundingRectWithSize:size options:options attributes:attributes context:NULL].size;
}

- (void)setText:(NSString *)text {
    
    if (_text == text) return;
    _text = text;
    _textLabel.text = text;
    
    if (self.isShowing)  {
        [self setNeedsLayout];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor == textColor) return;
    _textColor = textColor;
    _textLabel.textColor = textColor;
}

- (void)setType:(IHFProgressHUDType)type {
    
    _type = type;
    
    [self updateIndicateView];
    
    if (self.isShowing)  {
        [self setNeedsLayout];
    }
}

- (void)setFlashingText:(NSString *)flashingText {
    
    _flashingText = flashingText;
    self.type = IHFProgressHUDTypeFlashingLabel;
    
    if (self.isShowing)  {
        [self setNeedsLayout];
    }
}

- (void)setCustomView:(UIView *)customView {
    
    _customView = customView;
    self.type = IHFProgressHUDTypeCustomView;
}

- (void)setProgress:(CGFloat)progress {
    
    if (_progress == progress) return;
    
    _progress = progress;
    
    UIView *indicator = self.indicator;
    if ([indicator respondsToSelector:@selector(setProgress:)])  {
        [(id)indicator setValue:@(self.progress) forKey:@"progress"];
    }
}

- (UIView *)maskView {
    if (!_maskView)  {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.frame = [[UIScreen mainScreen] bounds];
        self.maskViewUserInteractionEnabled = YES;
    }
    return _maskView;
}

- (void)setMaskViewColor:(UIColor *)maskViewColor {
    
    if(_maskViewColor == maskViewColor) return;
    _maskViewColor = maskViewColor;
    self.maskView.backgroundColor = maskViewColor;
}

- (void)setMaskViewUserInteractionEnabled:(BOOL)maskViewUserInteractionEnabled {
    if(_maskViewUserInteractionEnabled == maskViewUserInteractionEnabled) return;
    _maskViewUserInteractionEnabled = maskViewUserInteractionEnabled;
    self.maskView.userInteractionEnabled = maskViewUserInteractionEnabled;
}

#pragma mark - instance class show

- (void)show {
    [self showAnimated:YES];
}

- (void)showAnimated:(BOOL)animated {
    [self showInView:nil animation:animated];
}

- (void)showInView:(UIView *)aView animation:(BOOL)animated {
    
    if(self.isShowing) {
        [self timerInvalidate];
        return; // If is showing , not need add in subview again
    }
    
    if (aView == nil)
        aView = [[UIApplication sharedApplication].windows lastObject];

    [self addToView:aView];
    
    if(animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1.0f;
            self.maskView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            if(finished) {
                [self tellDelageteDidShowAnimation:YES];
            }
        }];
    } else {
        self.alpha = 1.0f;
        self.maskView.alpha = 1.0f;
        [self tellDelageteDidShowAnimation:NO];
    }
}

#pragma mark - instance class hide

- (void)hide {
    [self hideAnimation:YES];
}

- (void)hideAnimation:(BOOL)animated {
    
    if(animated) {
        self.alpha = 1.f;
        self.maskView.alpha = 1.f;
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0.f;
            self.maskView.alpha = 0.f;
        } completion:^(BOOL finished) {
            if(finished) {
                [self clean];
                [self tellDelageteDidHideAnimation:YES];
            };
        }];
    }else {
        [self clean];
        [self tellDelageteDidHideAnimation:NO];
    }
    
}

- (void)hideAfterDelay:(NSTimeInterval)delay {
    [self hideAnimation:YES afterDelay:delay];
}

- (void)hideAnimation:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    
    if(delay > 0) {
        // Use timer , not hide right now!
        NSTimer *timer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(handleHideTimer:) userInfo:@(animated) repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.hideTimer = timer;
    } else {
        [self hideAnimation:animated];
    }
}

- (void)handleHideTimer:(NSTimer *)timer {
    [self hideAnimation:[timer.userInfo boolValue]];
}

#pragma mark - support method

- (void)tellDelageteDidShowAnimation:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(progressHUD:didShowAnimation:)]) {
        [self.delegate progressHUD:self didShowAnimation:YES];
    }
}

- (void)tellDelageteDidHideAnimation:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(progressHUD:didHideAnimation:)]) {
        [self.delegate progressHUD:self didHideAnimation:YES];
    }
}

- (void)addToView:(UIView *)superView {
    [superView addSubview:self];
    [superView insertSubview:self.maskView belowSubview:self];
    
    self.isShowing = YES;
    
    // Alpha Animation
    self.alpha = 0;
    _maskView.alpha = 0;
}

- (void)timerInvalidate {
    [self.hideTimer invalidate];
    self.hideTimer = nil;
}

- (void)clean {
    [self.indicator.layer removeAllAnimations];
    [self.indicativeView.layer removeAllAnimations];

    [self timerInvalidate];
    [self removeFromSuperview];
    [self.maskView removeFromSuperview];

    self.isShowing = NO;
}

#pragma mark - Class method show 

// Show indicator

+ (void)showMessage:(NSString *)text {
    [self showMessage:text animation:YES];
}

+ (void)showMessage:(NSString *)text inView:(UIView *)aView {
    [self showMessage:text inView:aView animation:YES];
}

+ (void)showMessage:(NSString *)text animation:(BOOL)animated {
    [self showMessage:text inView:nil animation:animated];
}

+ (void)showMessage:(NSString *)text inView:(UIView *)aView animation:(BOOL)animated {
    
    IHFProgressHUD *hud = [IHFProgressHUD shareProgressHUD];
    [hud showInView:aView animation:animated];
    hud.type = IHFProgressHUDTypeIndicatorView;
    hud.text = text;
    [hud hideAnimation:animated afterDelay:30.f];
}

// Show flashing text

+ (void)showFlashingText:(NSString *)flashingText {
    [self showFlashingText:flashingText inView:nil];
}

+ (void)showFlashingText:(NSString *)flashingText inView:(UIView *)aView {
    [self showFlashingText:flashingText inView:aView animation:YES];

}

+ (void)showFlashingText:(NSString *)flashingText animation:(BOOL)animated {
    [self showFlashingText:flashingText inView:nil animation:YES];

}

+ (void)showFlashingText:(NSString *)flashingText inView:(UIView *)aView animation:(BOOL)animated {
    
    IHFProgressHUD *hud = [IHFProgressHUD shareProgressHUD];
    [hud showInView:aView animation:animated];
    hud.flashingText = flashingText;
    [hud hideAnimation:animated afterDelay:30.f];
}

// Show success

+ (void)showSuccess:(NSString *)text {
    [self showSuccess:text inView:nil];
}

+ (void)showSuccess:(NSString *)text animation:(BOOL)animated {
    [self showSuccess:text inView:nil animation:animated];
}

+ (void)showSuccess:(NSString *)text inView:(UIView *)aView {
    [self showSuccess:text inView:aView animation:YES];
}

+ (void)showSuccess:(NSString *)text inView:(UIView *)aView animation:(BOOL)animated {
    IHFProgressHUD *hud = [IHFProgressHUD shareProgressHUD];
    [hud showInView:aView animation:animated];
    hud.type = IHFProgressHUDTypeCheckMark;
    hud.text = text;
    [hud hideAnimation:animated afterDelay:2.f];
}

// Show success

+ (void)showError:(NSString *)text {
    [self showError:text inView:nil];
}

+ (void)showError:(NSString *)text animation:(BOOL)animated {
    [self showMessage:text inView:nil animation:animated];
}

+ (void)showError:(NSString *)text inView:(UIView *)aView {
    [self showMessage:text inView:aView animation:YES];

}

+ (void)showError:(NSString *)text inView:(UIView *)aView animation:(BOOL)animated {
    IHFProgressHUD *hud = [IHFProgressHUD shareProgressHUD];
    [hud showInView:aView animation:animated];
    hud.type = IHFProgressHUDTypeCheckError;
    hud.text = text;
    [hud hideAnimation:animated afterDelay:2.f];
}

// Show text (only text)

+ (void)showText:(NSString *)text {
    [self showText:text animation:YES];
}

+ (void)showText:(NSString *)text animation:(BOOL)animated {
    [self showText:text inView:nil animation:animated];
}

+ (void)showText:(NSString *)text inView:(UIView *)aView {
    [self showText:text inView:aView animation:YES];

}

+ (void)showText:(NSString *)text inView:(UIView *)aView animation:(BOOL)animated {
    IHFProgressHUD *hud = [IHFProgressHUD shareProgressHUD];
    [hud showInView:aView animation:animated];
    hud.type = IHFProgressHUDTypeOnlyText;
    hud.text = text;
    [hud hideAnimation:animated afterDelay:2.f];
}

// Show custom view and text

+ (void)showCustomView:(UIView *)customView text:(NSString *)text {
    [self showCustomView:customView text:text animation:YES];
}

+ (void)showCustomView:(UIView *)customView text:(NSString *)text animation:(BOOL)animated {
    [self showCustomView:customView text:text inView:nil animation:animated];
}

+ (void)showCustomView:(UIView *)customView text:(NSString *)text inView:(UIView *)aView {
    [self showCustomView:customView text:text inView:aView animation:YES];
}

+ (void)showCustomView:(UIView *)customView text:(NSString *)text inView:(UIView *)aView animation:(BOOL)animated {
    
    IHFProgressHUD *hud = [IHFProgressHUD shareProgressHUD];
    [hud showInView:aView animation:animated];
    hud.text = text;
    hud.customView = customView;
}

// Show circle bar (use circle bar indicate current progress)
// return because it may need set the progress

+ (instancetype)showCircleBar:(NSString *)text {
    return [self showCircleBar:text animation:YES];
}

+ (instancetype)showCircleBar:(NSString *)text animation:(BOOL)animated {
    return [self showCircleBar:text inView:nil animation:animated];
}

+ (instancetype)showCircleBar:(NSString *)text inView:(UIView *)aView {
    return [self showCircleBar:text inView:aView animation:YES];
}

+ (instancetype)showCircleBar:(NSString *)text inView:(UIView *)aView animation:(BOOL)animated {
    
    IHFProgressHUD *hud = [IHFProgressHUD shareProgressHUD];
    [hud showInView:aView animation:animated];
    hud.type = IHFProgressHUDTypeCircleBar;
    hud.progress = 0.f;
    hud.text = text;
    return hud;
}

// Show horizontal bar (current progress)
// return because it may need set the progress

+ (instancetype)showHorizontalBar:(NSString *)text {
    return [self showHorizontalBar:text animation:YES];
}

+ (instancetype)showHorizontalBar:(NSString *)text animation:(BOOL)animated {
    return [self showHorizontalBar:text inView:nil animation:animated];
}

+ (instancetype)showHorizontalBar:(NSString *)text inView:(UIView *)aView {
    return [self showHorizontalBar:text inView:aView animation:YES];
}

+ (instancetype)showHorizontalBar:(NSString *)text inView:(UIView *)aView animation:(BOOL)animated {
    
    IHFProgressHUD *hud = [IHFProgressHUD shareProgressHUD];
    [hud showInView:aView animation:animated];
    hud.type = IHFProgressHUDTypeHorizontalBar;
    hud.progress = 0.f;
    hud.text = text;
    return hud;
}

#pragma mark - Class method hide 
+ (void)hideHUD {
    [self hideHUDForView:nil];
}
+ (void)hideHUDAnimated:(BOOL)animated {
    [self hideHUDForView:nil animation:animated];
}
+ (void)hideHUDForView:(UIView *)view {
    [self hideHUDForView:view animation:YES];
}
+ (void)hideHUDForView:(UIView *)view animation:(BOOL)animated {

    IHFProgressHUD *hud = [IHFProgressHUD shareProgressHUD];
    [hud hideAnimation:animated];
}

@end
