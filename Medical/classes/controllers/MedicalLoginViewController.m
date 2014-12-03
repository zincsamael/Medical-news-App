//
//  MedicalLoginViewController.m
//  Medical
//
//  Created by zhangnan on 6/17/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalLoginViewController.h"
#import "MedicalRegisterViewController.h"
#import "MedicalActivateViewController.h"
#import "MedicalForgetPasswordViewController.h"

@interface MedicalLoginViewController ()
@property (nonatomic, strong) NSDictionary *dic;
@end

@implementation MedicalLoginViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.dic =[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"inputDataStruct" ofType:@"plist"]];
        self.formFormat = [_dic objectForKey:@"login"];
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
    self.title = @"登录";
    self.paramsKey = @[@"username",@"password"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)buttonDidClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if (![self validateInput]) {
        return;
    }
    
    [self.params setObject:@"1" forKey:@"platform"];
    [[AFAPPRequestManager manager]POST:@"user/login" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"]integerValue] == 0) {
            
            [ShareData shareInstance].curUser.uid = responseObject[@"id"];
            [ShareData shareInstance].password = [self.params objectForKey:@"password"];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }else {
            [self showFailAlertWith:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
            {
                MedicalActivateViewController *activate = [[MedicalActivateViewController alloc]initWithStyle:UITableViewStylePlain];
                activate.formFormat = [_dic objectForKey:@"activate"];
                [self.navigationController pushViewController:activate animated:YES];
            }
                break;
            case 1:
            {
                MedicalRegisterViewController *registerVC = [[MedicalRegisterViewController alloc]init];
                registerVC.titleArray = @[@"账号设置",@"填写信息",@"注册成功"];
                [self.navigationController pushViewController:registerVC animated:YES];
            }
                break;
            default:
            {
                MedicalForgetPasswordViewController *forget = [[MedicalForgetPasswordViewController alloc]initWithStyle:UITableViewStylePlain];
                forget.formFormat = [_dic objectForKey:@"find_password"];
                [self.navigationController pushViewController:forget animated:YES];
            }
                break;
        }
    }
    
}

@end
