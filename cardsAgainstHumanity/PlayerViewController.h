//
// PlayerViewController.h
// cardsAgainstHumanity
//
// Created by Abhinav Jain on 4/4/13.
// Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoinScreenViewController.h"
#import "WelcomeScreenViewController.h"

extern UIView *prevTouched;

@interface PlayerViewController : UIViewController <NSStreamDelegate, UIScrollViewAccessibilityDelegate, UIScrollViewDelegate>
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    NSMutableArray *cardImages;
    
    int curXOffset;
    
    bool horizontalScroll;
    bool verticalScroll;
    bool scoreUpdated;
}

@property (weak, nonatomic) IBOutlet UILabel *swipeUpLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIToolbar *playedCardToolbar;


@end