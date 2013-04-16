//
//  WelcomeScreenViewController.m
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 3/31/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "WelcomeScreenViewController.h"

NSString *dealer;
NSString *username;
NSInputStream *inputStream;
NSOutputStream *outputStream;
NSString *ipAddress;
NSString *winningCard;
NSMutableArray *usernames;
NSMutableArray *userCards;


@interface WelcomeScreenViewController ()

@end

@implementation WelcomeScreenViewController
@synthesize usernameTextField;

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
    
    userList = [[NSMutableArray alloc] init];
    usernames = [[NSMutableArray alloc] init];
    userCards = [[NSMutableArray alloc] init];
    
    usernameTextField.delegate = self;
}

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    ipAddress = @"67.194.101.42";
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)ipAddress, 1024, &readStream, &writeStream);
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
    
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
                     NSLog(@"%C", [user characterAtIndex:index]);
                    [temp appendString:[NSString stringWithFormat: @"%C",[user characterAtIndex:index]]];
                    index++;
                }
                
                index++;
                len -= index;
                
                NSLog(@"%@", temp);
                [userList addObject:temp];
                numReceived++;
            }
            
            if(numToReceive == numReceived)
            {
                if([userList count] > 1)
                {
                    [self performSegueWithIdentifier:@"joinSegue" sender:NULL];
                }
                else
                {
                    [self performSegueWithIdentifier:@"startSegue" sender:NULL];
                }
            }

            break;
        
        }
    }
}

- (NSData*) convertToJavaUTF8 : (NSString*) str
{
    NSUInteger len = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    Byte buffer[2];
    buffer[0] = (0xff & (len >> 8));
    buffer[1] = (0xff & len);
    NSMutableData *outData = [NSMutableData dataWithCapacity:2];
    [outData appendBytes:buffer length:2];
    [outData appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    return outData;
}

- (IBAction)goButtonPressed:(id)sender
{
    if([usernameTextField.text length] < 3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Username" message:@"Username must contain at least 3 characters."
                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        // SHOULD DELETE GOES AROUND SERVER FOR NOW FOR TESTING
        [self performSegueWithIdentifier:@"joinSegue" sender:sender];
    }
    else
    {
        [self initNetworkCommunication];
        NSString *msg = [NSString stringWithFormat:@"%@", usernameTextField.text];
        NSData *data = [self convertToJavaUTF8:msg];
        username = usernameTextField.text;
        [outputStream write:(const uint8_t *)[data bytes] maxLength:[data length]];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"joinSegue"])
    {
        JoinScreenViewController *vc = [segue destinationViewController];
        
    }
    else if([[segue identifier] isEqualToString:@"startSegue"])
    {
        SettingsScreenViewController *vc = [segue destinationViewController];
        
        vc.userList = userList;
    }

}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
