//
//  JoinScreenViewController.m
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 3/31/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "JoinScreenViewController.h"

NSMutableDictionary *playerScores;
NSString *dealer;

@interface JoinScreenViewController ()

@end

@implementation JoinScreenViewController

@synthesize playersTableView, userList;

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
    
    intReceived = false;
    numReceived = 0;
    numToReceive = 0;
    
    playerScores = [[NSMutableDictionary alloc] init];

    playersTableView.dataSource = self;
    playersTableView.delegate = self;
    
    [playersTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"joinList";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    NSString *cellValue = [userList objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    
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

            if(!intReceived)
            {
                if(len)
                {
                    intReceived = true;
                    numReceived = 0;
                    
                    [userList removeAllObjects];
                    
                    int i;
                    [data getBytes: &i length: sizeof(i)];
                                    
                    numToReceive = ntohl(i);
                    NSLog(@"%i", ntohl(i));
                }
                else
                {
                    NSLog(@"no buffer!");
                }
            }
            else
            {
                numReceived++;
                
                NSString *user = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                [userList addObject:user];
                [playerScores setObject:[NSNumber numberWithInt:0] forKey:user];
                
                if(numReceived == numToReceive)
                {
                    intReceived = false;
                    dealer = user;
                    [playersTableView reloadData];
                }
            }
            
            break;
            
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userList count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
