//
//  JsonTools.m
//  WayGo
//
//  Created by Vokie on 16/4/5.
//  Copyright © 2016年 vokie. All rights reserved.
//

#import "JsonTools.h"

@implementation JsonTools

//NSDictionary to JSON string
+ (NSString*)jsonWithObject:(id)obj {
    NSString *jsonString = nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    
    if (!jsonData) {
        NSLog(@"json解析失败:%@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


+ (id)objectWithJson:(NSString *)json {
    if (json == nil || json.length == 0) {
        return @{};
    }
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败:%@",err);
        return nil;
    }
    return dic;
}


@end
