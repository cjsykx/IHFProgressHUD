//
//  IHFFlashingLabel.h
//  IHFProgressHUD
//
//  Created by chenjiasong on 16/8/31.
//  Copyright © 2016年 Cjson. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, IHFFlashingType) {
    
    IHFFlashingTypeOfDirectionLeftToRight = 0x00,  // Default . direction left to right .
    IHFFlashingTypeOfDirectionRightToLeft = 0x01,  // Direction right to left.
    IHFFlashingTypeOfAutoreverses = 0x02,   // Left and right Reverse blinking.
    IHFFlashingTypeOfOverallFlashing = 0x03,       // over all Flashing
};
@interface IHFFlashingLabel : UIView


// UILabel property

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) NSAttributedString *attributedText;
@property (assign, nonatomic) NSInteger numberOfLines;
@property (assign, nonatomic) NSTextAlignment textAlignment; //Default is left


// flashing appearece

@property (assign, nonatomic) IHFFlashingType flashingType;   /**< flashing type, Default left to right */

@property (assign, nonatomic , getter=isRepeat) BOOL repeat;    /**< If repeat , the label will repeat flasing .Default yes */
@property (assign, nonatomic) CGFloat flashingWidth;             // Default 20
@property (assign, nonatomic) CGFloat flashingRadius;            // Default 20
@property (strong, nonatomic) UIColor *flashingColor;            // Default white color
@property (assign, nonatomic) NSTimeInterval durationTime;      // Default 2s

@property (assign, nonatomic, readonly) BOOL isFlashing; /**< The label is flasing or not */

- (void)startFlashing;
- (void)stopFlashing;

@end
