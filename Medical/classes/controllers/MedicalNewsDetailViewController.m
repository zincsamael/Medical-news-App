//
//  MedicalNewsDetailViewController.m
//  Medical
//
//  Created by zhangnan on 6/24/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalNewsDetailViewController.h"
#import "HTMLParser.h"
#import "FDLabelView.h"


@interface MedicalNewsDetailViewController()
{
    CGFloat currentY;
    UIScrollView *mScrollView;
    NSString *HTMLStr;
    UIView *footerView;
    UIView *headerView;
}

@property (nonatomic, strong) UITextView *textView;

@end

@implementation MedicalNewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.needLoadMoreData = NO;
        self.needPullRefresh = NO;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.needLoadMoreData = NO;
        self.needPullRefresh = NO;
    }
    return self;
}

- (void)setupHeaderView
{
    self.title = @"赛讯详情";
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 104)];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 103, 300, 1)];
    line.backgroundColor = UIColorFromRGB(0xe6e6e6);
    [headerView addSubview:line];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 80)];
    label.font = [UIFont systemFontOfSize:21];
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = _news.title;
    label.textColor = UIColorFromRGB(0x333333);
    [headerView addSubview:label];
    
    UILabel *_createTimeLabel, *_readCountLabel;
    _createTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 190, 20)];
    _createTimeLabel.font = [UIFont systemFontOfSize:12];
//    _createTimeLabel.layer.borderWidth = 1;
    _createTimeLabel.textColor = UIColorFromRGB(0x999999);
    [headerView addSubview:_createTimeLabel];
    
    _readCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 70, 100, 20)];
    _readCountLabel.font = [UIFont systemFontOfSize:12];
//        _readCountLabel.layer.borderWidth = 1;
    _readCountLabel.textColor = UIColorFromRGB(0x999999);
    [headerView addSubview:_readCountLabel];
    
    _createTimeLabel.text = [NSString stringWithFormat:@"发布时间：%@",_news.created_at];
    _readCountLabel.text = [NSString stringWithFormat:@"阅读量：%d",_news.browse_times];
    
    self.tableView.tableHeaderView = headerView;
    
//    headerView.layer.borderWidth = 1;
}

- (void)setFooterHeight
{
    CGRect rect = footerView.frame;
    rect.size.height = MAX(rect.size.height, currentY);
    footerView.frame = rect;
    self.tableView.tableFooterView = footerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    currentY = 20;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
    footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    self.tableView.tableFooterView = footerView;
    if (_news.title.length) {
        [self setupHeaderView];
    }
    

    
    [[AFAPPRequestManager manager]GET:@"api/article" parameters:@{@"id":_news.newsId} success:^(NSURLSessionDataTask *task, id responseObject){
        if (responseObject[@"content"]) {
            if (!_news.title.length) {
                _news = [MTLJSONAdapter modelOfClass:[News class] fromJSONDictionary:responseObject error:nil];
                [self setupHeaderView];
            }
            
            HTMLStr = responseObject[@"content"];
//            [self parseHTML];
            [self parseHTMLWithWebView];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


- (void)parseHTMLWithWebView
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, footerView.frame.size.height)];
    webView.delegate = self;
    webView.backgroundColor = [UIColor clearColor];
    webView.scrollView.scrollEnabled = NO;
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    NSString *webviewText = @"<style>body{margin:10;background-color:#f6f6f6;font:17px/27px Helvetica;} p {color:#666666} span {color:#666666}</style>";
    HTMLStr = [HTMLStr stringByReplacingOccurrencesOfString:@"src=\"" withString:@"src=\"http://114.215.176.211"];
    NSString *htmlString = [webviewText stringByAppendingFormat:@"<body>%@</body>", HTMLStr];
    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.imagingcenter.com.cn/"]];
    [footerView addSubview:webView];
    footerView.frame = CGRectMake(0, 0, 320, 500);
    self.tableView.tableFooterView = footerView;
    
    
    
    
//    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize='17.0px';document.body.style.color='blue';",fontSize,fontColor];
//    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.fontSize='20.0px';document.body.style.color='blue';"];
    
//    NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
//    
//    NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
//    "if (mySheet.addRule) {"
//    "mySheet.addRule(selector, newRule);"                               // For Internet Explorer
//    "} else {"
//    "ruleIndex = mySheet.cssRules.length;"
//    "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
//    "}"
//    "}";
//    
//    NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
//    NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p, span', 'text-align: justify;')"];
//    NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", 170];
//    NSString *setHighlightColorRule = [NSString stringWithFormat:@"addCSSRule('highlight', 'background-color: yellow;')"];
//    
//    // this is what change the text style
//    
//    NSString *insertRule3 = [NSString stringWithFormat:@"addCSSRule('html, body, div, p, span, a', 'font-family: Helvetica;')"];
//    NSString *changeColor = [NSString stringWithFormat:@"addCSSRule('html, body, div, p, span, a', 'color: #666666;')"];
//    
//    [webView stringByEvaluatingJavaScriptFromString:varMySheet];
//    
//    [webView stringByEvaluatingJavaScriptFromString:addCSSRule];
//    
//    [webView stringByEvaluatingJavaScriptFromString:insertRule1];
//    
//    [webView stringByEvaluatingJavaScriptFromString:insertRule2];
//    
//    [webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
//    
//    [webView stringByEvaluatingJavaScriptFromString:setHighlightColorRule];
//    [webView stringByEvaluatingJavaScriptFromString:insertRule3];
//    [webView stringByEvaluatingJavaScriptFromString:changeColor];
    
    

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    

//    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize='17.0px';document.body.style.color='blue';",fontSize,fontColor];
//    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.fontSize='20.0px';document.body.style.color='blue';"];

    NSString *varMySheet = @"var mySheet = document.styleSheets[0];";

    NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
    "if (mySheet.addRule) {"
    "mySheet.addRule(selector, newRule);"                               // For Internet Explorer
    "} else {"
    "ruleIndex = mySheet.cssRules.length;"
    "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
    "}"
    "}";

    NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
    NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p, span', 'text-align: justify;')"];
    NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", 170];
    NSString *setHighlightColorRule = [NSString stringWithFormat:@"addCSSRule('highlight', 'background-color: yellow;')"];

    // this is what change the text style

    NSString *maxWidth = @"addCSSRule('img','max-width: 300px;')";
    NSString *insertRule3 = [NSString stringWithFormat:@"addCSSRule('html, body, div, p, span, a', 'font-family: Helvetica;')"];
    NSString *changeColor = [NSString stringWithFormat:@"addCSSRule('html, body, div, p, span, a', 'color: #666666;')"];

    [webView stringByEvaluatingJavaScriptFromString:varMySheet];

    [webView stringByEvaluatingJavaScriptFromString:addCSSRule];
    [webView stringByEvaluatingJavaScriptFromString:maxWidth];
    
    const CGFloat defaultWebViewHeight = 22.0;
    //reset webview size
    CGRect originalFrame = webView.frame;
    webView.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, 320, defaultWebViewHeight);
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    if (actualSize.height <= defaultWebViewHeight) {
        actualSize.height = defaultWebViewHeight;
    }
    CGRect webViewFrame = footerView.frame;
    webViewFrame.size.height = actualSize.height;
    
    webView.frame = CGRectMake(0, 0, webViewFrame.size.width, webViewFrame.size.height);
    footerView.frame = webViewFrame;
    
    self.tableView.tableFooterView = footerView;
}

