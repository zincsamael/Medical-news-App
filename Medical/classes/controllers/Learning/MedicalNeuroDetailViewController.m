//
//  MedicalNeuroDetailViewController.m
//  Sunrise
//
//  Created by zhangnan on 7/15/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalNeuroDetailViewController.h"
#import <SDWebImageManager.h>
#import "MedicalImageAlbumViewController.h"
#import "AFAPPRequestManager.h"
#import "HTMLParser.h"
#import "FDLabelView.h"
#import "MedicalNeuroDetailViewCell.h"


static NSString *medicalDetailCell = @"medicalDetailCell";
@interface MedicalNeuroDetailViewController ()
{
    UIView *footerView;
    UIView *headerView;
}

@property (nonatomic, strong) NSArray *referenceArray;
@property (nonatomic, strong) NSArray *htmlItemArray;
@property (nonatomic, strong) NSArray *cellTitleArray;
@property (nonatomic, strong) NSMutableDictionary *rowHeightDic;
@end

@implementation MedicalNeuroDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.needLoadMoreData = NO;
        self.needPullRefresh = NO;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.needPullRefresh = NO;
        self.needLoadMoreData = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    self.needPullRefresh = NO;
    self.needLoadMoreData = NO;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.referenceArray = @[];
    [self.tableView registerClass:[MedicalNeuroDetailViewCell class] forCellReuseIdentifier:medicalDetailCell];
    self.htmlItemArray = @[@[@"ybtd",@"ct",@"mri",@"xgzy",@"cs",@"hyx",@"jclc",@"jbzd"],@[@"bwys",@"zztz",@"jbyh",@"zl"]];
    self.cellTitleArray = @[@[@"一般特点",@"CT发现",@"MR发现",@"血管造影",@"超声",@"核医学",@"推荐使用的影像学检查及流程",@"鉴别诊断"],@[@"危险因素（既往史、家族史）",@"症状及体征",@"疾病自然病程及预后",@"治疗"]];
    self.rowHeightDic = [NSMutableDictionary dictionary];
    
    [self loadData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
}

- (void)loadData
{
    [[AFAPPRequestManager manager] GET:@"api/image-center" parameters:@{@"method":@"getNeourByID",@"nid":self.infoId} success:^(NSURLSessionDataTask *task, id responseObject) {
        self.detailDic = responseObject;
        [self setupHeaderView];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
    
    
    
    [self loadReference];
}

- (void)loadReference
{
    [[AFAPPRequestManager manager] GET:@"api/image-center" parameters:@{@"method":@"getWenxianByNid",@"nid":self.infoId} success:^(NSURLSessionDataTask *task, id responseObject) {
        _referenceArray = responseObject;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)setupHeaderView
{
    self.title = @"影像详情";
    
    NSString *string = [_detailDic objectForKey:@"title"];;
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:21] constrainedToSize:CGSizeMake(300, 1000)];
    CGFloat height = 50;
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 214-(height-size.height))];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 103-(height-size.height), 300, 1)];
    line.backgroundColor = UIColorFromRGB(0xe6e6e6);
    [headerView addSubview:line];
    
    

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, size.height+20)];
    label.font = [UIFont systemFontOfSize:21];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = string;
    label.textColor = UIColorFromRGB(0x333333);
    [headerView addSubview:label];
    
    UILabel *_createTimeLabel;
    _createTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70-(height-size.height), 300, 20)];
    _createTimeLabel.font = [UIFont systemFontOfSize:12];
    //    _createTimeLabel.layer.borderWidth = 1;
    _createTimeLabel.textColor = UIColorFromRGB(0x999999);
    [headerView addSubview:_createTimeLabel];
    
