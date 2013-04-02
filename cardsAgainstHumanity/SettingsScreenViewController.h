//
//  SettingsScreenViewController.h
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 3/31/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoinScreenViewController.h"

@interface SettingsScreenViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSString *terminateCondition;
    NSMutableArray *terminationConds;
}

@property (weak, nonatomic) IBOutlet UITextField *cardsPerHandTextField;
@property (weak, nonatomic) IBOutlet UITextField *winningScoreTextField;
@property (weak, nonatomic) IBOutlet UITableView *rulesTableView;


@end
