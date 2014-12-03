//
//  MedicalPictureInfoViewController.m
//  Sunrise
//
//  Created by zhangnan on 7/16/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalPictureInfoViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MedicalPictureInfoViewController ()

@end

@implementation MedicalPictureInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 300, 300)];
    NSString *url = [NSString stringWithFormat:@"http://www.imagingcenter.com.cn%@",[_info objectForKey:@"pic"]];
    [[SDWebImageManager sharedManager]downloadWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        imageView.image = image;
    }];
    [self.view addSubview:imageView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 320, 300, self.view.frame.size.height-320)];
    [self.view addSubview:textView];
    textView.scrollEnabled = YES;
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    textView.backgroundColor = [UIColor clearColor];
    NSString *htmlString = [_info objectForKey:@"info"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:17.0];
    [attributedString setAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:UIColorFromRGB(0x666666)} range:NSMakeRange(0, attributedString.length)];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:7];
    [style setParagraphSpacing: 20];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, attributedString.length)];
    textView.attributedText = attributedString;
    textView.textContainer.size = textView.frame.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
