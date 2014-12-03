//
//  MedicalTableViewController.h
//  Sunrise
//
//  Created by zhangnan on 7/2/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface MedicalTableViewController : UITableViewController<MJRefreshBaseViewDelegate>

@property (nonatomic, strong) MJRefreshHeaderView *header;
@property (nonatomic, strong) MJRefreshFooterView *footer;
@property (nonatomic, assign) BOOL needPullRefresh;
@property (nonatomic, assign) BOOL needLoadMoreData;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger totalPages;
@end
