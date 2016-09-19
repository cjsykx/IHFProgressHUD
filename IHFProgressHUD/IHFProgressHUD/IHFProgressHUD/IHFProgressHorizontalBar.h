//
//  IHFProgressBar.h
//  IHFProgressHUD
//
//  Created by chenjiasong on 16/9/5.
//  Copyright © 2016年 Cjson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IHFProgressHorizontalBar : UIView

@property (strong, nonatomic) UIColor *progressColor;
@property (strong, nonatomic) UIColor *barColor;
@property (strong, nonatomic) UIColor *progressRemainingColor;

@property (assign, nonatomic) CGFloat progress;

@end
