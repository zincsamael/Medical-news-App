//
//  MedicalRegisterViewController.m
//  Medical
//
//  Created by zhangnan on 6/19/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalRegisterViewController.h"
#import "MedicalAccountViewController.h"
#import "MedicalAdditionInfoViewController.h"
#import "MedicalSuccessViewController.h"
#import "NSString+Regex.h"

@interface MedicalRegisterViewController ()
{
    
}
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, assign) NSInteger stepIndex;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *arrow1;
@end

@implementation MedicalRegisterViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _stepIndex = 0;
        self.hidesBottomBarWhenPushed = YES;
        _params = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        _stepIndex = 0;
        self.hidesBottomBarWhenPushed = YES;
        _params = [NSMutableDictionary dictionary];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_type == MedicalRegisterTypeActivate) {
        self.title = @"激活";
    }else {
        self.title = @"注册";
    }
    
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
    CGFloat width = 280.0/_titleArray.count;
    for (int i = 0; i<_titleArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20+(width)*i, 10, width, 40)];
        titleLabel.textAlignment = i;
        titleLabel.tag = 100+i;
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = [_titleArray objectAtIndex:i];
        
        titleLabel.textColor = UIColorFromRGB(0x999999);
        if (i== 0) {
            titleLabel.textColor = UIColorFromRGB(0x218de7);
        }
        [self.view addSubview:titleLabel];
    }
    
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(width+5, 10, 20, 40)];
    arrow.image = [UIImage imageNamed:@"icon_arrow_slim_selected"];
    arrow.contentMode = UIViewContentModeCenter;
    [self.view addSubview:arrow];
    
    UIImageView *arrow1 = [[UIImageView alloc]initWithFrame:CGRectMake((width)*2+15, 10, 20, 40)];
    arrow1.image = [UIImage imageNamed:@"icon_arrow_slim"];
    arrow1.contentMode = UIViewContentModeCenter;
    [self.view addSubview:arrow1];
    self.arrow1 = arrow1;
    
    [self customChildViewControllers];
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(10, 58, 300, 1)];
    v.backgroundColor = UIColorFromRGB(0xe6e6e6);
    [self.view addSubview:v];
    v.hidden = YES;
    self.line = v;
}

- (void)customChildViewControllers
{
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"inputDataStruct" ofType:@"plist"]];
    MedicalAccountViewController *accountVC =[[MedicalAccountViewController alloc]initWithStyle:UITableViewStylePlain];
    accountVC.formFormat = [dic objectForKey:@"account"];
    CGRect rect = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-40);
    accountVC.view.frame = rect;
    __weak MedicalAccountViewController *weakAccount = accountVC;
    accountVC.buttonClickedBlock = ^{
        [weakAccount.view endEditing:YES];
        [weakAccount.params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [_params setObject:obj forKey:key];
        }];
        
        if (![weakAccount validateInput]) {
            return;
        }
        [[AFAPPRequestManager manager]POST:@"user/username/" parameters:@{@"username":[_params objectForKey:@"username"],@"platform":@"1",@"email":[_params objectForKey:@"email"]} success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"status"] integerValue] == 0) {
                [self moveToNextStep];
            }else {
                [weakAccount showFailAlertWith:responseObject];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    };
    [self.view addSubview:accountVC.view];
    [self addChildViewController:accountVC];
    //    [accountVC didMoveToParentViewController:self];
    
    MedicalAdditionInfoViewController *additionVC =[[MedicalAdditionInfoViewController alloc]initWithStyle:UITableViewStylePlain];
    additionVC.formFormat = [[dic objectForKey:@"addition_info"]mutableCopy];
    
    __weak MedicalAdditionInfoViewController *weakAddition = additionVC;
    additionVC.buttonClickedBlock = ^{
        
        [weakAddition.view endEditing:YES];
        [weakAddition.params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [_params setObject:obj forKey:key];
        }];
        
        if (![weakAddition validateInput]) {
            return;
        }
        
        [_params setObject:@"1" forKeyedSubscript:@"platform"];
        
        
        [[AFAPPRequestManager manager] POST:@"user/register" parameters:_params success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *uid = [[responseObject objectForKey:@"id"] stringValue];
            if ([responseObject[@"status"]integerValue]==0) {
                [ShareData shareInstance].curUser = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:_params error:nil];
                [ShareData shareInstance].curUser.uid = uid;
                [self moveToNextStep];
                //                [ShareData shareInstance].curUser.uid = uid;
            }else
            {
                NSString *warning = @"";
                id obj = [responseObject objectForKey:@"msg"];
                if ([obj isKindOfClass:[NSArray class]]) {
                    warning = obj[0]?:@"操作失败";
                }else {
                    warning = warning?:@"操作失败";
                }
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:warning delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    };
    [self addChildViewController:additionVC];
    if (self.type == MedicalRegisterTypeActivate) {
        [additionVC.paramsKey enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *string = [additionVC stringForIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] withPropertyArray:additionVC.paramsKey];
            [additionVC.params setObject:string forKey:[additionVC.paramsKey objectAtIndex:idx]];
        }];
    }
    
    MedicalSuccessViewController *successVC =[[MedicalSuccessViewController alloc]initWithStyle:UITableViewStylePlain];
    successVC.formFormat = [dic objectForKey:@"success"];
    if (self.type == MedicalRegisterTypeRegister) {
        successVC.slogen = @"恭喜您注册成功";
    }
    else {
        successVC.slogen = @"恭喜您激活成功";
    }
    successVC.buttonClickedBlock = ^{
        [self moveToNextStep];
    };
    [self addChildViewController:successVC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)moveToNextStep
{
    if (_stepIndex>=_titleArray.count-1) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        return;
    }
    
    if (_stepIndex == _titleArray.count-2) {
        [self.navigationItem setHidesBackButton:YES];
    }
    MedicalBaseFormViewController *curVC = (MedicalBaseFormViewController *)[[self childViewControllers] objectAtIndex:_stepIndex];
    MedicalBaseFormViewController *nextVC = (MedicalBaseFormViewController *)[[self childViewControllers] objectAtIndex:_stepIndex+1];
    nextVC.view.frame = CGRectOffset(curVC.view.frame, curVC.view.frame.size.width, 0);
    
    _stepIndex++;
    UILabel *l = (UILabel *)[self.view viewWithTag:100+_stepIndex];
    l.textColor = UIColorFromRGB(0x218de7);
    
    [self transitionFromViewController:curVC toViewController:nextVC duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect rect = curVC.view.frame;
        
        nextVC.view.frame = rect;
        rect.origin.x -= rect.size.width;
        curVC.view.frame = rect;
        
    } completion:^(BOOL finished) {
        [nextVC didMoveToParentViewController:self];
        
        if (_stepIndex == 2) {
            self.line.hidden = NO;
            self.arrow1.image = [UIImage imageNamed:@"icon_arrow_slim_selected"];
        }
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
