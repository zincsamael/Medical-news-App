//
//  MedicalParticipateViewController.m
//  Medical
//
//  Created by zhangnan on 6/11/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalParticipateViewController.h"
#import "MedicalAnswerCell.h"
#import "MedicalButtonCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+MD5.h"
#import "RTLabel.h"
#define kLeftCount 90

@interface MedicalParticipateViewController ()
{
    NSTimer *timer;
    NSInteger timeLeft;
}
@property (nonatomic, assign) NSInteger step;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger curScore;
@property (nonatomic, assign) NSInteger totalTime;
@end

@implementation MedicalParticipateViewController

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
    timeLeft = kLeftCount;
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"inputDataStruct" ofType:@"plist"]];
    self.formFormat = [dic objectForKey:@"participate"];
    _step = 0;
    _score = 0;
    _totalTime = 0;
    
    [self.tableView registerClass:[MedicalAnswerCell class] forCellReuseIdentifier:@"MedicalAnswerCell"];
    
    [self setHeader];
//    [self loadFinishPage];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonDidClicked:(UIButton *)sender
{
    if (_step>=_entries.count) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        return;
    }
    if (_step>=0 && _step < _entries.count) {
        if (!self.tableView.indexPathForSelectedRow) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您尚未选中任何选项" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    _score += _curScore;
    _step ++;
    
    _totalTime += (kLeftCount-timeLeft);
    
    if (_step >= (NSInteger)_entries.count) {
        [self loadFinishPage];
        [timer invalidate];
        timer = nil;
        return;
    }
    timeLeft = kLeftCount;
    [self setHeader];
    [self.tableView reloadData];
    if (_step >= 0) {
        [timer invalidate];
        timer = nil;
        NSString *title = [NSString stringWithFormat:@"进入下一题（%d秒）",timeLeft];
        [sender setTitle:title forState:UIControlStateNormal];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(questionTimeTick:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

- (void)loadFinishPage
{
//    http://114.215.176.211/join/question
    
    NSArray *arr =[[NSBundle mainBundle]loadNibNamed:@"answerSheet" owner:self options:nil];
    
    UIView *v = [arr objectAtIndex:0];
    
    CGFloat off_y = 110;
    RTLabel *label1 = [[RTLabel alloc]initWithFrame:CGRectMake(0, off_y, v.frame.size.width, 40)];
    [label1 setParagraphReplacement:@""];
    [label1 setTextAlignment:RTTextAlignmentCenter];
    label1.text =[NSString stringWithFormat:@"<font size=15 color='#6f6f6f'>本次成绩为 </font> <font size=15 color='#ff9c00'>%d分</font> ",_score];
    [v addSubview:label1];
    
    
    RTLabel *label2 = [[RTLabel alloc]initWithFrame:CGRectMake(0, off_y+40, v.frame.size.width, 40)];
    [label2 setParagraphReplacement:@""];
    [label2 setTextAlignment:RTTextAlignmentCenter];
    label2.text =[NSString stringWithFormat:@"<font size=15 color='#6f6f6f'>答题用时 </font> <font size=15 color='#ff9c00'>%d分%d秒</font> ",_totalTime/60,_totalTime%60];
    [v addSubview:label2];
    
    
    RTLabel *label3 = [[RTLabel alloc]initWithFrame:CGRectMake(0, off_y+80, v.frame.size.width, 40)];
    [label3 setParagraphReplacement:@""];
    [label3 setTextAlignment:RTTextAlignmentCenter];
    label3.text =[NSString stringWithFormat:@"<font size=15 color='#6f6f6f'>您还有 </font> <font size=15 color='#ff9c00'>%d次 </font><font size=15 color='#6f6f6f'>答题机会 </font> ",1];
    [v addSubview:label3];
    
    self.tableView.tableHeaderView = v;
    [self.tableView reloadData];
    
    [[AFAPPRequestManager manager]POST:@"join/question" parameters:@{@"platform":@"1",@"user_id":[ShareData shareInstance].curUser.uid,@"score":@(_score),@"time":@(_totalTime)} success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)setHeader
{
    timeLeft = kLeftCount;
    
    [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(questionTimeTick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    NSDictionary *dic = [_entries objectAtIndex:_step];
    NSString *question = [NSString stringWithFormat:@"%d.%@", _step+1,dic[@"question"]];
    CGFloat height = [question sizeWithFont:[UIFont systemFontOfSize:21] constrainedToSize:CGSizeMake(290, 1000) lineBreakMode:NSLineBreakByWordWrapping].height+30;
    NSString *url = [dic objectForKey:@"img"];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, height+(url.length?310:0))];
    v.backgroundColor = UIColorFromRGB(0xe5e5e5);
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 290, height)];
    titleLabel.font = [UIFont systemFontOfSize:21];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.text = question;
    titleLabel.textColor = UIColorFromRGB(0x333333);
    [v addSubview:titleLabel];
    
    
    if (url.length) {
        UIImageView *image= [[UIImageView alloc]initWithFrame:CGRectMake(10, height, 300, 300)];
        image.contentMode = UIViewContentModeScaleAspectFit;
        [image setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        [v addSubview:image];
        
    }
    
    self.tableView.tableHeaderView = v;
}

- (void)questionTimeTick:(NSTimer *)_timer
{
    timeLeft--;
    MedicalButtonCell *cell = (MedicalButtonCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    if (timeLeft<0) {
        [timer invalidate];
        timer = nil;
        timeLeft = kLeftCount;
        [self buttonDidClicked:cell.button];
    }else{
        NSString *title = [NSString stringWithFormat:@"进入下一题（%d秒）",timeLeft];
        UIButton *sender = cell.button;
        [sender setTitle:title forState:UIControlStateNormal];
    }
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

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_step>-1 && indexPath.section == 0) {
        
        NSString *md5Answer = [[NSString stringWithFormat:@"tianpu%d",indexPath.row] MD5];
        NSDictionary *dic = [_entries objectAtIndex:_step];

        if ([md5Answer isEqualToString:[dic objectForKey:@"answer"]]) {
            _curScore = 4;
        }else {
            _curScore = 0;
        }
        
//         MedicalButtonCell *cell = (MedicalButtonCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//        [self buttonDidClicked:cell.button];
        
    }else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (_step >= _entries.count) {
//        return 2;
//    }else {
//        return [super numberOfSectionsInTableView:tableView];
//    }
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_step == -1) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else if (_step >= (NSInteger)_entries.count){
        if (section == 0) {
            return 0;
        }
        return 1;
    }
    else {
        if (section == 0) {
            if (!_entries.count) {
                return 0;
            }
            NSDictionary *dic = [_entries objectAtIndex:_step];
            __block NSInteger count = 0;
            [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([key hasPrefix:@"option"]) {
                    if (obj && ((NSString *)obj).length) {
                        count++;
                    }
                }
            }];
            return count;
        }
        else {
           return [super tableView:tableView numberOfRowsInSection:section]; 
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_step >= _entries.count) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }else {
        if (indexPath.section == 0) {
            NSDictionary *dic = [_entries objectAtIndex:_step];
            
            NSString *str = [dic objectForKey:[NSString stringWithFormat:@"option%d",indexPath.row]];
            
            CGFloat height = [str sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(320-50-10, 1000) lineBreakMode:NSLineBreakByWordWrapping].height ;
            return height +30;
        }
        else {
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_step >= _entries.count) {
        if (indexPath.section == 1) {
            MedicalButtonCell *cell = (MedicalButtonCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
            [cell.button setTitle:@"返回首页" forState:UIControlStateNormal];
            return cell;
        }
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else {
        switch (indexPath.section) {
            case 0:
            {
                MedicalAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MedicalAnswerCell" forIndexPath:indexPath];
                NSDictionary *dic = [_entries objectAtIndex:_step];
                cell.titleLabel.text = [dic objectForKey:[NSString stringWithFormat:@"option%d",indexPath.row]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            case 1:
            {
                MedicalButtonCell *cell = (MedicalButtonCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
                NSString *title = [NSString stringWithFormat:@"进入下一题（%d秒）",90];
                [cell.button setTitle:title forState:UIControlStateNormal];
                return cell;
            }
            default:
                return [super tableView:tableView cellForRowAtIndexPath:indexPath];
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_step >-1) {
        if (section == 1) {
            return 15;
        }
    }
    return 0;
}



@end
