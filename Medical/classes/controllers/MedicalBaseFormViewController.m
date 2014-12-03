//
//  MedicalBaseFormViewController.m
//  Medical
//
//  Created by zhangnan on 6/17/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalBaseFormViewController.h"
#import "MedicalInputCell.h"
#import "MedicalButtonCell.h"
#import "MedicalIndicatorCell.h"


static NSString *inputCell = @"inputCell";
static NSString *buttonCell = @"buttonCell";
static NSString *indicatorCell = @"indicatorCell";

@interface MedicalBaseFormViewController ()
@end

@implementation MedicalBaseFormViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.needLoadMoreData = NO;
        self.needPullRefresh = NO;
        _params = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.needLoadMoreData = NO;
        self.needPullRefresh = NO;
        _params = [NSMutableDictionary dictionary];
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
    
    self.tableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    
    [self.tableView registerClass:[MedicalInputCell class] forCellReuseIdentifier:inputCell];
    [self.tableView registerClass:[MedicalButtonCell class] forCellReuseIdentifier:buttonCell];
    [self.tableView registerClass:[MedicalIndicatorCell class] forCellReuseIdentifier:indicatorCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (_formFormat.count) {
        return _formFormat.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *arr = [_formFormat objectAtIndex:section];
    if (arr) {
        return arr.count;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        case 2:
        {
            NSArray *subArr = [_formFormat objectAtIndex:indexPath.section];
            NSDictionary *dic = nil;
            NSString *title = nil;
            if (subArr) {
                dic = [subArr objectAtIndex:indexPath.row];
                title = [dic objectForKey:@"title"];
            }
            if ([dic objectForKey:@"inputType"]) {
                NSString *key = [_paramsKey objectAtIndex:indexPath.row];
                if (key) {
                    NSString *text = [self.params objectForKey:key];
                    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 2000) lineBreakMode:UILineBreakModeWordWrap];
                    
                    return MAX(size.height +20, 43);
                }
                
            }
            
            if (indexPath.row == 0) {
                return 44;
            }
            else {
                return 43;
            }
        }
            break;
        default:
            return 44;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subArr = [_formFormat objectAtIndex:indexPath.section];
    NSDictionary *dic = nil;
    NSString *title = nil;
    if (subArr) {
        dic = [subArr objectAtIndex:indexPath.row];
        title = [dic objectForKey:@"title"];
    }
    switch (indexPath.section) {
        case 0:
        {
            MedicalInputCell *cell = (MedicalInputCell *)[tableView dequeueReusableCellWithIdentifier:inputCell forIndexPath:indexPath];
            
            if (title) {
                cell.titleLabel.text = title;
            }
            if ([dic objectForKey:@"placeholder"]) {
                cell.inputField.placeholder = [dic objectForKey:@"placeholder"];
            }else {
                cell.inputField.placeholder = @"";
            }
            if ([dic objectForKey:@"secret"] && [[dic objectForKey:@"secret"]boolValue]==YES)
            {
                cell.inputField.secureTextEntry = YES;
            }else {
                cell.inputField.secureTextEntry = NO;
            }
            if ([dic objectForKey:@"inputType"]) {
                cell.type = MedicalInputTypeTextView;
                cell.inputView.delegate = self;
            }else {
                cell.type = MedicalInputTypeTextField;
                cell.inputField.delegate = self;
            }
            return cell;
        }
            break;
        case 1:
        {
            MedicalButtonCell *cell = (MedicalButtonCell *)[tableView dequeueReusableCellWithIdentifier:buttonCell forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            if (title) {
                [cell.button setTitle:title forState:UIControlStateNormal];
            }
            [cell.button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        default:
        {
            MedicalIndicatorCell *cell = [tableView dequeueReusableCellWithIdentifier:indicatorCell forIndexPath:indexPath];
            if (title) {
                cell.textLabel.text = title;
            }
            return cell;
        }
            break;
    }
}

- (void)buttonDidClicked:(UIButton *)sender
{
    if (self.buttonClickedBlock) {
        self.buttonClickedBlock();
    }
    
}

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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 30;
    }
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    v.backgroundColor = [UIColor clearColor];
    return v;
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSString *text = textField.text;
    if (text) {
        NSString *key = [_paramsKey objectAtIndex:indexPath.row];
        if (key) {
            [self.params setObject:text forKey:key];
        }
        
    }
}

- (NSString *)stringForIndexPath:(NSIndexPath *)indexPath withPropertyArray:(NSArray *)propertyArray
{
    NSObject *str = [[ShareData shareInstance].curUser.dictionaryValue objectForKey:[propertyArray objectAtIndex:indexPath.row]];
    NSString *string = @"";
    if (!str || (NSNull *)str == [NSNull null]) {
        string = @"";
    }else if ([str isKindOfClass:[NSNumber class]])
    {
        string = [(NSNumber *)str stringValue];
    }else {
        string = (NSString *)str;
    }
    return string;
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITableViewCell *cell = (UITableViewCell *)textView.superview.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSString *text = textView.text;
    if (text) {
        NSString *key = [_paramsKey objectAtIndex:indexPath.row];
        if (key) {
            [self.params setObject:text forKey:key];
        }
    }
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)validateInput
{
    for (NSString *key in _paramsKey) {
        NSString *text = [self.params objectForKey:key];
        
        if ([key isEqualToString:@"username"]) {
            if (![text validateUsername]) {
                [self showAlertWith:@"用户名格式不对"];
                return NO;
            }
        }
        if ([key isEqualToString:@"email"]) {
            if (![text validateEmail]) {
                [self showAlertWith:@"电子邮箱格式不对"];
                return NO;
            }
        }
        if ([key isEqualToString:@"password"]) {
            if (![text validatePassword]) {
                [self showAlertWith:@"密码格式不对"];
                return NO;
            }
        }
        if ([key isEqualToString:@"password2"]) {
            if (![text isEqualToString:[self.params objectForKey:@"password"]]) {
                [self showAlertWith:@"密码输入不一致"];
                return NO;
            }
        }
        if ([key isEqualToString:@"telephone"]) {
            if (![text validatePhoneNumber]) {
                [self showAlertWith:@"手机号格式不对"];
                return NO;
            }
            if (![text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length) {
                [self showAlertWith:@"手机号不能为空"];
                return NO;
            }
        }
        if ([key isEqualToString:@"area"]) {
            if (![self.params objectForKey:@"area"]) {
                [self showAlertWith:@"请选择地区"];
                return NO;
            }
        }
        if ([key isEqualToString:@"name"]) {
            NSString *str = [self.params objectForKey:@"name"];
            if (!str || (str.length == 0)) {
                [self showAlertWith:@"请输入姓名"];
                return NO;
            }
        }
        if ([key isEqualToString:@"hospital"]) {
            NSString *str = [self.params objectForKey:@"hospital"];
            if (!str || (str.length == 0)) {
                [self showAlertWith:@"请输入医院名称"];
                return NO;
            }
        }
    }
    return YES;
}

- (void)showAlertWith:(NSString *)warning
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:warning delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)showFailAlertWith:(id)responseObject
{
    NSString *warning = @"";
    id obj = [responseObject objectForKey:@"msg"];
    if ([obj isKindOfClass:[NSArray class]]) {
        warning = obj[0]?:@"操作失败";
    }else {
        warning = obj?:@"操作失败";
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:warning delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
@end
