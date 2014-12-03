//
//  MedicalAnswerCell.m
//  Sunrise
//
//  Created by zhangnan on 6/25/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalAnswerCell.h"

@implementation MedicalAnswerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.indentationWidth = 20;
        self.indentationLevel = 2;
        
        _checkButton= [UIButton buttonWithType: UIButtonTypeCustom];
        _checkButton.backgroundColor = [UIColor whiteColor];
        [_checkButton setBackgroundImage:[UIImage imageNamed:@"icon_radio"] forState:UIControlStateNormal];
        [_checkButton setBackgroundImage:[UIImage imageNamed:@"icon_radio_selected"] forState:UIControlStateSelected];
        _checkButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_checkButton];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        self.titleLabel.numberOfLines = 0;
//        self.titleLabel.layer.borderWidth = 1;
        [self.contentView addSubview:self.titleLabel];
        
        self.backgroundColor = UIColorFromRGB(0xf6f6f6);
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, self.frame.size.height-1, 300, 1)];
        line.backgroundColor = UIColorFromRGB(0xe6e6e6);
        line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _checkButton.frame = CGRectMake(10, 15, 22, 22);
    _titleLabel.frame = CGRectMake(50, 0, 320-50-10, self.frame.size.height);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.textLabel.textColor = [UIColor colorWithRed:33/255.0 green:141/255.0 blue:231/255.0 alpha:1];
    }else {
        self.textLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    }
    _checkButton.selected = selected;
}
@end
