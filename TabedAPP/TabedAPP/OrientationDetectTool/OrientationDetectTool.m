//
//  OrientationDetectTool.m
//  oritentionTest
//
//  Created by 马玉龙 on 16/4/12.
//  Copyright © 2016年 huatu. All rights reserved.
/** 本来一般情况可以使用通知来做
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification
 object:nil];
 但是，当用户没有开启屏幕旋转功能时，当前设备是无法接收到通知的，原因就是因为你锁定屏幕之后，系统会默认你当前的屏幕状态一直都是你锁屏时的状态。
 目前多大数用户的苹果手机基本都有螺旋仪和加速器，我们可以根据这个东西来判断
 这时候就需要先引入CoreMotion.frameWork这个框架，这个框架就是来处理螺旋仪和加速器的东西
 原文链接：http://www.jianshu.com/p/692e7a490747
 */

#import "OrientationDetectTool.h"
#import <CoreMotion/CoreMotion.h>
#define kNtfyName4DeviceUpsideDown  @"kNtfyName4DeviceUpsideDown"
#define kNtfy4DevicePortrait @"kNtfy4DevicePortrait"

/** 是否是第一次播报颠倒的信息.声明为全局变量,
 才能保证只有第一次是被初始化为yes.
 这是继承自NSObject的模型,没有初始化实例变量的地方.
 */
BOOL gIsFirstSpeek = YES;
@interface OrientationDetectTool ()

@property(nonatomic, strong) CMMotionManager *xmotionMng; //是集合的话立刻懒加载

/** 手机是否为竖屏状态记录 */
@property(nonatomic, assign) BOOL xisPortrait;

/** 手机是否为竖屏颠倒状态记录 */
@property(nonatomic, assign) BOOL xisPortraitUpsideDown;

/** 手机是否为横屏状态记录 */
@property(nonatomic, assign) BOOL xisLandScape;

@end

@implementation OrientationDetectTool
HMSingleton_m(OrientationDetectTool);
/** 全局变量 放@implementation下也可以! */
// BOOL gIsFirstSpeek = YES;

#pragma mark -  action
- (void)startMotionMng {
  self.xmotionMng.deviceMotionUpdateInterval = 1.0;
  if (self.xmotionMng.isDeviceMotionAvailable) {
    NSLog(@"deviceMotionAvailable");
    [self.xmotionMng
        startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                            withHandler:^(CMDeviceMotion *_Nullable motion,
                                          NSError *_Nullable error) {
                              [self performSelectorOnMainThread:
                                        @selector(handleDeviceMotion:)
                                                     withObject:motion
                                                  waitUntilDone:YES];
                            }];
  } else {
    NSLog(@"no device Motion on device");
    self.xmotionMng = nil;
  }
}

/** typedef NS_ENUM(NSInteger, UIDeviceOrientation) {
 UIDeviceOrientationUnknown,
 UIDeviceOrientationPortrait,            // Device oriented vertically, home
 button on the bottom
 UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home
 button on the top
 UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home
 button on the right
 UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home
 button on the left
 UIDeviceOrientationFaceUp,              // Device oriented flat, face up
 UIDeviceOrientationFaceDown             // Device oriented flat, face down
 } __TVOS_PROHIBITED;
 */
- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion {
  double x = deviceMotion.gravity.x;
  double y = deviceMotion.gravity.y;
  if (fabs(y) >= fabs(x)) {
    if ((y >= 0) && (!self.xisPortraitUpsideDown)) {
      // UIDeviceOrientationPortraitUpsideDown
      NSLog(@"颠倒了!");
      /**  更新开关 */
      self.xisPortrait = NO;
      self.xisLandScape = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNtfyName4DeviceUpsideDown
                                                            object:nil
                                                          userInfo:nil];

      if (gIsFirstSpeek) {
        gIsFirstSpeek = NO;

        /** 震动并语音提醒 */
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//        [[TtsToolWithSwitch sharedTtsToolWithSwitch]
//            startByStopLastVoice2SpeakContent:@"手机颠倒了,请改为正常竖屏方便导航"
//                   afterDelay:0];
      }
    } else if (!self.xisPortrait) {
      // UIDeviceOrientationPortrait
      NSLog(@"竖屏!");
      /** 更新开关 */
      self.xisPortrait = YES;
      self.xisPortraitUpsideDown = NO;
      self.xisLandScape = NO;
      gIsFirstSpeek = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNtfy4DevicePortrait
                                                            object:nil
                                                          userInfo:nil];

      /** 震动并语音提醒 */
//      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//      [[TtsToolWithSwitch sharedTtsToolWithSwitch]
//          startByStopLastVoice2SpeakContent:@"竖屏,可以正确导航"
//                 afterDelay:0];
    }
  } else if (!self.xisLandScape) {
    NSLog(@"横屏");
    //    if (x >= 0) {
    //      // UIDeviceOrientationLandscapeRight
    //
    //    } else {
    //      // UIDeviceOrientationLandscapeLeft
    //    }

    /** 更新开关 */
    self.xisLandScape = YES;
    self.xisPortrait = NO;
    self.xisPortraitUpsideDown = NO;
    gIsFirstSpeek = YES;

    /** 震动并语音提醒 */
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    [[TtsToolWithSwitch sharedTtsToolWithSwitch]
//        startByStopLastVoice2SpeakContent:@"横屏，请改为正常竖屏方便导航"
//               afterDelay:0];
  }
}

- (void)stopMotionMng {
  [self.xmotionMng stopDeviceMotionUpdates];
  self.xmotionMng = nil;
}

//- (void)setToOrientationPortrait {
//  NSNumber *portraitValue =
//      [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
//  [[UIDevice currentDevice] setValue:portraitValue forKey:@"orientation"];
//}

#pragma mark -  getter & setter
- (CMMotionManager *)xmotionMng {
  if (!_xmotionMng) {
    _xmotionMng = [[CMMotionManager alloc] init];
  }
  return _xmotionMng;
}

@end
