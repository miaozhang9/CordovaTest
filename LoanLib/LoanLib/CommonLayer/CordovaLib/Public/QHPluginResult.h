/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import <Foundation/Foundation.h>
#import "QHAvailability.h"

typedef enum {
    QHCommandStatus_NO_RESULT = 0,
    QHCommandStatus_OK,
    QHCommandStatus_CLASS_NOT_FOUND_EXCEPTION,
    QHCommandStatus_ILLEGAL_ACCESS_EXCEPTION,
    QHCommandStatus_INSTANTIATION_EXCEPTION,
    QHCommandStatus_MALFORMED_URL_EXCEPTION,
    QHCommandStatus_IO_EXCEPTION,
    QHCommandStatus_INVALID_ACTION,
    QHCommandStatus_JSON_EXCEPTION,
    QHCommandStatus_ERROR
} QHCommandStatus;

@interface QHPluginResult : NSObject {}

@property (nonatomic, strong, readonly) NSNumber* status;
@property (nonatomic, strong, readonly) id message;
@property (nonatomic, strong)           NSNumber* keepCallback;
// This property can be used to scope the lifetime of another object. For example,
// Use it to store the associated NSData when `message` is created using initWithBytesNoCopy.
@property (nonatomic, strong) id associatedObject;

- (QHPluginResult*)init;
+ (QHPluginResult*)resultWithStatus:(QHCommandStatus)statusOrdinal;
+ (QHPluginResult*)resultWithStatus:(QHCommandStatus)statusOrdinal messageAsString:(NSString*)theMessage;
+ (QHPluginResult*)resultWithStatus:(QHCommandStatus)statusOrdinal messageAsArray:(NSArray*)theMessage;
+ (QHPluginResult*)resultWithStatus:(QHCommandStatus)statusOrdinal messageAsInt:(int)theMessage;
+ (QHPluginResult*)resultWithStatus:(QHCommandStatus)statusOrdinal messageAsNSInteger:(NSInteger)theMessage;
+ (QHPluginResult*)resultWithStatus:(QHCommandStatus)statusOrdinal messageAsNSUInteger:(NSUInteger)theMessage;
+ (QHPluginResult*)resultWithStatus:(QHCommandStatus)statusOrdinal messageAsDouble:(double)theMessage;
+ (QHPluginResult*)resultWithStatus:(QHCommandStatus)statusOrdinal messageAsBool:(BOOL)theMessage;
+ (QHPluginResult*)resultWithStatus:(QHCommandStatus)statusOrdinal messageAsDictionary:(NSDictionary*)theMessage;
+ (QHPluginResult*)resultWithStatus:(QHCommandStatus)statusOrdinal messageAsArrayBuffer:(NSData*)theMessage;
+ (QHPluginResult*)resultWithStatus:(QHCommandStatus)statusOrdinal messageAsMultipart:(NSArray*)theMessages;
+ (QHPluginResult*)resultWithStatus:(QHCommandStatus)statusOrdinal messageToErrorObject:(int)errorCode;

+ (void)setVerbose:(BOOL)verbose;
+ (BOOL)isVerbose;

- (void)setKeepCallbackAsBool:(BOOL)bKeepCallback;

- (NSString*)argumentsAsJSON;

@end
