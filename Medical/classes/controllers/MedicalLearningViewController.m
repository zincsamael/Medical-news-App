//
//  MedicalLearningViewController.m
//  Medical
//
//  Created by zhangnan on 6/11/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalLearningViewController.h"
#import "AFAPPRequestManager.h"
#import "ImageCenterViewCell.h"
#import "MedicalNeuroDetailViewController.h"

static NSString *imageCenterCell = @"imageCenterCell";

@interface MedicalLearningViewController ()
@property (nonatomic, strong) NSMutableArray *entries;
@property (nonatomic, strong) NSMutableArray *infoEntries;
@property (nonatomic, strong) NSMutableArray *imgEntries;
@end

@implementation MedicalLearningViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.needLoadMoreData = NO;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.needLoadMoreData = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ImageCenterViewCell class] forCellReuseIdentifier:imageCenterCell];
    self.entries = [NSMutableArray array];
    self.infoEntries = [NSMutableArray array];
    self.imgEntries = [NSMutableArray array];
//    AFHTTPSessionManager *manager= [AFHTTPSessionManager manager];
////    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager GET:@"http://114.215.176.211/api/image-center?method=getNeourImgsByID&nid=10" parameters:@"" success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
    [self loadData];
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == self.header) {
        [self loadData];
    }
}

- (void)loadData{
    
    UIView *v = [self.tableView viewWithTag:9999];
    if (v) {
        [v removeFromSuperview];
    }
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    activityIndicator.center = CGPointMake(160, 160);
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.tableView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [[AFAPPRequestManager manager] GET:@"api/image-center" parameters:@{@"method":@"getNeoursByTitle",@"title":@""} success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.entries removeAllObjects];
        NSArray *arr = responseObject;
        for (int i=0; i<arr.count; i++) {
            NSDictionary *dic = [arr objectAtIndex:i];
            [self.entries addObject:dic];
//            [self.infoEntries addObject:@""];
//            [self.imgEntries addObject:@""];
//            [[AFAPPRequestManager manager] GET:@"api/image-center" parameters:@{@"method":@"getNeourByID",@"nid":[dic objectForKey:@"ID"]} success:^(NSURLSessionDataTask *task, id responseObject) {
//                [self.infoEntries replaceObjectAtIndex:i withObject:responseObject];
//                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                
//            }];
//            [[AFAPPRequestManager manager] GET:@"api/image-center" parameters:@{@"method":@"getNeourImgsByID",@"nid":[dic objectForKey:@"ID"]} success:^(NSURLSessionDataTask *task, id responseObject) {
//                [self.imgEntries replaceObjectAtIndex:i withObject:responseObject];
//                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                
//            }];
        }
        [self.header endRefreshing];
        [self.footer endRefreshing];
        [self.tableView reloadData];
        [activityIndicator stopAnimating];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self.header endRefreshing];
        [self.footer endRefreshing];
        [self.entries removeAllObjects];
        [self.tableView reloadData];
        UIView *v = [[UIView alloc]initWithFrame:self.tableView.bounds];
        v.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        v.backgroundColor = UIColorFromRGB(0xf6f6f6);
        v.tag = 9999;
        [self.tableView addSubview:v];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        label.text = @"网络连接失败";
        label.center = CGPointMake(160, 160);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:15];
//        label.layer.borderWidth = 1;
        [v addSubview:label];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 37)];
        button.center = CGPointMake(160, 200);
        [button setTitle:@"点此重新加载" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [button setBackgroundColor:UIColorFromRGB(0xffffff)];
        [button addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
        button.center = CGPointMake(160, 200);
        button.layer.borderColor = [UIColorFromRGB(0xcccccc)CGColor];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.borderWidth = 1;
        [v addSubview:button];
        
        [activityIndicator stopAnimating];
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCenterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:imageCenterCell forIndexPath:indexPath];
    
    NSDictionary *dic = [self.entries objectAtIndex:indexPath.row];
//    NSDictionary *infoDic = [self.infoEntries objectAtIndex:indexPath.row];
//    NSArray *imgArray = [self.imgEntries objectAtIndex:indexPath.row];
    cell.introLabel.text = [dic objectForKey:@"title"];
    
    if ([dic isKindOfClass:[NSDictionary class]]) {
        cell.createTimeLabel.text = [NSString stringWithFormat:@"作者:%@  编辑:%@  审校:%@",[dic objectForKey:@"author"]?:@"",[dic objectForKey:@"editer"]?:@"",[dic objectForKey:@"jy"]?:@""];
    }
    
    [[SDWebImageManager sharedManager]downloadWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.imagingcenter.com.cn%@",([dic objectForKey:@"img"]?:@"")]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        cell.portraitView.image = image;
    }];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.entries objectAtIndex:indexPath.row];
    MedicalNeuroDetailViewController *neuroVC = [[MedicalNeuroDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
    neuroVC.infoId = [dic objectForKey:@"ID"];
    neuroVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:neuroVC animated:YES];
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
