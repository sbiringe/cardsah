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

extern UIView *prevTouched;
extern unsigned int curDIndex;
extern unsigned int curPIndex;

@interface PlayerViewController : UIViewController <NSStreamDelegate, UIScrollViewAccessibilityDelegate, UIScrollViewDelegate>
{
    NSMutableArray *pCardImages;
    NSMutableArray *dCardImages;
    NSMutableArray *usernames;
    NSMutableArray *userCards;
    
    int curXOffset;
    
    bool intReceived;
    bool usernameReceived;
    bool winnerSelected;
    
    int numReceived;
    int numToReceive;
    
    
    NSString *submittedUser;
    NSString *submittedCard;
    
    bool horizontalScroll;
    bool verticalScroll;
    bool scoreUpdated;
}

@property (weak, nonatomic) IBOutlet UILabel *swipeUpLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIToolbar *playedCardToolbar;
@property (weak, nonatomic) IBOutlet UIImageView *dealerCardImageView;


@end