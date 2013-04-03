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
	// Do any additional setup after loading the view.
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
