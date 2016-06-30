//
//  RegManager.m
//  RegxUrl
//
//  Created by Vokie on 16/6/1.
//  Copyright © 2016年 tvoh. All rights reserved.
//

#import "RegManager.h"

@implementation RegManager

//提取图片链接
+ (NSMutableArray *)regProcessWithContent:(NSString *)content {
    //匹配的正则表达式
    NSString* matchRegex=@"(http|https|ftp|rtsp|mms)://((\\w)+[\\.]){1,}(net|com|cn|org|cc|io|tv|[0-9]{1,3})(\\S*/)((\\S)+(\\.gif|\\.jpg|\\.png|\\.bmp))";
    
    NSError *error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:matchRegex
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:&error];
    NSArray *match = [reg matchesInString:content
                                  options:NSMatchingReportCompletion
                                    range:NSMakeRange(0, [content length])];
    
    
    NSMutableArray *matchStringArray = [NSMutableArray array];
    // 取得所有的NSRange对象
    if(match.count != 0)
    {
        for (NSTextCheckingResult *matc in match)
        {
            NSRange range = [matc range];
            range.location = range.location;
            range.length = range.length;
            NSString *substring = [content substringWithRange:range];
            if ([substring containsString:@"icon.png"]) {
                continue;
            }
            
            [matchStringArray addObject:substring];
        }
    }
    
    return matchStringArray;
}

//提取页面链接
+ (NSMutableArray *)crawWebWithContent:(NSString *)content {
    //匹配的正则表达式
//    NSString* matchRegex=@"(http|https)://((\\w)+[\\.]){1,}(net|com|cn|org|cc|io|tv|[0-9]{1,3})(\\S*/)((\\S)+(\\.html|\\.htm))";
    NSString* matchRegex=@"\"(http|https)://((\\w)+[\\.]){1,}(net|com|cn|org|cc|io|tv|[0-9]{1,3})(\\S*\")";
    
    NSError *error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:matchRegex
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:&error];
    NSArray *match = [reg matchesInString:content
                                  options:NSMatchingReportCompletion
                                    range:NSMakeRange(0, [content length])];
    
    
    NSMutableArray *matchStringArray = [NSMutableArray array];
    // 取得所有的NSRange对象
    if(match.count != 0)
    {
        for (NSTextCheckingResult *matc in match)
        {
            NSRange range = [matc range];
            range.location = range.location + 1;
            range.length = range.length - 2;
            NSString *substring = [content substringWithRange:range];
            if ([substring containsString:@".png"] || [substring containsString:@".js"] | [substring containsString:@".swf"] || [substring containsString:@".jpg"] || [substring containsString:@".gif"] || [substring containsString:@".jpeg"] || [substring containsString:@".bmp"]) {
                continue;
            }
            
            [matchStringArray addObject:substring];
        }
    }
    
    return matchStringArray;
}

@end
