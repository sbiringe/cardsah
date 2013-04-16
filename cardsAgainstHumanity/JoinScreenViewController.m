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
NSMutableArray *userList;
NSMutableArray *pCardImages;
NSMutableArray *dCardImages;
unsigned int curDIndex;
unsigned int curPIndex;

@interface JoinScreenViewController ()

@end

@implementation JoinScreenViewController

@synthesize playersTableView;

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
    randomSeedReceived = false;
    youAreDealer = false;
    numReceived = 0;
    randomSeed = 0;
    numToReceive = 0;
    
    tempUser = [[NSMutableString alloc] init];
    
    playerScores = [[NSMutableDictionary alloc] init];
    pCardImages = [[NSMutableArray alloc] init];
    dCardImages = [[NSMutableArray alloc] init];
    
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
                int i;
                
                len -= 4;
                [data getBytes: &i length: sizeof(i)];
                
                randomSeed = ntohl(i);
                
                NSLog(@"%i", randomSeed);
                
                NSMutableData *dataBool = [[NSMutableData alloc] initWithCapacity:20];
                
                uint8_t bufBool[1024];
                range = NSMakeRange(4, len);
                [data getBytes:bufBool range:range];
                [dataBool appendBytes:(const void *)bufBool length:len];
                
                
                [dataBool getBytes: &youAreDealer length: sizeof(youAreDealer)];
                
                [self initAndShuffleDecks];
                
                [self performSegueWithIdentifier:@"beginGame" sender:nil];
                return;
            }
            
            if(!intReceived)
            {
                if(len)
                {
                    intReceived = true;
                    numReceived = 0;
                    
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
                    [userList removeAllObjects];
                    
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
            
            //len = [(NSInputStream *)stream read:buf maxLength:1024];
            
            NSMutableData *data1 = [[NSMutableData alloc] initWithCapacity:20];
            
            uint8_t buf1[1024];
            
            [data getBytes:buf1 range:range];
            
            [data1 appendBytes:(const void *)buf1 length:len];
            
            NSString *user = [[NSString alloc] initWithData:data1 encoding:NSASCIIStringEncoding];
            
            int index = 0;
            
            while(len > 0)
            {
                while([user characterAtIndex:index])
                {
                    [tempUser appendString:[NSString stringWithFormat: @"%C",[user characterAtIndex:index]]];
                    index++;
                    len--;
                    if(len == 0)
                        return;
                }
                
                index++;
                len -= index;
                
                NSLog(@"%@", tempUser);
                [userList addObject:tempUser];
                
                tempUser = [[NSMutableString alloc] init];
                
                [playerScores setObject:[NSNumber numberWithInt:0] forKey:tempUser];
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

-(void)initAndShuffleDecks
{
    curDIndex = 0;
    for (int i = 0; i < userList.count; i++)
    {
        if ([[userList objectAtIndex:i] isEqualToString:username])
        {
            curPIndex = i*5;
            break;
        }
    }
    
    //Initialize 'pCardImages' array
    for (int i = 1; i <= 152; i++)
    {
        NSString *addPCard = [NSString stringWithFormat:@"PCard%i.png",i];
        [pCardImages addObject:addPCard];
    }
    
    //Initialize 'dCardImages' array
    for (int j = 1; j <= 56; j++)
    {
        NSString *addDCard = [NSString stringWithFormat:@"DCard%i.png",j];
        [dCardImages addObject:addDCard];
    }
    
    srand(randomSeed);
    
    for(int i = 0; i < 500; ++i)
    {
        int rand1 = rand() % [pCardImages count];
        int rand2 = rand() % [pCardImages count];
        
        while(rand1 == rand2)
        {
            rand1 = rand() % [pCardImages count];
            rand2 = rand() % [pCardImages count];
        }
        
        NSString *temp = [pCardImages objectAtIndex:rand1];
        
        [pCardImages setObject:[pCardImages objectAtIndex:rand2] atIndexedSubscript:rand1];
        [pCardImages setObject:temp atIndexedSubscript:rand2];
    }

    for(int i = 0; i < 500; ++i)
    {
        int rand1 = rand() % [dCardImages count];
        int rand2 = rand() % [dCardImages count];
        
        while(rand1 == rand2)
        {
            rand1 = rand() % [dCardImages count];
            rand2 = rand() % [dCardImages count];
        }
        
        NSString *temp = [dCardImages objectAtIndex:rand1];
        
        [dCardImages setObject:[dCardImages objectAtIndex:rand2] atIndexedSubscript:rand1];
        [dCardImages setObject:temp atIndexedSubscript:rand2];
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
