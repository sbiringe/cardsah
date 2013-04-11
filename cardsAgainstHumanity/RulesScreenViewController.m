//
//  RulesScreenViewController.m
//  cardsAgainstHumanity
//
//  Created by Abhinav Jain on 4/2/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "SettingsScreenViewController.h"
#import "RulesScreenViewController.h"

@interface RulesScreenViewController ()

@end

@implementation RulesScreenViewController

@synthesize cardsPerHandLabel, scoreToWinLabel, terminateLabel, RulesTView;

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
    
    scoreUpdated = false;
    
    RulesTView.text = @"Cards Per Hand:";
    NSString *str;
    NSMutableString *temp = [NSMutableString string];
    str = [NSString stringWithFormat:@"%d",cPH];
    [temp appendString:@" "];
    [temp appendString:str];
    RulesTView.text = [RulesTView.text stringByAppendingString:temp];
    RulesTView.text = [RulesTView.text stringByAppendingString:@"\n"];
    RulesTView.text = [RulesTView.text stringByAppendingString:@"\n"];
    
    RulesTView.text = [RulesTView.text stringByAppendingString:@"Winner is decided by:"];
    RulesTView.text = [RulesTView.text stringByAppendingString:@"\n"];
    
    
    NSLog(@"%@",endGameCond);
    if ([endGameCond isEqualToString:@"Play to Score"])
    {
        RulesTView.text = [RulesTView.text stringByAppendingString:endGameCond];
        NSString *str2;
        NSMutableString *temp2 = [NSMutableString string];
        str2 = [NSString stringWithFormat:@"%d",winScore];
        [temp2 appendString:@" "];
        [temp2 appendString:str2];
        RulesTView.text = [RulesTView.text stringByAppendingString:temp2];
        
    }
    else if ([endGameCond isEqualToString:@"Run out of Cards"])
    {
        RulesTView.text = [RulesTView.text stringByAppendingString:endGameCond];
        RulesTView.text = [RulesTView.text stringByAppendingString:@" "];
        
    }
    else if ([endGameCond isEqualToString:@"Play Forever!"])
    {
        RulesTView.text = [RulesTView.text stringByAppendingString:endGameCond];
        RulesTView.text = [RulesTView.text stringByAppendingString:@" "];
        
    }
    
    
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{
    switch(eventCode) {
            
        case NSStreamEventHasBytesAvailable:
        {
            NSMutableData *data = [[NSMutableData alloc] init];
            uint8_t buf[1024];
            
            unsigned int len = 0;
            
            len = [(NSInputStream *)stream read:buf maxLength:1024];
            
            [data appendBytes:(const void *)buf length:len];
            
            NSString *user = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            
            if(!scoreUpdated)
            {
                scoreUpdated = true;
                int newScore = [[playerScores objectForKey:user] intValue] + 1;
                [playerScores setObject:[NSNumber numberWithInt:newScore] forKey:user];
            }
            else
            {
                scoreUpdated = false;
                
                dealer = user;
                // Go to view results screen
                //[self performSegueWithIdentifier:@"" sender:nil]
            }
            
            
            break;
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
