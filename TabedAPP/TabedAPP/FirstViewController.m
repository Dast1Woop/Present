//
//  FirstViewController.m
//  TabedAPP
//
//  Created by 马玉龙 on 2017/8/18.
//  Copyright © 2017年 huatu. All rights reserved.
/*
 1.过了第一关才解锁第二关
 2.不本地化存储关卡
 3.关卡设计：摇一摇；蹂躏我（刮刮乐）；然后，牛郎唱歌（待定）；唱完后，“阳光太强，无法说出想对你说的那句话”（手机向下，标题变为980，界面变为gif图片）；
 ps:128根号e980去掉上半部分后会成为一句英文语句。
 */

#import "FirstViewController.h"
#define YLHEIGHT [UIScreen mainScreen].bounds.size.height
#define YLWIDTH [UIScreen mainScreen].bounds.size.width
#import "OrientationDetectTool.h"
NSTimeInterval const lTimeInterval = 3;
NSTimeInterval const lTimeDelay4ShowTips = 20;

@interface FirstViewController ()

@property(nonatomic, strong) UIImageView *gImgV4Sleeping;//是集合的话立刻懒加载
@property (nonatomic, assign) BOOL gIsFirstTap;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.title = @"128";
   
    [self setUpUI];
    
    self.gIsFirstTap = YES;
    [self m4AddGesture];
    
    [self m4AddNtfies];
    
     [[OrientationDetectTool sharedOrientationDetectTool] startMotionMng];
}

- (void)m4AddNtfies{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(m4AppDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)setUpUI{
    CGFloat lH4NavBar = self.navigationController.navigationBar.bounds.size.height;
    UIImageView *lImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20 + 44, self.view.bounds.size.width, self.view.bounds.size.height - lH4NavBar - 20 - self.tabBarController.tabBar.bounds.size.height)];
    lImgV.image = [UIImage imageNamed:@"niulang.png"];
    [self.view addSubview:lImgV];
    
    
    [self m4SleepingAnimation];
}

- (void)m4AddGesture{
    UITapGestureRecognizer *lTapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(m4TapG:)];
    [self.view addGestureRecognizer:lTapG];
}

- (void)m4TapG:(UITapGestureRecognizer *)tapG{
    if (NO == self.gIsFirstTap) {
        return;
    }
    self.gIsFirstTap = NO;
    
    //今天还睡？注孤身！20s后台提示地震了！
    UILabel *lLbl4Word = [[UILabel alloc] init];
    lLbl4Word.text = @"在这个特殊的日子里，此汪假寐，盖以诱你！";
    
    [self.view addSubview:lLbl4Word];
    lLbl4Word.frame = CGRectMake(0, 100, YLWIDTH, 100);
    lLbl4Word.textAlignment = NSTextAlignmentCenter;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(lTimeDelay4ShowTips * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        lLbl4Word.text = @"想叫醒我跟你玩？不可能！除非地震...";
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self m4SleepingAnimation];
}



- (void)m4SleepingAnimation{
    
    //为减少一个局部变量，且避免tabbar切换时无动画效果，把动画写在willAppear中。但是退到后台再进来就没有Z字了！那就监听app变活跃的通知！
    UIImageView *lImgV4Sleeping = [[UIImageView alloc] initWithFrame:CGRectMake(YLWIDTH * 0.2, 40 + 20 + YLHEIGHT * 0.5,40, 40)];
    lImgV4Sleeping.image = [UIImage imageNamed:@"sleeping.png"];
    [self.view addSubview:lImgV4Sleeping];
    [UIView animateWithDuration:lTimeInterval
                          delay:0
                        options:UIViewAnimationOptionRepeat//无限循环
                     animations:^{
                         CGAffineTransform translation = CGAffineTransformMakeTranslation(100, -100);
                         //在缩放基础上叠加平移
                         CGAffineTransform scaleTranslation = CGAffineTransformScale(translation, 0.001, 0.001);
                         //在旋转基础上叠加缩放和平移
                         CGAffineTransform rotateScaleTranslation = CGAffineTransformRotate(scaleTranslation, M_PI * 5);
                         lImgV4Sleeping.transform = rotateScaleTranslation;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)m4AppDidBecomeActive{
    [self m4SleepingAnimation];
}


- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"come in");
    self.tabBarController.selectedIndex = 1;
}





@end
