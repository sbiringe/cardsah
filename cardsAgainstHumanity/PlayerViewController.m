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

@synthesize mainScrollView, swipeUpLabel, actionSheet, playedCardToolbar, dealerCardImageView;

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
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    NSString *dealerImageName = [NSString stringWithFormat:@"DCard1.jpg"];
    UIImage *dealerImage = [UIImage imageNamed:dealerImageName];
    dealerCardImageView.image = dealerImage;
    
    scoreUpdated = false;
    horizontalScroll = false;
    verticalScroll = false;
    
    if (![dealer isEqualToString:username])
    {
        horizontalScroll = true;
    }
    
    // Creates Action Sheet
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Action Sheet"
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    cardImages = [[NSMutableArray alloc] init];

    [self setupHorizontalScrollView];
    
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
    
    [mainScrollView setShowsVerticalScrollIndicator:NO];
    
    [self.mainScrollView setBackgroundColor:[UIColor blackColor]];
    [mainScrollView setCanCancelContentTouches:NO];
    CGFloat width = 200;
    CGFloat height = 310;
    
    mainScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    mainScrollView.clipsToBounds = NO;
    mainScrollView.scrollEnabled = YES;
    mainScrollView.pagingEnabled = YES;
    
    for(int i = 0; i < 5; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"PCard%i.jpg",i];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

        [cardImages addObject:imageView];
    }
    
    
    CGFloat cx = 0;
    for (int i = 0;i<5;i++)
    {
        UIImageView *imageView = [cardImages objectAtIndex:i];
        /*
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
        */
        
        CGRect rect = imageView.frame;
        rect.size.height = width;
        rect.size.width = height;
        rect.origin.x = cx+5;
        rect.origin.y = 0;
        
        imageView.frame = rect;
        
        [mainScrollView addSubview:imageView];
        
        cx += imageView.frame.size.width+10;
        
    }
    [mainScrollView setContentSize:CGSizeMake(cx, height * 2)];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!horizontalScroll && !verticalScroll)
    {
        if (scrollView.contentOffset.y > 0  ||  scrollView.contentOffset.y < 0 )
        {
            CGFloat pageWidth = scrollView.frame.size.width;
            int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            verticalScroll = true;
            curXOffset = pageWidth * page;
        }
        else
            horizontalScroll = true;
    }

    if(horizontalScroll)
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    else
        scrollView.contentOffset = CGPointMake(curXOffset, scrollView.contentOffset.y);
         
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // Card has been played
    if(scrollView.bounds.origin.y > 0)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        //[self createActionSheetWithImageView:[cardImages objectAtIndex:page]];
        mainScrollView.scrollEnabled = FALSE;
        swipeUpLabel.text = @"Waiting for other members' selection";
        
        CGRect frame = scrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        [scrollView scrollRectToVisible:frame animated:NO];
    }
    
    horizontalScroll = false;
    verticalScroll = false;
}

-(void)createActionSheetWithImageView:(UIImageView *)imageView
{
    // Makes toolbar for pickerView
    playedCardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    [playedCardToolbar sizeToFit];
    
    // Adds objects to barItems
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    NSString *toolbarTitle = @"Waiting...";
    
    // Creates label to be used as custom view for UIBarButtonItem 
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 11.0f, [toolbarTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]].width, 21.0f)];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [titleLabel setText:toolbarTitle];
    
    // Adds title in middle
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    [barItems addObject:title];
    
    // Sets barItems array to the toolbar
    [playedCardToolbar setItems:barItems animated:YES];
    
    [actionSheet addSubview:imageView];
    [actionSheet showInView:self.view];
    [actionSheet setBounds:CGRectMake(0,0,320, 470)];
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