//
//  ImageCenterViewCell.m
//  Sunrise
//
//  Created by zhangnan on 7/14/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "ImageCenterViewCell.h"

@implementation ImageCenterViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.readCountLabel.hidden = YES;
        self.introLabel.numberOfLines = 1;
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
    self.portraitView.frame = CGRectMake(10, 10, 50, 50);
    self.introLabel.frame = CGRectMake(70, 6, 230, 20);
    self.createTimeLabel.frame = CGRectMake(70, 25, 230, 20);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
