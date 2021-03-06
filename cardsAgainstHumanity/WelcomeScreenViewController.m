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
NSMutableString *winningCard;
NSMutableArray *userList;
NSMutableArray *userCards;


@interface WelcomeScreenViewController ()

@end

@implementation WelcomeScreenViewController
@synthesize usernameTextField;
@synthesize header, userNameLabel, welcome, welcomeImage, dealerLabel;

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
    userCards = [[NSMutableArray alloc] init];
    winningCard = [[NSMutableString alloc] init];
    playerScores = [[NSMutableDictionary alloc] init];
    
    usernameTextField.delegate = self;
    usernameTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    
    header.backgroundColor = [UIColor whiteColor];
    header.font=[header.font fontWithSize:25];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"wel.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    welcomeImage.image = image;
}

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    ipAddress = @"67.194.102.48";
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
            
            if(numToReceive == numReceived)
            {
                intReceived = false;
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
