//
//  LeaderboardViewController.h
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 4/7/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoinScreenViewController.h"
#import "WelcomeScreenViewController.h"
#import "WelcomeScreenViewController.h"

@interface LeaderboardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSStreamDelegate>
{
    bool scoreUpdated;
}

@property (weak, nonatomic) IBOutlet UITableView *playerScoresTableView;

@end
