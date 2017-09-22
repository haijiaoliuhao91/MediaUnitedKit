# MediaUnitedKit

MediaUnitedKit集成了自定义【视频+图像】采集、【视频+图片】保存到自定义相册、图片编辑【不规则裁剪、旋转、加框、黑白、撤销】、自定义图片选择器、音频的录制+播放【支持本地和网络音频播放】。

![Screenshot](https://github.com/dexianyinjiu/MediaUnitedKit/blob/master/Screenshot/capture.png)
![Screenshot](https://github.com/dexianyinjiu/MediaUnitedKit/blob/master/Screenshot/editor.png)
![Screenshot](https://github.com/dexianyinjiu/MediaUnitedKit/blob/master/Screenshot/gallery.png)
![Screenshot](https://github.com/dexianyinjiu/MediaUnitedKit/blob/master/Screenshot/audio.png)


## 代码结构
![Screenshot](https://github.com/dexianyinjiu/MediaUnitedKit/blob/master/Screenshot/framework.png)

其实通过类名就可以一目了然，在这里简述一下，具体可以去看代码。

### 音频
`MMAudioUtil`集成了音频的录制和播放，使用`AVFoundation`框架。音频录制使用的是`AVAudioRecorder`。音频播放可以使用`AVAudioPlayer` ，但是网络音频的播放需要先将音频下载到本地，然后通过本地路径播放。所以这里使用的是`AVPlayer`，支持本地和网络路径。

使用方式就比较简单了：

```objc
    NSURL *mp3URL = [NSURL fileURLWithPath:@"本地路径"];
    NSURL *mp3URL = [NSURL URLWithString:@"网络路径"];
    //播放器
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:mp3URL];
    AVPlayer *audioPlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    [audioPlayer play];
```

### 视频

`MediaCaptureController`同样使用`AVFoundation`框架。拍照和录制视频自由切换，支持对焦、双击缩放镜头、前后置摄像头切换、闪光灯设置以及支持屏幕旋转。采集的视频和图片通过代理回传，通过key值`UIImagePickerControllerMediaURL`获取视频路径，key值`UIImagePickerControllerOriginalImage`获取图片。

```objc
//代理
- (void)mediaCaptureController:(UIViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
```

视频的播放，GitHub上有很多，我在本项目中添加了[WMPlayer](https://github.com/zhengwenming/WMPlayer)，大家可以看一下。

### 图片编辑

1、裁剪
`MMImageClipper`实现图片的不规则裁剪，我参考的是在code4app下载的，GitHub上的貌似更好一些：[链接](https://github.com/jberlana/JBCroppableView)。

2、旋转
旋转就是每次旋转90度，具体可以看代码吧。

3、加框
这个就是图片合成了，需要注意的是图片的形状是各种各样的，所以要针对所编辑图片的size对边框图片做拉伸处理，为防止边框变形，要选非边框位置的某一像素点拉伸，具体可以看代码。

4、黑白
使用强大的框架：[GPUImage](https://github.com/BradLarson/GPUImage)。使用方式详见`UIImage+Category`类下的`sketchImage`方法。

5、撤销
使用数据库存储，数据ID可代表顺序。

### 图库

自定义的图片选择器[MMImagePicker](https://github.com/dexianyinjiu/MMImagePicker)，使用`AssetsLibrary`框架，集成了图片的预览和固定形状的裁剪。

## END
有问题可以联系我【QQ:1539901764 要备注来源哦】，如果这个工具对你有些帮助，麻烦给一个star、fork、watch。O(∩_∩)O谢谢

