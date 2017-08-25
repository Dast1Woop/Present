//
//  SecondViewController.m
//  TabedAPP
//
//  Created by 马玉龙 on 2017/8/18.
//  Copyright © 2017年 huatu. All rights reserved.
//

#import "SecondViewController.h"
#import "MDScratchImageView.h"
#define YLHEIGHT [UIScreen mainScreen].bounds.size.height
#define YLWIDTH [UIScreen mainScreen].bounds.size.width
#define kPercentDidShow 0.8
#define kNtfyName4DeviceUpsideDown  @"kNtfyName4DeviceUpsideDown"
#define kNtfy4DevicePortrait @"kNtfy4DevicePortrait"

@interface SecondViewController ()<MDScratchImageViewDelegate>
@property(nonatomic, strong) UIImageView *gImgV;//是集合的话立刻懒加载
@property(nonatomic, strong) NSTimer *gTimer;//是集合的话立刻懒加载
@property (nonatomic, assign) int gSecond;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.title = @"√e";
    
    [self m4AddNtfies];
    self.gSecond = 0;
}

- (void)m4AddNtfies{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(m4DeviceUpsideDown2SecVC)
                                                 name:kNtfyName4DeviceUpsideDown
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(m4DevicePortrait2SecVC)
                                                 name:kNtfy4DevicePortrait
                                               object:nil];
}

/** 倒立时显示标注图，竖屏时换回来 */
- (void)m4DeviceUpsideDown2SecVC{
    if (self.gSecond == 0) {
        [[NSRunLoop currentRunLoop] addTimer:self.gTimer forMode:NSRunLoopCommonModes];
    }
    
    //5s后再改变图片
    if (self.gSecond >= 5) {
        self.gImgV.image = [UIImage imageNamed:@"upsideWithMark"];
        
        [self.gTimer invalidate];
        self.gTimer = nil;
    }
    
}

- (void)m4Timer{
    self.gSecond += 1;
}

- (void)m4DevicePortrait2SecVC{
    self.gSecond = 0;
    self.gImgV.image = [UIImage imageNamed:@"upside"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //重置蒙版
    [self m4RemoveSubViews];
}

- (void)setUpUI{
    CGFloat lH4NavBar = self.navigationController.navigationBar.bounds.size.height;
    [self.view addSubview:self.gImgV];
    
    MDScratchImageView *lMDImgV = [[MDScratchImageView alloc] initWithFrame:CGRectMake(0, lH4NavBar + 20, self.view.bounds.size.width, self.view.bounds.size.height - lH4NavBar - 20 - self.tabBarController.tabBar.bounds.size.height)];
    [lMDImgV setImage:[UIImage imageNamed:@"cover.jpg"] radius:20];
    lMDImgV.delegate = self;
    [self.view addSubview:lMDImgV];
    
    //机智如你！
    UILabel *lLbl4Word = [[UILabel alloc] init];
    [self.view addSubview:lLbl4Word];
    
    lLbl4Word.text = @"机智如你！尽情的蹂躏我吧！";
    lLbl4Word.textColor = [UIColor orangeColor];
    lLbl4Word.frame = CGRectMake(0, 20+44, YLWIDTH, 100);
    lLbl4Word.textAlignment = NSTextAlignmentCenter;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [lLbl4Word removeFromSuperview];
    });
}

- (void)m4RemoveSubViews{
    for (UIView *lV in self.view.subviews) {
        [lV removeFromSuperview];
    }
}

//delegate
- (void)mdScratchImageView:(MDScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress{
    NSLog(@"%f",maskingProgress);
    if (maskingProgress > kPercentDidShow) {
        self.tabBarController.selectedIndex = 2;
    }
}

#pragma mark -  getter & setter
- (UIImageView *)gImgV{
    if (nil == _gImgV) {
        CGFloat lH4NavBar = self.navigationController.navigationBar.bounds.size.height;
        _gImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, lH4NavBar + 20, self.view.bounds.size.width, self.view.bounds.size.height - lH4NavBar - 20 - self.tabBarController.tabBar.bounds.size.height)];
        _gImgV.image = [UIImage imageNamed:@"upside"];
    }
    return _gImgV;
}

- (NSTimer *)gTimer{
    if (nil == _gTimer) {
        _gTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(m4Timer)
                                                 userInfo:nil
                                                  repeats:YES];
    }
    return _gTimer;
}


@end
