//
//  MedicalActiveViewController.h
//  Medical
//
//  Created by zhangnan on 6/11/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MedicalRegisterViewController.h"
#import "APIHeader.h"
#import "News.h"
#import "InfoEntryViewCell.h"
#import "MedicalNewsDetailViewController.h"
#import <SDWebImageManager.h>
#import "MedicalTableViewController.h"
#import "CycleScrollView.h"

@interface MedicalActiveViewController : MedicalTableViewController
@property (strong, nonatomic) IBOutlet UIButton *matchButton;
@property (strong, nonatomic) IBOutlet UIButton *studyButton;
@property (strong, nonatomic) IBOutlet UIButton *participateButton;
@property (strong, nonatomic) IBOutlet CycleScrollView *cycleView;

- (IBAction)handleMatchButton:(UIButton *)sender;
- (IBAction)handleStudyButton:(UIButton *)sender;
- (IBAction)handleParticapateButton:(UIButton *)sender;


@end
