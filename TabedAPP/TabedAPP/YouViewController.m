//
//  YouViewController.m
//  TabedAPP
//
//  Created by 马玉龙 on 2017/8/18.
//  Copyright © 2017年 huatu. All rights reserved.
//

#import "YouViewController.h"
#import "OrientationDetectTool.h"
#define kNtfyName4DeviceUpsideDown  @"kNtfyName4DeviceUpsideDown"
#define YLHEIGHT [UIScreen mainScreen].bounds.size.height
#define YLWIDTH [UIScreen mainScreen].bounds.size.width

#define OFFSET -80
@interface YouViewController ()
@property (nonatomic, assign) BOOL gIsFirstUpsideDown;

@end

@implementation YouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor cyanColor];
    self.title = @"?";
    
    [self m4AddNtfies];
    self.gIsFirstUpsideDown = YES;
}

- (void)m4AddNtfies{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(m4DeviceUpsideDown)
                                                 name:kNtfyName4DeviceUpsideDown
                                               object:nil];
}

- (void)m4DeviceUpsideDown{
    if (NO == self.gIsFirstUpsideDown) {
        return;
    }
    self.gIsFirstUpsideDown = NO;
    
    self.title = @"980";
    
    //界面变为播放gif图
    NSString *path = [[NSBundle mainBundle] pathForResource:@"128e980" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, OFFSET, YLWIDTH, YLHEIGHT - OFFSET)];
    webView.scalesPageToFit = YES;
    [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:@"utf-8" baseURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    webView.backgroundColor = [UIColor orangeColor];
    webView.opaque = NO;
    [self.view addSubview:webView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[OrientationDetectTool sharedOrientationDetectTool] startMotionMng];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[OrientationDetectTool sharedOrientationDetectTool] stopMotionMng];
    self.title = @"?";
    self.gIsFirstUpsideDown = YES;
}


@end
