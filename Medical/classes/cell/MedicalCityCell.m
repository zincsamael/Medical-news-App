//
//  MedicalCityCell.m
//  Sunrise
//
//  Created by zhangnan on 8/30/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalCityCell.h"
@interface MedicalCityCell()
{
    UIView *backView;
}
@end

@implementation MedicalCityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
        backView.backgroundColor = [UIColor whiteColor];
        backView = v;
        backView.layer.borderWidth = 1;
        backView.layer.borderColor = [UIColorFromRGB(0xe6e6e6) CGColor];
        [self.contentView addSubview:v];
        self.backgroundColor = UIColorFromRGB(0xf3f3f3);
        NSArray *arr = [MedicalCityCell cityArray];
        for (int i = 0; i< arr.count; i++) {

            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(14+60*(i%5), 7+26*(i/5), 52, 26);
            [button setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x515151) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button addTarget:self action:@selector(cityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//            button.layer.borderWidth = 1;
            [backView addSubview:button];
        }
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)cityButtonClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(cityDidSelected:)]) {
        [self.delegate cityDidSelected:sender.titleLabel.text];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    backView.frame = CGRectMake(10, -1, 300, self.frame.size.height+1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSArray *)cityArray
{
    return @[@"北京",@"天津",@"上海",@"重庆",@"河北",@"河南",@"云南",@"辽宁",@"黑龙江",@"湖南",@"安徽",@"山东",@"新疆",@"江苏",@"浙江",@"江西",@"湖北",@"广西",@"甘肃",@"山西",@"内蒙古",@"陕西",@"吉林",@"福建",@"贵州",@"广东",@"青海",@"西藏",@"四川",@"宁夏",@"海南",@"台湾",@"香港",@"澳门"];
}
@end
