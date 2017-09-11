//
//  DataBaseManager.m
//  WayGo
//
//  Created by Vokie on 16/3/25.
//  Copyright © 2016年 vokie. All rights reserved.
//

#import "DatabaseManager.h"

//订阅的网址类型枚举
typedef NS_ENUM(NSInteger, AdminType) {
    AdminTypeUser = 0,
    AdminTypeSystem
};

@interface DatabaseManager ()

@property (nonatomic, retain) NSArray *sqlArray;
@end

@implementation DatabaseManager

+ (instancetype)sharedManager {
    static DatabaseManager *manager = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (BOOL)createDatabaseWithName:(NSString *)dbName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:dbName];
    NSLog(@"sqlite_path: %@", dbPath);
    self.db = [FMDatabase databaseWithPath:dbPath];
    if (![self.db open]) {
        //failed create database.
        return NO;
    }else{
        //success create database.
        [self.db close];
        return YES;
    }
}

- (BOOL)executeSQL:(NSString *)sql {
    if ([self.db open]) {
        NSLog(@">>> %@", sql);
        [self.db executeUpdate:sql];
        [self.db close];
        return YES;
    }else{
        return NO;
    }
}

//获取订阅的数据列表
- (NSMutableArray *)getSubscribeData {
    if ([self.db open]) {
        FMResultSet *rs = [self.db executeQuery:@"select * from subscribe_list"];
        NSMutableArray *mArray = [NSMutableArray array];
        while ([rs next]) {
            // 每条记录的检索值
            NSInteger rid = [rs intForColumn:@"id"];
            NSString *name = [rs stringForColumn:@"name"];
            NSString *address = [rs stringForColumn:@"address"];
            NSInteger admin = [rs intForColumn:@"admin"];
            
            
            [mArray addObject:@{@"rid":@(rid), @"name":name, @"address":address, @"admin":@(admin)}];
        }
        [rs close];
        [self.db close];
        return mArray;
    }else{
        return nil;
    }
    
}

//获取选中的订阅网址
- (NSDictionary *)getFocusWebsite {
    if ([self.db open]) {
        FMResultSet *rs = [self.db executeQuery:@"select * from focus_website"];
        NSDictionary *dict = nil;
        while ([rs next]) {
            // 每条记录的检索值
            NSString *name = [rs stringForColumn:@"web_name"];
            NSString *site = [rs stringForColumn:@"website"];
            
            
           dict = @{@"name":name, @"site":site};
        }
        [rs close];
        [self.db close];
        return dict;
    }else{
        return nil;
    }
}

//更新选中的订阅网址
- (BOOL)updateFocusWebsite:(NSString *)site name:(NSString *)name {
    if ([self.db open]) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE focus_website set web_name = '%@', website = '%@'", name, site];
        NSLog(@">>> %@", sql);
        [self.db executeUpdate:sql];
        [self.db close];
        return YES;
    }else{
        return NO;
    }
    
}

//创建table表
- (void)createTable {
    self.sqlArray = @[@"CREATE TABLE IF NOT EXISTS subscribe_list (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, address TEXT, admin INTEGER)",//订阅名称，网页地址，区别是用户订阅还是默认值
                      @"CREATE TABLE IF NOT EXISTS db_version (version INTEGER)", //数据库版本
                      @"CREATE TABLE IF NOT EXISTS focus_website (web_name TEXT, website TEXT )"  //当前是首页聚焦的网址
                      ];
    for (NSString *string in self.sqlArray) {
        [self executeSQL:string];
    }
}

- (void)insertWebsite {
    if ([self.db open]) {
        
        //判断是否是首次进入App初始插入默认网址数据
        BOOL hasData = NO;
        FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM db_version"];
        while ([rs next]) {
            // 每条记录的检索值
            NSLog(@"IN");
            hasData = YES;
            break;
        }
        [rs close];
        
        //首次使用时初始化插入数据库
        if (!hasData) {
            //插入数据库版本
            [self.db executeUpdate:@"insert into db_version(version) values(?)", DB_START_VERSION];
            //插入系统默认订阅网址
            [self.db executeUpdate:@"insert into subscribe_list(id, name, address, admin) values(?, ?, ?, ?)", @1, @"CocoaChina", @"http://www.CocoaChina.com", @(AdminTypeSystem)];
            [self.db executeUpdate:@"insert into subscribe_list(id, name, address, admin) values(?, ?, ?, ?)", @5, @"网易", @"http://www.163.com", @(AdminTypeSystem)];
            [self.db executeUpdate:@"insert into subscribe_list(id, name, address, admin) values(?, ?, ?, ?)", @2, @"豆瓣", @"https://www.douban.com", @(AdminTypeSystem)];
            [self.db executeUpdate:@"insert into subscribe_list(id, name, address, admin) values(?, ?, ?, ?)", @3, @"妹子图", @"http://www.99mm.me", @(AdminTypeSystem)];
            
            //插入当前焦点页
            [self.db executeUpdate:@"insert into focus_website(web_name, website) values(?, ?)", @"CocoaChina", @"http://www.CocoaChina.com"];
        }
        
        [self.db close];
    }
}


- (void)autoUpgrade {
    NSArray *upgradeArray = @[
                              @"insert into subscribe_list(name, address, admin) values('优姿', 'www.youzi4.com', 0)",//TODO
                              ];
    
    if ([self.db open]) {
        FMResultSet *rs = [self.db executeQuery:@"select * from db_version"];
        while ([rs next]) {
            // 每条记录的检索值
            NSInteger ver = [rs intForColumn:@"version"];

            while(ver < DB_TARGET_VERSION) {
                [self executeSQL:upgradeArray[ver]];
                ver++;
            }
        }
        [rs close];
        
        //更新当前的db_version表的版本号到目标版本
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE db_version set version = %d", DB_TARGET_VERSION];
        [self executeSQL:updateSQL];
        
        [self.db close];
    }
}

@end
