//
//  WinningScreenViewController.h
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 4/13/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelcomeScreenViewController.h"
#import "PlayerViewController.h"

@interface WinningScreenViewController : UIViewController<UIScrollViewAccessibilityDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *mainCard;
@property (weak, nonatomic) IBOutlet UIImageView *cardOne;
@property (weak, nonatomic) IBOutlet UILabel *cardOneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardTwo;
@property (weak, nonatomic) IBOutlet UILabel *cardTwoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardThree;
@property (weak, nonatomic) IBOutlet UILabel *cardThreeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardFour;
@property (weak, nonatomic) IBOutlet UILabel *cardFourLabel;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) UIScrollView *mainScrollView;

@end
