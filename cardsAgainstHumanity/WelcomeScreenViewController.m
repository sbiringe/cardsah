//
//  WelcomeScreenViewController.m
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 3/31/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "WelcomeScreenViewController.h"

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
    
    [self initNetworkCommunication];

    usernameTextField.delegate = self;
}

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"67.194.195.60", 1024, &readStream, &writeStream);
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
    switch(eventCode) {
            
        case NSStreamEventHasBytesAvailable:
        {
            NSMutableData *data = [[NSMutableData alloc] init];
            uint8_t buf[1024];
            
            unsigned int len = 0;
            
            len = [(NSInputStream *)stream read:buf maxLength:1024];
            
            if(len) {
                
                [data appendBytes:(const void *)buf length:len];
                int i;
                [data getBytes: &i length: sizeof(i)];
                /*
                NSString *string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                 */
                
                NSLog(@"%i", ntohl(i));
                
            }
            else
            {
                NSLog(@"no buffer!");
            }
            
            break;
            
        }
    }
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"launchSegue"])
    {
        NSString *msg = [NSString stringWithFormat:@"%@", usernameTextField.text];
        NSData *data = [self convertToJavaUTF8:msg];
        
        /*
        long x = htonl(5);
        [outputStream write:(uint8_t*)&x maxLength:sizeof(x)];
        */
        
        [outputStream write:(const uint8_t *)[data bytes] maxLength:[data length]];
        
        LaunchScreenViewController *vc = [segue destinationViewController];
        
        vc.username = [[NSString alloc] initWithString:usernameTextField.text];
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
