//
//  JoinScreenViewController.h
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 3/31/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinScreenViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *userList;
}

@property (weak, nonatomic) IBOutlet UITableView *playersTableView;
@property (nonatomic) int cardPerHand;
@property (nonatomic) int scoreToWin;
@property (weak, nonatomic) NSString *terminateCondition;

@property (weak, nonatomic) IBOutlet UIButton *startButton;


@end
