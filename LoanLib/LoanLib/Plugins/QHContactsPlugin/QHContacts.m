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

#import "QHContacts.h"
#import <UIKit/UIKit.h>

#define QHIOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

@interface QHContacts ()

@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSString *callbackId;
@property (nonatomic, strong) NSDictionary *pickedContactDictionary;

@end

@implementation QHContacts

// overridden to clean up Contact statics
- (void)onAppTerminate
{
    // NSLog(@"Contacts::onAppTerminate");
}

- (bool)existsValue:(NSDictionary*)dict val:(NSString*)expectedValue forKey:(NSString*)key
{
    id val = [dict valueForKey:key];
    bool exists = false;
    
    if (val != nil) {
        exists = [(NSString*)val compare : expectedValue options : NSCaseInsensitiveSearch] == 0;
    }
    
    return exists;
}

- (void)chooseContactProperty:(QHInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    NSArray* options = [command argumentAtIndex:0 withDefault:[NSNull null]];
    
    _callbackId = callbackId;
    _options = options;
    _pickedContactDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kABRecordInvalidID], qhContactId, nil];
    
    QHContactsHelper* abHelper = [[QHContactsHelper alloc] init];
    QHContacts* __weak weakSelf = self;
    
    if (QHIOSVersion >= 9.0) {
        [abHelper createContactStore:^(CNContactStore *contactStore, QHAddressBookAccessError *error) {
            if (contactStore == NULL) {
                // permission was denied or other error - return error
                QHPluginResult* result = [QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageToErrorObject:error ? (int)error.errorCode:UNKNOWN_ERROR];
                [weakSelf.commandDelegate sendPluginResult:result callbackId:callbackId];
                return;
            }
            CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
            contactVc.delegate = self;
            [self.viewController presentViewController:contactVc animated:YES completion:nil];
        }];
    } else {
        [abHelper createAddressBook: ^(ABAddressBookRef addrBook, QHAddressBookAccessError* errCode) {
            if (addrBook == NULL) {
                // permission was denied or other error - return error
                QHPluginResult* result = [QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageToErrorObject:errCode ? (int)errCode.errorCode:UNKNOWN_ERROR];
                [weakSelf.commandDelegate sendPluginResult:result callbackId:callbackId];
                return;
            }
            
            ABPeoplePickerNavigationController* pickerController = [[ABPeoplePickerNavigationController alloc] init];
            pickerController.peoplePickerDelegate = self;
            pickerController.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
            [self.viewController presentViewController:pickerController animated:YES completion:nil];
        }];
    }
}

#pragma mark-ABPeoplePickerNavigationControllerDelegate

- (BOOL)personViewController:(ABPersonViewController*)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self peoplePickerNavigationController:peoplePicker didSelectPerson:person];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController*)peoplePicker
{
    [[peoplePicker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

// Called after a person has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABPersonViewController* personController = [[ABPersonViewController alloc] init];
    personController.displayedPerson = person;
    personController.personViewDelegate = self;
    [peoplePicker pushViewController:personController animated:YES];
    return;
}

// Called after a property has been selected by the user.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    QHContact* pickedContact = [[QHContact alloc] initFromABRecord:(ABRecordRef)person];
    NSArray* fields = _options;
    NSDictionary* returnFields = [[QHContact class] calcReturnFields:fields];
    
    QHPluginResult* result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsDictionary:_pickedContactDictionary];
    [self.commandDelegate sendPluginResult:result callbackId:_callbackId];
    [[peoplePicker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CNContactPickerDelegate

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
   
    if (![contactProperty.key isEqualToString:CNContactPhoneNumbersKey]) {

    } else {
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        
        CNContact *contact = contactProperty.contact;
        //  选中的联系方式
        CNPhoneNumber *phoneNumber = contactProperty.value;
        NSString *str = phoneNumber.stringValue;
        NSCharacterSet *setToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *phoneStr = [[str componentsSeparatedByCharactersInSet:setToRemove]componentsJoinedByString:@""];
        
        if (![QHContactsHelper qh_isBlank:phoneStr]) {
            // self.immediateContact.mobilePhoneNo = phoneStr;
            [mdic setObject:phoneStr forKey:@"phoneNumber"];
        }
        //  姓名
        NSString *lastname = contact.familyName;
        NSString *firstname = contact.givenName;
        NSString *fullName = [NSString stringWithFormat:@"%@%@",lastname, firstname];
        if (!fullName) {
            fullName = @"姓名不详";
        }
        [mdic setObject:fullName forKey:@"fullName"];
        
        _pickedContactDictionary = [mdic copy];
        
        QHPluginResult* result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsDictionary:_pickedContactDictionary];
        [self.commandDelegate sendPluginResult:result callbackId:_callbackId];
    }
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 点击了取消按钮会执行该方法
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end

@implementation QHAddressBookAccessError

@synthesize errorCode;

- (QHAddressBookAccessError*)initWithCode:(QHContactError)code
{
    self = [super init];
    if (self) {
        self.errorCode = code;
    }
    return self;
}

@end

@implementation QHContactsHelper

/**
 * NOTE: workerBlock is responsible for releasing the addressBook that is passed to it
 */
- (void)createAddressBook:(QHAddressBookWorkerBlock)workerBlock
{
    ABAddressBookRef addressBook;
    CFErrorRef error = nil;
    addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            // callback can occur in background, address book must be accessed on thread it was created on
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (error) {
                    workerBlock(NULL, [[QHAddressBookAccessError alloc] initWithCode:UNKNOWN_ERROR]);
                } else if (!granted) {
                    workerBlock(NULL, [[QHAddressBookAccessError alloc] initWithCode:PERMISSION_DENIED_ERROR]);
                } else {
                    // 已授权
                    workerBlock(addressBook, [[QHAddressBookAccessError alloc] initWithCode:UNKNOWN_ERROR]);
                }
            });
        });
}

- (void)createContactStore:(QHContactStoreWorkerBlock)workerBlock
{
    __weak typeof(self) weakSelf = self;
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (error) {
                workerBlock(NULL, [[QHAddressBookAccessError alloc] initWithCode:UNKNOWN_ERROR]);
            } else if (!granted) {
                workerBlock(NULL, [[QHAddressBookAccessError alloc] initWithCode:PERMISSION_DENIED_ERROR]);
            } else {
                // 已授权
                workerBlock(store, [[QHAddressBookAccessError alloc] initWithCode:UNKNOWN_ERROR]);
            }
        });
    }];
}

+ (BOOL)qh_isBlank:(NSString *)str
{
    if (!str
        || [str isKindOfClass:[NSNull class]]
        || [str isEqualToString:@""]
        || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

@end
