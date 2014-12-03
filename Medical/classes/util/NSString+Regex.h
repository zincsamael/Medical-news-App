//
//  NSString+Regex.h
//  Sunrise
//
//  Created by zhangnan on 6/25/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)
- (BOOL)validateEmail;
- (BOOL)validatePhoneNumber;
- (BOOL)validateUsername;
- (BOOL)validatePassword;
@end
