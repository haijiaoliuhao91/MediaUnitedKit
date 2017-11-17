//
//  MMBarButtonItem.h
//  MMImagePicker
//
//  Created by LEA on 2017/3/2.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMBarButtonItem : UIBarButtonItem

// 图片
@property (nonatomic, strong) UIImage *customImage;
// 文本
@property (nonatomic, strong) NSString *customTitle;
// 文本颜色
@property (nonatomic, strong) UIColor *titleColor;

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (instancetype)initWithImage:(UIImage *)image target:(id)target action:(SEL)action;

@end
