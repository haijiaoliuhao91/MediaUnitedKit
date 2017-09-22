//
//  MMImagePickerComponent.h
//  MMImagePicker
//
//  Created by LEA on 2017/6/15.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "UIView+Geometry.h"
#import "MMBarButtonItem.h"
#import "MBProgressHUD.h"

//#### 宏定义
#define kDeviceIsIphone6p               CGSizeEqualToSize(CGSizeMake(1242,2208), [[[UIScreen mainScreen] currentMode] size])
#define kBlankWidth                     4.0f
#define kBottomHeight                   44.0f
#define RGBColor(r,g,b,a)               [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kMainColor                      RGBColor(26, 181, 237, 1.0)

//图片路径
#define MMImagePickerSrcName(file)      [@"MMImagePicker.bundle" stringByAppendingPathComponent:file]
