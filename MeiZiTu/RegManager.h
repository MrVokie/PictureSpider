//
//  RegManager.h
//  RegxUrl
//
//  Created by Vokie on 16/6/1.
//  Copyright © 2016年 tvoh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegManager : NSObject

+ (NSMutableArray *)regProcessWithContent:(NSString *)content;
+ (NSMutableArray *)crawWebWithContent:(NSString *)content originURL:(NSString *)originUrl;

@end
