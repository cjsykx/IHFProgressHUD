//
//  JSLabelHUD.m
//  JSProgressHUD
//
//  Created by Cjson on 15/10/21.
//  Copyright (c) 2015年 ihefe. All rights reserved.

//  the class use for a simple remind the user something .

#import "JSLabelHUD.h"

static CFTimeInterval const _kDefaultForwardAnimationDuration = 0.5;
static CFTimeInterval const _kDefaultBackwardAnimationDuration = 0.5;
static CFTimeInterval const _kDefaultWaitAnimationDuration = 0.5;

static CGFloat const _kDefaultTopMargin = 50.0;
static CGFloat const _kDefaultBottomMargin = 50.0;
static CGFloat const _kDefalultTextInset = 10.0;

@implementation JSLabelHUD

#pragma mark - system method
-(instancetype)initWithText:(NSString *)text{
    
    self = [super init];
    
    if (self) {
        self.text = text;

        [self sizeToFit];
    }
    
    return self;
}

+(instancetype)labelHUDWithText:(NSString *)text{
    
    return [[self alloc] initWithText:text];
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // TODO:user can be set frame for the label
        // Do an initialization setting for the Label
        self.forwardAnimationDuration = _kDefaultForwardAnimationDuration;
        self.backwardAnimationDuration = _kDefaultBackwardAnimationDuration;
        self.textInsets = UIEdgeInsetsMake(_kDefalultTextInset, _kDefalultTextInset, _kDefalultTextInset, _kDefalultTextInset);
        self.maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) - 20.0;
        
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:14.0];

    }
    
    return self;
}

-(void)sizeToFit{
    
    [super sizeToFit];
    
    CGRect frame = self.frame;
    
    // width
    CGFloat width = CGRectGetWidth(self.bounds) + self.textInsets.left + self.textInsets.right;
    frame.size.width = width > self.maxWidth ? self.maxWidth : width;
    
    // height
    frame.size.height = CGRectGetHeight(self.bounds) + self.textInsets.top + self.textInsets.bottom;
    
    self.frame = frame;
}

#pragma mark - costom method
-(void)beginAnimationGroup{
    
    // forwardAnimation set
    CABasicAnimation *forwardAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    forwardAnimation.duration = self.forwardAnimationDuration;
    forwardAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5f :1.7f :0.6f :0.85f];
    forwardAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    forwardAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    // backwardAnimation set
    CABasicAnimation *backwardAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    backwardAnimation.duration = self.backwardAnimationDuration;
    backwardAnimation.beginTime = forwardAnimation.duration + _kDefaultWaitAnimationDuration;
    backwardAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4f :0.15f :0.5f :-0.7f];
    backwardAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    backwardAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    
    //animationGroup set
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[forwardAnimation,backwardAnimation];
    animationGroup.duration = forwardAnimation.duration + backwardAnimation.duration + _kDefaultWaitAnimationDuration;
    animationGroup.removedOnCompletion = NO;
    animationGroup.delegate = self;
    animationGroup.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:animationGroup forKey:nil];
}

// animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if(flag){
        [self removeFromSuperview];
    }
}

/**
 *  let label show in the view , default position is center
 *
 *  @param view
 */
-(void)showInView:(UIView *)view{
    
    [self beginAnimationGroup];
    
    CGPoint viewPoint = view.center;
    
    // default center
    self.center = viewPoint;
    
    [view addSubview:self];
    
}

/**
 *  let label show in the view
 *
 *  @param view
 *  @param position 
 */
- (void)showInView:(UIView *)view inPostion:(JSLabelHUDShowInPosition)position
{
    [self beginAnimationGroup];
    
    CGPoint point = view.center;
    
    switch (position) {
        case JSLabelHUDShowInPositionTop:
            
            point.y = _kDefaultTopMargin;
            break;
            
        case JSLabelHUDShowInPositionBottom:
            
            point.y = CGRectGetHeight(view.bounds) - _kDefaultBottomMargin;
            break;
            
        default:
            break;
    }
    
    self.center = point;
    [view addSubview:self];
}

// sizeToFit Need
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    bounds.size = [self.text boundingRectWithSize:CGSizeMake(self.maxWidth - self.textInsets.left - self.textInsets.right,
                                                             CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    return bounds;
    
}



@end
