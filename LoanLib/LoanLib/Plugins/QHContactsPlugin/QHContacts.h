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
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "QHPlugin.h"
#import "QHContact.h"

@interface QHContacts : QHPlugin <ABPersonViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>

- (void)chooseContactProperty:(QHInvokedUrlCommand*)command;

@end

@interface QHAddressBookAccessError : NSObject
{
    
}

@property (assign) QHContactError errorCode;

- (QHAddressBookAccessError*)initWithCode:(QHContactError)code;

@end

typedef void (^ QHAddressBookWorkerBlock)(
    ABAddressBookRef addressBook,
    QHAddressBookAccessError* error
    );

typedef void (^ QHContactStoreWorkerBlock)(
    CNContactStore *contactStore,
    QHAddressBookAccessError* error
);


@interface QHContactsHelper : NSObject
{

}

- (void)createAddressBook:(QHAddressBookWorkerBlock)workerBlock;
- (void)createContactStore:(QHContactStoreWorkerBlock)workerBlock;

+ (BOOL)qh_isBlank:(NSString *)str;

@end
