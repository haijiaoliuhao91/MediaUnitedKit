# MMImagePicker

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/dexianyinjiu/MMImagePicker/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/MMImagePicker.svg?style=flat)](http://cocoapods.org/pods/MMImagePicker)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/MMImagePicker.svg?style=flat)](http://cocoapods.org/pods/MMImagePicker)&nbsp;

![MMImagePicker](MMImagePicker.png)

MMImagePicker是一个简单便捷的图片选择器，可以多选、单选、对图片进行裁剪。支持选择原图，可预览。


## 使用

1. `pod "MMImagePicker"` ;
2. `pod install` / `pod update`;
3. `#import <MMImagePicker/MMImagePickerController.h>`.

```objc
MMImagePickerController属性介绍：
   
//主色调[默认蓝色]
@property (nonatomic, strong) UIColor *mainColor;
//是否回传原图[可用于控制图片压系数]
@property (nonatomic, assign) BOOL isOrigin;
//是否显示原图选项[默认NO]
@property (nonatomic, assign) BOOL showOriginImageOption;
//是否只选取一张[默认NO]
@property (nonatomic, assign) BOOL singleImageOption;
//是否选取一张且需要裁剪[默认NO]
@property (nonatomic, assign) BOOL cropImageOption;
//裁剪的大小[默认方形、屏幕宽度]
@property (nonatomic, assign) CGSize imageCropSize;
//最大选择数目[默认9张]
@property (nonatomic, assign) NSInteger maximumNumberOfImage;
//代理
@property (nonatomic, assign) id<MMImagePickerDelegate> delegate;
```

  
示例：

```objc
MMImagePickerController *mmVC = [[MMImagePickerController alloc] init];
mmVC.delegate = self;   
mmVC.mainColor = [UIColor blueColor];  
mmVC.maximumNumberOfImage = 9; 
mmVC.showOriginImageOption = YES;

UINavigationController *mmNav = [[UINavigationController alloc] initWithRootViewController:mmVC];
[mmNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"default_bar"] forBarMetrics:UIBarMetricsDefault];
mmNav.navigationBar.barStyle = UIBarStyleBlackOpaque;
mmNav.navigationBar.tintColor = [UIColor whiteColor];
[self.navigationController presentViewController:mmNav animated:YES completion:nil];
```
```objc
#pragma mark - MMImagePickerDelegate
- (void)mmImagePickerController:(MMImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
     NSLog(@"%@",info);
}

 - (void)mmImagePickerControllerDidCancel:(MMImagePickerController *)picker
{
     NSLog(@"Cancel");
}
```

## 使用要求

* iOS 7.0 or later.
* Xcode 7.0 or later.
* OS X 10.10 or later.

## 许可证

MIT



