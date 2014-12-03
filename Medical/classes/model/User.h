//
//  User.h
//  Medical
//
//  Created by zhangnan on 6/21/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface User : MTLModel<MTLJSONSerializing>


@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *hospital;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *person_score;
@property (nonatomic, assign) NSInteger person_top;
@property (nonatomic, strong) NSString *person_time;
@property (nonatomic, strong) NSString *person_answer_times;

@property (nonatomic, strong) NSString *hospital_score;
@property (nonatomic, assign) NSInteger hospital_top;



@end
