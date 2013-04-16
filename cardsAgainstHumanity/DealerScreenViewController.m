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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSString *msg = [NSString stringWithFormat:@"%@", @"imageFileName"];
        NSData *data = [self convertToJavaUTF8:msg];
        [outputStream write:(const uint8_t *)[data bytes] maxLength:[data length]];
        [self performSegueWithIdentifier:@"goToPlayerScreen" sender:nil];
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
    
    [outputStream setDelegate:self];
    
    cardOne.hidden = YES;
    cardTwo.hidden = YES;
    cardThree.hidden = YES;
    cardFour.hidden = YES;

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
            imageName = [playedCards objectAtIndex:i];
            image = [UIImage imageNamed:imageName];
            cardOne.image = image;
        }
        if (i==1)
        {
            // Card 2
            cardTwo.hidden = NO;
            imageName = [playedCards objectAtIndex:i];
            image = [UIImage imageNamed:imageName];
            cardTwo.image = image;
        }
        if (i==2)
        {
            // Card 3
            cardThree.hidden = NO;
            imageName = [playedCards objectAtIndex:i];
            image = [UIImage imageNamed:imageName];
            cardThree.image = image;
        }
        if (i==3)
        {
            // Card 4
            cardFour.hidden = NO;
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
