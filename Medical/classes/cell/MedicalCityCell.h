//
//  MedicalCityCell.h
//  Sunrise
//
//  Created by zhangnan on 8/30/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MedicalCityDidSelectedDelegate <NSObject>

- (void)cityDidSelected:(NSString *)cityName;

@end

@interface MedicalCityCell : UITableViewCell
@property (nonatomic, assign) id<MedicalCityDidSelectedDelegate> delegate;
@end
