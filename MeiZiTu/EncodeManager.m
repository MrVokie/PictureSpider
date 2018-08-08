//
//  EncodeManager.m
//  RegxUrl
//
//  Created by Vokie on 16/6/1.
//  Copyright © 2016年 tvoh. All rights reserved.
//

#import "EncodeManager.h"

@implementation EncodeManager


/**
 尝试多种格式的解码方式，解码获取到的数据，如果包含html，则表示正常解析，返回数据
 */
+ (NSString *)encodeWithData:(NSData *)data {
    NSString *result = nil;
    result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if (result != nil && result.length > 0 && [result containsString:@"html"]) {
        return result;
    }
    
    result = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];

    if (result != nil && result.length > 0 && [result containsString:@"html"]) {
        return result;
    }
    
    result = [[NSString alloc]initWithData:data encoding:NSUnicodeStringEncoding];

    if (result != nil && result.length > 0 && [result containsString:@"html"]) {
        return result;
    }
    
    //GBK解码
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    result=[[NSString alloc]initWithData:data encoding:enc];

    if (result != nil && result.length > 0 && [result containsString:@"html"]) {
        return result;
    }
    
    return nil;
}
@end
