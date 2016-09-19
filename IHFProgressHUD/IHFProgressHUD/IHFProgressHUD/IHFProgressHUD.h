//
//  IHFProgressHUD.h
//  IHFProgressHUD
//
//  Created by chenjiasong on 16/9/1.
//  Copyright © 2016年 Cjson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IHFProgressHUD;
@protocol IHFProgressHUDDelegate <NSObject>

@optional
/**
 Tell delegate the HUD have completed showed!
 */
- (void)progressHUD:(IHFProgressHUD *)HUD didShowAnimation:(BOOL)animated;

/**
 Tell delegate the popup view have completed hiden!
 */
- (void)progressHUD:(IHFProgressHUD *)HUD didHideAnimation:(BOOL)animated;
@end

typedef NS_ENUM(NSInteger, IHFProgressHUDType) {
    
    IHFProgressHUDTypeIndicatorView, // ActivityIndicatorView , show message
    
    IHFProgressHUDTypeCircleBar, // circle bar
    
    IHFProgressHUDTypeHorizontalBar,     // Horizontal progress bar.

    IHFProgressHUDTypeCustomView, //  Show by custom define
    
    IHFProgressHUDTypeOnlyText,    // Show text, only text.
    
    IHFProgressHUDTypeCheckMark, // shows success
    
    IHFProgressHUDTypeCheckError, // shows error
    
    IHFProgressHUDTypeFlashingLabel, // flashing label , you must set the flashing text!
};

typedef NS_ENUM(NSInteger, IHFProgressHUDBackgroundStyle) {
    
    IHFProgressHUDBackgroundStyleColor, // Using color.default, and color is clear!
    IHFProgressHUDBackgroundStyleBlur   // Using blur
};

/**
 IHFProgrssHUD : The HUD usually use for indicated the network condistions . It can show and hide . Show and hide can use Class method and instance method.
 Class method : It can easier to show the HUD and type what you like for you . AND it use single instance .
 Instance method : It can to change the appearence for the HUD and set its delegate , after delay and so on . 
 */
@interface IHFProgressHUD : UIView

// ****************************** Class method *****************************


// Single instance
+ (instancetype)shareProgressHUD;

/////////////////////// Show

// Show indicator

/** 
 Shows indicator with specified text
 */
+ (void)showMessage:(NSString *)text;

+ (void)showMessage:(NSString *)text inView:(UIView *)aView;
+ (void)showMessage:(NSString *)text animation:(BOOL)animated;
+ (void)showMessage:(NSString *)text inView:(UIView *)aView animation:(BOOL)animated;

/**
 Shows specified text and mask it flasing
 */

+ (void)showFlashingText:(NSString *)flashingText;
+ (void)showFlashingText:(NSString *)flashingText inView:(UIView *)aView;
+ (void)showFlashingText:(NSString *)flashingText animation:(BOOL)animated;
+ (void)showFlashingText:(NSString *)flashingText inView:(UIView *)aView animation:(BOOL)animated;

/**
 Shows success with specified text
 */

+ (void)showSuccess:(NSString *)text;
+ (void)showSuccess:(NSString *)text animation:(BOOL)animated;
+ (void)showSuccess:(NSString *)text inView:(UIView *)aView;
+ (void)showSuccess:(NSString *)text inView:(UIView *)aView animation:(BOOL)animated;

/**
 Shows error with specified text
 */

+ (void)showError:(NSString *)text;
+ (void)showError:(NSString *)text animation:(BOOL)animated;
+ (void)showError:(NSString *)text inView:(UIView *)aView;
+ (void)showError:(NSString *)text inView:(UIView *)aView animation:(BOOL)animated;

// Show text (only text)

/**
 Shows specified text (only text)
 */

+ (void)showText:(NSString *)text;
+ (void)showText:(NSString *)text animation:(BOOL)animated;
+ (void)showText:(NSString *)text inView:(UIView *)aView;
+ (void)showText:(NSString *)text inView:(UIView *)aView animation:(BOOL)animated;

// Show circle bar (use circle bar indicate current progress)
// return because it may need set the progress

/**
 returns circle bar HUD with specified text
 @ set progress to draw the circle
 */

