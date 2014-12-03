//
//  MedicalImageAlbumViewController.h
//  Sunrise
//
//  Created by zhangnan on 7/15/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicalPictureModelController.h"

@interface MedicalImageAlbumViewController : UIViewController<UIPageViewControllerDelegate>
@property (nonatomic, strong) NSArray *imgArray;
- (id)initWithArray:(NSArray *)array andStartIndex:(NSInteger)index;
@end
