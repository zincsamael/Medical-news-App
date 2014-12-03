//
//  MedicalActivateViewController.m
//  Medical
//
//  Created by zhangnan on 6/21/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalActivateViewController.h"
#import "MedicalRegisterViewController.h"

@interface MedicalActivateViewController ()

@end

@implementation MedicalActivateViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"激活";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.paramsKey = @[@"name_code"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonDidClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self.params setObject:@"1" forKey:@"platform"];
//    [ShareData shareInstance].curUser = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:@{@"id":@"asdf",@"name":@"asdf",@"hospital":@"azxcv"} error:nil];
//    
//    MedicalRegisterViewController *registerVC = [[MedicalRegisterViewController alloc]init];
//    [self.navigationController pushViewController:registerVC animated:YES];
//    registerVC.titleArray = @[@"账号设置",@"信息补充",@"激活成功"];
//    registerVC.type = MedicalRegisterTypeActivate;
//    return;
    [[AFAPPRequestManager manager] POST:@"user/active/" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"]integerValue] == 0) {
            [ShareData shareInstance].curUser = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject error:nil];
            
            MedicalRegisterViewController *registerVC = [[MedicalRegisterViewController alloc]init];
            [self.navigationController pushViewController:registerVC animated:YES];
            registerVC.titleArray = @[@"账号设置",@"信息补充",@"激活成功"];
            registerVC.type = MedicalRegisterTypeActivate;
        }else {
            [self showFailAlertWith:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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

@end
