//
//  DealerScreenViewController.h
//  cardsAgainstHumanity
//
//  Created by Asad Saleem Qureshi on 4/11/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelcomeScreenViewController.h"
#import "PlayerViewController.h"
#import "SettingsScreenViewController.h"

extern NSString *winnerIsUser;
extern bool winnerDecided;

@interface DealerScreenViewController : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate, NSStreamDelegate>
{
    bool goBackToPlayerView;
}

@property (weak, nonatomic) UIPageViewController *playerScreen;
@property (weak, nonatomic) IBOutlet UIImageView *mainCard;
@property (weak, nonatomic) IBOutlet UIButton *Card1Button;
@property (weak, nonatomic) IBOutlet UIButton *Card2Button;
@property (weak, nonatomic) IBOutlet UIButton *Card3Button;
@property (weak, nonatomic) IBOutlet UIButton *Card4Button;
@property (weak, nonatomic) IBOutlet UIImageView *cardOne;
@property (weak, nonatomic) IBOutlet UIImageView *cardTwo;
@property (weak, nonatomic) IBOutlet UIImageView *cardThree;
@property (weak, nonatomic) IBOutlet UIImageView *cardFour;

-(IBAction)pageInfo;

@end
