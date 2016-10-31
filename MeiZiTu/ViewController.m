//
//  ViewController.m
//  MeiZiTu
//
//  Created by Vokie on 5/31/16.
//  Copyright © 2016 Vokie. All rights reserved.
//

#import "ViewController.h"
#import "RegManager.h"
#import "HTTPSessionManager.h"
#import "EncodeManager.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "CHTCollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallFooter.h"
#import <UIImageView+WebCache.h>
#import "MWPhotoBrowser.h"
#import "MBProgressHUD+EasyUse.h"
#import "SubscribeView.h"
#import "DatabaseManager.h"
#import "SettingViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "SplashView.h"

#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

@interface ViewController()<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, MWPhotoBrowserDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *cellSizes;
@property (nonatomic, strong) NSMutableArray *imageUrlArray;  //当前页面的图片链接
@property (nonatomic, strong) NSMutableArray *urlArray;   //当前页面的url地址
@property (nonatomic, strong) NSMutableArray *mwPhotoArray;
@property (nonatomic, retain) SubscribeView *subView;
@property (nonatomic, retain) NSString *homeWebsite;
@property (nonatomic, strong) ALAssetsLibrary * assetsLibrary;
@property (nonatomic, assign) NSInteger webUrlIndex;
@property (nonatomic, retain) SplashView *splashView;
@property (nonatomic, assign) BOOL isShowStatusBar;
@property (nonatomic, retain) CWStatusBarNotification *notification;
@end

@implementation ViewController

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(2, 0, 0, 0);
        layout.headerHeight = APP_SCREEN_WIDTH * 2.0 / 5.0f;//宽高比 => 5：2
        layout.footerHeight = 0;
        layout.minimumColumnSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CHTCollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
        [_collectionView registerClass:[CHTCollectionViewWaterfallFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:FOOTER_IDENTIFIER];
    }
    return _collectionView;
}

- (NSArray *)cellSizes {
    if (!_cellSizes) {
        _cellSizes = @[
                       [NSValue valueWithCGSize:CGSizeMake(400, 600)],
                       [NSValue valueWithCGSize:CGSizeMake(600, 400)],
                       [NSValue valueWithCGSize:CGSizeMake(1024, 768)],
                       [NSValue valueWithCGSize:CGSizeMake(768, 1024)]
                       ];
    }
    return _cellSizes;
}

- (CWStatusBarNotification *)notification {
    if (!_notification) {
        _notification = [[CWStatusBarNotification alloc]init];
        _notification.notificationLabelBackgroundColor = COLOR_THEME;
        _notification.notificationLabelTextColor = [UIColor whiteColor];
        _notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
    }
    return _notification;
}

- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray array];
    }
    return _imageUrlArray;
}

- (NSMutableArray *)urlArray {
    if (!_urlArray) {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
}

- (NSMutableArray *)mwPhotoArray {
    if (!_mwPhotoArray) {
        _mwPhotoArray = [NSMutableArray arrayWithCapacity:50];
    }
    return _mwPhotoArray;
}

- (SubscribeView *)subView {
    if (!_subView) {
        _subView = [[[NSBundle mainBundle]loadNibNamed:@"SubscribeView" owner:self options:nil] firstObject];
        _subView.frame = CGRectMake(-APP_SCREEN_WIDTH, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
        //        _subView.backgroundColor = [UIColor whiteColor];
        [[[UIApplication sharedApplication]keyWindow]addSubview:_subView];
    }
    return _subView;
}

- (ALAssetsLibrary *)assetsLibrary {
    if (_assetsLibrary) {
        return _assetsLibrary;
    }
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    return _assetsLibrary;
}

- (void)showSplashView {
    _splashView = [[[NSBundle mainBundle] loadNibNamed:@"SplashView" owner:self options:nil] firstObject];
    _splashView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
    _splashView.showTime = 2.5f;  //启动广告展示时间
    
    //提前0.3秒显示状态栏，修复状态栏显示引起的导航栏跳跃
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_splashView.showTime) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _isShowStatusBar = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    });
    [_splashView showInView];
}

