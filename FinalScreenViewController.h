//
//  FinalScreenViewController.h
//  cardsAgainstHumanity
//
//  Created by Abhinav Jain on 4/18/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoinScreenViewController.h"
#import "DealerScreenViewController.h"
#import "WinningScreenViewController.h"

@interface FinalScreenViewController : UIViewController
{
    bool scoreUpdated;
}


@property (weak, nonatomic) IBOutlet UILabel *WinnerLabel;
@property (weak, nonatomic) IBOutlet UITableView *finalTableView;

@end
