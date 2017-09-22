//
//  MMBarButtonItem.m
//  MMImagePicker
//
//  Created by LEA on 2017/3/2.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMBarButtonItem.h"

@implementation MMBarButtonItem

static const CGFloat fontSize = 16.0f;

#pragma mark - init
- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize textSize = [title boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 44)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil].size;
    UIButton *customView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textSize.width, 44)];
    customView.titleLabel.font = font;
    [customView setTitle:title forState:UIControlStateNormal];
    [customView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [customView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [self initWithCustomView:customView];
}

- (instancetype)initWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton *customView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [customView setImage:image forState:UIControlStateNormal];
    [customView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [self initWithCustomView:customView];
}

#pragma mark - setter
- (void)setCustomTitle:(NSString *)customTitle
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize textSize = [customTitle boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 44)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:font}
                                                context:nil].size;
    
    UIButton *customView = (UIButton *)self.customView;
    customView.frame = CGRectMake(0, 0, textSize.width, 44);
    [customView setTitle:customTitle forState:UIControlStateNormal];
}

- (void)setCustomImage:(UIImage *)customImage
{
    UIButton *customView = (UIButton *)self.customView;
    customView.frame = CGRectMake(0, 0, customImage.size.width, customImage.size.height);
    [customView setImage:customImage forState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    UIButton *customView = (UIButton *)self.customView;
    [customView setTitleColor:titleColor forState:UIControlStateNormal];
}

@end