//    _readCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 70, 00, 20)];
//    _readCountLabel.font = [UIFont systemFontOfSize:12];
//    //        _readCountLabel.layer.borderWidth = 1;
//    _readCountLabel.textColor = UIColorFromRGB(0x999999);
//    [headerView addSubview:_readCountLabel];
    
    _createTimeLabel.text = [NSString stringWithFormat:@"作者:%@  编辑:%@  审校:%@",[_detailDic objectForKey:@"author"],[_detailDic objectForKey:@"editer"],[_detailDic objectForKey:@"jy"]];
    
    
    [[AFAPPRequestManager manager] GET:@"api/image-center" parameters:@{@"method":@"getNeourImgsByID",@"nid":self.infoId} success:^(NSURLSessionDataTask *task, id responseObject) {
        _imgArray = responseObject;
        for (int i = 0; i<3; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(12+(12+90)*i, 114-(height-size.height), 90, 90);
            if (_imgArray.count >i) {
                NSDictionary *dic = [_imgArray objectAtIndex:i];
                NSString *url = [@"http://www.imagingcenter.com.cn" stringByAppendingString:[dic objectForKey:@"pic"]];
                [[SDWebImageManager sharedManager]downloadWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                    [btn setBackgroundImage:image forState:UIControlStateNormal];
                }];
            }
            btn.tag = 500+i;
            [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:btn];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
   
    
    self.tableView.tableHeaderView = headerView;
    
    //    headerView.layer.borderWidth = 1;
}

- (void)buttonClicked:(UIButton *)sender
{
    MedicalImageAlbumViewController *albumVC = [[MedicalImageAlbumViewController alloc]initWithArray:_imgArray andStartIndex:sender.tag-500];
    [self.navigationController pushViewController:albumVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"术语";
            break;
        case 1:
            return @"影像学";
            break;
        case 2:
            return @"临床特征";
            break;
        default:
            return @"参考文献";
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
        case 2:
            return [[self.htmlItemArray objectAtIndex:section-1] count];
            break;
        default:
            return _referenceArray.count;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MedicalNeuroDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:medicalDetailCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1 || indexPath.section == 2) {
//        cell.webView.tag = indexPath.section*1000+indexPath.row;
//        cell.webView.delegate = self;
        cell.showTitle = YES;
        NSString *key = [[_htmlItemArray objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row];
        cell.htmlStr = [_detailDic objectForKey:key];
        cell.titleLabel.text = [[_cellTitleArray objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row];
    }else if(indexPath.section == 0){
        cell.showTitle = NO;
        cell.htmlStr = [_detailDic objectForKey:@"sy"];
        NSLog(@"%@",NSStringFromCGSize(cell.textView.textContainer.size));
    }else {
        cell.showTitle = NO;
        NSDictionary *dic = [_referenceArray objectAtIndex:indexPath.row];
        cell.htmlStr = [dic objectForKey:@"info"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 || indexPath.section == 1) {
        NSString *key = [[_htmlItemArray objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row];
        NSString *htmlStr = [_detailDic objectForKey:key];
        htmlStr = [htmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        CGRect rect = [self rectForHtmlString:htmlStr];
        return rect.size.height+40;
    }else if(indexPath.section == 0){
        NSString *string = [_detailDic objectForKey:@"sy"];
        CGRect rect = [self rectForHtmlString:string];
        return rect.size.height;
    }
    else {
        NSDictionary *dic = [_referenceArray objectAtIndex:indexPath.row];
        NSString *string = [dic objectForKey:@"info"];
        CGRect rect = [self rectForHtmlString:string];
        return rect.size.height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, 322, 44)];
    v.layer.borderWidth = 1;
    v.layer.borderColor = [UIColorFromRGB(0xe6e6e6)CGColor];
    v.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
    switch (section) {
        case 0:
            label.text = @"术语";
            break;
        case 1:
            label.text = @"影像学";
            break;
        case 2:
            label.text = @"临床特征";
            break;
        default:
            label.text = @"参考文献";
            break;
    }
    label.textColor = UIColorFromRGB(0x333333);
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:21];
    [v addSubview:label];
    return v;
}

- (CGRect)rectForHtmlString:(NSString *)string
{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGRect rect;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [attributedString setAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, attributedString.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:15];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, attributedString.length)];
    CGFloat width = 290;
    rect = [attributedString boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    rect.size.height += 20;
    return rect;
    // whatever your desired width is
    
}

@end
