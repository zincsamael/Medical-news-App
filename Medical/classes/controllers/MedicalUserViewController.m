//
//  MedicalUserViewController.m
//  Medical
//
//  Created by zhangnan on 6/11/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalUserViewController.h"
#import "MedicalInputCell.h"
#import "User.h"
#import "MedicalModifyProfileViewController.h"
#import "MedicalChangePasswordViewController.h"

@interface MedicalUserViewController ()
{
    NSDictionary *dic;
}
@property (nonatomic, strong) NSArray *propertyArray;
@end

@implementation MedicalUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"inputDataStruct" ofType:@"plist"]];
    self.formFormat = [dic objectForKey:@"profile"];
    self.propertyArray = @[@"username",@"name",@"area",@"hospital",@"person_score",@"person_top",@"person_answer_times"];
    
    if ([ShareData shareInstance].curUser.uid) {
        [self loadUserInfo];
    }
    
}


- (void)loadUserInfo
{
    [[AFAPPRequestManager manager]GET:@"user/info" parameters:@{@"id":[ShareData shareInstance].curUser.uid,@"code":@"yao*qi-123",@"platform":@"1"} success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"]integerValue] == 0) {
            [ShareData shareInstance].curUser = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject[@"data"] error:nil];
            [ShareData shareInstance].curUser.password = [ShareData shareInstance].password;
            
            [self.tableView reloadData];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"inputDataStruct" ofType:@"plist"]];
        self.formFormat = [dic objectForKey:@"profile"];
    }
    return self;
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



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 20;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subArr = [self.formFormat objectAtIndex:indexPath.section];
    NSDictionary *info = nil;
    NSString *title = nil;
    if (subArr) {
        info = [subArr objectAtIndex:indexPath.row];
        title = [info objectForKey:@"title"];
    }
    else return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
    if (indexPath.section ==0 && [info objectForKey:@"inputType"])
    {
        NSString *string = [self stringForIndexPath:indexPath withPropertyArray:self.propertyArray];
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 2000) lineBreakMode:UILineBreakModeWordWrap];
        return MAX(size.height +20, 43);
    }
    else return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 0;
    }
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    v.backgroundColor = [UIColor clearColor];
    return v;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        MedicalInputCell *inputCell = (MedicalInputCell *)cell;
        inputCell.inputField.enabled = NO;
        NSString *string;
        string = [self stringForIndexPath:indexPath withPropertyArray:self.propertyArray];
        
        NSString *key = [self.propertyArray objectAtIndex:indexPath.row];
        if ([key isEqualToString:@"hospital_top"]||[key isEqualToString:@"person_top"]) {
            if ([string isEqualToString:@"0"]) {
                string = @"暂无";
            }
        }
        
        inputCell.inputField.text = string;
        if ([self.formFormat[indexPath.section][indexPath.row] objectForKey:@"inputType"]) {
            inputCell.inputView.text = string;
            inputCell.inputView.editable = NO;
        }else {
            inputCell.inputField.text = string;
        }
        
        
        if([key isEqualToString:@"hospital_score"])
        {
            if ([string integerValue]==0) {
                inputCell.inputField.text = string;
            }else {
                inputCell.inputField.text = [NSString stringWithFormat:@"%@分",string];
            }
        }
        
        if([key isEqualToString:@"person_score"])
        {
            inputCell.inputField.text = [NSString stringWithFormat:@"%@分,用时%@",string,[ShareData shareInstance].curUser.person_time];
        }
        if ([key isEqualToString:@"person_answer_times"]) {
            inputCell.inputField.text = [NSString stringWithFormat:@"剩余%@次",string];
        }
        
        return inputCell;
    }else {
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 2) {
        return;
    }
    switch (indexPath.row) {
        case 0:
        {
            MedicalModifyProfileViewController *modifyVC = [[MedicalModifyProfileViewController alloc]init];
            modifyVC.formFormat = [dic objectForKey:@"modify"];
            [self.navigationController pushViewController:modifyVC animated:YES];
            
        }
            break;
        case 1:
        {
            MedicalChangePasswordViewController *modifyVC = [[MedicalChangePasswordViewController alloc]init];
            modifyVC.formFormat = [dic objectForKey:@"change_password"];
            [self.navigationController pushViewController:modifyVC animated:YES];
        }
            break;
        default:
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationLogout object:nil];
        }
            break;
    }
}

@end
