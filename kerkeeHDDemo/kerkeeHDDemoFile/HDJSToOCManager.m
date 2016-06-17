//
//  HDJSToOCManager.m
//  KerkeeDemo
//
//  Created by 邓立兵 on 16/5/18.
//  Copyright © 2016年 邓立兵. All rights reserved.
//

#import "HDJSToOCManager.h"

#import <UIKit/UIKit.h>
#import "KCJSBridge.h"

@implementation HDJSToOCManager

- (NSString*)getJSObjectName{
    // 这个 和 js 中的变量要保持一致
    return @"kerkeeJSManager";
}

// js 中 可以调用 jsToOc() 来调用
- (void)jsToOc:(KCWebView*)aWebView argList:(KCArgList*)args{
    NSLog(@"JS调用OC args : %@", args);
}

- (void)mutualJSOC:(KCWebView*)aWebView argList:(KCArgList*)args{
    NSLog(@"JS调用OC，OC回调JS args : %@", args);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"success" forKey:@"info"];
    NSString *json = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:0 error:nil] encoding:NSUTF8StringEncoding];
    KCAutorelease(json);
    //回调，callbackId，kerkee.js 内部已经处理好
    [KCJSBridge callbackJS:aWebView callBackID:[args getObject:@"callbackId"] jsonString:json];
}

@end
