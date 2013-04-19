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
    
    intReceived = false;
    usernameReceived = false;
    winnerSelected = false;
    numReceived = 0;
    numToReceive = 0;
    
    scoreUpdated = false;
    horizontalScroll = false;
    verticalScroll = false;
    
    
    if (youAreDealer)
    {
        mainScrollView.scrollEnabled = false;
        horizontalScroll = true;
        swipeUpLabel.text = @"Waiting for other members' selection";
    }
    
    // Creates Action Sheet
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Action Sheet"
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
   
    //NSString *dealerImageName = [NSString stringWithFormat:[dCardImages objectAtIndex:curDIndex]];
    //NSLog(@"Player Card Array length is: %i",pCardImages.count);
    //NSLog(@"Dealer Card Array length is: %i",dCardImages.count);
    //NSLog(@"Dealer Card is: %@",[dCardImages objectAtIndex:curDIndex]);
    
    UIImage *dealerImage = [UIImage imageNamed:[dCardImages objectAtIndex:curDIndex]];
    dealerCardImageView.image = dealerImage;
    
    
    [self setupHorizontalScrollView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    mainScrollView.scrollEnabled = TRUE;
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    

    if (youAreDealer)
    {
        mainScrollView.scrollEnabled = false;
        horizontalScroll = true;
        swipeUpLabel.text = @"Waiting for other members' selection";
    }
    else
    {
        horizontalScroll = false;
        verticalScroll =  false;
        swipeUpLabel.text = @"Swipe Up to Submit Card";
    }
    
    // Creates Action Sheet
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Action Sheet"
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    UIImage *dealerImage = [UIImage imageNamed:[dCardImages objectAtIndex:curDIndex]];
    dealerCardImageView.image = dealerImage;
    
    int lastDealerIndex = (currentRound - 1) % [userList count];

    if(currentRound != 0 && indexInUserList != lastDealerIndex)
    {
        int dealerIndex = currentRound % [userList count];
        int nextCard = indexInUserList;
        if(dealerIndex < indexInUserList)
        {
            nextCard--;
        }

        NSString *imageName = [pCardImages objectAtIndex:curPIndex + nextCard];
        NSLog(@"Image added to hand is: %@", imageName);
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        [userCards insertObject:imageName atIndex:pageIndex];

        CGFloat width = 180;
        CGFloat height = 250;

        CGRect rect = imageView.frame;
        rect.size.height = width;
        rect.size.width = height;
        rect.origin.x = 320 * pageIndex + 35;
        rect.origin.y = 0;

        imageView.frame = rect;

        [mainScrollView insertSubview:imageView atIndex:pageIndex];

        curPIndex += [userList count] - 1;
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"submittedCards"])
    {
        DealerScreenViewController *dealerScreen = [segue destinationViewController];
        
        dealerScreen.playerScreen = self;
    }
    else if([[segue identifier] isEqualToString:@"winningScreen"])
    {
        WinningScreenViewController *winningScreen = [segue destinationViewController];
        
        winningScreen.pageIndex = pageIndex;
        winningScreen.mainScrollView = mainScrollView;
    }
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{
    switch(eventCode) {
            
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
                    
                    int i;
                    [data getBytes: &i length: sizeof(i)];
                    
                    numToReceive = ntohl(i);
                    NSLog(@"%i", numToReceive);
                    
                    len -= 4;
                    
                    // You are the dealer
                    if(numToReceive == 50)
                    {
                        [self performSegueWithIdentifier:@"submittedCards" sender:nil];
                        intReceived = false;
                        return;
                    }
                    else if(numToReceive == 51)
                    {
                        winnerSelected = true;
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
            {
                intReceived = false;
                return;
            }
            
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
                
                if(!usernameReceived)
                {
                    usernameReceived = true;
                    submittedUser = temp;
                }
                else
                {
                    usernameReceived = false;
                    submittedCard = temp;
                }
                
                NSLog(@"%@", temp);
                numReceived++;
            }
            
            if(winnerSelected)
            {
                winnerSelected = false;
                [winningCard setString:submittedUser];
                //winningCard = submittedUser;
                
                int winningIndex = 0;
                
                for(int i = 0; i < playedCards.count; i++)
                {
                    if([winningCard isEqualToString:[playedCards objectAtIndex:i]])
                    {
                        winningIndex = i;
                        break;
                    }
                }
                
                NSString *winningUser = [playedUsernames objectAtIndex:winningIndex];
                
                int newScore = [[playerScores objectForKey:winningUser] intValue] + 1;
                [playerScores setObject:[NSNumber numberWithInt:newScore] forKey:winningUser];
               
                if(!youAreDealer)
                {
                    [self performSegueWithIdentifier:@"winningScreen" sender:nil];
                }
                
                intReceived = false;
                usernameReceived = false;
                return;
            }
            
            if(numReceived == numToReceive)
            {
                intReceived = false;
                [playedUsernames addObject:submittedUser];
                [playedCards addObject:submittedCard];
            }
            
            break;

            
            /*
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
            */
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
    CGFloat height = 250;
    
    mainScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    mainScrollView.clipsToBounds = NO;
    mainScrollView.scrollEnabled = YES;
    mainScrollView.pagingEnabled = YES;
    
    CGFloat cx = 0;
    
    for(int i = curPIndex; i < (curPIndex+5); i++)
    {
        //NSString *imageName = [NSString stringWithFormat:@"PCard%i.png",i+1];
        
        NSString *imageName = [pCardImages objectAtIndex:i];
        NSLog(@"Image added to hand is: %@", imageName);
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [userCards addObject:imageName];
        
        //[pCardImages addObject:imageView];
        //UIImageView *imageView = [pCardImages objectAtIndex:i];
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
        rect.origin.x = cx+35;
        rect.origin.y = 0;
        
        imageView.frame = rect;
        
        [mainScrollView addSubview:imageView];
        
        cx += imageView.frame.size.width+70;
    }
    
    curPIndex = [userList count] * 5;
    
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
        pageIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
                
        [playedUsernames addObject:username];
        [playedCards addObject:[userCards objectAtIndex:pageIndex]];
        NSString *playedCard = [userCards objectAtIndex:pageIndex];
        
        //Remove card from user's hand 
        //[pCardImages removeObject:[userCards objectAtIndex:page]];
        [userCards removeObjectAtIndex:pageIndex];
        
        NSArray *subV = [mainScrollView subviews];
        [[subV objectAtIndex:pageIndex] removeFromSuperview];
        
        mainScrollView.scrollEnabled = FALSE;
        swipeUpLabel.text = @"Waiting for other members' selection";
        
        NSString *msg = [NSString stringWithFormat:@"%@", playedCard];
        NSData *data = [self convertToJavaUTF8:msg];
        [outputStream write:(const uint8_t *)[data bytes] maxLength:[data length]];
        
        CGRect frame = scrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        [scrollView scrollRectToVisible:frame animated:NO];
    }
    
    horizontalScroll = false;
    verticalScroll = false;
    
    if(youAreDealer)
        horizontalScroll = true;
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