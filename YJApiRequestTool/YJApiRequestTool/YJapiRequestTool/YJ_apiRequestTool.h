//
//  YJ_apiRequestTool.h
//  YJApiRequestTool
//
//  Created by 于英杰 on 2019/5/13.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


/**
 网络请求的方式
 */
typedef enum : NSUInteger {
    
    YJ_GETMethodType,
    YJ_POSTMethodType,
    
} YJ_RequestMethod;

typedef void(^Sucsess)(id object);
typedef void(^Failure)(id error);

@interface YJ_apiRequestTool : NSObject
@property(nonatomic,copy)Sucsess Sucsess;
@property(nonatomic,copy)Failure Failure;

/**单利*/
+ (YJ_apiRequestTool *)shareInstance;

/**数据请求*/
- (void)requestWithUrlString:(NSString *)urlString Parameter:(id)parameter Sucsessblock:(Sucsess)sucsess
                     FailureBlock:(Failure)failure Method:(YJ_RequestMethod)requestMethod;
/**图片上传*/
- (void)UpLoadWithUrlString:(NSString *)urlString Parameter:(NSMutableArray <UIImage *>*)images Sucsessblock:(Sucsess)sucsess
                FailureBlock:(Failure)failure Method:(YJ_RequestMethod)requestMethod;

/**取消一个请求*/
-(void)requestCanelOne;
/** 取消所有请求*/
-(void)requestCanelAll;
@end

NS_ASSUME_NONNULL_END
