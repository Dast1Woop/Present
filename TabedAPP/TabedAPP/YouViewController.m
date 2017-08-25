//
//  YouViewController.m
//  TabedAPP
//
//  Created by 马玉龙 on 2017/8/18.
//  Copyright © 2017年 huatu. All rights reserved.
//

#import "YouViewController.h"
#import <AVFoundation/AVFoundation.h>
#define kNtfyName4DeviceUpsideDown  @"kNtfyName4DeviceUpsideDown"
#define YLHEIGHT [UIScreen mainScreen].bounds.size.height
#define YLWIDTH [UIScreen mainScreen].bounds.size.width

#define OFFSET -80
@interface YouViewController ()
@property (nonatomic, assign) BOOL gIsFirstUpsideDown;

@property(nonatomic, strong) AVAudioPlayer *gPlayer;//是集合的话立刻懒加载
@property(nonatomic, strong) UILabel *gLbl4Tip;//是集合的话立刻懒加载
@property(nonatomic, strong) NSTimer *gTimer;//是集合的话立刻懒加载
@property(nonatomic, strong) UIImageView *gImgV;//是集合的话立刻懒加载
@property(nonatomic, strong) UIView *gContentV;//是集合的话立刻懒加载

@property (nonatomic, assign) BOOL gIsNeedShowILoveYou;

@end

@implementation YouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor cyanColor];
    self.title = @"?";
    
    [self m4SetUpUI];
    [self m4AddNtfies];
    [self m4PlayMusic];
    self.gIsFirstUpsideDown = YES;
    self.gIsNeedShowILoveYou = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.view bringSubviewToFront:self.gContentV];
}

- (void)m4PlayMusic{
    
    if ([self.gPlayer prepareToPlay]) {
        [self.gPlayer play];
    }
}

- (void)m4AddNtfies{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(m4DeviceUpsideDown)
                                                 name:kNtfyName4DeviceUpsideDown
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(m4ReplayMusic:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:[AVAudioSession sharedInstance]];
}

- (void)m4ReplayMusic:(NSNotification *)ntfy{
    NSLog(@"%@",ntfy);
    NSLog(@"%@",ntfy.userInfo[@"AVAudioSessionInterruptionTypeKey"]);
    
    if (self.gPlayer.isPlaying) {
        [self.gPlayer pause];
    }else{
        if ([self.gPlayer prepareToPlay]) {
            [self.gPlayer play];
        }
    }
}

- (void)m4SetUpUI{
    [self.view addSubview:self.gContentV];
    [self.gContentV addSubview:self.gImgV];
    
    //文本提示
    UILabel *lLbl = [[UILabel alloc] init];
    [self.gContentV addSubview:lLbl];
    
    lLbl.text = @"她在干什么？注意你说的第一个字哦！";
    lLbl.textAlignment = NSTextAlignmentCenter;
    lLbl.numberOfLines = 0;
    lLbl.frame = CGRectMake(0, 0, YLWIDTH, 88);
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
    webView.backgroundColor = [UIColor whiteColor];
    webView.opaque = NO;
    [self.view addSubview:webView];
    
    //添加下拉提示：“你看不到我”
    [self.view addSubview:self.gLbl4Tip ];
    
    #warning:高度设置时，因括号位置不对，即YLHEIGHT*(1 - 0.45 - 64 - 49）,打印出来为-75004.150000，控件高度为负数，居然导致程序内存暴增被杀死。
    NSLog(@"ha = %f",(1 - 0.45) - 64 - 49);
    NSLog(@"haha = %f",667*(1 - 0.45 - 64 - 49));
    _gLbl4Tip.frame = CGRectMake(0, 300, YLWIDTH, YLHEIGHT * (1 - 0.45) - 64 - 49);
    
    //随时间增加文字
    [[NSRunLoop currentRunLoop] addTimer:self.gTimer forMode:NSRunLoopCommonModes];
}

- (void)dealloc{
    [self.gTimer invalidate];
    self.gTimer = nil;
}

- (void)m4AddText2Lbl{
    if (self.gLbl4Tip.text.length > 52) {
        self.gLbl4Tip.text = @"隐藏关卡：灰白图倒着看!";
        self.gIsNeedShowILoveYou = YES;
    }
    
    if (self.gIsNeedShowILoveYou == YES) {
        if ([self.gLbl4Tip.text containsString:@"惊喜!Tips"]) {
                self.gLbl4Tip.text = @"Tips:上拉，下拉！❤️";
        }
        self.gLbl4Tip.text = [NSString stringWithFormat:@"%@%@",self.gLbl4Tip.text,@"Tips:上拉，下拉！❤️"];
    }else{
        self.gLbl4Tip.text = [NSString stringWithFormat:@"%@%@",self.gLbl4Tip.text,@"看不到!😙"];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.title = @"?";
    self.gIsFirstUpsideDown = YES;
}

#pragma mark -  getter & setter
- (UILabel *)gLbl4Tip{
    if (nil == _gLbl4Tip) {
        _gLbl4Tip = [[UILabel alloc] init];
//        _gLbl4Tip.backgroundColor = [UIColor yellowColor];
        _gLbl4Tip.numberOfLines = 0;
        _gLbl4Tip.text = @"你看不到!";
        _gLbl4Tip.textColor = [UIColor blackColor];
        _gLbl4Tip.textAlignment = NSTextAlignmentCenter;
    }
    return _gLbl4Tip;
}

- (UIImageView *)gImgV{
    if (nil == _gImgV) {
        _gImgV = [[UIImageView alloc] init];
        _gImgV.image = [UIImage imageNamed:@"milker"];
        _gImgV.frame = CGRectMake(0, 0, YLWIDTH, YLHEIGHT - 64 - 49);
    }
    return _gImgV;
}

- (NSTimer *)gTimer{
    if (nil == _gTimer) {
       _gTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(m4AddText2Lbl) userInfo:nil repeats:YES];
    }
    return _gTimer;
}

- (AVAudioPlayer *)gPlayer{
    if (nil == _gPlayer) {
        NSString *lPath = [[NSBundle mainBundle] pathForResource:@"qingFeiDeYi.mp3" ofType:nil];
        NSURL *lUrl = [NSURL fileURLWithPath:lPath];
        _gPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:lUrl error:nil];
        _gPlayer.volume = 0.52;
        
        //负数代表无限循环
        _gPlayer.numberOfLoops = -520;
    }
    return  _gPlayer;
}

- (UIView *)gContentV{
    if (nil == _gContentV) {
        _gContentV = [[UIView alloc] initWithFrame:CGRectMake(0, 64, YLWIDTH, YLHEIGHT - 64 - 49)];
    }
    return _gContentV;
}


@end
