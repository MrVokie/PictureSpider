//
//  SubscribeModel.m
//  MeiZiTu
//
//  Created by Vokie on 16/6/14.
//  Copyright © 2016年 Vokie. All rights reserved.
//

#import "SubscribeModel.h"
#import "MBProgressHUD+EasyUse.h"
#import "DatabaseManager.h"

@implementation SubscribeModel

- (void)sqlUpdate {
    NSString *sqlString = [NSString stringWithFormat:@"UPDATE subscribe_list SET name = '%@', address = '%@' where id = %@", self.name, self.address, self.rid];
    [[DatabaseManager sharedManager]executeSQL:sqlString];
    [MBProgressHUD showWithText:@"修改成功"];
}

- (void)sqlDelete {
    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM subscribe_list where id = %@", self.rid];
    [[DatabaseManager sharedManager]executeSQL:sqlString];
}

- (void)sqlInsert {
    NSString *sqlString = [NSString stringWithFormat:@"insert into subscribe_list(name, address, admin) values('%@', '%@', %@)", self.name, self.address, self.admin];
    [[DatabaseManager sharedManager]executeSQL:sqlString];
    
    [MBProgressHUD showWithText:@"添加成功"];
}

@end
