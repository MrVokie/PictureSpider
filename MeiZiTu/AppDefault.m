//
//  AppDefault.m
//  MeiZiTu
//
//  Created by Vokie on 2016/11/2.
//  Copyright © 2016年 Vokie. All rights reserved.
//

#import "AppDefault.h"

@implementation AppDefault

+ (instancetype)sharedManager {
    static AppDefault *manager = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (BOOL)loadDiskDataToMemory {
    self.autoLoadMore = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoLoadMore"];
    
    //当ua不存在时，默认设置为YES(首次初始化)
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"ua":@(YES)}];
    self.ua = [[NSUserDefaults standardUserDefaults] boolForKey:@"ua"];
    return YES;
}
@end
