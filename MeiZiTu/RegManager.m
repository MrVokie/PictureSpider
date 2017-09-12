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
+ (NSMutableArray *)regProcessWithContent:(NSString *)content originURL:(NSString *)originUrl {

    originUrl = [RegManager findBaseUrlWithString:originUrl];
    
    //匹配的正则表达式
    NSString *matchRegex = @"<img src=\"(\\S*\")";
    
    NSError *error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:matchRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *match = [reg matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, [content length])];
    
    
    NSMutableArray *matchStringArray = [NSMutableArray array];
    // 取得所有的NSRange对象
    if (match.count != 0) {
        for (NSTextCheckingResult *matc in match) {
            NSRange range = [matc range];
            range.location = range.location + 10;
            range.length = range.length - 11;
            NSString *substring = [content substringWithRange:range];
            
            substring = [[substring componentsSeparatedByString:@"?"] firstObject];
            if ([substring containsString:@"<%"]) {
                continue;
            }
            
            
            if (![substring hasPrefix:@"http"]) {
                if ([substring hasPrefix:@"//"]) {
                    substring = [NSString stringWithFormat:@"http:%@", substring];
                }else if ([substring hasPrefix:@"/"]) {
                    substring = [NSString stringWithFormat:@"%@%@", originUrl, substring];
                }else{
                    substring = [NSString stringWithFormat:@"%@/%@", originUrl, substring];
                }
                
            }
            NSLog(@"收录图片：%@", substring);
            [matchStringArray addObject:substring];
        }
    }
    
    return matchStringArray;
}

//提取页面链接
+ (NSMutableArray *)crawWebWithContent:(NSString *)content originURL:(NSString *)originUrl {
    originUrl = [RegManager findBaseUrlWithString:originUrl];
    
    
    NSString* matchRegex=@"<a href=\"(\\S*\")";
    
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
            range.location = range.location + 9;
            range.length = range.length - 10;
            NSString *substring = [content substringWithRange:range];
            if ([substring containsString:@".png"] || [substring containsString:@".js"] | [substring containsString:@".swf"] || [substring containsString:@".jpg"] || [substring containsString:@".gif"] || [substring containsString:@".jpeg"] || [substring containsString:@".bmp"] || [substring containsString:@"<%"] || [substring containsString:@"javascript:"]) {
                continue;
            }
            
            
            if (substring.length <=1) {  //过滤单字符。主要是： "/"    "#"。
                continue;
            }
            
            //去除锚点#号
            substring = [[substring componentsSeparatedByString:@"#"] firstObject];
            
            if (substring.length <= 0) {
                continue;
            }
            
            
            if (![substring hasPrefix:@"http"]) {
                if ([substring hasPrefix:@"//"]) {
                    substring = [NSString stringWithFormat:@"http:%@", substring];
                }else if ([substring hasPrefix:@"/"]) {
                    substring = [NSString stringWithFormat:@"%@%@", originUrl, substring];
                }else{
                    substring = [NSString stringWithFormat:@"%@/%@", originUrl, substring];
                }
            }
            
            //只抓取当前域名下的所有网址。过滤跳转到其它外链。
            if ([substring containsString:originUrl]) {
                NSLog(@"收录地址：%@", substring);
                [matchStringArray addObject:substring];
            }
        }
    }
    
    return matchStringArray;
}


+ (NSString *)findBaseUrlWithString:(NSString *)urlString {
    //匹配的正则表达式
    NSString *matchRegex = @"(http|https|ftp|rtsp|mms)://((\\w)+[\\.]){1,}((\\w){1,3})";
    
    NSError *error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:matchRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *match = [reg matchesInString:urlString options:NSMatchingReportCompletion range:NSMakeRange(0, [urlString length])];
    
    // 取得所有的NSRange对象
    if (match.count != 0) {
        for (NSTextCheckingResult *matc in match) {
            NSRange range = [matc range];
            NSString *substring = [urlString substringWithRange:range];
            
            return substring;
        }
    }
    return urlString;
}

@end
