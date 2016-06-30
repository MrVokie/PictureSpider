//
//  JsonTools.h
//  WayGo
//
//  Created by Vokie on 16/4/5.
//  Copyright © 2016年 vokie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonTools : NSObject

+ (id)objectWithJson:(NSString *)json;

+ (NSString *)jsonWithObject:(id)obj;
@end
