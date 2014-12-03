//
//  MedicalInputCell.m
//  Medical
//
//  Created by zhangnan on 6/18/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalInputCell.h"

@interface MedicalInputCell()
{
    UIView *backView;
}

@end

@implementation MedicalInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
        backView.backgroundColor = [UIColor whiteColor];
        backView = v;
        backView.layer.borderWidth = 1;
        backView.layer.borderColor = [UIColorFromRGB(0xe6e6e6) CGColor];
        [self.contentView addSubview:v];
        
        _type = MedicalInputTypeTextField;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, self.frame.size.height)];
        label.backgroundColor = [UIColor clearColor];
        _titleLabel = label;
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [v addSubview:label];
        
        UITextField *inputField = [[UITextField alloc]initWithFrame:CGRectZero];
        _inputField = inputField;
        _inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        _inputField.clearsOnBeginEditing = YES;
        _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputField.font = [UIFont systemFontOfSize:15];
        _inputField.textColor = UIColorFromRGB(0x666666);
        [v addSubview:inputField];
        
        UITextView *inputView = [[UITextView alloc]initWithFrame:CGRectZero];
        _inputView = inputView;
        _inputView.font = [UIFont systemFontOfSize:15];
        _inputView.textColor = UIColorFromRGB(0x666666);
        _inputView.scrollEnabled = NO;
        _inputView.contentInset = UIEdgeInsetsMake(5, 0, 15, 0);
        [v addSubview:inputView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _inputField.frame = CGRectMake(90, 0, self.frame.size.width-110, self.frame.size.height);
    _inputView.frame = CGRectMake(85, 0, self.frame.size.width-110, self.frame.size.height);
    
    if (_type == MedicalInputTypeTextField) {
        backView.frame = CGRectMake(10, self.frame.size.height-44, 300, 44);
        _titleLabel.frame = CGRectMake(15, 0, 80, self.frame.size.height);
    }else {
        backView.frame = CGRectMake(10, -1, 300, self.frame.size.height+1);
        backView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _titleLabel.frame = CGRectMake(15, 0, 80, 44);
    }
}

- (void)setType:(MedicalInputType)type
{
    _type = type;
    switch (type) {
        case MedicalInputTypeTextView:
        {
            _inputField.hidden = YES;
            _inputView.hidden = NO;
        }
            break;
        case MedicalInputTypeTextField:
        {
            _inputField.hidden = NO;
            _inputView.hidden = YES;
        }
            break;
        default:
            break;
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    backView.backgroundColor = [UIColor whiteColor];
}

@end
