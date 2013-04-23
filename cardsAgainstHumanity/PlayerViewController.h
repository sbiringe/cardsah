//
// PlayerViewController.h
// cardsAgainstHumanity
//
// Created by Abhinav Jain on 4/4/13.
// Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoinScreenViewController.h"
#import "WelcomeScreenViewController.h"
#import "DealerScreenViewController.h"
#import "WinningScreenViewController.h"

extern UIView *prevTouched;


@interface PlayerViewController : UIViewController <NSStreamDelegate, UIScrollViewAccessibilityDelegate, UIScrollViewDelegate>
{
    int curXOffset;
    
    bool intReceived;
    bool usernameReceived;
    bool winnerSelected;
    
    int numReceived;
    int numToReceive;
    
    int pageIndex;
    
    UILabel *dealerLabel;
    
    int currentDealerIndex;
    
    NSString *submittedUser;
    NSString *submittedCard;
    bool cardSubmitted;
    
    bool horizontalScroll;
    bool verticalScroll;
    bool scoreUpdated;
    
    bool hasSeenDealerAlert;
    bool hasSeenPlayerAlert;
}

@property (weak, nonatomic) IBOutlet UILabel *swipeUpLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIToolbar *playedCardToolbar;
@property (weak, nonatomic) IBOutlet UIImageView *dealerCardImageView;
@property (weak, nonatomic) IBOutlet UILabel *dealerCardLabel;


@end