//
// PlayerViewController.m
// cardsAgainstHumanity
//
// Created by Abhinav Jain on 4/4/13.
// Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "PlayerViewController.h"

UIView *prevTouched;
@interface PlayerViewController ()

@end

@implementation PlayerViewController

@synthesize mainScrollView, swipeUpLabel;

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
    
    scoreUpdated = false;
    
    [self initNetworkCommunication];

    [self setupHorizontalScrollView];
    
}

- (void)initNetworkCommunication
{
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
            
            [data appendBytes:(const void *)buf length:len];
            
            NSString *user = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            
            if(!scoreUpdated)
            {
                scoreUpdated = true;
                int newScore = [[playerScores objectForKey:user] intValue] + 1;
                [playerScores setObject:[NSNumber numberWithInt:newScore] forKey:user];
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

- (void)setupHorizontalScrollView
{
    mainScrollView.delegate = self;
    
    [self.mainScrollView setBackgroundColor:[UIColor blackColor]];
    [mainScrollView setCanCancelContentTouches:NO];
    CGFloat width = 249;
    CGFloat height = 310;
    
    mainScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    mainScrollView.clipsToBounds = NO;
    mainScrollView.scrollEnabled = YES;
    mainScrollView.pagingEnabled = YES;
    
    CGFloat cx = 0;
    for (int i = 0;i<5;i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"image1.jpg"];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        tap.cancelsTouchesInView = YES;
        [imageView addGestureRecognizer:tap];
        
        if (![dealer isEqualToString:username])
        {
            swipeUpLabel.hidden = TRUE;
            UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleUpSwipe:)];
            upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
            [imageView addGestureRecognizer:upSwipe];
        }
        
        CGRect rect = imageView.frame;
        rect.size.height = width;
        rect.size.width = height;
        rect.origin.x = cx+5;
        rect.origin.y = 0;
        
        imageView.frame = rect;
        
        [mainScrollView addSubview:imageView];
        
        cx += imageView.frame.size.width+10;
        
    }
    
    [mainScrollView setContentSize:CGSizeMake(cx, [mainScrollView bounds].size.height)];
}

- (void)imageTapped:(UITapGestureRecognizer *)sender
{
    //We could implement deselect? That would require attaching another selector to it to deselect
    prevTouched.alpha = 1;
    prevTouched = sender.view;
    sender.view.alpha = 0.5;
    
}

- (void)handleUpSwipe:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"%s", "Swipe");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end