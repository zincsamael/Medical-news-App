//
//  MedicalPictureModelController.h
//  Sunrise
//
//  Created by zhangnan on 7/16/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MedicalPictureInfoViewController.h"

@interface MedicalPictureModelController : NSObject<UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray *imgArray;
- (id)initWithInfoArray:(NSArray *)array;
- (MedicalPictureInfoViewController *)viewControllerAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfViewController:(MedicalPictureInfoViewController *)viewController;
@end
