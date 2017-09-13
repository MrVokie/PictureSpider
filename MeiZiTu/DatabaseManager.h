//
//  DataBaseManager.h
//  WayGo
//
//  Created by Vokie on 16/3/25.
//  Copyright © 2016年 vokie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

#define DB_START_VERSION 0
#define DB_TARGET_VERSION 4

@interface DatabaseManager : NSObject
@property (nonatomic, retain) FMDatabase *db;

+ (instancetype) sharedManager;

- (BOOL)createDatabaseWithName:(NSString *)dbName;
- (BOOL)executeSQL:(NSString *)sql;
- (NSMutableArray *)getSubscribeData;

- (void)insertWebsite;
- (void)createTable;

- (BOOL)updateFocusWebsite:(NSString *)site name:(NSString *)name;
- (NSDictionary *)getFocusWebsite;
- (void)autoUpgrade;
@end
