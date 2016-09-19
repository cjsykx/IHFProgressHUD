//
//  IHFCheckErrorView.m
//  IHFProgressHUD
//
//  Created by chenjiasong on 16/8/30.
//  Copyright © 2016年 Cjson. All rights reserved.
//

#import "IHFCheckErrorView.h"

@interface IHFCheckErrorView ()
@property (weak, nonatomic) CAShapeLayer *circleLayer ;
@property (weak, nonatomic) CAShapeLayer *crossPathLayer ;
@end

@implementation IHFCheckErrorView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayers];
        [self animate];
     
    }
    return self;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self setupLayers];
        [self animate];
        
    }
    return self;
}

#pragma mark - CGPath

- (CGPathRef)circleWithFrame:(CGRect)rect {
    
    CGFloat startAngle = ((0) / 180.0 * M_PI) ; //0
    CGFloat endAngle = ((360) / 180.0 * M_PI) ;  //360
    
    CGFloat circle2R = rect.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(circle2R / 2, circle2R / 2) radius:rect.size.width / 2 startAngle:startAngle endAngle:endAngle clockwise:NO];
    
    return path.CGPath;
}

- (CGPathRef)crossPathWithFrame:(CGRect)rect {
    
    CGFloat factor = self.frame.size.width / 5.0;
    
    CGFloat circle2R = rect.size.width;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(circle2R / 2.0 - factor, circle2R / 2.0 - factor)];
    CGPoint p1 = CGPointMake(circle2R / 2.0 + factor, circle2R / 2.0 + factor);
    [path addLineToPoint:p1];
    
    [path moveToPoint:CGPointMake(circle2R / 2.0 + factor, circle2R / 2.0 - factor)];
    CGPoint p2 = CGPointMake(circle2R / 2.0 - factor, circle2R / 2.0 + factor);
    [path addLineToPoint:p2];
    
    return path.CGPath;
}

- (void)setupLayers {
    
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / -500.0;
    t = CATransform3DRotate(t, (90.0 * M_PI / 180.0), 1, 0, 0);
    _circleLayer.transform = t;
    _crossPathLayer.opacity = 0.0;
    
    CAShapeLayer *crossPathLayer = [[CAShapeLayer alloc] init];
    crossPathLayer.path = [self crossPathWithFrame:self.frame];
    crossPathLayer.fillColor = [UIColor clearColor].CGColor;
    crossPathLayer.strokeColor = [UIColor redColor].CGColor;
    crossPathLayer.lineCap = kCALineCapRound;
    crossPathLayer.lineWidth = 4;;
    crossPathLayer.frame = self.bounds;
    crossPathLayer.position = CGPointMake(self.frame.size.width / 2.0,self.frame.size.height / 2.0);

    [self.layer addSublayer:crossPathLayer];
    
    _crossPathLayer = crossPathLayer;
    
    CAShapeLayer *circleLayer = [[CAShapeLayer alloc] init];
    circleLayer.path = [self circleWithFrame:self.frame];
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = [UIColor redColor].CGColor;
    circleLayer.lineCap = kCALineCapRound;
    circleLayer.lineWidth = 4;;
    circleLayer.frame = self.bounds;
    circleLayer.position = CGPointMake(self.frame.size.width / 2.0,self.frame.size.height /2.0);
    [self.layer addSublayer:circleLayer];
    
    _circleLayer = circleLayer;
}

- (void)animate {
    
    NSTimeInterval time = 0.4;

    CABasicAnimation *strokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEnd.fromValue = @(0.00);
    strokeEnd.toValue = @(1.0);
    strokeEnd.duration = time;
    strokeEnd.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeEnd.removedOnCompletion = NO;
    strokeEnd.fillMode = kCAFillModeBoth;
    [self.circleLayer addAnimation:strokeEnd forKey:@"strokeEnd"];
    
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / -500.0;
    t = CATransform3DRotate(t, (90.0 * M_PI / 180.0), 1, 0, 0);
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = 1.0 / -500.0;
    t2 = CATransform3DRotate(t2, (-M_PI), 1, 0, 0);

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = time;
    animation.fromValue = [NSValue valueWithCATransform3D:t];
    animation.toValue = [NSValue valueWithCATransform3D:t2];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.crossPathLayer addAnimation:animation forKey:@"scale"];
}

#pragma mark - support tool
- (void)cleanLayer:(UIView *)view {
    for (CALayer *layer in view.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
}

#pragma mark - draw

- (void)drawCheckError {
    
    [self cleanLayer:self];
    
    CGFloat circle2R = self.frame.size.width;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(circle2R / 2, circle2R / 2) radius:circle2R / 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    CGPoint p1 =  CGPointMake(circle2R / 4, circle2R/4);
    [path moveToPoint:p1];
    
    CGPoint p2 =  CGPointMake(circle2R / 4 * 3, circle2R / 4 * 3);
    [path addLineToPoint:p2];
    
    CGPoint p3 =  CGPointMake(circle2R / 4 * 3, circle2R / 4);
    [path moveToPoint:p3];
    
    CGPoint p4 =  CGPointMake(circle2R / 4, circle2R / 4 * 3);
    [path addLineToPoint:p4];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.lineWidth = 5;
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor redColor].CGColor;
    
    [self.layer addSublayer:layer];
}

@end
