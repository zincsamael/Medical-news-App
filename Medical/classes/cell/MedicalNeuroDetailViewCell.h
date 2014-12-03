//
//  MedicalNeuroDetailViewCell.h
//  Sunrise
//
//  Created by zhangnan on 7/15/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicalNeuroDetailViewCell : UITableViewCell
@property (nonatomic, strong) NSString *htmlStr;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL showTitle;
@end
