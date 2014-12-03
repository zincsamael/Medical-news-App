//
//  MedicalNeuroDetailViewController.h
//  Sunrise
//
//  Created by zhangnan on 7/15/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalTableViewController.h"

@interface MedicalNeuroDetailViewController : MedicalTableViewController<UIWebViewDelegate>
@property (nonatomic, strong) NSString *infoId;
@property (nonatomic, strong) NSDictionary *detailDic;
@property (nonatomic, strong) NSArray *imgArray;
@end
