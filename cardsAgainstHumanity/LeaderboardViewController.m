//
//  LeaderboardViewController.m
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 4/7/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "LeaderboardViewController.h"

@interface LeaderboardViewController ()

@end

@implementation LeaderboardViewController

@synthesize playerScoresTableView;

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
    
    playerScoresTableView.delegate = self;
    playerScoresTableView.dataSource = self;
    
    scoreUpdated = false;
    
    [playerScoresTableView reloadData];
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
    
    NSString *cellValue = [sorted objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    cell.detailTextLabel.text = [playerScores objectForKey:cellValue];
    
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
        
                [playerScoresTableView reloadData];
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
