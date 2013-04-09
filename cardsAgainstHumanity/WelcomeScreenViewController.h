//
//  WelcomeScreenViewController.h
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 3/31/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <netinet/in.h>
#import "JoinScreenViewController.h"
#import "SettingsScreenViewController.h"

extern NSString *username;

@interface WelcomeScreenViewController : UIViewController <UITextFieldDelegate, NSStreamDelegate>
{
    NSMutableArray *userList;
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    bool intReceived;
    int numToReceive;
    int numReceived;
}

@property (weak, nonatomic) NSString *username;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

//asfsadasd
//fafsfafasfasdfasdfadsfa

@end
