//
//  MedicalInputCell.h
//  Medical
//
//  Created by zhangnan on 6/18/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MedicalInputType) {
    MedicalInputTypeTextField,
    MedicalInputTypeTextView,
};

@interface MedicalInputCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UITextView *inputView;
@property (nonatomic, assign) MedicalInputType type;

@end
