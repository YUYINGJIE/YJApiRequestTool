//
//  ViewController.m
//  YJApiRequestTool
//
//  Created by 于英杰 on 2019/5/13.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import "ViewController.h"
#import "YJapiRequestTool/YJ_apiRequestTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString*url = @"http://";
    
    NSDictionary *URLParameters = @{
                                    @"managerId" : @"000"
                                    };

    [[YJ_apiRequestTool shareInstance]requestWithUrlString:url Parameter:URLParameters Sucsessblock:^(id  _Nonnull object) {
        NSLog(@"%@",object);
    } FailureBlock:^(id  _Nonnull error) {
        NSLog(@"%@",error);
    } Method:YJ_POSTMethodType];
    
}


@end
