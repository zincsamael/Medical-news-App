//
//  MedicalMatchInfoViewController.m
//  Medical
//
//  Created by zhangnan on 6/11/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalMatchInfoViewController.h"
#import "MedicalActiveViewController.h"

@interface MedicalMatchInfoViewController ()
@property (nonatomic, strong) NSMutableArray *entries;
@end

@implementation MedicalMatchInfoViewController

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
    self.curPage = 1;
    self.entries = [@[] mutableCopy];
    [self.tableView registerClass:[InfoEntryViewCell class] forCellReuseIdentifier:@"InfoEntryViewCell"];
    self.tableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadData];
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
    [[AFAPPRequestManager manager]GET:@"api/article-list" parameters:@{@"type":@"0",@"page":@(self.curPage),@"pageNum":@"10"} success:^(NSURLSessionDataTask *task, id responseObject)
     {
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
