//
//  DealerScreenViewController.m
//  cardsAgainstHumanity
//
//  Created by Asad Saleem Qureshi on 4/11/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "DealerScreenViewController.h"

@implementation DealerScreenViewController

@synthesize mainCard;
@synthesize cardOne;
@synthesize cardTwo;
@synthesize cardThree;
@synthesize cardFour;
@synthesize Card1Button, Card2Button, Card3Button, Card4Button;
@synthesize playerScreen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSData*) convertToJavaUTF8 : (NSString*) str
{
    NSUInteger len = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    Byte buffer[2];
    buffer[0] = (0xff & (len >> 8));
    buffer[1] = (0xff & len);
    NSMutableData *outData = [NSMutableData dataWithCapacity:2];
    [outData appendBytes:buffer length:2];
    [outData appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    return outData;
}

#pragma mark - View lifecycle

- (IBAction)pageInfo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                    message:@"Do you want to declare this card as the winner of this round?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    
    [alert show];
    
}
- (IBAction)Button1Press:(id)sender {
    [winningCard setString:[playedCards objectAtIndex:0]];
}

- (IBAction)Button2Press:(id)sender {
    [winningCard setString:[playedCards objectAtIndex:1]];
}

- (IBAction)Button3Press:(id)sender {
    [winningCard setString:[playedCards objectAtIndex:2]];
}

- (IBAction)Button4Press:(id)sender {
    [winningCard setString:[playedCards objectAtIndex:3]];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        int winningIndex = 0;
        
        for(int i = 0; i < playedCards.count; i++)
        {
            if([winningCard isEqualToString:[playedCards objectAtIndex:i]])
            {
                winningIndex = i;
                break;
            }
        }
        
        NSString *winningUser = [playedUsernames objectAtIndex:winningIndex];
        
        int newScore = [[playerScores objectForKey:winningUser] intValue] + 1;
        [playerScores setObject:[NSNumber numberWithInt:newScore] forKey:winningUser];
        
        NSString *msg = [NSString stringWithFormat:@"%@", winningCard];
        NSData *data = [self convertToJavaUTF8:msg];
        [outputStream write:(const uint8_t *)[data bytes] maxLength:[data length]];
        goBackToPlayerView = true;
        [self performSegueWithIdentifier:@"gotoWinningScreen" sender:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if(goBackToPlayerView)
    {
        goBackToPlayerView = false;
        [self dismissViewControllerAnimated:NO completion:^{}];

    }
}

/*
- (void)selectWinner:(UIAlertView *)sender 
{
    sender.view.alpha = 0.5;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //u need to change 0 to other value(,1,2,3) if u have more buttons.then u can check which button was pressed.
    
    if (buttonIndex == 0)
    {
        [self selectWinner];
    }
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    goBackToPlayerView = false;

    [outputStream setDelegate:self];

    cardOne.hidden = YES;
    Card1Button.hidden = YES;
    cardTwo.hidden = YES;
    Card2Button.hidden = YES;
    cardThree.hidden = YES;
    Card3Button.hidden = YES;
    cardFour.hidden = YES;
    Card4Button.hidden = YES;

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
            Card1Button.hidden = NO;
            imageName = [playedCards objectAtIndex:i];
            image = [UIImage imageNamed:imageName];
            cardOne.image = image;
        }
        if (i==1)
        {
            // Card 2
            cardTwo.hidden = NO;
            Card2Button.hidden = NO;
            imageName = [playedCards objectAtIndex:i];
            image = [UIImage imageNamed:imageName];
            cardTwo.image = image;
        }
        if (i==2)
        {
            // Card 3
            cardThree.hidden = NO;
            Card3Button.hidden = NO;
            imageName = [playedCards objectAtIndex:i];
            image = [UIImage imageNamed:imageName];
            cardThree.image = image;
        }
        if (i==3)
        {
            // Card 4
            cardFour.hidden = NO;
            Card4Button.hidden = NO;
            imageName = [playedCards objectAtIndex:i];
            image = [UIImage imageNamed:imageName];
            cardFour.image = image;
        }
    }
}


- (void)setupHorizontalScrollView
{
    
}


@end
