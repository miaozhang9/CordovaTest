//
//  NSMutableDictionary+QH.h
//  LoanLib
//
//  Created by guopengwen on 16/12/20.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (QH)

-(void)qh_setObj:(id)i forKey:(NSString*)key;

-(void)qh_setString:(NSString*)i forKey:(NSString*)key;

@end
