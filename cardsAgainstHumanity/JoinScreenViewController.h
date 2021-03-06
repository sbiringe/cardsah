//
//  JoinScreenViewController.h
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 3/31/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelcomeScreenViewController.h"
#import "SettingsScreenViewController.h"

extern NSMutableDictionary *playerScores;
extern NSString *dealer;
extern bool youAreDealer;
extern NSMutableArray *pCardImages;
extern NSMutableArray *dCardImages;
extern unsigned int curDIndex;
extern unsigned int curPIndex;
extern NSMutableArray *playedUsernames;
extern NSMutableArray *playedCards;
extern int currentRound;
extern int totalPCards;
extern int totalDCards;
extern int indexInUserList;

@interface JoinScreenViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSStreamDelegate>
{
    int minPlayers;
    bool getTurnBool;
    bool randomSeedReceived;
    bool intReceived;
    int numToReceive;
    int randomSeed;
    int numReceived;
    int numShuffles;
}

@property (weak, nonatomic) IBOutlet UITableView *playersTableView;
@property (nonatomic) int cardPerHand;
@property (nonatomic) int scoreToWin;
@property (weak, nonatomic) NSString *terminateCondition;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIImageView *connImage;


@end