- (void)parseNodes:(NSArray *)inputNodes {
    for (HTMLNode *node in inputNodes) {
        
        if (node.nodetype == HTMLIFrame) {
            [self addVideoPlayer:[node getAttributeNamed:@"src"]];
        }
        
        NSArray *childNodes = [node children];
        if (childNodes.count > 0) {
            if (childNodes.count == 1) {
                HTMLNode *theNode = [childNodes objectAtIndex:0];
                if (theNode.nodetype == HTMLImageNode) {
                    [self addSubImageView:[theNode getAttributeNamed:@"src"]];
                }
//                if (theNode.nodetype == HTMLStrongNode) {
//                    [self addSubStrongText:theNode.contents];
//                }
//                if (theNode.nodetype == HTMLTextNode) {
//                    [self addSubText:theNode.rawContents];
//                }
//                if (theNode.nodetype == HTMLLiNode) {
//                    [self addSubText:theNode.rawContents];
//                }
//                if (theNode.nodetype == HTMLUlNode) {
//                    [self addSubText:theNode.rawContents];
//                }
            }else{
                for (HTMLNode *node1 in childNodes)
                    [self parseNodes:node1.children];
            }
        }
    }
}

- (void)parseHTML {
//    NSString *readmePath = [[NSBundle mainBundle] pathForResource:@"iOS6" ofType:@"html"];
//    NSString *html = [NSString stringWithContentsOfFile:readmePath encoding:NSUTF8StringEncoding error:NULL];
    
//    NSString *html = HTMLStr;
//    html = [html stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
//
    NSString *htmlStr = HTMLStr;
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:HTMLStr error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }

    HTMLNode *bodyNode = [parser body];
    NSArray *inputNodes = [bodyNode children];
    
    [self parseNodes:inputNodes];
    
    
    htmlStr = [htmlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:17.0];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    [attributedString setAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:UIColorFromRGB(0x666666)} range:NSMakeRange(0, attributedString.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:7];
    [style setParagraphSpacing: 20];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, attributedString.length)];
    
    CGFloat width = 280;
    CGRect rect;
    rect = [attributedString boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];

//    rect.size.height -;
    rect.size.height = ceilf(rect.size.height);
//    rect.size.width = ceilf(rect.size.width);
    
    CGRect footRect = footerView.frame;
    
    CGSize size = attributedString.size;
    

    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, footRect.size.height-rect.size.height, 320, rect.size.height)];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _textView.editable = NO;
    _textView.layoutManager.allowsNonContiguousLayout = YES;
