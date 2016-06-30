//
//  SubscribeModel.h
//  MeiZiTu
//
//  Created by Vokie on 16/6/14.
//  Copyright © 2016年 Vokie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscribeModel : NSObject

@property (nonatomic, retain) NSString *rid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *admin;

- (void)sqlUpdate;
- (void)sqlDelete;
- (void)sqlInsert;
@end
