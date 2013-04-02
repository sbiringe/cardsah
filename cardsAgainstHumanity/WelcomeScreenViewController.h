//
//  WelcomeScreenViewController.h
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 3/31/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaunchScreenViewController.h"

@interface WelcomeScreenViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) NSString *username;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@end