//    _textView.layer.borderWidth = 1;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.textContainerInset = UIEdgeInsetsMake(15, 10, 0, 10);
    _textView.attributedText = attributedString;
    _textView.scrollEnabled = NO;
    _textView.textContainer.size = rect.size;

    [footerView addSubview:_textView];
    
    footRect.size.height += rect.size.height-200;
    footerView.frame = footRect;
    self.tableView.tableFooterView = footerView;
}

- (void)addSubImageView:(NSString *)imageURL {
//    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    
    static CGFloat y = 20;
    __weak UIImageView *iv = imageView;
    [imageView setImageWithURL:[NSURL URLWithString:[AFAppDotNetAPIBaseURLString stringByAppendingString:imageURL]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        CGRect footRect = footerView.frame;
        CGFloat height = (self.view.frame.size.width-30)/image.size.width * image.size.height;
        y += 20+height;
        CGRect rect = CGRectMake(15, 20+ y, self.view.frame.size.width-30, height);
        iv.frame = rect;
//        for (FDLabelView *v in footerView.subviews) {
//            if (![v isKindOfClass:[FDLabelView class]]) {
//                continue;
//            }
//            CGRect r = v.frame;
//            r.origin.y += height+10;
//            v.frame = r;
//        }
        
        footRect.size.height += (rect.size.height+rect.origin.y);
        footerView.frame = footRect;
        self.tableView.tableFooterView = footerView;
    }];
    
    [footerView addSubview:imageView];
}

//添加引用
- (void)addBlockQuoteView:(NSString *)content {
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    FDLabelView *titleView = [[FDLabelView alloc] initWithFrame:CGRectMake(20, currentY, 280, 0)];
    titleView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    titleView.textColor = [UIColor whiteColor];
    titleView.font = [UIFont systemFontOfSize:13];
    titleView.minimumScaleFactor = 0.50;
    titleView.numberOfLines = 0;
    titleView.text = content;
    titleView.lineHeightScale = 0.90;
    titleView.fixedLineHeight = 0.00;
    titleView.fdLineScaleBaseLine = FDLineHeightScaleBaseLineCenter;
    titleView.fdTextAlignment = FDTextAlignmentLeft;
    titleView.fdAutoFitMode = FDAutoFitModeAutoHeight;
    titleView.fdLabelFitAlignment = FDLabelFitAlignmentCenter;
    titleView.contentInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    [footerView addSubview:titleView];
    
    currentY += titleView.visualTextHeight + 10;
    [self setFooterHeight];
}

//添加文章标题
- (void)addSubStrongText:(NSString *)content {
    
    FDLabelView *titleView = [[FDLabelView alloc] initWithFrame:CGRectMake(10, currentY, 300, 0)];
    titleView.backgroundColor = [UIColor redColor];
    titleView.textColor = [UIColor colorWithHue:0.57 saturation:0.87 brightness:0.82 alpha:0.80];
    titleView.font = [UIFont boldSystemFontOfSize:18];
    titleView.minimumScaleFactor = 0.50;
    titleView.numberOfLines = 0;
    titleView.text = content;
    titleView.lineHeightScale = 0.90;
    titleView.fixedLineHeight = 0.00;
    titleView.fdLineScaleBaseLine = FDLineHeightScaleBaseLineCenter;
    titleView.fdTextAlignment = FDTextAlignmentLeft;
    titleView.fdAutoFitMode = FDAutoFitModeAutoHeight;
    titleView.fdLabelFitAlignment = FDLabelFitAlignmentCenter;
    titleView.contentInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    [footerView addSubview:titleView];
    currentY += titleView.visualTextHeight;
    [self setFooterHeight];
}

//添加文章段落
- (void)addSubText:(NSString *)content {
    
    
    FDLabelView *titleView = [[FDLabelView alloc] initWithFrame:CGRectMake(10, currentY, 300, 0)];
    titleView.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.00];
    titleView.textColor = UIColorFromRGB(0x666666);
    titleView.font = [UIFont systemFontOfSize:17];
    titleView.minimumScaleFactor = 0.50;
    titleView.numberOfLines = 0;
    titleView.text = content;
    titleView.adjustsFontSizeToFitWidth = NO;
    titleView.lineBreakMode = NSLineBreakByTruncatingTail;
    titleView.lineHeightScale = 0.80;
    titleView.fixedLineHeight = 25;
    titleView.fdLineScaleBaseLine = FDLineHeightScaleBaseLineBottom;
    titleView.fdTextAlignment = FDTextAlignmentLeft;
    titleView.fdAutoFitMode = FDAutoFitModeAutoHeight;
    titleView.fdLabelFitAlignment = FDLabelFitAlignmentCenter;
    titleView.contentInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    [footerView addSubview:titleView];
    
    currentY += titleView.visualTextHeight + 10;
    [self setFooterHeight];
    
    titleView.debug = NO;
}

- (void)addVideoPlayer:(NSString *)urlStr {
    
    NSURL *url = [NSURL URLWithString:urlStr];
    UIWebView *videoWeb = [[UIWebView alloc]initWithFrame:CGRectMake(10, currentY, 300, 190)];
    [videoWeb loadRequest:[NSURLRequest requestWithURL:url]];
    [footerView addSubview:videoWeb];
    currentY += 190 + 10;
    [self setFooterHeight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
