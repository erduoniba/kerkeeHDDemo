#### kerkee 之Web和iOS开发使用篇

简单认识：*kerkee* 是一个多主体共存型 *Hybrid* 框架，具有跨平台、用户体验好、性能高、扩展性好、灵活性强、易维护、规范化、集成云服务、具有Debug环境、彻底解决跨域问题。该框架从开发者角度支持三种团队开发模式：**Web开发者** 、**Native开发者** 、**Web开发者和Native团队共同合作的开发团队** 。

下面我将从 **Web开发者和Native（iOS）团队共同合作的开发团队** 模式来分析使用该框架。

##### 一、相关资料：

官网地址：[http://www.kerkee.com](http://www.kerkee.com/)

*Github* 源码地址：[https://github.com/kercer](https://github.com/kercer)

QQ交流群：110710084



**二、简单的使用：**

[kerkee在iOS上的快速上手指南](http://blog.linzihong.com/kerkeezai-iosshang-de-kuai-su-sha ng-shou-zhi-nan/) 

1、建立新项目 `kerkeeHDDemo`  在项目目录中建立 `Podfile` 文件：

```shell
platform :ios, '7.0'

inhibit_all_warnings!
pod ‘kerkee’, ’~> 1.0.1’  
```

2、使用 *CocoaPods* 来导入 *kerkee* 框架，使用终端 cd 到你的 `Podfile` 文件所在的目录:

```shell
cd $PodfilePath
pod install
```

3、运行  `Podfile`  同目录中的 `kerkeeHDDemo.xcworkspace` 即可；

4、在项目中添加 *html* 代码：(本人对 *html* 不熟悉，相信懂的人肯定懂)

*kerkeeTest.html* :

```html
<!--Create by Harry on 17/06/2016-->
<!--  Copyright © 2016年 HarryDeng. All rights reserved.-->

<html>
    <head>
        <title>kerkee测试h5界面</title>
        <meta http-equiv="Content-Type"content="text/html; charset=UTF-8">
            <script>
                function test()
                {
                    alert("test alert...");
                    return "abcd";
                }
                </script>
            </head>
    
    <body>
        <br/>
        <br/>
        
        <input type="button" value="js数据传递给oc" onclick="kerkeeJSManager.jsToOc('js数据传递给oc'); ">
            
        <br/>
            
        <input type="button" value="js数据传递给oc，oc回传给js" onclick="kerkeeJSManager.mutualJSOC('js数据传递给oc，oc回传给js', function(json)
                {
                console.log(JSON.stringify(json))
                }); ">
                
        <br/>
                
        <button id="hallo" onclick="buttonClick1('js数据传递给oc,h5的方法单独写出buttonClick1')">
            js数据传递给oc,h5的方法单独写出buttonClick1 </button>
        
        <br/>
        
        <button id="hallo" onclick="buttonClick2('js数据传递给oc,h5的方法单独写出buttonClick2')">
            js数据传递给oc,h5的方法在js文件实现 buttonClick2 </button>
        
        <br/>
                
    </body>

            <script>
            var kerkeeJSManager;
            function buttonClick1(s1)
            {
                kerkeeJSManager.jsToOc(s1);
            }
              
			function ocToJs(s1)
            {
                console.log(JSON.stringify(s1))
            }
            </script>
            
            <!--html页面绑定js事件，一般放在href之后，如果放在之前加载JS事件会阻塞界面-->
            <script type="text/javascript" src="kerkeeTest.js"></script>
            
</html>
```

上面有三种方式来处理按钮的点击事件：

i.  	直接在<button> </button> 中处理

ii.  	使用 function 处理；

iii. 	使用 js 来处理 function。

代码解释：

|          代码           |                   理解分析                   |
| :-------------------: | :--------------------------------------: |
| ***kerkeeJSManager*** | ***js* 这边中 *iOS* 和  *js* 交互桥梁，在 *iOS* 也同样存在 *kerkeeJSManager* 关键字** |
|    ***jsToOc()***     | ***kerkeeJSManager* 方法 ，使用 *kerkeeJSManager.jsToOc()* 可以调用 *iOS* 对应的                                                                                                                                   *- (void)jsToOc:(KCWebView*)aWebView argList:(KCArgList*)args*                             方法，实现 *js* 调用 *iOS* 原生代码** |
|    ***ocToJs()***     | **在 *iOS* 中使用                                                                                                     *[KCJSBridge callJSFunction:@"ocToJs" withJSONObject:@{@"hhh" : @"www"} WebView:m_webView];*                                                                                     可以调用 *js* 的 *ocToJs()* 方法，实现了 *iOS* 调用 *js* 代码** |
|                       |                                          |



*kerkeeTest.js* :

```javascript
var kerkeeJSManager;
function buttonClick2(s1)
{
    kerkeeJSManager.jsToOc(s1);
}
```



5、在项目中添加 *iOS* 代码:

*HDJSToOCManager.h*：

```objective-c
#import <Foundation/Foundation.h>
#import "KCJSObject.h"
#import "KCArgList.h"

// 这个类作为 和 js 交互桥梁类
@interface HDJSToOCManager : KCJSObject

- (void)jsToOc:(KCWebView*)aWebView argList:(KCArgList*)args;

- (void)mutualJSOC:(KCWebView*)aWebView argList:(KCArgList*)args;

@end
```

*HDJSToOCManager.m*：

```objective-c
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
```

这个类主要是生成和  *js* 对应的变量 *kerkeeJSManager* ，是 *iOS* 这边  ***iOS* 和  *js* 交互桥梁**



*ViewController.m*：

```objective-c
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
```

上面的代码并不多，其核心代码之一在 ***KCApiBridge*** 中，可以看到， ***KCApiBridge*** 在初始化的时候找到 ***kerkee.js*** 并且使用  *- (nullable NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;* 在 *iOS* 的 *UIWebView* 注入 ***kerkee.js***  代码。这份 *js* 才是**真正的**将 *iOS* 的桥梁 *HDJSToOCManager* 实体和 *js*变量 *kerkeeJSManager* 的关键代码。在 [这里](https://github.com/kercer/kerkee_ios/blob/master/kerkeeExample/assets/kerkee.js) 可以看到作者在demo中的  ***kerkee.js***  源码。因为我对 *js* 也是入门阶段，所以选择在源码上改动之后，代码如下：

```javascript
;(function(window){
	if (window.WebViewJSBridge)
		return;
	window.WebViewJSBridge = {
  
  };

	console.log("--- kerkee init begin---");
	var browser={
        versions:function(){
            var u = navigator.userAgent, app = navigator.appVersion;
            return {
                trident: u.indexOf('Trident') > -1, //IE
                presto: u.indexOf('Presto') > -1, //opera
                webKit: u.indexOf('AppleWebKit') > -1, //apple&google kernel
                gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1,//firfox
                mobile: !!u.match(/AppleWebKit.*Mobile.*/), //is Mobile
                ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //is ios
                android: u.indexOf('Android') > -1 || u.indexOf('Adr') > -1, //android
                iPhone: u.indexOf('iPhone') > -1 , //iPhone or QQHD
                iPad: u.indexOf('iPad') > -1, //iPad
                iPod: u.indexOf('iPod') > -1, //iPod
                webApp: u.indexOf('Safari') == -1, //is webapp,no header and footer
                weixin: u.indexOf('MicroMessenger') > -1, //is wechat
                qq: u.match(/\sQQ/i) == " qq" //is qq
            };
        }(),
        language:(navigator.browserLanguage || navigator.language).toLowerCase()
    }

	var global = this || window;
                               
	var ApiBridge ={
		msgQueue : [],
		callbackCache : [],
		callbackId : 0,
		processingMsg : false,
		isReady : false,
		isNotifyReady : false
	};

	ApiBridge.create = function()
	{                  
		ApiBridge.bridgeIframe = document.createElement("iframe");
		ApiBridge.bridgeIframe.style.display = 'none';
        document.documentElement.appendChild(ApiBridge.bridgeIframe);
	};

	ApiBridge.prepareProcessingMessages = function()
	{
		ApiBridge.processingMsg = true;
	};

	ApiBridge.fetchMessages = function()
	{
		if (ApiBridge.msgQueue.length > 0)
		{
			var messages = JSON.stringify(ApiBridge.msgQueue);
			ApiBridge.msgQueue.length = 0;
			return messages;
		}
		ApiBridge.processingMsg = false;
		return null;
	};

	ApiBridge.callNative = function(clz, method, args, callback)
	{
		var msgJson = {};
		msgJson.clz = clz;
		msgJson.method = method;
		if (args != undefined)
			msgJson.args = args;

		if (callback)
		{
			var callbackId = ApiBridge.getCallbackId();
			ApiBridge.callbackCache[callbackId] = callback;
			if (msgJson.args)
			{
				msgJson.args.callbackId = callbackId.toString();
			}
			else
			{
				msgJson.args =
				{
					"callbackId" : callbackId.toString()
				};
			}
		}

		if (browser.versions.ios)
		{
			if (ApiBridge.bridgeIframe == undefined)
			{
				ApiBridge.create();
			}
			// var msgJson = {"clz": clz, "method": method, "args": args};
			ApiBridge.msgQueue.push(msgJson);
			if (!ApiBridge.processingMsg)
				ApiBridge.bridgeIframe.src = "kcnative://go";
		}
		else if (browser.versions.android)
		{
			// android
			return prompt(JSON.stringify(msgJson));
		}

	};

	ApiBridge.log = function(msg)
	{
		ApiBridge.callNative("ApiBridge", "JSLog",
		{
			"msg" : msg
		});
	}

	ApiBridge.getCallbackId = function()
	{
		return ApiBridge.callbackId++;
	}

	ApiBridge.onCallback = function(callbackId, obj)
	{
		if (ApiBridge.callbackCache[callbackId])
		{
			ApiBridge.callbackCache[callbackId](obj);
			// ApiBridge.callbackCache[callbackId] = undefined;
			// //如果是注册事件的话，不能undefined；
		}
	}

	ApiBridge.onBridgeInitComplete = function(callback)
	{
		ApiBridge.callNative("ApiBridge", "onBridgeInitComplete", {}, callback);
	}

	ApiBridge.onNativeInitComplete = function(callback)
	{
		ApiBridge.isReady = true;
		console.log("--- kerkee onNativeInitComplete end ---");

		if (callback)
		{
			callback();
			ApiBridge.isNotifyReady = true;
			console.log("--- device ready go--- ");
		}
	}

	ApiBridge.compile = function(aIdentity, aJS)
	{
		var value;
		var error;
		try
		{
			value = eval(aJS);
		}
		catch (e)
		{
			var err = {};
			err.name = e.name;
			err.message = e.message;
			err.number = e.number & 0xFFFF;
			error = err;
		}

		ApiBridge.callNative("ApiBridge", "compile",
		{
			"identity" : aIdentity,
			"returnValue" : value,
			"error" : error
		});
	}

	var	_Configs =
    {
        isOpenJSLog:false,
        sysLog:{},
        isOpenNativeXHR:true,
        sysXHR:{}
    };
    _Configs.sysLog = global.console.log;
    _Configs.sysXHR = global.XMLHttpRequest;


	var kerkee = {};

	
	/*****************************************
	 * JS和iOS 交互接口
	 *****************************************/
    kerkee.jsToOc = function(s1)
       {
       ApiBridge.callNative("kerkeeJSManager", "jsToOc",
    	    {
    	    	"s1" : s1
    	  	});
       };
       
       kerkee.mutualJSOC = function(aString, callback)
       {
       ApiBridge.callNative("kerkeeJSManager", "mutualJSOC",
            {
           	 	"aString" : aString
            }, callback);
       }
       
    global.kerkeeJSManager = kerkee;
                               

	kerkee.openJSLog = function()
	{
		_Configs.isOpenJSLog = true;
		global.console.log = ApiBridge.log;
	}
	kerkee.closeJSLog = function()
	{
		_Configs.isOpenJSLog = false;
        global.console.log = _Configs.sysLog;
	}

	kerkee.onDeviceReady = function(handler)
	{
		ApiBridge.onDeviceReady = handler;

		if (ApiBridge.isReady && !ApiBridge.isNotifyReady && handler)
		{
			console.log("-- device ready --");
			handler();
			ApiBridge.isNotifyReady = true;
		}
	};

	kerkee.invoke = function(clz, method, args, callback)
	{
		if (callback)
		{
			ApiBridge.callNative(clz, method, args, callback);
		}
		else
		{
			ApiBridge.callNative(clz, method, args);
		}
	};

	kerkee.onSetImage = function(srcSuffix, desUri)
	{
		// console.log("--- kerkee onSetImage ---");
		var obj = document.querySelectorAll('img[src$="' + srcSuffix + '"]');
		for (var i = 0; i < obj.length; ++i)
		{
			obj[i].src = desUri;
		}
	};


	/*****************************************
	 * XMLHttpRequest实现
	 *****************************************/
	var _XMLHttpRequest = function()
	{
		this.id = _XMLHttpRequest.globalId++;
		_XMLHttpRequest.cache[this.id] = this;

		this.status = 0;
		this.statusText = '';
		this.readyState = 0;
		this.responseText = '';
		this.headers = {};
		this.onreadystatechange = undefined;

		ApiBridge.callNative('XMLHttpRequest', 'create',
		{
			"id" : this.id
		});
	}

	_XMLHttpRequest.globalId = 0;
	_XMLHttpRequest.cache = [];
	_XMLHttpRequest.setProperties = function(jsonObj)
	{
		var id = jsonObj.id;
		if (_XMLHttpRequest.cache[id])
		{
			var obj = _XMLHttpRequest.cache[id];

			if (jsonObj.hasOwnProperty('status'))
			{
				obj.status = jsonObj.status;
			}
			if (jsonObj.hasOwnProperty('statusText'))
			{
				obj.statusText = jsonObj.statusText;
			}
			if (jsonObj.hasOwnProperty('readyState'))
			{
				obj.readyState = jsonObj.readyState;
			}
			if (jsonObj.hasOwnProperty('responseText'))
			{
				obj.responseText = jsonObj.responseText;
			}
			if (jsonObj.hasOwnProperty('headers'))
			{
				obj.headers = jsonObj.headers;
			}

			if (_XMLHttpRequest.cache[id].onreadystatechange)
			{
				_XMLHttpRequest.cache[id].onreadystatechange();
			}
		}
	}

	_XMLHttpRequest.prototype.open = function(method, url, async)
	{
		ApiBridge.callNative('XMLHttpRequest', 'open',
		{
			"id" : this.id,
			"method" : method,
			"url" : url,
			"scheme" : window.location.protocol,
			"host" : window.location.hostname,
			"port" : window.location.port,
			"href" : window.location.href,
			"referer" : document.referrer != "" ? document.referrer : undefined,
			"useragent" : navigator.userAgent,
			"cookie" : document.cookie != "" ? document.cookie : undefined,
			"async" : async,
			"timeout" : this.timeout
		});
	}

	_XMLHttpRequest.prototype.send = function(data)
	{
		if (data != null)
		{
			ApiBridge.callNative('XMLHttpRequest', 'send',
			{
				"id" : this.id,
				"data" : data
			});
		}
		else
		{
			ApiBridge.callNative('XMLHttpRequest', 'send',
			{
				"id" : this.id
			});
		}
	}
	_XMLHttpRequest.prototype.overrideMimeType = function(mimetype)
	{
		ApiBridge.callNative('XMLHttpRequest', 'overrideMimeType',
		{
			"id" : this.id,
			"mimetype" : mimetype
		});
	}
	_XMLHttpRequest.prototype.abort = function()
	{
		ApiBridge.callNative('XMLHttpRequest', 'abort',
		{
			"id" : this.id
		});
	}
	_XMLHttpRequest.prototype.setRequestHeader = function(headerName,
			headerValue)
	{
		ApiBridge.callNative('XMLHttpRequest', 'setRequestHeader',
		{
			"id" : this.id,
			"headerName" : headerName,
			"headerValue" : headerValue
		});
	}
	_XMLHttpRequest.prototype.getAllResponseHeaders = function()
	{
		var strHeaders = '';
		for ( var name in this.headers)
		{
			strHeaders += (name + ": " + this.headers[name] + "\r\n");
		}
		return strHeaders;
	}
	_XMLHttpRequest.prototype.getResponseHeader = function(headerName)
	{
		var strHeaders;
		var upperCaseHeaderName = headerName.toUpperCase();
		for ( var name in this.headers)
		{
			if (upperCaseHeaderName == name.toUpperCase())
				strHeaders = this.headers[name]
		}
		return strHeaders;
	}
	_XMLHttpRequest.deleteObject = function(id)
	{
		if (_XMLHttpRequest.cache[id])
		{
			_XMLHttpRequest.cache[id] = undefined;
		}
	}

	global.ApiBridge = ApiBridge;
	global.kerkee = kerkee;
	global.XMLHttpRequest = _XMLHttpRequest;

	kerkee.register = function(_window)
	{
		_window.ApiBridge = window.ApiBridge;
		_window.kerkee = window.kerkee;
		_window.console.log = window.console.log;
		_window.XMLHttpRequest = window.XMLHttpRequest;
		_window.open = window.open;
	};


	ApiBridge.onBridgeInitComplete(function(aConfigs)
	{
		if (aConfigs)
		{
			if (aConfigs.hasOwnProperty('isOpenJSLog'))
        	{
        		_Configs.isOpenJSLog = aConfigs.isOpenJSLog;
        	}
        	if (aConfigs.hasOwnProperty('isOpenNativeXHR'))
       		{
       			_Configs.isOpenNativeXHR = aConfigs.isOpenNativeXHR;
       		}
		}

		if (_Configs.isOpenJSLog)
		{
			global.console.log = ApiBridge.log;
		}
		ApiBridge.onNativeInitComplete(ApiBridge.onDeviceReady);

	});

})(window);

```

如果单纯的只是  *js* 和 *iOS* 的交互，只需要关注 下面 的代码即可：（当然你也可以自己设置多个 *kerkeeJSManager* 桥梁及 更多的 交互方法）

```javascript
/*****************************************
 * JS和iOS 交互接口
 *****************************************/
kerkee.jsToOc = function(s1)
   {
   ApiBridge.callNative("kerkeeJSManager", "jsToOc",
	    {
	    	"s1" : s1
	  	});
   };
   
   kerkee.mutualJSOC = function(aString, callback)
   {
   ApiBridge.callNative("kerkeeJSManager", "mutualJSOC",
        {
       	 	"aString" : aString
        }, callback);
   }
   
global.kerkeeJSManager = kerkee;
```



6、编译运行：

![Xcode 编译运行效果](http://7xqhx8.com1.z0.glb.clouddn.com/kerkee_Xcode.gif) 



![Safari进行web调试](http://7xqhx8.com1.z0.glb.clouddn.com/kerkee_Safari.gif)  

7、demo下载地址：[GitHub地址](https://github.com/erduoniba/kerkeeHDDemo.git)



**三、总结：**

这里只是简单的介绍了 *iOS* 使用 *kerkee* 框架来加载 *html* 实现 ***js* 和 *iOS* 交互** ，如果只是单纯的为了简单的交互，可以看我的另外一篇博客 ：[JS和OC相互调用](http://blog.csdn.net/u012390519/article/details/50144049) ，这里介绍了几个更加轻量级的框架实现 ***js* 和 *iOS* 交互**。但是  ***js* 和 *iOS* 交互** 功能在  *kerkee* 框架的一小部分，更多高性能、支持跨平台、扩展性好、易维护等等优秀的特性，我会慢慢阅读源码来说明。