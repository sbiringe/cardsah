//
// PlayerViewController.m
// cardsAgainstHumanity
//
// Created by Abhinav Jain on 4/4/13.
// Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

@synthesize mainScrollView;

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
    // Do any additional setup after loading the view.
    
    [self setupHorizontalScrollView];
    
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
        NSString *imageName = [NSString stringWithFormat:@"Tiger.jpg"];
        UIImage *image = [UIImage imageNamed:imageName];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        CGRect rect = imageView.frame;
        rect.size.height = width;
        rect.size.width = height;
        rect.origin.x = cx+5;
        rect.origin.y = 0;
        
        imageView.frame = rect;
        
        [mainScrollView addSubview:imageView];
        
        cx += imageView.frame.size.width+10;
        
        //imageName = [NSString stringWithFormat:@"Tiger.jpg"];
        //image = [UIImage imageNamed:imageName];
    }
    
    //self.pageControl.numberOfPages = nimages;
    [mainScrollView setContentSize:CGSizeMake(cx, [mainScrollView bounds].size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end