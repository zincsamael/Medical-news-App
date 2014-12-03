//
//  ShareData.m
//  YuanZi
//
//  Created by zhangnan on 4/11/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "ShareData.h"
//#import "AFNetworking.h"

@implementation ShareData

+ (instancetype)shareInstance
{
    static ShareData *_shareData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareData = [[self alloc]init];
    });
    return _shareData;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _curUser = [[User alloc]init];
    
    return self;
}

@end
