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
@synthesize mainCard, cardOne, cardTwo, cardThree, cardFour;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
