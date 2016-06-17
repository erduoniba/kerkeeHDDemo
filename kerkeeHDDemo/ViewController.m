//
//  ViewController.m
//  kerkeeHDDemo
//
//  Created by Harry on 16/6/17.
//  Copyright © 2016年 HarryDeng. All rights reserved.
//

#import "ViewController.h"
#import "KCWebView.h"
#import "KCJSBridge.h"
#import "HDJSToOCManager.h"

@interface ViewController ()
{
    KCJSBridge *m_jsBridge;
    KCWebView *m_webView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 将 HDJSToOCManager对象 和 js中的 kerkeeJSManager (详见HDJSToOCManager)绑定
    [KCJSBridge registObject:[[HDJSToOCManager alloc] init]];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"kerkeeTest" ofType:@"html"];
    NSURL *url = [NSURL URLWithString:file];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    m_webView = [[KCWebView alloc] initWithFrame:self.view.bounds];
    [m_webView loadRequest:request];
    [self.view addSubview:m_webView];
    
    // 在m_webView 加载 “kerkee.js” 代码，具体代码见 KCApiBridge.m 中的 init 方法 （这个时候需要在项目中添加“kerkee.js” 文件）
    m_jsBridge = [[KCJSBridge alloc] initWithWebView:m_webView delegate:self];
    
    UIButton *bb = [UIButton buttonWithType:UIButtonTypeInfoLight];
    bb.frame = CGRectMake(100, 400, 50, 50);
    [bb addTarget:self action:@selector(ocToJs) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bb];
}

- (void)ocToJs{
    [KCJSBridge callJSFunction:@"ocToJs" withJSONObject:@{@"hhh" : @"www"} WebView:m_webView];
}

#pragma mark --
#pragma mark KCWebViewProgressDelegate
-(void)webView:(KCWebView*)webView identifierForInitialRequest:(NSURLRequest*)initialRequest{
    
}

#pragma mark - UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
    NSString *scrollHeight = [aWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    NSLog(@"scrollHeight: %@", scrollHeight);
    NSLog(@"webview.contentSize.height %f", aWebView.scrollView.contentSize.height);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
