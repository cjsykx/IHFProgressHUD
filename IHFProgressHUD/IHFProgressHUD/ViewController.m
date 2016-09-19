//
//  ViewController.m
//  IHFProgressHUD
//
//  Created by chenjiasong on 16/8/30.
//  Copyright © 2016年 Cjson. All rights reserved.
//

#import "ViewController.h"
#import "IHFCheckErrorView.h"
#import "IHFFlashingLabel.h"

#import "IHFProgressHUD.h"
@interface ViewController ()<IHFProgressHUDDelegate>
@property (strong, nonatomic) IHFCheckErrorView *errorView;

@property (strong, nonatomic) IHFFlashingLabel *label1;
@property (strong, nonatomic) IHFFlashingLabel *label2;
@property (strong, nonatomic) IHFFlashingLabel *label3;
@property (strong, nonatomic) IHFFlashingLabel *label4;

@property (strong, nonatomic) IHFProgressHUD *hud;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval *currentTime;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(50, 50, 50, 50);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *button1 = [[UIButton alloc] init];
    button1.frame = CGRectMake(50, 300, 50, 50);
    button1.backgroundColor = [UIColor redColor];
    [button1 addTarget:self action:@selector(didCancleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];

    
    
//    _errorView = [[IHFCheckErrorView alloc] initWithFrame:CGRectMake(100, 300, 50, 50)];
//    [self.view addSubview:_errorView];

}

- (void)action:(NSTimer *)time{
    
    static int i = 0;
    i++;
    _hud.progress = i / 10.0;
}

- (void)didCancleButton:(UIButton *)sender{
//    [MBProgressHUD hideHUD];
//    [_hud hide];
//    [IHFProgressHUD hideHUD];
    

    [IHFProgressHUD showSuccess:@"success!"];

//    _hud.type = IHFProgressHUDTypeCheckMark;
//    _hud.text = @"success1111qqweqeqeqeqeqeqeqeqweqweqeqweewqeeeeeeeeeeeeeeqeqeqeqeeqweqweqweqeeqeqeqweqeqeqeqeqeqeqwqweweqeqeweeqweqwe";
}

- (void)didClickButton:(UIButton *)sender{
   
//    IHFProgressHUD *hud = [IHFProgressHUD showHorizontalBar:@"IHEFE"];
//    hud.delegate = self;
//    hud.maskViewUserInteractionEnabled = NO;
    


//    IHFProgressHUD *hud = [[IHFProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    [self.view addSubview:hud];
//    hud.text = @"success";
//    _hud = hud;
//    [hud show];
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bannerFailure"]];
//    hud.type = IHFProgressHUDTypeIndicatorView;
    
    [IHFProgressHUD showCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bannerFailure"]] text:@"success1111qqweqeqeqeqeqeqeqeqweqweqeqweewqeeeeeeeeeeeeeeqeqeqeqeeqweqweqweqeeqeqeqweqeqeqeqeqeqeqwqweweqeqeweeqweqwe" animation:YES];

    

//    hud.progress = 0.0;
    
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action:) userInfo:nil repeats:YES];
    
//    NSTimer *timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(handleHideTimer:) userInfo:@(YES) repeats:NO];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//    self.timer = timer;
//
//    hud.flashingText = @"IHEFE";
//
//    [hud hideAfterDelay:2];
    
//    [IHFProgressHUD showText:@"IHEFE"];
    
//    [IHFProgressHUD show]
    
    
//    self.label1 = [[IHFFlashingLabel alloc] init];
//    self.label1.frame = CGRectMake(20, 245, 200, 35);
//    self.label1.text = @"IHEFE";
//    self.label1.textColor = [UIColor grayColor];
//    self.label1.font = [UIFont systemFontOfSize:30];
//    self.label1.flashingType = IHFFlashingTypeOfAutoreverses;
//    self.label1.flashingWidth = 20;
//    self.label1.flashingRadius = 20;
//    self.label1.flashingColor = [UIColor yellowColor];
//    [self.label1 startFlashing];
//
//    [self.view addSubview:self.label1];
    
    
//    _indicator = indicator;

    
//    [_resultView removeFromSuperview];
//    _resultView = [[IHFResultView alloc] initWithFrame:CGRectMake(100, 150, 50, 50) resultViewType:resultViewTypeSuccess];
//    [self.view addSubview:_resultView];
//
//    [_errorView removeFromSuperview];
//    _errorView = [[IHFCheckErrorView alloc] initWithFrame:CGRectMake(100, 300, 50, 50)];
//    [self.view addSubview:_errorView];

//    [MBProgressHUD showMessage:@"正在加载..."];
    
//    [MBProgressHUD showSuccess:@"成功了，晕死了"];
    
//    self.label1 = [[IHFFlashingLabel alloc] init];
//    self.label1.frame = CGRectMake(20, 35, 200, 35);
//    self.label1.text = @"IHEFE";
//    self.label1.textColor = [UIColor grayColor];
//    self.label1.font = [UIFont systemFontOfSize:18];
//    [self.label1 startFlashing];                 // 开启闪烁
//    [self.view addSubview:self.label1];
//
//    
//    self.label2 = [[IHFFlashingLabel alloc] init];
//    self.label2.frame = CGRectMake(20, 105, 200, 35);
//    self.label2.text = @"IHEFE";
//    self.label2.textColor = [UIColor grayColor];
//    self.label2.font = [UIFont systemFontOfSize:30];
//    self.label2.flashingType = IHFFlashingTypeOfDirectionRightToLeft;           // 滚动方向 right to left
//    self.label2.durationTime = 0.7;                     // 滚动时间
//    self.label2.flashingColor = [UIColor orangeColor];   // 高亮颜色
//    [self.label2 startFlashing];                         // 开启闪烁
//    [self.view addSubview:self.label2];
//    
//    
//    self.label3 = [[IHFFlashingLabel alloc] init];
//    self.label3.frame = CGRectMake(20, 175, 200, 35);
//    self.label3.text = @"IHEFE";
//    self.label3.textColor = [UIColor grayColor];
//    self.label3.font = [UIFont systemFontOfSize:30];
//    self.label3.flashingType = IHFFlashingTypeOfAutoreverses;
//    self.label3.flashingWidth = 20;                      // 高亮的宽度
//    self.label3.flashingRadius = 20;                     // 阴影的宽度
//    self.label3.flashingColor = [UIColor yellowColor];   // 高亮颜色
//    [self.label3 startFlashing];                         // 开启闪烁
//    [self.view addSubview:self.label3];
//    
//    
//    self.label4 = [[IHFFlashingLabel alloc] init];
//    self.label4.frame = CGRectMake(20, 245, 200, 35);
//    self.label4.text = @"IHEFE";
//    self.label4.textColor = [UIColor grayColor];
//    self.label4.font = [UIFont systemFontOfSize:30];
//    self.label4.flashingType = IHFFlashingTypeOfOverallFlashing;
//    self.label4.durationTime = 0.5;
//    self.label4.flashingColor = [UIColor redColor];
//    [self.label4 startFlashing];
//    [self.view addSubview:self.label4];
}

- (void)progressHUD:(IHFProgressHUD *)HUD didShowAnimation:(BOOL)animated{
    NSLog(@"HUD show");
}

- (void)progressHUD:(IHFProgressHUD *)HUD didHideAnimation:(BOOL)animated{
    NSLog(@"HUD hide");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
