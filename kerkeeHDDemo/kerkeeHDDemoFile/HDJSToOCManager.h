//
//  HDJSToOCManager.h
//  KerkeeDemo
//
//  Created by 邓立兵 on 16/5/18.
//  Copyright © 2016年 邓立兵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCJSObject.h"
#import "KCArgList.h"

// 这个类作为 和 js 交互桥梁类
@interface HDJSToOCManager : KCJSObject

- (void)jsToOc:(KCWebView*)aWebView argList:(KCArgList*)args;

- (void)mutualJSOC:(KCWebView*)aWebView argList:(KCArgList*)args;

@end
