//
//  MedicalModifyProfileViewController.m
//  Medical
//
//  Created by zhangnan on 6/25/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalModifyProfileViewController.h"
#import "MedicalInputCell.h"

@implementation MedicalModifyProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"修改资料";
    self.paramsKey = @[@"telephone",@"email"];
    
    [self.paramsKey enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *string = [self stringForIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] withPropertyArray:self.paramsKey];
        [self.params setObject:string forKey:[self.paramsKey objectAtIndex:idx]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MedicalInputCell *cell = (MedicalInputCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.inputField.text = [super stringForIndexPath:indexPath withPropertyArray:self.paramsKey];
        return cell;
    }else return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
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
    
    [self.params setObject:[ShareData shareInstance].curUser.password forKey:@"password"];
    [self.params setObject:[ShareData shareInstance].curUser.password forKey:@"password2"];
    [[AFAPPRequestManager manager]POST:@"user/info" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"]integerValue] == 0) {
            [ShareData shareInstance].curUser.email = [self.params objectForKey:@"email"];
            [ShareData shareInstance].curUser.telephone = [self.params objectForKey:@"telephone"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"资料修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else {
            [self showFailAlertWith:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
