//
//  YJ_apiRequestTool.m
//  YJApiRequestTool
//
//  Created by 于英杰 on 2019/5/13.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import "YJ_apiRequestTool.h"
#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>
#import "AFNetworkActivityLogger/AFNetworkActivityLogger.h"
#import <MJExtension/MJExtension.h>
#define TIME_OUT 60

@interface YJ_apiRequestTool ()
@property(nonatomic,strong)AFHTTPSessionManager *AFManager;

@end

@implementation YJ_apiRequestTool
+ (YJ_apiRequestTool *)shareInstance{
    static YJ_apiRequestTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YJ_apiRequestTool alloc]init];
    });
    return instance;
}

-(id)init{
    
    if (self = [super init]) {
        /*
         处理请求体的类型 根据要求可进行设置 ----requestSerializer
         self.AFManager.requestSerializer = [AFJSONRequestSerializer serializer];
         self.AFManager.requestSerializer = [AFPropertyListRequestSerializer serializer];
         self.AFManager.requestSerializer = [AFHTTPRequestSerializer serializer];


         返回数据的类型 根据要求可进行设置 ----responseSerializer
         self.AFManager.responseSerializer = [AFHTTPResponseSerializer serializer];
         self.AFManager.responseSerializer = [AFJSONResponseSerializer serializer];
         self.AFManager.responseSerializer = [AFJSONResponseSerializer serializer];

         设定超时时间
         self.AFManager.requestSerializer.timeoutInterval = SYS_TIME_OUT;

         安全套字节 https 证书给后台要 不用的话无需处理
         self.AFManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
         self.AFManager.securityPolicy.allowInvalidCertificates = YES;
         [self.AFManager.securityPolicy setValidatesDomainName:NO];
         
         */
        [[AFNetworkActivityLogger sharedLogger]setLogLevel:AFLoggerLevelDebug];
        //开启日志
        [[AFNetworkActivityLogger sharedLogger] startLogging];
        self.AFManager  = [AFHTTPSessionManager manager];
        self.AFManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.AFManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.AFManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"text/plain",@"application/json"]];
        self.AFManager.requestSerializer.timeoutInterval = TIME_OUT;
       
    ((AFJSONResponseSerializer*)self.AFManager.responseSerializer).removesKeysWithNullValues=YES;
        
        [[AFNetworkActivityIndicatorManager sharedManager]setEnabled:YES];// 上面这两句是打印出json数据需要添加的代码
        
        //关闭缓存避免干扰测试
    self.AFManager.requestSerializer.cachePolicy=NSURLRequestReloadIgnoringLocalCacheData;

    }
    return self;
}

- (void)requestWithUrlString:(NSString *)urlString Parameter:(id)parameter Sucsessblock:(Sucsess)sucsess FailureBlock:(Failure)failure Method:(YJ_RequestMethod)requestMethod{
    
    if (requestMethod==YJ_GETMethodType) {

        [self.AFManager GET:urlString parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (sucsess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    sucsess(responseObject);
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }];
    }
   
    else if (requestMethod==YJ_POSTMethodType){
        
        [self.AFManager POST:urlString parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (sucsess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    sucsess(responseObject);
                });
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }];
    }
    
}

- (void)UpLoadWithUrlString:(NSString *)urlString Parameter:(NSMutableArray<UIImage *> *)images Sucsessblock:(Sucsess)sucsess FailureBlock:(Failure)failure Method:(YJ_RequestMethod)requestMethod{
    
   
    [self.AFManager POST:urlString parameters:images constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       
        [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImage*image = (UIImage*)obj;
            NSString *fileName = fileNameWithindex(idx);
            NSData *data=UIImageJPEGRepresentation(image, 0.3);
            [formData appendPartWithFileData:data name:@"image" fileName:fileName mimeType:@"image/jpg"];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucsess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                sucsess(responseObject);
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
   
}
- (void)requestCanelOne {
    [[[[self.AFManager operationQueue] operations] lastObject] cancel];
}
- (void)requestCanelAll {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[self.AFManager operationQueue] cancelAllOperations];
}
 NSInteger getNowInterVal(){
    NSDate  *date = [NSDate date];
    return date.timeIntervalSince1970 * 1000; //乘以1000为毫秒
}

NSString * fileNameWithindex(NSInteger index){
   
    NSInteger tipInterVal = getNowInterVal();
    return   [NSString stringWithFormat:@"%ld%zd.jpg", (long)tipInterVal, (unsigned long)index];
}
@end
