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
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

enum QHContactError {
    UNKNOWN_ERROR = 0,
    INVALID_ARGUMENT_ERROR = 1,
    TIMEOUT_ERROR = 2,
    PENDING_OPERATION_ERROR = 3,
    IO_ERROR = 4,
    NOT_SUPPORTED_ERROR = 5,
    OPERATION_CANCELLED_ERROR = 6,
    PERMISSION_DENIED_ERROR = 20
};
typedef NSUInteger QHContactError;

@interface QHContact : NSObject {
    ABRecordRef record;         // the ABRecord associated with this contact
    NSDictionary* returnFields; // dictionary of fields to return when performing search
}

@property (nonatomic, assign) ABRecordRef record;
@property (nonatomic, strong) NSDictionary* returnFields;

+ (NSDictionary*)defaultABtoW3C;
+ (NSDictionary*)defaultW3CtoAB;
+ (NSSet*)defaultW3CtoNull;
+ (NSDictionary*)defaultObjectAndProperties;
+ (NSDictionary*)defaultFields;

+ (NSDictionary*)calcReturnFields:(NSArray*)fields;
- (id)init;
- (id)initFromABRecord:(ABRecordRef)aRecord;
- (bool)setFromContactDict:(NSDictionary*)aContact asUpdate:(BOOL)bUpdate;

+ (BOOL)needsConversion:(NSString*)W3Label;
+ (NSDictionary *) getContactLabels;
+ (NSArray *) filterLabels: (NSString *) contactApiLabel;
+ (CFStringRef)convertContactTypeToPropertyLabel:(NSString*)label;
+ (NSString*)convertPropertyLabelToContactType:(NSString*)label;
+ (BOOL)isValidW3ContactType:(NSString*)label;
- (bool)setValue:(id)aValue forProperty:(ABPropertyID)aProperty inRecord:(ABRecordRef)aRecord asUpdate:(BOOL)bUpdate;

- (NSDictionary*)toDictionary:(NSDictionary*)withFields;
- (NSNumber*)getDateAsNumber:(ABPropertyID)datePropId;
- (NSObject*)extractName;
- (NSObject*)extractMultiValue:(NSString*)propertyId;
- (NSObject*)extractAddresses;
- (NSObject*)extractIms;
- (NSObject*)extractOrganizations;
- (NSObject*)extractPhotos;

- (NSMutableDictionary*)translateW3Dict:(NSDictionary*)dict forProperty:(ABPropertyID)prop;
- (bool)setMultiValueStrings:(NSArray*)fieldArray forProperty:(ABPropertyID)prop inRecord:(ABRecordRef)person asUpdate:(BOOL)bUpdate;
- (bool)setMultiValueDictionary:(NSArray*)array forProperty:(ABPropertyID)prop inRecord:(ABRecordRef)person asUpdate:(BOOL)bUpdate;
- (ABMultiValueRef)allocStringMultiValueFromArray:array;
- (ABMultiValueRef)allocDictMultiValueFromArray:array forProperty:(ABPropertyID)prop;
- (BOOL)foundValue:(NSString*)testValue inFields:(NSDictionary*)searchFields;
- (BOOL)testStringValue:(NSString*)testValue forW3CProperty:(NSString*)property;
- (BOOL)testDateValue:(NSString*)testValue forW3CProperty:(NSString*)property;
- (BOOL)searchContactFields:(NSArray*)fields forMVStringProperty:(ABPropertyID)propId withValue:testValue;
- (BOOL)testMultiValueStrings:(NSString*)testValue forProperty:(ABPropertyID)propId ofType:(NSString*)type;
- (NSArray*)valuesForProperty:(ABPropertyID)propId inRecord:(ABRecordRef)aRecord;
- (NSArray*)labelsForProperty:(ABPropertyID)propId inRecord:(ABRecordRef)aRecord;
- (BOOL)searchContactFields:(NSArray*)fields forMVDictionaryProperty:(ABPropertyID)propId withValue:(NSString*)testValue;

@end

// generic ContactField types
#define qhContactFieldType @"type"
#define qhContactFieldValue @"value"
#define qhContactFieldPrimary @"pref"
// Various labels for ContactField types
#define qhContactWorkLabel @"work"
#define qhContactHomeLabel @"home"
#define qhContactOtherLabel @"other"
#define qhContactPhoneWorkFaxLabel @"work fax"
#define qhContactPhoneHomeFaxLabel @"home fax"
#define qhContactPhoneMobileLabel @"mobile"
#define qhContactPhonePagerLabel @"pager"
#define qhContactPhoneIPhoneLabel @"iphone"
#define qhContactPhoneMainLabel @"main"
#define qhContactUrlBlog @"blog"
#define qhContactUrlProfile @"profile"
#define qhContactImAIMLabel @"aim"
#define qhContactImICQLabel @"icq"
#define qhContactImMSNLabel @"msn"
#define qhContactImYahooLabel @"yahoo"
#define qhContactImSkypeLabel @"skype"
#define qhContactImFacebookMessengerLabel @"facebook"
#define qhContactImGoogleTalkLabel @"gtalk"
#define qhContactImJabberLabel @"jabber"
#define qhContactImQQLabel @"qq"
#define qhContactImGaduLabel @"gadu"  
#define qhContactFieldId @"id"
// special translation for IM field value and type
#define qhContactImType @"type"
#define qhContactImValue @"value"

// Contact object
#define qhContactId @"id"
#define qhContactName @"name"
#define qhContactFormattedName @"formatted"
#define qhContactGivenName @"givenName"
#define qhContactFamilyName @"familyName"
#define qhContactMiddleName @"middleName"
#define qhContactHonorificPrefix @"honorificPrefix"
#define qhContactHonorificSuffix @"honorificSuffix"
#define qhContactDisplayName @"displayName"
#define qhContactNickname @"nickname"
#define qhContactPhoneNumbers @"phoneNumbers"
#define qhContactAddresses @"addresses"
#define qhContactAddressFormatted @"formatted"
#define qhContactStreetAddress @"streetAddress"
#define qhContactLocality @"locality"
#define qhContactRegion @"region"
#define qhContactPostalCode @"postalCode"
#define qhContactCountry @"country"
#define qhContactEmails @"emails"
#define qhContactIms @"ims"
#define qhContactOrganizations @"organizations"
#define qhContactOrganizationName @"name"
#define qhContactTitle @"title"
#define qhContactDepartment @"department"
#define qhContactBirthday @"birthday"
#define qhContactNote @"note"
#define qhContactPhotos @"photos"
#define qhContactCategories @"categories"
#define qhContactUrls @"urls"
