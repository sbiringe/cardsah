//
//  LaunchScreenViewController.h
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 3/31/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchScreenViewController : UIViewController
{
    bool startAlreadyPressed;
}

@property (strong, nonatomic) NSString *username;

@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end
