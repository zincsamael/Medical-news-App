//
//  MedicalNeuroDetailViewCell.m
//  Sunrise
//
//  Created by zhangnan on 7/15/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalNeuroDetailViewCell.h"
#import "HTMLParser.h"
#import "FDLabelView.h"

@interface MedicalNeuroDetailViewCell()
{
    CGFloat currentY;
}

@end

@implementation MedicalNeuroDetailViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        currentY = 10;
        self.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        [self addSubview:label];
        label.font = [UIFont systemFontOfSize:19];
        label.textColor = UIColorFromRGB(0x333333);
        label.backgroundColor = [UIColor clearColor];
        self.titleLabel = label;
        
        UITextView *textView = [[UITextView alloc] init];
        textView.scrollEnabled = NO;
        textView.editable = NO;
//        textView.font = [UIFont systemFontOfSize:15];
//        textView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:textView];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
//        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
        textView.backgroundColor = [UIColor clearColor];
        self.textView = textView;
        
        self.textView.layoutManager.allowsNonContiguousLayout = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setShowTitle:(BOOL)showTitle
{
    if (showTitle != _showTitle) {
        _showTitle = showTitle;
    }
    self.titleLabel.hidden = !_showTitle;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_showTitle) {
        self.titleLabel.frame = CGRectMake(15, 10, self.frame.size.width-30, 30);
        self.textView.frame= CGRectMake(10, 40, self.frame.size.width-20, self.frame.size.height-40);
        self.textView.textContainer.size = self.textView.frame.size;
    }else {
        self.textView.frame= CGRectMake(10, 0, self.frame.size.width-20, self.frame.size.height);
        self.textView.textContainer.size = self.textView.frame.size;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHtmlStr:(NSString *)htmlStr
{
    if (htmlStr != _htmlStr) {
        _htmlStr = htmlStr;
//        for (UIView *v in self.contentView.subviews) {
//            [v removeFromSuperview];
//        }
//        [self parseHTML:htmlStr];

//        htmlStr = [[NSString alloc]initWithData:[htmlStr dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUnicodeStringEncoding];
//        [_textView setValue:htmlStr forKey:@"contentToHTMLString"];
////
//        return;
        htmlStr = [htmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:17.0];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];

        [attributedString setAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:UIColorFromRGB(0x666666)} range:NSMakeRange(0, attributedString.length)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:15];
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:style
                                 range:NSMakeRange(0, attributedString.length)];
        _textView.attributedText = attributedString;
        self.textView.textContainer.size = self.textView.frame.size;
//        _textView.layer.borderWidth = 1;
//
//        htmlStr = [NSString stringWithFormat:@"<div id='foo'>%@</div>",htmlStr];
//        [self.webView loadHTMLString:htmlStr baseURL:nil];
    }
}

@end
