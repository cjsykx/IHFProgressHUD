//
//  JSLabelHUD.h
//  JSProgressHUD
//
//  Created by Cjson on 15/10/21.
//  Copyright (c) 2015年 ihefe. All rights reserved.
//

#import <UIKit/UIKit.h>

// set the position for the HUD
typedef NS_ENUM(NSInteger, JSLabelHUDShowInPosition){
    
    JSLabelHUDShowInPositionTop,  // in the top
    JSLabelHUDShowInPositionMiddle,  // in the middle
    JSLabelHUDShowInPositionBottom,  // in the bottom
    
};
@interface JSLabelHUD : UILabel
/**
 *  init with text
 *
 *  @param text : the text for show in view
 *
 *  @return self
 */
-(instancetype)initWithText:(NSString *)text;

+(instancetype)labelHUDWithText:(NSString *)text;

@property (nonatomic, assign) CFTimeInterval forwardAnimationDuration; /**< forword duration for animation */

@property (nonatomic, assign) CFTimeInterval backwardAnimationDuration;/**< backward duration for animation */

@property (nonatomic, assign) UIEdgeInsets   textInsets; /**< text edgeInset */

@property (nonatomic, assign) CGFloat        maxWidth; /**< max width for the label's width */

/**
 *  let label show in the view , default position is center
 *
 *  @param view
 */
-(void)showInView:(UIView *)view;

/**
 *  let label show in the view
 *
 *  @param view
 *  @param position
 */
- (void)showInView:(UIView *)view inPostion:(JSLabelHUDShowInPosition)position;

@end
