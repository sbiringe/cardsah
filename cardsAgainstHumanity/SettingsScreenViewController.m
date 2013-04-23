//
//  SettingsScreenViewController.m
//  cardsAgainstHumanity
//
//  Created by Scott Biringer on 3/31/13.
//  Copyright (c) 2013 Scott Biringer. All rights reserved.
//

#import "SettingsScreenViewController.h"

int winScore;
int cPH;
NSString *endGameCond;
@interface SettingsScreenViewController ()

@end

@implementation SettingsScreenViewController
@synthesize cardsPerHandTextField, winningScoreTextField, rulesTableView, winningScorePickerView;
@synthesize cardsPerHandPickerView, pickerToolbar, actionSheet;

@synthesize settingsLabel, cardsPerHandLabel, howToWinLabel, settingsImage;

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
    
    [outputStream setDelegate:self];

    // Creates Action Sheet
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Action Sheet"
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];

    
    terminationConds = [[NSMutableArray alloc] initWithObjects:@"Play to Score", @"Run out of Cards", @"Play Forever!", nil];
    wsOptions = [[NSMutableArray alloc] init];
    cphOptions = [[NSMutableArray alloc] init];
    
    for(int i = 3; i <= 10; i++)
    {
        [wsOptions addObject:[NSNumber numberWithInt:i]];
        [cphOptions addObject:[NSNumber numberWithInt:i]];
    }
    
    winScore = 0;
    cPH = 0;
    endGameCond = [[NSString alloc] init];
    
    rulesTableView.delegate = self;
    rulesTableView.dataSource = self;
    rulesTableView.scrollEnabled = false;
    
    cardsPerHandTextField.delegate = self;
    winningScoreTextField.delegate = self;
    winningScorePickerView.delegate = self;
    cardsPerHandPickerView.delegate = self;
    
    // Initialize default values
    winningScoreTextField.text = @"5";
    winningScore = 5;
    wsRow = 2;
    cardsPerHandTextField.text = @"5";
    cardsPerHand = 5;
    cphRow = 2;
    
    
    terminateCondition = @"Play to Score";
    
    winningScorePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    winningScorePickerView.delegate = self;
    winningScorePickerView.showsSelectionIndicator = YES;
    winningScorePickerView.tag = 0;
    winningScorePickerView.hidden = YES;
    winningScorePickerView.dataSource = self;
    [self.view addSubview:winningScorePickerView];
    
    cardsPerHandPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    cardsPerHandPickerView.delegate = self;
    cardsPerHandPickerView.showsSelectionIndicator = YES;
    cardsPerHandPickerView.tag = 1;
    cardsPerHandPickerView.hidden = YES;
    cardsPerHandPickerView.dataSource = self;
    [self.view addSubview:cardsPerHandPickerView];
    
    winScore = winningScore;
    cPH = cardsPerHand;
    endGameCond = terminateCondition;
    
    // background
    self.view.backgroundColor = [UIColor blackColor];
    
    settingsLabel.font = [UIFont fontWithName:@"Times New Roman" size: 25];
    

    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"settings.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    settingsImage.image = image;
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

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"joinSegue"])
    {
        NSString *msg1 = [NSString stringWithFormat:@"%@", cardsPerHandTextField.text];
        NSData *data1 = [self convertToJavaUTF8:msg1];
        [outputStream write:(const uint8_t *)[data1 bytes] maxLength:[data1 length]];
        
        NSString *condition;
        
        if([terminateCondition isEqualToString:@"Play to Score"])
            condition = @"0";
        else if([terminateCondition isEqualToString:@"Run out of Cards"])
            condition = @"1";
        else
            condition = @"2";
        
        NSString *msg2 = [NSString stringWithFormat:@"%@", condition];
        NSData *data2 = [self convertToJavaUTF8:msg2];
        [outputStream write:(const uint8_t *)[data2 bytes] maxLength:[data2 length]];
        
        NSString *msg3 = [NSString stringWithFormat:@"%@", winningScoreTextField.text];
        NSData *data3 = [self convertToJavaUTF8:msg3];
        [outputStream write:(const uint8_t *)[data3 bytes] maxLength:[data3 length]];
        
        JoinScreenViewController *vc = [segue destinationViewController];
        
        vc.cardPerHand = (int)cardsPerHandTextField.text;
        vc.scoreToWin = (int)winningScoreTextField.text;
        vc.terminateCondition = terminateCondition;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"settingsTable";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    NSString *cellValue = [terminationConds objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [terminationConds count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        terminateCondition = @"Play to Score";
        winningScoreTextField.hidden = NO;
    }
    else if(indexPath.row == 1)
    {
        terminateCondition = @"Run out of Cards";
        winningScoreTextField.hidden = YES;
    }
    else
    {
        terminateCondition = @"Play Forever!";
        winningScoreTextField.hidden = YES;
    }
    endGameCond = terminateCondition;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    // Dismiss keyboard
    [textField resignFirstResponder];
    
    if(textField.tag == 0)
    {
        // Shows cardsPerHandPickerView
        cardsPerHandPickerView.hidden = NO;
        winningScorePickerView.hidden = YES;
        
        // Sets initial value of chosen string and to the top category in winningScorePickerView
        curCardsPerHand = [[cphOptions objectAtIndex:[cardsPerHandPickerView selectedRowInComponent:0]] intValue];
        
        [self createActionSheetWithToolbarTitle:@"Cards Per Hand" picker:cardsPerHandPickerView];
    }
    else
    {
        // Shows WinningScorePickerView
        winningScorePickerView.hidden = NO;
        cardsPerHandPickerView.hidden = YES;
        
        // Sets initial value of chosen string and to the top category in winningScorePickerView
        curWinScore = [[wsOptions objectAtIndex:[winningScorePickerView selectedRowInComponent:0]] intValue];
        
        [self createActionSheetWithToolbarTitle:@"Winning Score" picker:winningScorePickerView];
    }
}

-(void)createActionSheetWithToolbarTitle:(NSString *)toolbarTitle picker:(UIPickerView *)pickerView
{
    // Makes toolbar for pickerView
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    // Adds objects to barItems
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    // Adds cancel button on left side
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPickerClicked)];
    [barItems addObject:cancelButton];
    
    // Adds spacing so buttons and the title are spaced nicely
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    
    
    // Creates label to be used as custom view for UIBarButtonItem
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 11.0f, [toolbarTitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]].width, 21.0f)];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [titleLabel setText:toolbarTitle];
    //[titleLabel setTextAlignment:UITextAlignmentCenter];
    
    // Adds title in middle
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    [barItems addObject:title];
    
    // Adds spacing so buttons and the title are spaced nicely
    [barItems addObject:flexSpace];
    
    // Adds done button on right side
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePickerClicked)];
    [barItems addObject:doneButton];
    
    // Sets barItems array to the toolbar
    [pickerToolbar setItems:barItems animated:YES];
    
    [actionSheet addSubview:pickerToolbar];
    [actionSheet addSubview:pickerView];
    [actionSheet showInView:self.view];
    [actionSheet setBounds:CGRectMake(0,0,320, 470)];
}

