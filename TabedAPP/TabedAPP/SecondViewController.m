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

@interface SecondViewController ()<MDScratchImageViewDelegate>

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.title = @"√e";
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
    UIImageView *lImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, lH4NavBar + 20, self.view.bounds.size.width, self.view.bounds.size.height - lH4NavBar - 20 - self.tabBarController.tabBar.bounds.size.height)];
    lImgV.image = [UIImage imageNamed:@"love.jpg"];
    [self.view addSubview:lImgV];
    
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
    if (maskingProgress > 0.8) {
        self.tabBarController.selectedIndex = 2;
    }
}


@end
