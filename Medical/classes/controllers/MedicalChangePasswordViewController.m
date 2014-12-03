//
//  MedicalChangePasswordViewController.m
//  Medical
//
//  Created by zhangnan on 6/25/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalChangePasswordViewController.h"

@implementation MedicalChangePasswordViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"修改密码";
    self.paramsKey = @[@"password",@"password2"];
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
    [self.params setObject:@"yao*qi-123" forKey:@"code"];
    [self.params setObject:[ShareData shareInstance].curUser.uid forKey:@"id"];
    
    [self.params setObject:[ShareData shareInstance].curUser.email forKey:@"email"];
    [self.params setObject:[ShareData shareInstance].curUser.telephone forKey:@"telephone"];
    
    [[AFAPPRequestManager manager]POST:@"user/info" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"]integerValue] == 0) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self showFailAlertWith:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
}
@end
