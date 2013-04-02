//
//  LaunchScreenViewController.m
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 3/31/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "LaunchScreenViewController.h"

@interface LaunchScreenViewController ()

@end

@implementation LaunchScreenViewController
@synthesize joinButton, startButton, username;

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
    
    startAlreadyPressed = false;
    joinButton.enabled = NO;
}

- (IBAction)joinPressed:(id)sender
{
    // If game has already started then display error message
    /*
    if(gameHasStarted)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Already In Progress"
                                                    message:@"Please wait and try again."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        [alert show];
     }
     else if(startAlreadyPressed)
     {
        [self performSegueWithIdentifier:@"startSegue" sender:sender];
     }
     else
     {
        [self performSegueWithIdentifier:@"joinSegue" sender:sender];
     }

     */
    
}

- (IBAction)startPressed:(id)sender
{
    // Might have to store on server if someone has pressed start
    if(startAlreadyPressed)
        [self performSegueWithIdentifier:@"joinSegue" sender:sender];
    else
    {
        joinButton.enabled = YES;
        startAlreadyPressed = true;
        [self performSegueWithIdentifier:@"startSegue" sender:sender];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
