//
//  OrientationDetectTool.h
//  oritentionTest
//
//  Created by 马玉龙 on 16/4/12.
//  Copyright © 2016年 huatu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMSingleton.h"

@interface OrientationDetectTool : NSObject
HMSingleton_h(OrientationDetectTool);

/** 开始监视手机方向:横屏\竖屏\颠倒了 */
- (void)startMotionMng;

/** 停止监视手机方向 */
- (void)stopMotionMng;
@end
