//
//  ShareData.h
//  YuanZi
//
//  Created by zhangnan on 4/11/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "APIHeader.h"


@interface ShareData : NSObject

@property (nonatomic, strong) User *curUser;
@property (nonatomic, strong) NSString *password;

+ (instancetype)shareInstance;
@end
