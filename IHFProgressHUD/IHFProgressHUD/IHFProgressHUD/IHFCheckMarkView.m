//
//  IHFCheckMarkView.m
//  IHFProgressHUD
//
//  Created by chenjiasong on 16/8/30.
//  Copyright © 2016年 Cjson. All rights reserved.
//

#import "IHFCheckMarkView.h"
@interface IHFCheckMarkView ()
@property (weak, nonatomic) CAShapeLayer *circleLayer ;
@property (weak, nonatomic) CAShapeLayer *outlineLayer ;
@end

@implementation IHFCheckMarkView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupLayers];
        [self animate];
    }
    
    return self;
}

#pragma mark - CGPath

- (CGPathRef)outLineCircleWithFrame:(CGRect)rect {
    
    CGFloat startAngle = ((0) / 180.0 * M_PI) ; //0
    CGFloat endAngle = ((360) / 180.0 * M_PI) ;  //360
    
    CGFloat circle2R = rect.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(circle2R / 2, circle2R / 2) radius:rect.size.width / 2 startAngle:startAngle endAngle:endAngle clockwise:NO];
    
    return path.CGPath;
}

- (CGPathRef)circleWithFrame:(CGRect)rect {
    
    CGFloat startAngle = ((60) / 180.0 * M_PI) ; //0
    CGFloat endAngle = ((200) / 180.0 * M_PI) ;  //360
    
    CGFloat circle2R = CGRectGetWidth(rect);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(circle2R / 2, circle2R / 2) radius:rect.size.width / 2 startAngle:startAngle endAngle:endAngle clockwise:NO];
    
    [path moveToPoint:CGPointMake(circle2R / 4, circle2R / 2)];
    [path addLineToPoint:CGPointMake(circle2R / 4 + 10, circle2R / 2 + 10)];
    [path addLineToPoint:CGPointMake(circle2R / 4 * 3 + 10, circle2R / 4 - 5)];
    
    return path.CGPath;
}

- (void)setupLayers {
    
    CAShapeLayer *outlineLayer = [[CAShapeLayer alloc] init];
    
    outlineLayer.position = CGPointMake(0,0);
    outlineLayer.path = [self outLineCircleWithFrame:self.frame];
    outlineLayer.fillColor = [UIColor clearColor].CGColor;
    outlineLayer.strokeColor = [UIColor colorWithRed:150.0/255.0 green:216.0/255.0 blue:115.0/255.0 alpha:1.0].CGColor;
    outlineLayer.lineCap = kCALineCapRound;
    outlineLayer.lineWidth = 4;
    outlineLayer.opacity = 0.1;
    [self.layer addSublayer:outlineLayer];
    
    _outlineLayer = outlineLayer;
    
    CAShapeLayer *circleLayer = [[CAShapeLayer alloc] init];
    circleLayer.position = CGPointMake(0,0);
    circleLayer.path = [self circleWithFrame:self.frame];
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = [UIColor colorWithRed:150.0/255.0 green:216.0/255.0 blue:115.0/255.0 alpha:1.0].CGColor;
    circleLayer.lineCap = kCALineCapRound;
    circleLayer.lineWidth = 4;
    
    [self.layer addSublayer:circleLayer];
    
    _circleLayer = circleLayer;
}


- (void)animate {
    
    CABasicAnimation *strokeStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    CABasicAnimation *strokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];    CGFloat factor = 0.045;
    strokeEnd.fromValue = @(0.00);
    strokeEnd.toValue = @(0.93);
    strokeEnd.duration = 10.0 * factor;
    
    CAMediaTimingFunction *timing = [CAMediaTimingFunction functionWithControlPoints:0.3 :0.6 :0.8 :1.2];
    strokeEnd.timingFunction = timing;
    
    strokeStart.fromValue = @(0.0);
    strokeStart.toValue = @(0.68);
    strokeStart.duration =  7.0 * factor;
    strokeStart.beginTime =  CACurrentMediaTime() + 3.0 * factor;
    strokeStart.fillMode = kCAFillModeBackwards;
    strokeStart.timingFunction = timing;
    _circleLayer.strokeStart = 0.68;
    _circleLayer.strokeEnd = 0.93;
    
    strokeEnd.removedOnCompletion = NO;
    strokeEnd.fillMode = kCAFillModeForwards;
    
    strokeStart.removedOnCompletion = NO;
    strokeStart.fillMode = kCAFillModeForwards;
    
    [self.circleLayer addAnimation:strokeEnd forKey:@"strokeEnd"];
    [self.circleLayer addAnimation:strokeStart forKey:@"strokeStart"];
}


#pragma mark - draw

- (void)drawSuccessWithFrame:(CGRect)rect {
    
    // Drawing code
    
    CGFloat circleR = rect.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(circleR / 2, circleR / 2) radius:rect.size.width / 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
    [path moveToPoint:CGPointMake(circleR / 4, circleR / 2)];
    CGPoint p1 = CGPointMake(circleR / 4 + 10, circleR / 2 + 10);
    [path addLineToPoint:p1];
    
    CGPoint p2 = CGPointMake(circleR / 4 * 3, circleR / 4);
    [path addLineToPoint:p2];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.lineWidth = 5;
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];
}

#pragma mark - support tool
- (void)cleanLayer:(UIView *)view {
    for (CALayer *layer in view.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
}
@end
