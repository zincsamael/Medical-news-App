//
//  MedicalMatchRuleViewController.m
//  Sunrise
//
//  Created by zhangnan on 7/1/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalMatchRuleViewController.h"
#import "MedicalParticipateViewController.h"

@interface MedicalMatchRuleViewController ()

@end

@implementation MedicalMatchRuleViewController

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
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"inputDataStruct" ofType:@"plist"]];
    self.formFormat = [dic objectForKey:@"participate"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *nav = [segue destinationViewController];
    MedicalParticipateViewController *vc = (MedicalParticipateViewController *)nav.topViewController;
    vc.entries = _entries;
}


- (void)buttonDidClicked:(UIButton *)sender
{
    [[AFAPPRequestManager manager] GET:@"join/question" parameters:@{@"platform":@"1",@"user_id":[ShareData shareInstance].curUser.uid} success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"]integerValue]==1) {
            [self showFailAlertWith:responseObject];
            return;
        }else {
            NSArray *arr = [responseObject objectForKey:@"question"];
            if (arr && arr.count) {
                
                _entries = [NSMutableArray arrayWithArray:arr];
//                [self performSegueWithIdentifier:@"presentAnswerSheet" sender:nil];
//                UIStoryboardSegue *segue = [UIStoryboard ]
                MedicalParticipateViewController *pVC = [[MedicalParticipateViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:pVC];
                nav.navigationBar.translucent = NO;
                nav.navigationBar.barTintColor = UIColorFromRGB(0x218DF1);
                nav.navigationBar.tintColor = [UIColor whiteColor];
                pVC.title = @"我要参赛";
                pVC.entries = _entries;
                [self presentViewController:nav animated:YES completion:^{
                    self.tabBarController.selectedIndex = 0;
                }];
                
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


@end
