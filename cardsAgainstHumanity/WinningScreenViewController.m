//
//  WinningScreenViewController.m
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 4/13/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "WinningScreenViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WinningScreenViewController ()

@end

@implementation WinningScreenViewController
@synthesize mainCard, cardOne, cardTwo, cardThree, cardFour, cardOneLabel, cardTwoLabel, cardThreeLabel, cardFourLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //[outputStream setDelegate:self];
    cardOne.hidden = YES;
    cardOneLabel.hidden = YES;
    cardTwo.hidden = YES;
    cardTwoLabel.hidden = YES;
    cardThree.hidden = YES;
    cardThreeLabel.hidden = YES;
    cardFour.hidden = YES;
    cardFourLabel.hidden = YES;
    
    // Big Card
    NSString *imageName = [dCardImages objectAtIndex:curDIndex];
    
    UIImage *image = [UIImage imageNamed:imageName];
    mainCard.image = image;
    
    for (int i = 0; i < userList.count-1; i++)
    {
        NSString *curUsername = [playedUsernames objectAtIndex:i];
        if (youAreDealer && [curUsername isEqualToString:username])
        {
            continue;
        }
        if (i==0)
        {
            // Card 1
            cardOne.hidden = NO;
            cardOneLabel.hidden = NO;
            cardOneLabel.text = [playedUsernames objectAtIndex:i];
            imageName = [playedCards objectAtIndex:i];
            image = [UIImage imageNamed:imageName];
            cardOne.image = image;
            if ([imageName isEqualToString:winningCard])
            {
                [cardOne.layer setBorderColor: [[UIColor blueColor] CGColor]];
                [cardOne.layer setBorderWidth: 5.0];
                cardOneLabel.textColor = [UIColor blueColor];
            }
        }
        if (i==1)
        {
            // Card 2
            cardTwo.hidden = NO;
            cardTwoLabel.hidden = NO;
            cardTwoLabel.text = [playedUsernames objectAtIndex:i];
            imageName = [playedCards objectAtIndex:i];
            image = [UIImage imageNamed:imageName];
            cardTwo.image = image;
            if ([imageName isEqualToString:winningCard])
            {
                [cardTwo.layer setBorderColor: [[UIColor blueColor] CGColor]];
                [cardTwo.layer setBorderWidth: 5.0];
                cardTwoLabel.textColor = [UIColor blueColor];
            }
        }
        if (i==2)
        {
            // Card 3
            cardThree.hidden = NO;
            cardThreeLabel.hidden = NO;
            cardThreeLabel.text = [playedUsernames objectAtIndex:i];
            imageName = [playedCards objectAtIndex:i];
            image = [UIImage imageNamed:imageName];
            cardThree.image = image;
            if ([imageName isEqualToString:winningCard])
            {
                [cardThree.layer setBorderColor: [[UIColor blueColor] CGColor]];
                [cardThree.layer setBorderWidth: 5.0];
                cardThreeLabel.textColor = [UIColor blueColor];
            }
        }
        if (i==3)
        {
            // Card 4
            cardFour.hidden = NO;
            cardFourLabel.hidden = NO;
            cardFourLabel.text = [playedUsernames objectAtIndex:i];
            imageName = [playedCards objectAtIndex:i];
            image = [UIImage imageNamed:imageName];
            cardFour.image = image;
            if ([imageName isEqualToString:winningCard])
            {
                [cardFour.layer setBorderColor: [[UIColor blueColor] CGColor]];
                [cardFour.layer setBorderWidth: 5.0];
                cardFourLabel.textColor = [UIColor blueColor];
            }
        }
    }
}

- (IBAction)nextClicked:(id)sender
{
    [playedCards removeAllObjects];
    [playedUsernames removeAllObjects];
    
    if(youAreDealer)
        [self dismissViewControllerAnimated:NO completion:^{}];
    else
         [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
