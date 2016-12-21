//
//  NSMutableDictionary+QH.m
//  LoanLib
//
//  Created by guopengwen on 16/12/20.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "NSMutableDictionary+QH.h"

@implementation NSMutableDictionary (QH)

-(void)qh_setObj:(id)i forKey:(NSString*)key{
    if (i!=nil) {
        self[key] = i;
    }
}

-(void)qh_setString:(NSString*)i forKey:(NSString*)key
{
    if (i != nil) {
       [self setValue:i forKey:key];
    }
}

@end
