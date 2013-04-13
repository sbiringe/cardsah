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
