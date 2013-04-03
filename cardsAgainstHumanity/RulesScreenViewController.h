//
//  RulesScreenViewController.h
//  cardsAgainstHumanity
//
//  Created by Abhinav Jain on 4/2/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RulesScreenViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextView *RulesTView;
@property (retain, nonatomic) UILabel *cardsPerHandLabel;
@property (retain, nonatomic) UILabel *scoreToWinLabel;
@property (retain, nonatomic) UILabel *terminateLabel;



@end
