//
//  News.h
//  Medical
//
//  Created by zhangnan on 6/21/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface News : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *newsId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, assign) NSInteger browse_times;
@property (nonatomic, assign) NSInteger type;

- (NSString *)shortDate;
@end
