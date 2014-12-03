//
//  MedicalSuccessViewController.m
//  Medical
//
//  Created by zhangnan on 6/20/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalSuccessViewController.h"

@interface MedicalSuccessViewController ()

@end

@implementation MedicalSuccessViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    label.text = self.slogen;
    label.font = [UIFont systemFontOfSize:21];
    label.textColor = UIColorFromRGB(0x333333);
    label.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = label;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void)buttonDidClicked:(UIButton *)sender
{
    [super buttonDidClicked:sender];
}
@end
