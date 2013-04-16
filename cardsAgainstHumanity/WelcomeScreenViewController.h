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

extern NSString *dealer;
extern NSString *username;
extern NSInputStream *inputStream;
extern NSOutputStream *outputStream;
extern NSString *ipAddress;
extern NSString *winningCard;
extern NSMutableArray *userList;


@interface WelcomeScreenViewController : UIViewController <UITextFieldDelegate, NSStreamDelegate>
{    
    bool intReceived;
    int numToReceive;
    int numReceived;
}

@property (weak, nonatomic) NSString *username;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

//asfsadasd
//fafsfafasfasdfasdfadsfa

@end
