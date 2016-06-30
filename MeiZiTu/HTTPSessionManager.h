//
//  NetworkManager.h
//  WayGo
//
//  Created by Vokie on 16/3/18.
//  Copyright © 2016年 vokie. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void (^requestSuccessBlock)(id response);
typedef void (^requestFailureBlock)(NSError *error);

typedef enum {
    GET,
    POST
} HTTPMethod;

@interface HTTPSessionManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (void)requestWithMethod:(HTTPMethod)method
                     path:(NSString *)path
                   params:(NSDictionary*)params
             successBlock:(requestSuccessBlock)success
              failureBlock:(requestFailureBlock)failure;

- (void)switchUserAgentToPC:(BOOL)flag;
@end
