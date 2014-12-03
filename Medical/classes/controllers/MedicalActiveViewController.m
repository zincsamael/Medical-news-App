//
//  MedicalActiveViewController.m
//  Medical
//
//  Created by zhangnan on 6/11/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalActiveViewController.h"

@interface MedicalActiveViewController ()
@property (nonatomic, strong) NSMutableArray *entries;
@property (nonatomic, strong) NSMutableArray *newsArray;
@end

@implementation MedicalActiveViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _newsArray = [NSMutableArray array];
    self.curPage = 1;
    self.entries = [@[] mutableCopy];
    [self.tableView registerClass:[InfoEntryViewCell class] forCellReuseIdentifier:@"InfoEntryViewCell"];
    self.tableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadData];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationShowLogin object:nil];
    
    CGColorRef color = [UIColorFromRGB(0xcdcdcd) CGColor];
    self.matchButton.layer.borderWidth = 1;
    self.matchButton.layer.borderColor = color;
    
    self.studyButton.layer.borderWidth = 1;
    self.studyButton.layer.borderColor = color;;
    
    self.participateButton.layer.borderWidth = 1;
    self.participateButton.layer.borderColor = color;;
    
    [[AFAPPRequestManager manager]GET:@"api/focus" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = responseObject[@"data"];
        
        if ([array isKindOfClass:[NSArray class]]) {
            if ([array count]) {
                [self setScrollerHeaderWithArray:array];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)setScrollerHeaderWithArray:(NSArray *)array
{
    _cycleView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 160) animationDuration:2];
    [self.tableView.tableHeaderView addSubview:_cycleView];
    
    __weak MedicalActiveViewController *weakSelf = self;
    NSMutableArray *viewsArray = [NSMutableArray arrayWithCapacity:array.count];
    for (int i = 0; i<array.count; i++) {
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 160)];
        UIButton *_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = v.bounds;
        _btn.userInteractionEnabled = NO;
        _btn.tag = 500+i;
        NSDictionary *dic = [array objectAtIndex:i];
        NSURL *url = [NSURL URLWithString:[dic objectForKey:@"img"]];
        [[SDWebImageManager sharedManager]downloadWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            [_btn setBackgroundImage:image forState:UIControlStateNormal];
        }];
        _btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [v addSubview:_btn];
        
        [viewsArray addObject:v];
    }
    
    _cycleView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        //        NSLog(@"第 %d 个",pageIndex);
        return viewsArray[pageIndex];
    };
    _cycleView.totalPagesCount = ^NSInteger(void){
        return array.count;
    };
    
    _cycleView.TapActionBlock = ^(NSInteger pageIndex){
        NSDictionary *dic = [array objectAtIndex:pageIndex];
        
        News *news = [[News alloc]init];
        news.newsId = [dic objectForKey:@"article_id"];
        MedicalNewsDetailViewController *newsDetail = [[MedicalNewsDetailViewController alloc]init];
        newsDetail.news = news;
        [weakSelf.navigationController pushViewController:newsDetail animated:YES];
    };
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == self.header) {
        self.curPage = 1;
        [self loadData];
    }
    else {
        if (self.curPage < self.totalPages) {
            self.curPage ++;
            [self loadData];
        }else {
            [refreshView endRefreshing];
        }
    }
}

- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    [refreshView endRefreshing];
}

- (void)loadData
{
    [[AFAPPRequestManager manager]GET:@"api/article-list" parameters:@{@"type":@"home",@"page":@(self.curPage),@"pageNum":@"10"} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arr = [responseObject objectForKey:@"data"]?:@[];
        
        self.totalPages = [responseObject[@"last_page"]integerValue];
        if (self.curPage==1) {
            [self.entries removeAllObjects];
        }
        for (int i = 0; i<arr.count; i++) {
            News *news = [MTLJSONAdapter modelOfClass:[News class] fromJSONDictionary:arr[i] error:nil];
            
            [self.entries addObject:news];
        }
        [self.header endRefreshing];
        [self.footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (void)handleParticapateButton:(UIButton *)sender
{
    self.tabBarController.selectedIndex = 4;
}

- (void)handleMatchButton:(UIButton *)sender
{
    News *news = [[News alloc]init];
    news.newsId = @"33";
    MedicalNewsDetailViewController *newsDetail = [[MedicalNewsDetailViewController alloc]init];
    newsDetail.news = news;
    [self.navigationController pushViewController:newsDetail animated:YES];
}

- (void)handleStudyButton:(UIButton *)sender
{
    self.tabBarController.selectedIndex = 2;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.entries.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoEntryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoEntryViewCell" forIndexPath:indexPath];
    cell.backgroundColor = UIColorFromRGB(0xf6f6f6);
    // Configure the cell...
    News *news = [self.entries objectAtIndex:indexPath.row];
    cell.introLabel.text = news.title;
    
    cell.createTimeLabel.text = [NSString stringWithFormat:@"发布时间：%@",[news shortDate]];
    cell.readCountLabel.text = [NSString stringWithFormat:@"阅读量：%d",news.browse_times];
    
    if(news.avatar)
    {
        cell.portraitView.image = news.avatar;
    }else {
        [[SDWebImageManager sharedManager]downloadWithURL:[NSURL URLWithString:news.cover] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            news.avatar = image;
            cell.portraitView.image = news.avatar;
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    News *news = [self.entries objectAtIndex:indexPath.row];
    
    MedicalNewsDetailViewController *newsDetail = [[MedicalNewsDetailViewController alloc]init];
    newsDetail.news = news;
    [self.navigationController pushViewController:newsDetail animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    MedicalRegisterViewController *vc = [segue destinationViewController];
//    vc.titleArray = @[@"账号设置",@"填写信息",@"注册成功"];
//    vc.type = MedicalRegisterTypeRegister;
}
@end
