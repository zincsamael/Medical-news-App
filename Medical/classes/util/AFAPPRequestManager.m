//
//  AFAPPRequestManager.m
//  Medical
//
//  Created by zhangnan on 6/21/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "AFAPPRequestManager.h"

@implementation AFAPPRequestManager

//- (instancetype)initWithBaseURL:(NSURL *)url
//{
//    
//}


+ (instancetype)manager
{
    static AFAPPRequestManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[AFAPPRequestManager alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
        _sharedManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    });
    
    return _sharedManager;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
