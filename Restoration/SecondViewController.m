//
//  SecondViewController.m
//  Restoration
//
//  Created by leven on 2017/11/16.
//  Copyright © 2017年 leven. All rights reserved.
//

#import "SecondViewController.h"

static NSString *const kMessageRestorationKey = @"kMessageRestorationKey";

@interface SecondViewController ()<
UIViewControllerRestoration>
@property (strong, nonatomic) IBOutlet UITextField *messageInput;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restorationClass = [SecondViewController class];
    self.restorationIdentifier = @"SecondViewController";
}

- (void) encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeObject:_messageInput.text forKey:kMessageRestorationKey];
}

- (void) decodeRestorableStateWithCoder:(NSCoder *)coder{
    [super decodeRestorableStateWithCoder:coder];
    self.messageInput.text = [coder decodeObjectForKey:kMessageRestorationKey];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    SecondViewController* vc = nil;
    UIStoryboard* sb = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
    if (sb) {
        vc = (SecondViewController*)[sb instantiateViewControllerWithIdentifier:@"SecondViewController"];
        vc.restorationIdentifier = [identifierComponents lastObject];
        vc.restorationClass = [SecondViewController class];
    }
    return vc;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_messageInput becomeFirstResponder];
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
