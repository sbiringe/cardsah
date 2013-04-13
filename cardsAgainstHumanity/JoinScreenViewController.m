//
//  JoinScreenViewController.m
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 3/31/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "JoinScreenViewController.h"

NSMutableDictionary *playerScores;
bool youAreDealer;

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
    getTurnBool = false;
    numReceived = 0;
    numToReceive = 0;
    
    playerScores = [[NSMutableDictionary alloc] init];
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];

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

- (IBAction)startGameClicked:(id)sender
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)ipAddress, 4041, &readStream, &writeStream);
    
    NSInputStream *inputStream1 = (__bridge NSInputStream *)readStream;
    NSInputStream *outputStream1 = (__bridge NSOutputStream *)writeStream;
    
    [inputStream1 setDelegate:self];
    [outputStream1 setDelegate:self];
    
    [inputStream1 scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream1 scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream1 open];
    [outputStream1 open];

}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{
    switch(eventCode)
    {
        case NSStreamEventHasBytesAvailable:
        {
            NSMutableData *data = [[NSMutableData alloc] init];
            uint8_t buf[1024];
            
            int len = 0;
            
            len = [(NSInputStream *)stream read:buf maxLength:1024];
            
            [data appendBytes:(const void *)buf length:len];
            
            NSRange range;
            
            if(getTurnBool)
            {
                [data getBytes: &youAreDealer length: sizeof(youAreDealer)];

                [self performSegueWithIdentifier:@"beginGame" sender:nil];
                return;
            }
            
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
                    NSLog(@"%i", numToReceive);
                    
                    len -= 4;
                    
                    if(numToReceive == -1)
                    {
                        getTurnBool = true;
                        return;
                    }
                    
                    range = NSMakeRange(4, len);
                }
                else
                {
                    NSLog(@"no buffer!");
                }
            }
            else
            {
                range = NSMakeRange(0, len);
            }
            
            if(len <= 0)
                return;
            
            NSMutableString *temp = [[NSMutableString alloc] init];
            //len = [(NSInputStream *)stream read:buf maxLength:1024];
            
            NSMutableData *data1 = [[NSMutableData alloc] initWithCapacity:20];
            
            uint8_t buf1[1024];
            
            [data getBytes:buf1 range:range];
            
            [data1 appendBytes:(const void *)buf1 length:len];
            
            NSString *user = [[NSString alloc] initWithData:data1 encoding:NSASCIIStringEncoding];
            
            int index = 0;
            
            while(len > 0)
            {
                NSMutableString *temp = [[NSMutableString alloc] init];
                
                while([user characterAtIndex:index])
                {
                    [temp appendString:[NSString stringWithFormat: @"%C",[user characterAtIndex:index]]];
                    index++;
                }
                
                index++;
                len -= index;
                
                NSLog(@"%@", temp);
                [userList addObject:temp];
                [playerScores setObject:[NSNumber numberWithInt:0] forKey:temp];
                numReceived++;
            }
            
            
            if(numReceived == numToReceive)
            {
                intReceived = false;
                [playersTableView reloadData];
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
