//
//  SettingsScreenViewController.m
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 3/31/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "SettingsScreenViewController.h"

@interface SettingsScreenViewController ()

@end

@implementation SettingsScreenViewController
@synthesize cardsPerHandTextField, winningScoreTextField, rulesTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"launchSegue"])
    {
        JoinScreenViewController *vc = [segue destinationViewController];
        
        vc.cardPerHand = (int)cardsPerHandTextField.text;
        vc.scoreToWin = (int)winningScoreTextField.text;
        vc.terminateCondition = terminateCondition;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"settingsTable";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    NSString *cellValue = [terminationConds objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [terminationConds count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        terminateCondition = @"Play to Score";
    }
    else if(indexPath.row == 1)
    {
        terminateCondition = @"Run out of Cards";
    }
    else
    {
        terminateCondition = @"Play Forever!";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    terminationConds = [[NSMutableArray alloc] initWithObjects:@"Play to Score", @"Run out of Cards", @"Play Forever!", nil];
    
    rulesTableView.delegate = self;
    rulesTableView.dataSource = self;
    rulesTableView.scrollEnabled = false;

    
    terminateCondition = @"Play to Score";
}

- (void)viewDidAppear:(BOOL)animated
{
    [rulesTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
