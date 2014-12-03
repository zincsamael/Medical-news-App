//
//  MedicalBaseFormViewController.h
//  Medical
//
//  Created by zhangnan on 6/17/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "AFAPPRequestManager.h"
#import "NSString+Regex.h"
#import "MedicalTableViewController.h"


#define kMedicalFormBaseTagTextField    900

typedef void(^ButtonDidClickBlock)();

@interface MedicalBaseFormViewController : MedicalTableViewController<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *formFormat;
@property (nonatomic, copy) ButtonDidClickBlock buttonClickedBlock;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSArray *paramsKey;
- (void)buttonDidClicked:(UIButton *)sender;
- (BOOL)validateInput;
- (void)showFailAlertWith:(id)responseObject;

- (NSString *)stringForIndexPath:(NSIndexPath *)indexPath withPropertyArray:(NSArray *)propertyArray;
@end