#pragma mark - 生命周期

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //显示广告加载页面
    [self showSplashView];
    
    NSDictionary *dict = [[DatabaseManager sharedManager] getFocusWebsite];
    self.homeWebsite = dict[@"site"];
    self.navigationItem.title = dict[@"name"];
    
    self.subView.hidden = NO;
    __weak typeof(self) weakSelf = self;
    self.subView.chooseBlock = ^(NSString *name, NSString *address) {
        weakSelf.navigationItem.title = name;
        weakSelf.homeWebsite = address;
        [[DatabaseManager sharedManager] updateFocusWebsite:address name:name];
        [weakSelf.collectionView.mj_header beginRefreshing];
    };
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"订阅" style:UIBarButtonItemStylePlain target:self action:@selector(subscribe)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(openSettings)];
    
    [self.view addSubview:self.collectionView];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _webUrlIndex = 0;
        _imageUrlArray = nil;
        _urlArray = nil;
        _mwPhotoArray = nil;
        
        //切换网址或者重新头部刷新时、停下footer刷新
        [self.collectionView.mj_footer endRefreshing];
        
        // 进入刷新状态后会自动调用这个block
        [[HTTPSessionManager sharedManager]requestWithMethod:GET path:self.homeWebsite params:nil successBlock:^(id responseObject) {
            NSString *result1 = [EncodeManager encodeWithData:responseObject];
            if (result1 == nil || result1.length == 0) {
                [self.collectionView.mj_header endRefreshing];
                [self.notification displayNotificationWithMessage:@"站点无数据.." forDuration:2.0f];
                return;
            }
//            NSLog(@"返回的数据：%@", result1);
            weakSelf.imageUrlArray = [self excludeDuplicated:[RegManager regProcessWithContent:result1]];
            
            weakSelf.urlArray = [self excludeDuplicated:[RegManager crawWebWithContent:result1]];
            
//            NSLog(@"%@", weakSelf.urlArray);
//            NSLog(@"%@", weakSelf.imageUrlArray);
            
            for (NSString *imgUrl in self.imageUrlArray) {
                [self.mwPhotoArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imgUrl]]];
            }
            
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer beginRefreshing];
        } failureBlock:^(NSError *error) {
            [self.notification displayNotificationWithMessage:@"网址没响应.." forDuration:2.0f];
            [self.collectionView.mj_header endRefreshing];
            
        }];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.webUrlIndex >= self.urlArray.count) {
            [self.notification displayNotificationWithMessage:@"已经全部加载" forDuration:2.0f];
            [self.collectionView.mj_footer endRefreshing];
            return;
        }
        
        NSString *urlPath = self.urlArray[self.webUrlIndex];
        
        // 进入刷新状态后会自动调用这个block
        [[HTTPSessionManager sharedManager]requestWithMethod:GET path:urlPath params:nil successBlock:^(id responseObject) {
            
            
            
            NSString *result1 = [EncodeManager encodeWithData:responseObject];
            
            if (result1 == nil || result1.length == 0) {
                [self.collectionView.mj_footer endRefreshing];
                [self.notification displayNotificationWithMessage:@"站点无数据，已为您跳过.." forDuration:2.0f];
                self.webUrlIndex++;
                [self.collectionView.mj_footer beginRefreshing];
                
                return;
            }
//            NSLog(@"返回的数据：%@", result1);
            NSMutableArray *currentPageImageUrls = [self excludeDuplicated:[RegManager regProcessWithContent:result1]];
            [weakSelf.imageUrlArray addObjectsFromArray:currentPageImageUrls];
            
            [weakSelf.urlArray addObjectsFromArray:[self excludeDuplicated:[RegManager crawWebWithContent:result1]]];
//            NSLog(@"%@", weakSelf.imageUrlArray);
            
            
            if (!currentPageImageUrls.count) {
                [self.collectionView.mj_footer endRefreshing];
                [self.notification displayNotificationWithMessage:@"站点无数据，已为您跳过.." forDuration:2.0f];
                self.webUrlIndex++;
                [self.collectionView.mj_footer beginRefreshing];
                return;
            }
            
            for (NSString *urlString in currentPageImageUrls) {
                NSURL *url = [NSURL URLWithString:urlString];
                [self.mwPhotoArray addObject:[MWPhoto photoWithURL:url]];
            }
            self.webUrlIndex++;
            [self.collectionView reloadData];
            [self.collectionView.mj_footer endRefreshing];
            
            [self.collectionView.mj_footer beginRefreshing];
            
        } failureBlock:^(NSError *error) {
            [self.collectionView.mj_footer endRefreshing];
            [self.notification displayNotificationWithMessage:@"站点无数据，已为您跳过.." forDuration:2.0f];
            self.webUrlIndex++;
            [self.collectionView.mj_footer beginRefreshing];
            
        }];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
    
}


- (BOOL)prefersStatusBarHidden {
    return !_isShowStatusBar;
}

- (NSMutableArray *)excludeDuplicated:(NSMutableArray *)array {
    NSSet *set = [NSSet setWithArray:array]; //去重
    return [[set allObjects] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.assetsLibrary = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

#pragma mark - Selector

- (void)openSettings {
    SettingViewController *svc = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
//    [MBProgressHUD showWithText:@"Setting"];
}

- (void)subscribe {
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect rect = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
        self.subView.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
    
    
//    [MBProgressHUD showWithText:@"尚未开发完成。"];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrlArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHTCollectionViewWaterfallCell *cell =
    (CHTCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                forIndexPath:indexPath];
//    cell.imageView.image = [UIImage imageNamed:self.imageUrlArray[indexPath.item % 4]];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrlArray[indexPath.item]] placeholderImage:[UIImage imageNamed:@"default_image"] options:(SDWebImageRetryFailed | SDWebImageProgressiveDownload) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    
    // Customise selection images to change colours if required
//    browser.customImageSelectedIconName = @"ImageSelected.png";
//    browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    
    // Present
    [self.navigationController pushViewController:browser animated:YES];
//    [self presentViewController:browser animated:YES completion:nil];
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:indexPath.item];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellSizes[indexPath.item % 4] CGSizeValue];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.mwPhotoArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.mwPhotoArray.count) {
        return [self.mwPhotoArray objectAtIndex:index];
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
    MWPhoto *photo = self.mwPhotoArray[index];
    [self.assetsLibrary saveImage:photo.underlyingImage toAlbum:@"MZT" completion:^(NSURL *assetURL, NSError *error) {
        [MBProgressHUD showWithText:@"已保存到MZT相册"];
    } failure:^(NSError *error) {
        [MBProgressHUD showWithText:@"保存失败"];
    }];
}

@end
