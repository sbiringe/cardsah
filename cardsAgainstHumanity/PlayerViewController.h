//
// PlayerViewController.h
// cardsAgainstHumanity
//
// Created by Abhinav Jain on 4/4/13.
// Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoinScreenViewController.h"

extern UIView *prevTouched;

@interface PlayerViewController : UIViewController <NSStreamDelegate>
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    bool scoreUpdated;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;


@end