# IHFProgressHUD
好用的提示框！

IHFProgressHUD 主要是用来针对网络情况给用户的提示控件。

目前主要是实现这些样式的提示框
```
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

```
****
类方法来实现上面样式：
****

####IHFProgressHUDTypeIndicatorView####
```
+ (void)showMessage:(NSString *)text;
```

####IHFProgressHUDTypeFlashingLabel####
```
+ (void)showFlashingText:(NSString *)showFlashingText;
```

####IHFProgressHUDTypeCheckMark####
```
+ (void)showSuccess:(NSString *)text;
```
####IHFProgressHUDTypeCheckError####
```
+ (void)showError:(NSString *)text;
```

####IHFProgressHUDTypeOnlyText####
```
+ (void)showText:(NSString *)text;
```

####IHFProgressHUDTypeCustomView####
```
+ (void)showCustomView:(UIView *)customView text:(NSString *)text;
```

####IHFProgressHUDTypeHorizontalBar####
```
+ (instancetype)showHorizontalBar:(NSString *)text;
```

####IHFProgressHUDTypeCircleBar####
```
+ (instancetype)showCircleBar:(NSString *)text;
```

> 注意：
1.只有HorizontalBar和CircleBar 我们有返回对象，为了让对象设置progress ，给用户知道下载的进度条。
2.CheckMark,CheckError样式会2s后消失，其他都要调用[IHFProgress hide]消失 ，或者也有30s后消失
3.FlashingLabel样式就是showFlashingText就是要闪烁的文字。

****
实例方法实现
****

通过单例得到对象：
```
+ (instancetype)shareProgressHUD;
```

可以设置如下的参数

####显示样式####
IHFProgressHUDType 
>注意：
如果设置了
IHFProgressHUDTypeFlashingLabel样式，要设置flashingText（要闪烁的文字）
如果设置了
IHFProgressHUDTypeCustomView样式，要设置customView（自定义的视图）

#### 显示大小 ####
maxHUDWidth 最大的宽度，默认200
maxHUDHeight; 最大的高度,  默认300
horizontalMargin; 横向边距,  默认25
verticalMargin;  纵向边距 ， 默认10

####延时消失时间####
delayTime; 几秒后消失

####背景####
IHFProgressHUDBackgroundStyle : 有模糊和颜色样式
maskViewUserInteractionEnabled ：背景的交互是否有效。 默认有效，有效的话在提示框出现时候就不能响应屏幕的其他点击事件，比如返回到前一个控制器操作等等。

设置好属性后，同样用
```
- (void)show;
- (void)hide;
```
来隐藏和消失

> 最后 : 
1.在HUD出现和消失我们都有didShow 和 didHide 2个代理事件
2.无论类方法和实例方法 我们都有Animtion 和 view 的参数设置，一般都用最简单的方法， 默认是有动画和加载最前面的View . 你也可以根据自己项目进行设置。

简书地址 ：http://www.jianshu.com/p/db7c405ac1fe
有什么问题assues我 cjsykx@163.com