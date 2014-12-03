//
//  InfoEntryViewCell.h
//  Medical
//
//  Created by zhangnan on 6/11/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoEntryViewCell : UITableViewCell
@property (strong, nonatomic) UIImageView *portraitView;
@property (strong, nonatomic) UILabel *introLabel;
@property (nonatomic, strong) UILabel *createTimeLabel;
@property (nonatomic, strong) UILabel *readCountLabel;
@end
