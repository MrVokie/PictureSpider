//
//  SplashView.h
//  NetEaseNews
//
//  Created by Vokie on 2016/10/19.
//  Copyright © 2016年 Vokie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashView : UIView

//广告位
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
//显示时间
@property (nonatomic, assign) CGFloat showTime;

- (void)removeAndCleanUp;

- (void)showInView;
@end
