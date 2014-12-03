//
//  MedicalRegisterViewController.h
//  Medical
//
//  Created by zhangnan on 6/19/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MedicalRegisterType) {
    MedicalRegisterTypeRegister,
    MedicalRegisterTypeActivate,
};

@interface MedicalRegisterViewController : UIViewController

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) MedicalRegisterType type;
@end