+ (instancetype)showCircleBar:(NSString *)text;
+ (instancetype)showCircleBar:(NSString *)text animation:(BOOL)animated;
+ (instancetype)showCircleBar:(NSString *)text inView:(UIView *)aView;
+ (instancetype)showCircleBar:(NSString *)text inView:(UIView *)aView animation:(BOOL)animated;

// Show horizontal bar (current progress)
// return because it may need set the progress

/**
 returns horizontal bar HUD with specified text
 @ set progress to draw the circle
 */
+ (instancetype)showHorizontalBar:(NSString *)text;
+ (instancetype)showHorizontalBar:(NSString *)text animation:(BOOL)animated;
+ (instancetype)showHorizontalBar:(NSString *)text inView:(UIView *)aView;
+ (instancetype)showHorizontalBar:(NSString *)text inView:(UIView *)aView animation:(BOOL)animated;

// Show custom view and text

/**
 show HUD with specified text and custom view
 */

+ (void)showCustomView:(UIView *)customView text:(NSString *)text;
+ (void)showCustomView:(UIView *)customView text:(NSString *)text animation:(BOOL)animated;
+ (void)showCustomView:(UIView *)customView text:(NSString *)text inView:(UIView *)aView;
+ (void)showCustomView:(UIView *)customView text:(NSString *)text inView:(UIView *)aView animation:(BOOL)animated;


///////////////////////// Hide

+ (void)hideHUD;
+ (void)hideHUDAnimated:(BOOL)animated;
+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUDForView:(UIView *)view animation:(BOOL)animated;


// ****************************** instance method *****************************

//////////////// show

- (void)show;
- (void)showAnimated:(BOOL)animated;
- (void)showInView:(UIView *)aView animation:(BOOL)animated;

//////////////// hide

- (void)hide;
- (void)hideAnimation:(BOOL)animated;
- (void)hideAfterDelay:(NSTimeInterval)delay;
- (void)hideAnimation:(BOOL)animated afterDelay:(NSTimeInterval)delay;



// ****************************** property *****************************

@property (assign, nonatomic) IHFProgressHUDType type; /**< the type decide the apperence */
@property (assign, nonatomic) IHFProgressHUDBackgroundStyle backgroundStyle; /**< backgroundStyle */

@property (copy, nonatomic) NSString *text; /**< The text show the status to tell user */
@property (strong, nonatomic) UIColor *textColor; /**< The text show the status to tell user */

@property (assign, nonatomic, readonly) NSTimeInterval delayTime; /**< Delay time to hide */

@property (assign, nonatomic) CGFloat maxHUDWidth; /**< max hud width ,defalut 200 . you can set it fit to you */
@property (assign, nonatomic) CGFloat maxHUDHeight; /**< max hud height defalut 300 . you can set it fit to you */

@property (assign, nonatomic) CGFloat horizontalMargin; /**< defalut 25 . you can set it fit to you */
@property (assign, nonatomic) CGFloat verticalMargin; /**< defalut 10 . you can set it fit to you */

@property (weak, nonatomic) id <IHFProgressHUDDelegate> delegate; /**< HUD Delegae , to get the action of the HUD completion showed and hiden */


////// ---------------- progress bar type ------------------------

@property (assign, nonatomic) CGFloat progress; /**< Shows the progress of your request , range is (0 - 1). it only task effect if the type is status bar   */
@property (strong, nonatomic) UIColor *progressBarTintColor; /**< Only take effect if the type is status bar   */


////// ---------------- custom view type ------------------------

@property (strong, nonatomic) UIView *customView; /**< Only task effect if the type is custom view */


////// ---------------- flashing label type ------------------------

@property (strong, nonatomic) NSString *flashingText; /**< Flash text , only take effect by type of flashingLabel . */

// Flashing Color

////// ---------------- mask view ------------------------

// Mask view , you may set the color and User interaction enabled .
// Color is using to cover beyond the visible of HUD. BUT default clear color NOT to cover.
// maskViewUserInteractionEnabled is using to let user to decide : can do operation if the HUD is showing whether or not ! eg: User want POP controller , and not want to continiue to request.

@property (strong, nonatomic) UIColor *maskViewColor; /**< Mask view color , default clear color , means NOT to cover beyond the visible of HUD*/

@property (assign, nonatomic) BOOL maskViewUserInteractionEnabled; /**< User interaction enabled , defalut YES , Means can't do operation in HUD is showing */


@end
