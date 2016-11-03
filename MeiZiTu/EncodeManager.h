//
//  EncodeManager.h
//  RegxUrl
//
//  Created by Vokie on 16/6/1.
//  Copyright © 2016年 tvoh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncodeManager : NSObject
/**
 对返回的data进行解码，尝试多种解码方式(UTF8、ASCII、Unicode、GB)
 */
+ (NSString *)encodeWithData:(NSData *)data;
@end
