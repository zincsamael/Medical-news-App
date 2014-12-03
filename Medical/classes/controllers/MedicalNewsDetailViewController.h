//
//  MedicalNewsDetailViewController.h
//  Medical
//
//  Created by zhangnan on 6/24/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "APIHeader.h"
#import <SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MedicalTableViewController.h"

@interface MedicalNewsDetailViewController : MedicalTableViewController<UIWebViewDelegate>
@property (nonatomic,strong) News *news;
@end