- (void)donePickerClicked
{
    if(winningScorePickerView.hidden == NO)
    {
        winningScore = [[wsOptions objectAtIndex:[winningScorePickerView selectedRowInComponent:0]] intValue];
        winScore = winningScore;
        winningScoreTextField.text = [[wsOptions objectAtIndex:[winningScorePickerView selectedRowInComponent:0]] stringValue];
        wsRow = [winningScorePickerView selectedRowInComponent:0];
    }
    else
    {
        cardsPerHand = [[cphOptions objectAtIndex:[cardsPerHandPickerView selectedRowInComponent:0]] intValue];
        cPH = cardsPerHand;
        cardsPerHandTextField.text = [[cphOptions objectAtIndex:[cardsPerHandPickerView selectedRowInComponent:0]] stringValue];
        cphRow = [cardsPerHandPickerView selectedRowInComponent:0];
    }
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)cancelPickerClicked
{
    if(winningScorePickerView.hidden == NO)
        [winningScorePickerView selectRow:wsRow inComponent:0 animated:NO];
    else
        [cardsPerHandPickerView selectRow:cphRow inComponent:0 animated:NO];

    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    if(pickerView.tag == 0)
    {
        return wsOptions.count;
    }
    else if(pickerView.tag == 1)
    {
        return cphOptions.count;
    }
    
    // Error
    return -1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    if(pickerView.tag == 0)
    {
        return [[wsOptions objectAtIndex:row] stringValue];
    }
    else if(pickerView.tag == 1)
    {
        return [[cphOptions objectAtIndex:row] stringValue];
    }
    
    // Error
    return NULL;
}

- (void)viewDidAppear:(BOOL)animated
{
    [rulesTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [winningScorePickerView selectRow:wsRow inComponent:0 animated:NO];
    [cardsPerHandPickerView selectRow:cphRow inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
