//
//  FinalScreenViewController.m
//  cardsAgainstHumanity
//
//  Created by Abhinav Jain on 4/18/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "FinalScreenViewController.h"

@interface FinalScreenViewController ()

@end

@implementation FinalScreenViewController

@synthesize WinnerLabel, finalTableView;

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
}

-(void)viewDidAppear:(BOOL)animated
{
    [finalTableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"joinList";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    NSArray *sorted = [[playerScores allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[playerScores objectForKey:obj2] compare:[playerScores objectForKey:obj1]];
    }];
    
    if (tie)
    {
        WinnerLabel.text = @"We have a tie!";
    }
    else
    {
        NSMutableString *curWinner;
        [curWinner appendString:@"Winner is "];
        [curWinner appendString:winnerIsUser];
        WinnerLabel.text = curWinner;
    }
    
    NSString *cellValue = [sorted objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    cell.detailTextLabel.text = [[playerScores objectForKey:cellValue] stringValue];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    return cell;
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
                
                [finalTableView reloadData];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [playerScores count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
