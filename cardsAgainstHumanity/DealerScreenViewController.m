//
//  DealerScreenViewController.m
//  cardsAgainstHumanity
//
//  Created by Asad Saleem Qureshi on 4/11/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "DealerScreenViewController.h"

@implementation DealerScreenViewController

@synthesize imageView;

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
                                          otherButtonTitles:nil];
    
    [alert show];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImage *plate1 = [UIImage imageNamed:@"King.jpg"];
    [imageView setImage:plate1];
}

- (void)setupHorizontalScrollView
{
    
}


@end
