//
//  WJWebViewController.m
//  XunYiTongV2.0
//
//  Created by jerry on 2017/5/18.
//  Copyright © 2017年 jerry. All rights reserved.
//

#import "WJWebViewController.h"
#import <WebKit/WebKit.h>

#define WJRGBColor(R,G,B)  [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1.0f]

static CGFloat const NAVI_HEIGHT = 64;

@interface WJWebViewController ()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) WKWebView *wk_WebView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *closeBarButtonItem;
@property (nonatomic, weak)   id <UIGestureRecognizerDelegate>delegate;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIProgressView *loadingProgressView;
@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation WJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createWebView];
    [self createNaviItem];
    [self loadRequest];
    // Do any additional setup after loading the view.
}
#pragma mark 版本适配

- (void)createWebView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.reloadButton];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        [self.view addSubview:self.wk_WebView];
        [self.view addSubview:self.loadingProgressView];
    } else {
        [self.view addSubview:self.webView];
    }
}

- (UIWebView*)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - NAVI_HEIGHT)];
        _webView.delegate = self;
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 10.0 && _canDownRefresh) {
            _webView.scrollView.refreshControl = self.refreshControl;
        }
    }
    return _webView;
}

- (WKWebView*)wk_WebView {
    if (!_wk_WebView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        config.preferences = [[WKPreferences alloc]init];
        config.userContentController = [[WKUserContentController alloc]init];
        _wk_WebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - NAVI_HEIGHT) configuration:config];
        _wk_WebView.navigationDelegate = self;
        _wk_WebView.UIDelegate = self;
        //添加此属性可触发侧滑返回上一网页与下一网页操作
        _wk_WebView.allowsBackForwardNavigationGestures = YES;
        //下拉刷新
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 10.0 && _canDownRefresh) {
            _wk_WebView.scrollView.refreshControl = self.refreshControl;
        }
        //进度监听
        [_wk_WebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _wk_WebView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        CGFloat progress = [change[NSKeyValueChangeNewKey] floatValue];
        [_loadingProgressView setProgress:progress animated:YES];
        
        if (_loadingProgressView.progress == 1.0) {

            [UIView animateWithDuration:0.3 animations:^{
                self.loadingProgressView.alpha = 0;
                
            } completion:^(BOOL finished) {
                _loadingProgressView.hidden = YES;
                _loadingProgressView.progress = 0.0f;
            }];
        }
    }
}

- (void)dealloc {
    
    [_wk_WebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wk_WebView stopLoading];
    [_webView stopLoading];
    _wk_WebView.UIDelegate = nil;
    _wk_WebView.navigationDelegate = nil;
    _webView.delegate = nil;
    
    if ([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}


- (UIProgressView*)loadingProgressView {
    if (!_loadingProgressView) {
        _loadingProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, NAVI_HEIGHT, self.view.bounds.size.width, 2)];
        _loadingProgressView.progressViewStyle = UIProgressViewStyleBar;//进度条的宽度是根据样式来变化的，设置width无效
        _loadingProgressView.progressTintColor = WJRGBColor(0, 190, 17); // 进度值背景颜色
        _loadingProgressView.trackTintColor = [UIColor clearColor]; // 进度条背景颜色
    }
    return _loadingProgressView;
}

- (UIRefreshControl*)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc]init];
        [_refreshControl addTarget:self action:@selector(webViewReload) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (void)webViewReload {
    [_webView reload];
    [_wk_WebView reload];
}

- (UIButton*)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.frame = CGRectMake(0, 0, 50, 50);
        _reloadButton.center = self.view.center;
    
        [_reloadButton setBackgroundImage:[UIImage imageNamed:@"sure_placeholder_error"] forState:UIControlStateNormal];
        [_reloadButton setTitle:@"您的网络有问题，请检查您的网络设置" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_reloadButton setTitleEdgeInsets:UIEdgeInsetsMake(200, -50, 0, -50)];
        _reloadButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _reloadButton.titleLabel.numberOfLines = 0;
        _reloadButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGRect rect = _reloadButton.frame;
        rect.origin.y -= 100;
        _reloadButton.frame = rect;
        _reloadButton.enabled = NO;
    }
    return _reloadButton;
}

#pragma mark 导航按钮
- (void)createNaviItem {
    [self showLeftBarButtonItem];
    [self showRightBarButtonItem];
}

- (void)showLeftBarButtonItem {
    if ([_webView canGoBack] || [_wk_WebView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.backBarButtonItem,self.closeBarButtonItem];
    } else {
        self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
    }
}

- (void)showRightBarButtonItem {
    
}

- (UIBarButtonItem*)backBarButtonItem {
    if (!_backBarButtonItem) {

        _backBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back_nor"]style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem*)closeBarButtonItem {
    if (!_closeBarButtonItem) {
        _closeBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    }
    return _closeBarButtonItem;
}

- (void)back:(UIBarButtonItem*)item {
    if ([_webView canGoBack] || [_wk_WebView canGoBack]) {
        [_webView goBack];
        [_wk_WebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)close:(UIBarButtonItem*)item {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 自定义导航按钮支持侧滑手势处理
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        self.delegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self.delegate;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

#pragma mark 加载请求
- (void)loadRequest {
    if (![self.url hasPrefix:@"http"]) {//是否具有http前缀
        self.url = [NSString stringWithFormat:@"http://%@",self.url];
    }
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        [_wk_WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    } else {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
}

#pragma mark WebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    webView.hidden = NO;
    // 不加载空白网址
    if ([request.URL.scheme isEqual:@"about"]) {
        webView.hidden = YES;
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //导航栏配置
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self showLeftBarButtonItem];
    [_refreshControl endRefreshing];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    webView.hidden = YES;
}

#pragma mark WKNavigationDelegate

#pragma mark 加载状态回调
//页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    webView.hidden = NO;
    _loadingProgressView.hidden = NO;
    _loadingProgressView.alpha = 1.0;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if ([webView.URL.scheme isEqual:@"about"]) {
        webView.hidden = YES;
    }
}

//页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    //导航栏配置
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        self.navigationItem.title = title;
    }];
    
    [self showLeftBarButtonItem];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [_refreshControl endRefreshing];
}

//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    webView.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//HTTPS认证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
