//
//  ContactsHandler.m
//  GoHaier
//
//  Created by niuxinghua on 2019/2/21.
//  Copyright © 2019年 com.haier. All rights reserved.
//

#import "ContactsHandler.h"
#import <ContactsUI/ContactsUI.h>
#import "ViewControllerUtil.h"
static ContactsHandler *sharedInstance;
@interface ContactsHandler()<CNContactPickerDelegate>

@end
@implementation ContactsHandler
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc]init];
    });
    return sharedInstance;
}
- (NSString *)handlerKey
{
    return @"ghaier_readContacts";
}
- (void)handlerMethod:(id)data
{
    NSLog(@"handler key %@ method called",[self handlerKey]);
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (error) {
                NSLog(@"没有授权, 需要去设置中心设置授权");
            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"用户已授权限");
                    CNContactPickerViewController * picker = [CNContactPickerViewController new];
                    picker.delegate = self;
                    // 加载手机号
                    picker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[ViewControllerUtil sharedInstance]topViewController] presentViewController: picker  animated:YES completion:nil];
                    });
                });
                
            }
        }];
    }
    
    if (status == CNAuthorizationStatusAuthorized) {
        
        //有权限时
        dispatch_async(dispatch_get_main_queue(), ^{
            CNContactPickerViewController * picker = [CNContactPickerViewController new];
            picker.delegate = self;
            picker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
            [[[ViewControllerUtil sharedInstance]topViewController] presentViewController: picker  animated:YES completion:nil];
        });
       
    }
    else{
        NSLog(@"您未开启通讯录权限,请前往设置中心开启");
    }
}
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    
}

/*!
 * @abstract    Singular delegate methods.
 * @discussion  These delegate methods will be invoked when the user selects a single contact or property.
 */
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    NSMutableArray *phoneNumbers = [NSMutableArray array];
    for (CNLabeledValue *labeledValue in contact.phoneNumbers){
        CNPhoneNumber *phoneValue = labeledValue.value;
        NSString * phoneNumber = phoneValue.stringValue;
        [phoneNumbers addObject:phoneNumber];
    }
    [self respondToWeb:@{@"phoneNumbers":phoneNumbers}];
}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    
}



@end
