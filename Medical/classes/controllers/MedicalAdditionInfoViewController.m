//
//  MedicalAdditionInfoViewController.m
//  Medical
//
//  Created by zhangnan on 6/20/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalAdditionInfoViewController.h"
#import "MedicalInputCell.h"
#import "MedicalCityCell.h"

@interface MedicalAdditionInfoViewController ()
@property (nonatomic, assign) BOOL showedCity;
@property (nonatomic, strong) NSMutableArray *firstSection;
@property (nonatomic, assign) NSInteger defaultEntriesCount;
@end

@implementation MedicalAdditionInfoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _showedCity = NO;
        _defaultEntriesCount = 4;
        self.paramsKey = @[@"name",@"area",@"hospital",@"telephone"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _firstSection = [NSMutableArray arrayWithArray:[self.formFormat objectAtIndex:0]];
    [self.tableView registerClass:[MedicalCityCell class] forCellReuseIdentifier:@"areaCell"];

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

#pragma mark - city select delegate
- (void)cityDidSelected:(NSString *)cityName
{
    if (_firstSection.count != _defaultEntriesCount) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        MedicalInputCell *cell = (MedicalInputCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [self.tableView beginUpdates];
        cell.inputField.text = cityName;
        [self.tableView endUpdates];
        
        [self.params setObject:cityName forKey:@"area"];
        
        _showedCity = !_showedCity;
        
        UIImageView *v = (UIImageView *)[cell.contentView viewWithTag:1500];
        [self.tableView beginUpdates];
        if (_showedCity) {
            [self.view endEditing:YES];
            [_firstSection insertObject:@{@"title":@"area"} atIndex:2];
            [self.formFormat replaceObjectAtIndex:0 withObject:_firstSection];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            v.image = [UIImage imageNamed:@"icon_arrow_up"];
        }else {
            [_firstSection removeObjectAtIndex:2];
            [self.formFormat replaceObjectAtIndex:0 withObject:_firstSection];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
            v.image = [UIImage imageNamed:@"icon_arrow_down"];
        }
        
        [self.tableView endUpdates];
    }
}

#pragma mark - UITableView delegate and datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.firstSection.count != _defaultEntriesCount && indexPath.row == 2) {
            MedicalCityCell *cityCell = [self.tableView dequeueReusableCellWithIdentifier:@"areaCell" forIndexPath:indexPath];
            cityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            cityCell.delegate = self;
            return cityCell;
        }
        MedicalInputCell *cell = (MedicalInputCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
        NSArray *subArr = [self.formFormat objectAtIndex:indexPath.section];
        NSDictionary *dic = nil;
        NSString *title = nil;
        if (subArr) {
            dic = [subArr objectAtIndex:indexPath.row];
            title = [dic objectForKey:@"title"];
        }
        UIView *v = [cell.contentView viewWithTag:1500];
        if (v) {
            [v removeFromSuperview];
        }
        
        if (indexPath.row == 1) {
            cell.inputField.enabled = NO;
            UIImage *img =  (!_showedCity)?[UIImage imageNamed:@"icon_arrow_down"]:[UIImage imageNamed:@"icon_arrow_up"];
            UIImageView *arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
            arrowImg.center = CGPointMake(280, 22);
            arrowImg.image = img;
            arrowImg.tag = 1500;
            [cell.contentView addSubview:arrowImg];
        }else {
            cell.inputField.enabled = YES;
        }
        
        NSString *string = [self stringForIndexPath:indexPath withPropertyArray:@[@"name",@"area",@"hospital",@"telephone"]];
        if ([dic objectForKey:@"inputType"]) {
            cell.inputView.text = string;
        }else {
            cell.inputField.text = string;
        }
        
        return cell;
    }
    else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)buttonDidClicked:(UIButton *)sender
{
    [super buttonDidClicked:sender];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        _showedCity = !_showedCity;

        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *v = (UIImageView *)[cell.contentView viewWithTag:1500];
        [tableView beginUpdates];
        if (_showedCity) {
            [self.view endEditing:YES];
            [_firstSection insertObject:@{@"title":@"area"} atIndex:2];
            [self.formFormat replaceObjectAtIndex:0 withObject:_firstSection];
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            v.image = [UIImage imageNamed:@"icon_arrow_up"];
        }else {
            [_firstSection removeObjectAtIndex:2];
            [self.formFormat replaceObjectAtIndex:0 withObject:_firstSection];
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            v.image = [UIImage imageNamed:@"icon_arrow_down"];
        }
        
        [tableView endUpdates];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return _firstSection.count;
    }
    NSArray *arr = [self.formFormat objectAtIndex:section];
    if (arr) {
        return arr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2 && _firstSection.count != _defaultEntriesCount) {

        return 198;
       
    }else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

@end
