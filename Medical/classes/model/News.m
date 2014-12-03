//
//  News.m
//  Medical
//
//  Created by zhangnan on 6/21/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "News.h"

@implementation News


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"newsId":@"id",
             @"title":@"title",
             @"created_at":@"created_at",
             @"cover":@"cover",
             @"type":@"type",
             @"browse_times":@"browse_times"};
}

- (NSString *)shortDate
{
    NSDateFormatter *formatter= [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:_created_at];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}
@end
