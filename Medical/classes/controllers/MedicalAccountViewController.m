//
//  MedicalAccountViewController.m
//  Medical
//
//  Created by zhangnan on 6/20/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalAccountViewController.h"

@interface MedicalAccountViewController ()

@end

@implementation MedicalAccountViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.paramsKey = @[@"username",@"password",@"password2",@"email"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)buttonDidClicked:(UIButton *)sender
{
    [super buttonDidClicked:sender];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 30;
    }
    if (section == 0) {
        return 0;
    }
    return 15;
}

@end
