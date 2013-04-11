//
//  DealerScreenViewController.h
//  cardsAgainstHumanity
//
//  Created by Asad Saleem Qureshi on 4/11/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealerScreenViewController : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *mainCard;

@property (weak, nonatomic) IBOutlet UIImageView *cardOne;

@property (weak, nonatomic) IBOutlet UIImageView *cardTwo;

@property (weak, nonatomic) IBOutlet UIImageView *cardThree;

@property (weak, nonatomic) IBOutlet UIImageView *cardFour;

-(IBAction)pageInfo;

@end
