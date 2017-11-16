//
//  ViewController.m
//  Restoration
//
//  Created by leven on 2017/11/16.
//  Copyright © 2017年 leven. All rights reserved.
//

#import "ViewController.h"

 static NSString *const kMessageRestorationKey = @"kMessageRestorationKey";

@interface ViewController ()<UITextFieldDelegate,
UIViewControllerRestoration>

@property (strong, nonatomic) IBOutlet UITextField *messageInput;

@property (nonatomic, copy) NSString *message;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restorationClass = [ViewController class];
    self.restorationIdentifier = @"ViewController";
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
    NSLog(@"%@",NSStringFromSelector(_cmd));
    ViewController* vc = nil;
    UIStoryboard* sb = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
    if (sb) {
        vc = (ViewController*)[sb instantiateViewControllerWithIdentifier:@"ViewController"];
        vc.restorationIdentifier = [identifierComponents lastObject];
        vc.restorationClass = [ViewController class];
    }
    return vc;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_messageInput becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
