#import "HTTPSessionManager.h"



@implementation HTTPSessionManager

+ (instancetype)sharedManager {
    static HTTPSessionManager *manager = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]];
    });
    return manager;
}

-(instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.requestSerializer.timeoutInterval = 8;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        
        [[NSUserDefaults standardUserDefaults]registerDefaults:@{@"ua":@(YES)}];
        
        BOOL uaflag = [[NSUserDefaults standardUserDefaults]boolForKey:@"ua"];
        [self switchUserAgentToPC:uaflag];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

- (void)switchUserAgentToPC:(BOOL)flag {
    if (flag) {
        //PC电脑端
        [self.requestSerializer setValue:@"Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20100101 Firefox/6.0" forHTTPHeaderField:@"User-Agent"];
    }else{
        //手机端
        [self.requestSerializer setValue:@"" forHTTPHeaderField:@"User-Agent"];
    }
    
}

- (void)requestWithMethod:(HTTPMethod)method
                     path:(NSString *)path
                   params:(NSDictionary*)params
             successBlock:(requestSuccessBlock)success
              failureBlock:(requestFailureBlock)failure {
    
    //对没有输入http货https前缀的地址加上这个前缀
    if (![path containsString:@"http://"] && ![path containsString:@"https://"]) {
        path = [NSString stringWithFormat:@"http://%@", path];
    }
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    switch (method) {
        case GET:{
            [self GET:path parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                failure(error);
            }];
            break;
        }
        case POST:{
            [self POST:path parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                failure(error);
            }];
            break;
        }
        default:
            break;
    }
}


@end