//
//  WinningScreenViewController.m
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 4/13/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "WinningScreenViewController.h"
#import <QuartzCore/QuartzCore.h>

bool tie;

@interface WinningScreenViewController ()

@end

@implementation WinningScreenViewController
@synthesize mainCard, cardOne, cardTwo, cardThree, cardFour, cardOneLabel, cardTwoLabel, cardThreeLabel, cardFourLabel;
@synthesize pageIndex, mainScrollView, countDownTimerLabel, nextRoundLabel;

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
	
    nextDealerIndex = 0;
    timerCount = 10;
    
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
                [cardOne.layer setBorderColor: [[UIColor greenColor] CGColor]];
                [cardOne.layer setBorderWidth: 5.0];
                cardOneLabel.textColor = [UIColor greenColor];
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
                [cardTwo.layer setBorderColor: [[UIColor greenColor] CGColor]];
                [cardTwo.layer setBorderWidth: 5.0];
                cardTwoLabel.textColor = [UIColor greenColor];
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
                [cardThree.layer setBorderColor: [[UIColor greenColor] CGColor]];
                [cardThree.layer setBorderWidth: 5.0];
                cardThreeLabel.textColor = [UIColor greenColor];
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
                [cardFour.layer setBorderColor: [[UIColor greenColor] CGColor]];
                [cardFour.layer setBorderWidth: 5.0];
                cardFourLabel.textColor = [UIColor greenColor];
            }
        }
    }
    
    [self updateGameVals];
    
    //Check if game is never ending (Play Forever) and we've gone through either all dealer or player cards
    if ([endGameCond isEqualToString:@"Play Forever!"])
    {
        if ((curPIndex + userList.count) > totalPCards)
        {
            curPIndex = 0;
        }
        if (curDIndex >= totalDCards)
        {
            curDIndex = 0;
        }
    }
    
    
    //Check if game is ended by running out of cards and we've gone through either all dealer or player cards
    if ([endGameCond isEqualToString:@"Run out of Cards"] && (((curPIndex + userList.count) > totalPCards) || (curDIndex >= totalDCards)))
    {
        winnerDecided = TRUE;
        // Set up the cell...
        NSArray *sorted = [[playerScores allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[playerScores objectForKey:obj2] compare:[playerScores objectForKey:obj1]];
        }];
        
        NSString *cellValue1 = [sorted objectAtIndex:0];
        int topScore1 = [[playerScores objectForKey:cellValue1] intValue];
        
        NSString *cellValue2 = [sorted objectAtIndex:1];
        int topScore2 = [[playerScores objectForKey:cellValue2] intValue];
        
        //Check if we have a tie
        if (topScore1 == topScore2)
        {
            tie = true;
        }
        else
        {
            winnerIsUser = cellValue1;
        }
    }
    
    //Check if there is a winner by points, if so, update 'winnerDecided' and 'winnerIsUser'
    if ([endGameCond isEqualToString:@"Play to Score"])
    {
        // Set up the cell...
        NSArray *sorted = [[playerScores allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[playerScores objectForKey:obj2] compare:[playerScores objectForKey:obj1]];
        }];
        
        NSString *cellValue = [sorted objectAtIndex:0];
        int topScore = [[playerScores objectForKey:cellValue] intValue];
        if (topScore == winScore)
        {
            winnerDecided = TRUE;
            winnerIsUser = cellValue;
        }
    }
    
    if (winnerDecided)
    {
        nextRoundLabel.text = @"Winner Displayed In";
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    timerCount = 10;
    
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats: YES];
    
}

- (void)updateGameVals
{
    [playedCards removeAllObjects];
    [playedUsernames removeAllObjects];
    
    currentRound++;
    nextDealerIndex = currentRound % [userList count];
    
    curDIndex++;
    
    if(curDIndex >= totalDCards)
        curDIndex = 0;
    
    int lastDealerIndex = (currentRound - 1) % [userList count];
    
    if(indexInUserList != lastDealerIndex)
    {
        int nextCard = indexInUserList;
        if(lastDealerIndex < indexInUserList)
        {
            nextCard--;
        }
        
        NSString *imageName = [pCardImages objectAtIndex:curPIndex + nextCard];
        NSLog(@"Image added to hand is: %@", imageName);
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        [userCards insertObject:imageName atIndex:pageIndex];
        
        CGFloat width = 200;
        CGFloat height = 250;
        
        CGRect rect = imageView.frame;
        rect.size.height = width;
        rect.size.width = height;
        rect.origin.x = 320 * pageIndex + 35;
        rect.origin.y = 0;
        
        imageView.frame = rect;
        
        [mainScrollView insertSubview:imageView atIndex:pageIndex];
    }
    
    curPIndex += [userList count] - 1;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateCountdown {
    
    if (timerCount == 1)
    {
        [countDownTimer invalidate];
        
        //Check if there is a winner
        if (winnerDecided)
        {
            nextRoundLabel.text = @"Winner Displayed In";
            [self performSegueWithIdentifier:@"GameOver" sender:nil];
        }
        else
        {
            //After timer, take it to next round
            if(youAreDealer)
            {
                youAreDealer = false;
                [self dismissViewControllerAnimated:NO completion:^{}];
            }
            else
            {
                if([[userList objectAtIndex:nextDealerIndex] isEqualToString:username])
                    youAreDealer = true;
                
                [self dismissViewControllerAnimated:YES completion:^{}];
            }
        }
    }
    
    timerCount--;
    countDownTimerLabel.text = [NSString stringWithFormat:@"%d", timerCount];
}

@end
