//
//  MedicalButtonCell.m
//  Medical
//
//  Created by zhangnan on 6/18/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalButtonCell.h"

@implementation MedicalButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectZero;
        _button.titleLabel.font = [UIFont systemFontOfSize:18];
        _button.backgroundColor = [UIColor colorWithRed:33/255.0 green:141/255.0 blue:241/255.0 alpha:1];
        [self.contentView addSubview:_button];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _button.frame = CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    _button.backgroundColor = [UIColor colorWithRed:33/255.0 green:141/255.0 blue:241/255.0 alpha:1];
}

@end
