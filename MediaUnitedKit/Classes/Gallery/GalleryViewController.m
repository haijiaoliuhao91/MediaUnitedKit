//
//  GalleryViewController.m
//  MediaUnitedKit
//
//  Created by LEA on 2017/9/22.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "GalleryViewController.h"
#import <MMImagePickerController.h>

@interface GalleryViewController ()<MMImagePickerDelegate>
{
    UIView *contentView;
    NSMutableArray *imageArray;
}

@end

@implementation GalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"DEMO";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-100)/2, 50, 100, 44)];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"选择图片" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(10, btn.bottom+50, self.view.width-20, self.view.height-btn.bottom-50)];
    contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentView];
    
    imageArray = [[NSMutableArray alloc] init];
}

#pragma mark - 选择图片
- (void)btClicked
{
    MMImagePickerController *mmVC = [[MMImagePickerController alloc] init];
    mmVC.delegate = self;
    mmVC.showOriginImageOption = YES;
    mmVC.maximumNumberOfImage = 9;
//    mmVC.cropImageOption = YES;
//    mmVC.singleImageOption = YES;
    BaseNavigationController *mmNav = [[BaseNavigationController alloc] initWithRootViewController:mmVC];
    [self.navigationController presentViewController:mmNav animated:YES completion:nil];
}

#pragma mark - 代理
- (void)mmImagePickerController:(MMImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [picker showHUD:@"图片加载中"];
    [imageArray removeAllObjects];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < [info count]; i ++)
        {
            NSDictionary *dict = [info objectAtIndex:i];
            UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
            NSData *imageData = UIImageJPEGRepresentation(image,1.0);
            int size = (int)[imageData length]/1024;
            if (size < 100) {
                imageData = UIImageJPEGRepresentation(image, 0.5);
            } else {
                imageData = UIImageJPEGRepresentation(image, 0.1);
            }
            [imageArray addObject:[UIImage imageWithData:imageData]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadImageListView];
            [picker dismissViewControllerAnimated:YES completion:nil];
            [picker hideHUD];
        });
    });
}

- (void)mmImagePickerControllerDidCancel:(MMImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 显示
- (void)loadImageListView
{
    for(UIView *sub in [contentView subviews]) {
        [sub removeFromSuperview];
    }
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat ITEM_W = (self.view.width-20-3*5)/4;
    NSInteger count = 0;
    for (NSInteger i = 0;i < [imageArray count]; i ++)
    {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, ITEM_W, ITEM_W)];
        imageV.backgroundColor = [UIColor clearColor];
        imageV.image = [imageArray objectAtIndex:i];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.contentScaleFactor = [[UIScreen mainScreen] scale];
        imageV.clipsToBounds = YES;
        [contentView addSubview:imageV];
        
        count ++;
        X = (ITEM_W+5)*count;
        if (count !=0 && count%4==0) {
            X = 0;
            count = 0;
            Y += ITEM_W+5;
        }
    }
    
    CGFloat H = Y+ITEM_W;
    if (count%4 == 0) {
        H -= ITEM_W;
    }
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
