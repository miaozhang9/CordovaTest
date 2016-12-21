//
//  QHHaleyPlugin.h
//  HelloCordova
//
//  Created by Harvey on 16/9/28.
//
//

#import "QH.h"

@interface QHCommonPlugin : QHPlugin

- (void)scan:(QHInvokedUrlCommand *)command;

- (void)location:(QHInvokedUrlCommand *)command;

- (void)pay:(QHInvokedUrlCommand *)command;

- (void)share:(QHInvokedUrlCommand *)command;

- (void)changeColor:(QHInvokedUrlCommand *)command;

- (void)shake:(QHInvokedUrlCommand *)command;

- (void)playSound:(QHInvokedUrlCommand *)command;

- (void)faceRecognition:(QHInvokedUrlCommand *)command;

- (void)camaraFetchFace:(QHInvokedUrlCommand *)command;

@end
