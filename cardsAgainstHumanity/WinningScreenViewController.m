//
//  WinningScreenViewController.m
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 4/13/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "WinningScreenViewController.h"

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
    NSString *imageName = [NSString stringWithFormat:@"DCard1.jpg"];
    
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
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [playedCards removeAllObjects];
    [playedUsernames removeAllObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
