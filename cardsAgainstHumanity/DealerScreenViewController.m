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

#pragma mark - View lifecycle

- (IBAction)pageInfo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                    message:@"Do you want to declare this card as the winner of this round?"
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:@"No", nil];
    
    [alert show];
    
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

    // Big Card
    NSString *imageName = [NSString stringWithFormat:@"image1.jpg"];
    
    UIImage *image = [UIImage imageNamed:imageName];
    mainCard.image = image;
    
    // Card 1
    imageName = [NSString stringWithFormat:@"image1.jpg"];
    image = [UIImage imageNamed:imageName];
    cardOne.image = image;
    
    // Card 2
    imageName = [NSString stringWithFormat:@"image1.jpg"];
    image = [UIImage imageNamed:imageName];
    cardTwo.image = image;
    
    // Card 3
    imageName = [NSString stringWithFormat:@"image1.jpg"];
    image = [UIImage imageNamed:imageName];
    cardThree.image = image;
    
    // Card 4
    imageName = [NSString stringWithFormat:@"image1.jpg"];
    image = [UIImage imageNamed:imageName];
    cardFour.image = image;
}


- (void)setupHorizontalScrollView
{
    
}


@end
