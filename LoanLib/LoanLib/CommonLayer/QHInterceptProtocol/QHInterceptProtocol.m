//
//  QHInterceptProtocol.m
//  LoanLib
//
//  Created by yinxukun on 2016/12/19.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "QHInterceptProtocol.h"
#import "QHLoanDoorBundle.h"
//#import "QHInterceptTool.h"
#define BB_CACHE_PROXY_HANDLED_KEY @"BB_CACHE_PROXY_HANDLED_KEY"

NSString const *QHIntercept_Key = @"local_intercept";

@interface QHInterceptProtocol () <NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation QHInterceptProtocol

- (void)startLoading
{
    //拦截cordova本地获取
    if ([[[self.request URL] absoluteString] containsString:QHIntercept_Key]) {

        NSString *newFilePath = [QHLoanDoorBundle filePath:@"cordova.js"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:newFilePath];

        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[self.request URL] MIMEType:@"application/javascript" expectedContentLength:[data length] textEncodingName:@"utf-8"];

        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:0];
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
    }
}

-(void)doFilter:(NSString *)url moduleName:(NSString *)moduleName request:(NSURLRequest *)request interceptTool:(QHInterceptTool *)interceptTool
{

}

- (void)stopLoading
{
    //　　#请求在这里该结束了，在此终止自己的请求吧
    //[connection cancel];
}

//#这几个不是Protocol的方法，是自发起的URLConnection的回调
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //　　#此方法会收到一部分或者全部的数据，可以这样子丢给原始请求的发起者
    //[self.client URLProtocol:self didLoadData:sourceData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //　　#和上一个方法类似，这里作为错误通知
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //#这里是收到响应的头部信息，比如HTTP Header，可视情况做对self.client做相应操作，也可以不做处理
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //　　#自己的请求加载完成了，这样子可以通知self.client
    [self.client URLProtocolDidFinishLoading:self];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSLog(@"%@", [[request URL] absoluteString]);
    if ([[[request URL] absoluteString] containsString:QHIntercept_Key]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    /**
     + canonicalRequestForRequest：是从NSURLProtocol一个抽象方法。你的类必须实现它。这是给你的应用程序来定义什么是“规范要求”的意思，但至少它应该返回相同的规范要求对于相同的输入要求。因此，如果两个语义上相等（即不一定==）被输入到该方法中，输出请求也应当语义相等。
     */
//    NSString* absolutePath = [[NSBundle mainBundle] pathForResource:path ofType:nil]
    return request;
}
@end

@implementation QHInterceptTool : NSObject

@end





