//
//  AppDefault.h
//  MeiZiTu
//
//  Created by Vokie on 2016/11/2.
//  Copyright © 2016年 Vokie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDefault : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, assign) BOOL autoLoadMore; //自动加载更多
@property (nonatomic, assign) BOOL ua;  //浏览器标识

- (BOOL)loadDiskDataToMemory;

@end
