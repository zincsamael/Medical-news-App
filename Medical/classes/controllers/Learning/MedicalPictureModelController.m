//
//  MedicalPictureModelController.m
//  Sunrise
//
//  Created by zhangnan on 7/16/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalPictureModelController.h"


@implementation MedicalPictureModelController


- (id)initWithInfoArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        // Create the data model.

        _imgArray = array;
    }
    return self;
}

- (MedicalPictureInfoViewController *)viewControllerAtIndex:(NSUInteger)index
{
    NSDictionary *dic = [_imgArray objectAtIndex:index];
    MedicalPictureInfoViewController *vc = [[MedicalPictureInfoViewController alloc]init];
    vc.parentViewController.title = [NSString stringWithFormat:@"%lu/%lu",index+1,(unsigned long)_imgArray.count];
    vc.info = dic;
    return vc;
}

- (NSUInteger)indexOfViewController:(MedicalPictureInfoViewController *)viewController
{
    return [_imgArray indexOfObject:viewController.info];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(MedicalPictureInfoViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(MedicalPictureInfoViewController *)viewController];
    if (index == NSNotFound) {
        return [self viewControllerAtIndex:0];;
    }
    
    index++;
    if (index >= [self.imgArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

@end
