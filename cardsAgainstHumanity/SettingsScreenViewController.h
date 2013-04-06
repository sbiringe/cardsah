//
//  SettingsScreenViewController.h
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 3/31/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoinScreenViewController.h"
#import "RulesScreenViewController.h"


extern int winScore;//winning score if available
extern int cPH;//initial cards per hand
extern NSString *endGameCond;//Condition for when game is over

@interface SettingsScreenViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSString *terminateCondition;
    NSMutableArray *terminationConds;
    NSMutableArray *cphOptions;
    NSMutableArray *wsOptions;

    int winningScore;
    int cardsPerHand;
    
    int curWinScore;
    int curCardsPerHand;
    
    int wsRow;
    int cphRow;
}

@property (weak, nonatomic) NSMutableArray *userList;
@property (weak, nonatomic) IBOutlet UITextField *cardsPerHandTextField;
@property (weak, nonatomic) IBOutlet UITextField *winningScoreTextField;
@property (weak, nonatomic) IBOutlet UITableView *rulesTableView;
@property (retain, nonatomic) UIPickerView *cardsPerHandPickerView;
@property (retain, nonatomic) UIPickerView *winningScorePickerView;
@property (nonatomic, retain) UIToolbar *pickerToolbar;
@property (nonatomic, retain) UIActionSheet *actionSheet;


-(void)createActionSheetWithToolbarTitle:(NSString *)toolbarTitle picker:(UIPickerView *)pickerView;

@end
