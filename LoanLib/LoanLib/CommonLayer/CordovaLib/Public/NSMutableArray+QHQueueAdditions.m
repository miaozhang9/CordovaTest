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

#import "NSMutableArray+QHQueueAdditions.h"

@implementation NSMutableArray (QHQueueAdditions)

- (id)qh_queueHead
{
    if ([self count] == 0) {
        return nil;
    }

    return [self objectAtIndex:0];
}

- (__autoreleasing id)qh_dequeue
{
    if ([self count] == 0) {
        return nil;
    }

    id head = [self objectAtIndex:0];
    if (head != nil) {
        // [[head retain] autorelease]; ARC - the __autoreleasing on the return value should so the same thing
        [self removeObjectAtIndex:0];
    }

    return head;
}

- (id)qh_pop
{
    return [self qh_dequeue];
}

- (void)qh_enqueue:(id)object
{
    [self addObject:object];
}

@end
