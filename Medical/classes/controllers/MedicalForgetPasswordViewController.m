//
//  MedicalForgetPasswordViewController.m
//  Medical
//
//  Created by zhangnan on 6/21/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalForgetPasswordViewController.h"
#import "MedicalSuccessViewController.h"

@interface MedicalForgetPasswordViewController ()

@end

@implementation MedicalForgetPasswordViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"找回密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *v= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectInset(v.bounds, 10, 0)];
    [v addSubview:label];
    label.text = @"请输入注册时所填写的电子邮箱";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = UIColorFromRGB(0x333333);
    
    self.tableView.tableHeaderView = v;
    self.paramsKey = @[@"email"];
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

- (void)buttonDidClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
    if ([self.params objectForKey:@"email"]) {
        [self.params setObject:@"1" forKey:@"platform"];
        [[AFAPPRequestManager manager] POST:@"user/forget-password" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
            if([responseObject[@"status"]integerValue] == 1)
            {

                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"该邮箱不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }else {
                //成功
                MedicalSuccessViewController *svc=  [[MedicalSuccessViewController alloc]init];
                svc.slogen = @"密码已发送到您得邮箱";
                NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"inputDataStruct" ofType:@"plist"]];
                svc.formFormat = [dic objectForKey:@"success"];
                svc.buttonClickedBlock = ^{
                    [svc.navigationController popToRootViewControllerAnimated:YES];
                };
                [self.navigationController pushViewController:svc animated:YES];
                svc.title = @"找回密码";
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 20;
    
}

@end
