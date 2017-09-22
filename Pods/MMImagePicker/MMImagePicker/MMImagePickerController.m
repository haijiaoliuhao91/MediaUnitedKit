//
//  MMImagePickerController.m
//  MMImagePicker
//
//  Created by LEA on 2017/3/2.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMImagePickerController.h"
#import "MMAssetCollectionController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MMAlbumCell.h"

@interface MMImagePickerController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<ALAssetsGroup *> *assetGroups;
@property (strong, nonatomic) ALAssetsLibrary *library;

@end

@implementation MMImagePickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"照片";
    self.view.backgroundColor = RGBColor(240.0, 240.0, 240.0, 1.0);
    self.navigationItem.rightBarButtonItem = [[MMBarButtonItem alloc] initWithTitle:@"取消" target:self action:@selector(barButtonItemAction:)];
    [self.view addSubview:self.tableView];
    
    self.assetGroups = [[NSMutableArray alloc] init];
    
    //获取系统相册列表
    [self showHUD:@"图库加载中"];
    self.library = [[ALAssetsLibrary alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        //为空时，枚举完成
        if (!group) {
            [weakSelf hideHUD];
            [weakSelf.tableView reloadData];
            [weakSelf pushImagePickerByAssetGroup:[weakSelf.assetGroups objectAtIndex:0] animated:NO];
            return ;
        }
        //剔除空相册
        NSInteger count = [group numberOfAssets];
        if (count) {
            NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
            if (nType == ALAssetsGroupSavedPhotos) {
                [weakSelf.assetGroups insertObject:group atIndex:0];
            } else {
                [weakSelf.assetGroups addObject:group];
            }
        }
    } failureBlock:^(NSError *error) {
        [weakSelf hideHUD];
        //无权限
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"请开启相册访问权限"
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确定",nil];
            [alterView show];
        }
    }];
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60.0f;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - 取消
- (void)barButtonItemAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(mmImagePickerControllerDidCancel:)]) {
        [self.delegate mmImagePickerControllerDidCancel:self];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assetGroups count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MMAlbumCell";
    MMAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MMAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    ALAssetsGroup *assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
    NSString *groupPropertyName = [assetGroup valueForProperty:ALAssetsGroupPropertyName];
    NSUInteger nType = [[assetGroup valueForProperty:ALAssetsGroupPropertyType] intValue];
    if (nType == ALAssetsGroupSavedPhotos) {
        groupPropertyName = @"相机胶卷";
    }
    NSInteger count = [assetGroup numberOfAssets];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",groupPropertyName, (long)count];
    cell.imageView.image = [UIImage imageWithCGImage:[assetGroup posterImage]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //跳转
    ALAssetsGroup *assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
    [self pushImagePickerByAssetGroup:assetGroup animated:YES];
}

#pragma mark - 跳转
- (void)pushImagePickerByAssetGroup:(ALAssetsGroup *)assetGroup animated:(BOOL)animated
{
    MMAssetCollectionController *imagePicker = [[MMAssetCollectionController alloc] init];
    imagePicker.assetGroup = assetGroup;
    imagePicker.mainColor = self.mainColor;
    imagePicker.maximumNumberOfImage = self.maximumNumberOfImage;
    imagePicker.showOriginImageOption = self.showOriginImageOption;
    imagePicker.singleImageOption = self.singleImageOption;
    imagePicker.cropImageOption = self.cropImageOption;
    imagePicker.imageCropSize = self.imageCropSize;

    __weak typeof(self) weakSelf = self;
    [imagePicker setCompletion:^(NSArray *info, BOOL isOrigin, BOOL isCancel){
        weakSelf.isOrigin = isOrigin;
        if (isCancel) { //取消
            if ([weakSelf.delegate respondsToSelector:@selector(mmImagePickerControllerDidCancel:)]) {
                [weakSelf.delegate mmImagePickerControllerDidCancel:weakSelf];
            } else {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        } else { //确认选择
            if ([weakSelf.delegate respondsToSelector:@selector(mmImagePickerController:didFinishPickingMediaWithInfo:)]) {
                [weakSelf.delegate mmImagePickerController:weakSelf didFinishPickingMediaWithInfo:info];
            }
        }
    }];
    [self.navigationController pushViewController:imagePicker animated:animated];
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
