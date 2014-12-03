//
//  InfoEntryViewCell.m
//  Medical
//
//  Created by zhangnan on 6/11/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "InfoEntryViewCell.h"

@implementation InfoEntryViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _portraitView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_portraitView];
        
        _introLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _introLabel.font = [UIFont systemFontOfSize:15];
        _introLabel.numberOfLines = 2;
        _introLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _introLabel.textColor = UIColorFromRGB(0x333333);
//        _introLabel.layer.borderWidth = 1;
        [self.contentView addSubview:_introLabel];
        
        _createTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _createTimeLabel.font = [UIFont systemFontOfSize:10];
//        _createTimeLabel.layer.borderWidth = 1;
        _createTimeLabel.textColor = UIColorFromRGB(0x999999);
        _createTimeLabel.clipsToBounds = YES;
        [self.contentView addSubview:_createTimeLabel];
        
        _readCountLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _readCountLabel.font = [UIFont systemFontOfSize:10];
//        _readCountLabel.layer.borderWidth = 1;
        _readCountLabel.textColor = UIColorFromRGB(0x999999);
        _readCountLabel.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [self.contentView addSubview:_readCountLabel];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, self.frame.size.height-1, 300, 1)];
        line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:line];
        line.backgroundColor = UIColorFromRGB(0xe6e6e6);
        
        
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
    _portraitView.frame = CGRectMake(10, 10, 75, 50);
    _introLabel.frame = CGRectMake(95, 6, 220, 40);
    _createTimeLabel.frame = CGRectMake(95, 45, 115, 20);
    
    _readCountLabel.frame = CGRectMake(220, 45, 200, 20);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
