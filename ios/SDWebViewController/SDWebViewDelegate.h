//
//  SDWebViewDelegate.h
//  SDWebViewController
//
//  Created by Dmitry Sytsevich on 5/30/19.
//  Copyright © 2019 Dmitry Sytsevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDWebViewDelegate <NSObject>

@optional
- (void)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType: (UIWebViewNavigationType)navigationType;
- (void)webViewWillClose:(UIWebView *)webView;
- (void)onWebViewDidFinishLoad:(UIWebView *)webView;
- (void)onWebViewDidStartLoad:(UIWebView *)webView;
- (void)webViewFailToLoad:(NSError *)error;

@end
