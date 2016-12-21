// UIActivityIndicatorView+QHNetworking.m
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIActivityIndicatorView+QHNetworking.h"
#import <objc/runtime.h>

#if TARGET_OS_IOS || TARGET_OS_TV

#import "QHURLSessionManager.h"

@interface QHActivityIndicatorViewNotificationObserver : NSObject
@property (readonly, nonatomic, weak) UIActivityIndicatorView *activityIndicatorView;
- (instancetype)initWithActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView;

- (void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task;

@end

@implementation UIActivityIndicatorView (QHNetworking)

- (QHActivityIndicatorViewNotificationObserver *)qh_notificationObserver {
    QHActivityIndicatorViewNotificationObserver *notificationObserver = objc_getAssociatedObject(self, @selector(qh_notificationObserver));
    if (notificationObserver == nil) {
        notificationObserver = [[QHActivityIndicatorViewNotificationObserver alloc] initWithActivityIndicatorView:self];
        objc_setAssociatedObject(self, @selector(qh_notificationObserver), notificationObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return notificationObserver;
}

- (void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task {
    [[self qh_notificationObserver] setAnimatingWithStateOfTask:task];
}

@end

@implementation QHActivityIndicatorViewNotificationObserver

- (instancetype)initWithActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView
{
    self = [super init];
    if (self) {
        _activityIndicatorView = activityIndicatorView;
    }
    return self;
}

- (void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter removeObserver:self name:QHNetworkingTaskDidResumeNotification object:nil];
    [notificationCenter removeObserver:self name:QHNetworkingTaskDidSuspendNotification object:nil];
    [notificationCenter removeObserver:self name:QHNetworkingTaskDidCompleteNotification object:nil];
    
    if (task) {
        if (task.state != NSURLSessionTaskStateCompleted) {
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreceiver-is-weak"
#pragma clang diagnostic ignored "-Warc-repeated-use-of-weak"
            if (task.state == NSURLSessionTaskStateRunning) {
                [self.activityIndicatorView startAnimating];
            } else {
                [self.activityIndicatorView stopAnimating];
            }
#pragma clang diagnostic pop

            [notificationCenter addObserver:self selector:@selector(qh_startAnimating) name:QHNetworkingTaskDidResumeNotification object:task];
            [notificationCenter addObserver:self selector:@selector(qh_stopAnimating) name:QHNetworkingTaskDidCompleteNotification object:task];
            [notificationCenter addObserver:self selector:@selector(qh_stopAnimating) name:QHNetworkingTaskDidSuspendNotification object:task];
        }
    }
}

#pragma mark -

- (void)qh_startAnimating {
    dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreceiver-is-weak"
        [self.activityIndicatorView startAnimating];
#pragma clang diagnostic pop
    });
}

- (void)qh_stopAnimating {
    dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreceiver-is-weak"
        [self.activityIndicatorView stopAnimating];
#pragma clang diagnostic pop
    });
}

#pragma mark -

- (void)dealloc {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self name:QHNetworkingTaskDidCompleteNotification object:nil];
    [notificationCenter removeObserver:self name:QHNetworkingTaskDidResumeNotification object:nil];
    [notificationCenter removeObserver:self name:QHNetworkingTaskDidSuspendNotification object:nil];
}

@end

#endif
