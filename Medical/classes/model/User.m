//
//  User.m
//  Medical
//
//  Created by zhangnan on 6/21/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"uid":@"id",
             @"email":@"email",
             @"hospital":@"hospital",
             @"hospital_score":@"hospital_score",
             @"hospital_top":@"hospital_top",
             @"name":@"name",
             @"person_score":@"person_score",
             @"person_time":@"person_time",
             @"person_top":@"person_top",
             @"telephone":@"telephone",
             @"password":NSNull.null,
             @"chance":@"chance",
             };
}

@end
