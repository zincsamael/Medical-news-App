//
//  MedicalIndicatorCell.m
//  Medical
//
//  Created by zhangnan on 6/19/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalIndicatorCell.h"

@interface MedicalIndicatorCell()
{
    UIImageView *arrowIndicator;
    UIView *backView;
}

@end

@implementation MedicalIndicatorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
        [self.contentView addSubview:v];
        backView.backgroundColor = [UIColor whiteColor];
        backView = v;
        
        arrowIndicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_arrow"]];
        [self.contentView addSubview:arrowIndicator];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.indentationWidth = 10;
        self.indentationLevel = 1;
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.textColor = UIColorFromRGB(0x333333);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    arrowIndicator.frame = CGRectMake(285, (self.frame.size.height-14)/2, 14, 14);
    backView.frame = CGRectMake(10, self.frame.size.height-44, 300, 44);
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = [UIColorFromRGB(0xe6e6e6) CGColor];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        backView.backgroundColor = UIColorFromRGB(0xe6e6e6);
    }else {
        backView.backgroundColor = [UIColor whiteColor];
    }
}

@end
