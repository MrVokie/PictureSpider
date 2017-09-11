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
    NSString* matchRegex=@"(http|https|ftp|rtsp|mms)://((\\w)+[\\.]){1,}(net|com|cn|org|cc|io|tv|[0-9]{1,3})(\\S*)(\\.gif|\\.jpg|\\.png|\\.bmp)";
    
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
            NSLog(@"%@", substring);
            [matchStringArray addObject:substring];
        }
    }
    
    return matchStringArray;
}

//提取页面链接
+ (NSMutableArray *)crawWebWithContent:(NSString *)content originURL:(NSString *)originUrl {
    //匹配的正则表达式
//    NSString* matchRegex=@"(http|https)://((\\w)+[\\.]){1,}(net|com|cn|org|cc|io|tv|[0-9]{1,3})(\\S*/)((\\S)+(\\.html|\\.htm))";
    
    if ([[originUrl substringWithRange:NSMakeRange(originUrl.length - 1, 1)] isEqualToString:@"/"]) {
        originUrl = [originUrl substringToIndex:(originUrl.length - 1)];
    }
    
    
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
            if ([substring containsString:@".png"] || [substring containsString:@".js"] | [substring containsString:@".swf"] || [substring containsString:@".jpg"] || [substring containsString:@".gif"] || [substring containsString:@".jpeg"] || [substring containsString:@".bmp"]) {
                continue;
            }
            
            NSLog(@"%@", substring);
            if (substring.length <=1) {  //过滤单字符。主要是： "/"    "#"。
                continue;
            }
            
            //去除锚点#号
            substring = [[substring componentsSeparatedByString:@"#"] firstObject];
            
            if (substring.length <= 0) {
                continue;
            }
            
            if (![substring containsString:@"://"]) {  //特殊处理 http://  or https://
                
                if ([substring containsString:@"javascript:"]) {  //过滤脚本
                    continue;
                }
                
                if ([[substring substringToIndex:1] isEqualToString:@"/"]) {
                    substring = [NSString stringWithFormat:@"%@%@", originUrl, substring];   //相对路径修改成绝对路径
                }else{
                    substring = [NSString stringWithFormat:@"%@/%@", originUrl, substring];   //相对路径修改成绝对路径
                }
            }
            
            //只抓取当前域名下的所有网址。过滤跳转到其它外链。
            if ([substring containsString:originUrl]) {
                [matchStringArray addObject:substring];
            }
        }
    }
    
    return matchStringArray;
}

@end
