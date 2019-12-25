//
//  SDWebViewController.m
//  SDWebViewController
//
//  Created by Dmitry Sytsevich on 5/30/19.
//  Copyright © 2019 Dmitry Sytsevich. All rights reserved.
//

#define IBT_BGCOLOR             [UIColor whiteColor]
#define IBT_ADDRESS_TEXT_COLOR  [UIColor colorWithRed:.44 green:.45  blue:.46  alpha:1]
#define IBT_PROGRESS_COLOR      [UIColor colorWithRed:0   green:.071 blue:.75  alpha:1]

#define POST_BACK_URL @"https://demo.cloudpayments.ru/WebFormPost/GetWebViewData"

#import "SDWebViewController.h"
#import "SDWebViewDelegate.h"
#import "NSString+URLEncoding.h"

@interface SDWebViewController () <UIWebViewDelegate> {
    
    // Address bar
    UIImageView *m_addressBarView;
    UILabel *m_addressLabel;

    // URL
    NSURL *m_currentUrl;

    BOOL m_bAutoSetTitle;
}
@property (strong, nonatomic) UIWebView *m_webView;

@property (strong, nonatomic) NSString *m_initUrl;
@property (strong, nonatomic) NSString *m_transactionId;
@property (strong, nonatomic) NSString *m_token;
@property (strong, nonatomic) NSMutableDictionary *m_extraInfo;

- (void)initWebView;
- (void)initAddressBarView;
- (void)removeAddressBar;
- (void)initNavigationBarItem;

@end

@implementation SDWebViewController

#pragma mark -

- (id)initWithURL:(id)url transactionId:(NSString *)transactionId token:(NSString *)token {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.m_initUrl = url;
    self.m_transactionId = transactionId;
    self.m_token = token;


    if ([url isKindOfClass:[NSString class]]) {
        self.m_initUrl = url;
    }
    else if ([url isKindOfClass:[NSURL class]]) {
        self.m_initUrl = [NSString stringWithFormat:@"%@", url];
    }

    m_bAutoSetTitle = YES;

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = IBT_BGCOLOR;

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [self initNavigationBarItem];
    [self initAddressBarView];
    [self initWebView];

    [self loadURL:self.m_initUrl transactionId:self.m_transactionId token:self.m_token];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.m_webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.m_webView.delegate = nil;

    m_addressBarView = nil;
    m_addressLabel = nil;

    m_currentUrl = nil;
}

#pragma MARK: - Private Method

- (void)initWebView {
    self.m_webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.m_webView.backgroundColor = [UIColor clearColor];
    self.m_webView.delegate = self;
    self.m_webView.scalesPageToFit = YES;
    self.m_webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.m_webView];
}

- (void)updateDisplayTitle:(NSString *)nsTitle {
    self.title = nsTitle;
}

#pragma MARK: - Address Bar

- (NSString *)getAddressBarHostText:(NSURL *)url {
    if ([url.host length] > 0) {
        return [NSString stringWithFormat:NSLocalizedString(@"Provided by %@", nil), url.host];
    } else {
        return @"";
    }
}

- (void)initAddressBarView {
    if (!m_addressBarView) {
        m_addressBarView = [[UIImageView alloc] init];
        m_addressBarView.frame = (CGRect){
            .origin.x = 0,
            .origin.y = 0,
            .size.width = CGRectGetWidth(self.view.bounds),
            .size.height = 40
        };

        m_addressLabel = [[UILabel alloc] init];
        m_addressLabel.frame = CGRectInset(m_addressBarView.bounds, 10, 6);
        m_addressLabel.textColor = [UIColor clearColor];
        m_addressLabel.textAlignment = NSTextAlignmentCenter;
        m_addressLabel.textColor = IBT_ADDRESS_TEXT_COLOR;
        m_addressLabel.font = [UIFont systemFontOfSize:12];

        [m_addressBarView addSubview:m_addressLabel];
    }

    [self.view addSubview:m_addressBarView];
}

- (void)removeAddressBar {
    [m_addressBarView removeFromSuperview];
    m_addressBarView = nil;
    m_addressLabel = nil;
}

#pragma MARK: - Navigation Bar

- (void)initNavigationBarItem {
    UIBarButtonItem *backItem =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onCloseAction:)];

    self.navigationItem.rightBarButtonItems = @[ backItem ];

}

- (void)onCloseAction:(__unused id)sender {
    if ([_m_delegate respondsToSelector:@selector(webViewWillClose:)]) {
        [_m_delegate webViewWillClose:self.m_webView];
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma MARK: - WebView Action

- (BOOL)isTopLevelNavigation:(NSURLRequest *)req {
    if (req.mainDocumentURL) {
        return [req.URL isEqual:req.mainDocumentURL];
    } else {
        return YES;
    }
}

- (void)loadURL:(NSString *)url transactionId:(NSString *)transactionId token:(NSString *)token {
    NSString *body = [NSString stringWithFormat: @"MD=%@&PaReq=%@&TermUrl=%@", token, transactionId, POST_BACK_URL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: url]];
    [request setHTTPMethod: @"POST"];
    body = [body stringByURLEncoding];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    [self.m_webView loadRequest: request];
}

#pragma MARK: - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([_m_delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        [_m_delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    m_currentUrl = request.mainDocumentURL;
    m_addressLabel.text = [self getAddressBarHostText:m_currentUrl];
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if ([_m_delegate respondsToSelector:@selector(onWebViewDidStartLoad:)]) {
        [_m_delegate onWebViewDidStartLoad:webView];
    }
    
    if ([self isTopLevelNavigation:webView.request]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([_m_delegate respondsToSelector:@selector(onWebViewDidFinishLoad:)]) {
        [_m_delegate onWebViewDidFinishLoad:webView];
    }
    
    if ([self isTopLevelNavigation:webView.request]) {
        m_currentUrl = webView.request.mainDocumentURL;
        m_addressLabel.text = [self getAddressBarHostText:m_currentUrl];
        
        if (m_bAutoSetTitle) {
            NSString *nsTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
            [self updateDisplayTitle:nsTitle];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([_m_delegate respondsToSelector:@selector(webViewFailToLoad:)]) {
        [_m_delegate webViewFailToLoad:error];
    }
    
    if ([error code] != NSURLErrorCancelled &&
        [self isTopLevelNavigation:webView.request]) {
        
    }
}

@end
