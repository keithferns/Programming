//
//  CurrentViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrentViewController.h"
#import "WriteNowAppDelegate.h"


#import "CustomTextView.h"
#import "CustomTextField.h"
#import "CustomToolBarMainView.h"

#import "CurrentTableViewController.h"
#import "AddEntityViewController.h"
#import "TasksViewController.h"

#import "FoldersViewController.h"
#import "TasksTableViewController.h"

#import "AddEntityTableViewController.h"
#import "TasksTableViewController.h"

@implementation CurrentViewController

@synthesize managedObjectContext;
@synthesize tableViewController;
@synthesize textView;
@synthesize newMemo;
@synthesize previousTextInput;
@synthesize toolBar, dateToolBar;
@synthesize datePicker, timePicker, pickerView, dateFormatter, timeFormatter;
@synthesize recurring;

@synthesize leftLabel, rightLabel, rightLabel_1, rightLabel_2;
@synthesize midView, bottomView;

#define screenRect [[UIScreen mainScreen] applicationFrame]
#define tabBarHeight self.tabBarController.tabBar.frame.size.height
#define navBarHeight self.navigationController.navigationBar.frame.size.height
#define toolBarRect CGRectMake(screenRect.size.width, 0, screenRect.size.width, 40)
#define textViewHeight 100.0
#define midViewRect CGRectMake(0, tabBarHeight+textViewHeight+10, screenRect.size.width, 30)
#define bottomViewRect CGRectMake(0, navBarHeight+160, screenRect.size.width, 260)

- (void)dealloc {
    [super dealloc];
    [textView release];
    datePicker = nil;
    timePicker = nil;
    pickerView = nil;
    timeFormatter = nil;
    dateFormatter = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self];   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
       
    swappingViews = NO;     
    isSelected = NO;
    /*-- Point current instance of the MOC to the main managedObjectContext --*/
	if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"CURRENT VIEWCONTROLLER: After managedObjectContext: %@",  managedObjectContext);
	}    
    self.title = @"Write Now";
    [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
    previousTextInput = @"";
    
    //TOOLBAR: setup    
    toolBar = [[CustomToolBarMainView alloc] initWithFrame:toolBarRect];
    [toolBar.firstButton setTarget:self];
    [toolBar.firstButton setAction:@selector(makeActionSheet:)];
    [toolBar.secondButton setTarget:self];
    [toolBar.secondButton setAction:@selector(saveMemo)];
    [toolBar.thirdButton setTarget:self];
    [toolBar.thirdButton setAction: @selector(selectFunction:)];
    [toolBar.fourthButton setTarget:self];
    [toolBar.fourthButton setAction:@selector(selectFunction:)];
    [toolBar.dismissKeyboard setTarget:self];
    [toolBar.dismissKeyboard setAction:@selector(dismissKeyboard)];

    //TEXTVIEW: setup and add to self.view
    textView = [[CustomTextView alloc] initWithFrame:CGRectMake(0, navBarHeight, 320, textViewHeight)];
    textView.delegate = self;    
    textView.inputAccessoryView = toolBar;
    [self.view addSubview:textView];
    
    //MIDVIEW
    midView = [[UIView alloc]initWithFrame:midViewRect];
    [midView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:midView];
    
    //BOTTOMVIEW: setup and add the datePicker and dateToolBar
    bottomView = [[UIView alloc] initWithFrame:bottomViewRect];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:bottomView];
    
    leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(-154, 0, 154, 30)];
    leftLabel.userInteractionEnabled = YES;
    leftLabel.tag = 12;
    [leftLabel.layer setCornerRadius:5.0];
    leftLabel.textAlignment = UITextAlignmentCenter;    
    [leftLabel setHighlightedTextColor:[UIColor grayColor]];

    
    rightLabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(screenRect.size.width, 0, 77, 30)];
    rightLabel_1.userInteractionEnabled = YES;
    rightLabel_1.tag = 13;
    [rightLabel_1.layer setCornerRadius:5.0];
    rightLabel_1.textAlignment = UITextAlignmentCenter;
    [rightLabel_1 setHighlightedTextColor:[UIColor grayColor]];

    
    rightLabel_2 = [[UILabel alloc]initWithFrame:CGRectMake(screenRect.size.width, 0, 77, 30)];
    rightLabel_2.userInteractionEnabled = YES;
    rightLabel_2.tag = 14;
    [rightLabel_2.layer setCornerRadius:5.0];
    rightLabel_2.textAlignment = UITextAlignmentCenter;
    [rightLabel_2 setHighlightedTextColor:[UIColor grayColor]];

    
    rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenRect.size.width, 0, 154, 30)];
    rightLabel.userInteractionEnabled = YES;
    rightLabel.tag = 15;
    [rightLabel.layer setCornerRadius:5.0];
    rightLabel.textAlignment = UITextAlignmentCenter;
    
    //BOTTOMVIEW:DATETOOLBAR: setup
    dateToolBar = [[CustomToolBar alloc] initWithFrame:toolBarRect];
    [dateToolBar.firstButton setTarget:self];
    [dateToolBar.firstButton setAction:@selector(setAppointmentDate)];
    [dateToolBar.secondButton setTarget:self];
    [dateToolBar.dismissKeyboard setTarget:self];
    [dateToolBar.dismissKeyboard setAction:@selector(dismissKeyboard)];
    
    tableViewController = [[CurrentTableViewController alloc] init];
    [tableViewController.tableView setFrame:CGRectMake(0, 0, screenRect.size.width, bottomView.frame.size.height)];    
    //[tableViewController.tableView.layer setCornerRadius:10.0];
    [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
    [tableViewController.tableView setSectionHeaderHeight:18];
    tableViewController.tableView.rowHeight = 48.0;
    //[tableViewController.tableView setTableHeaderView:tableLabel];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(screenRect.size.width, dateToolBar.frame.size.height, screenRect.size.width, bottomView.frame.size.height-dateToolBar.frame.size.height)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setDate:[NSDate date]];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)]];
    datePicker.timeZone = [NSTimeZone systemTimeZone];
    [datePicker sizeToFit];
    [datePicker setTag:0];
    datePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, MMM d, yyyy"];
    //datePicker.date = [dateFormatter dateFromString:leftLabel.text];

    timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(screenRect.size.width, toolBarRect.size.height, screenRect.size.width, bottomView.frame.size.height-toolBarRect.size.height)];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    [timePicker setMinuteInterval:10];
    timePicker.timeZone = [NSTimeZone systemTimeZone];
    [timePicker sizeToFit];
    [timePicker setTag:1];
    timePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [timePicker addTarget:self action:@selector(timePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"hh:mm a"];
    //timePicker.date = [timeFormatter dateFromString:leftLabel.text]; 
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(screenRect.size.width, dateToolBar.frame.size.height, screenRect.size.width, bottomView.frame.size.height-dateToolBar.frame.size.height)];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
    pickerView.showsSelectionIndicator = YES;
    recurring = [[NSArray alloc] initWithObjects:@"Never",@"Daily",@"Weekly", @"Fortnightly", @"Monthy", @"Annualy",nil];
}

- (void) viewWillAppear:(BOOL)animated{    
    
    [bottomView addSubview:tableViewController.tableView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.4];    
    [UIView setAnimationDelegate:self];
    tableViewController.tableView.frame = CGRectMake(0, 0, bottomView.frame.size.width, bottomView.frame.size.height);
   
    [UIView commitAnimations]; 
}

#pragma mark -
#pragma mark MAINTOOLBAR ACTIONS

- (void) selectFunction:(id)sender{
    NSLog(@"ATTEMPTING TO SET UP FOR AN APPOINTMENT ENTRY");
        [self.midView addSubview:leftLabel];
        [leftLabel setText:@"Date:"];
        [leftLabel setHighlighted:YES];
        
    if ([sender title] == @"Appointment"){
        tableViewController = nil;
        tableViewController = [[AddEntityTableViewController alloc]init];
        [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
        [tableViewController.tableView setSectionHeaderHeight:13];
        tableViewController.tableView.rowHeight = 30.0;
        //[tableViewController.tableView setTableHeaderView:tableLabel];
        [bottomView addSubview:tableViewController.tableView];
        CGRect startFrame = CGRectMake(-screenRect.size.width, 0, screenRect.size.width, bottomView.frame.size.height);
        tableViewController.tableView.frame = startFrame;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        CGRect endFrame = CGRectMake(0, 0, 320, bottomView.frame.size.height);
        tableViewController.tableView.frame = endFrame;
        leftLabel.frame = CGRectMake(0, 0, 154, midViewRect.size.height);
        
        
        [UIView commitAnimations];    
    }
    else if ([sender title] == @"To Do"){
        tableViewController = nil;
        tableViewController = [[TasksTableViewController alloc]init];
        [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
        [tableViewController.tableView setSectionHeaderHeight:13];
        tableViewController.tableView.rowHeight = 30.0;
        //[tableViewController.tableView setTableHeaderView:tableLabel];
        [self.bottomView addSubview:tableViewController.tableView];
        CGRect startFrame = CGRectMake(-320, 0, 320, 204);
        tableViewController.tableView.frame = startFrame;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        
        CGRect endFrame = CGRectMake(0, 0, 320, 204);
        tableViewController.tableView.frame = endFrame;
        
        endFrame = leftLabel.frame;
        endFrame.origin.x = 0;
        leftLabel.frame = endFrame;
        
        [UIView commitAnimations];    

    }
    return;
}


- (void)keyboardWillShow:(NSNotification *)notification {
    /* Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard. */
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]; // Get the origin of the keyboard when it's displayed.
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    if (textView.frame.origin.y+textView.frame.size.height  > keyboardTop){
        newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    }
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [self.navigationController.navigationBar setHidden:YES];
    
        CGRect endFrame = bottomView.frame;
        endFrame.origin.y  = keyboardTop;
        bottomView.frame = endFrame;
        [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (rightLabel_1.superview == nil||rightLabel_2.superview == nil){
        return;
        //FIXME: the tableview should only go down once all the date/time input is done. Currently it goes away after the startTime is set
    }
    NSDictionary* userInfo = [notification userInfo];
    
    /*Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.*/
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    [tableViewController.tableView setBackgroundColor:[UIColor whiteColor]];
    [tableViewController.tableView setAlpha:1.0];
    [textView setAlpha:1.0];
    
    tableViewController.tableView.frame = CGRectMake(0, 205, 320, 200);
    
    [self.navigationController.navigationBar setHidden:NO];
    
    [UIView commitAnimations];
}

#pragma mark - 
#pragma mark DATE/TIME PICKER ACTIONS
- (void)datePickerChanged:(id)sender{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:[datePicker date]];
    [dateComponents setYear:[dateComponents year]];
    [dateComponents setMonth:[dateComponents month]];
    [dateComponents setDay:[dateComponents day]];
    [dateComponents setHour:12];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    NSDate *selectedDate = [calendar dateFromComponents:dateComponents];
    NSLog(@"DatePicker Changed. Selected Date: %@", selectedDate);
    leftLabel.text = [dateFormatter stringFromDate:selectedDate];
    
    [[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"GetDateNotification" object:selectedDate];
}

- (void)timePickerChanged:(id)sender{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[timePicker date]];    
    [timeComponents setHour:[timeComponents hour]];
    [timeComponents setMinute:[timeComponents minute]];
    [timeComponents setSecond:[timeComponents second]];
    [timeComponents setYear:0];
    [timeComponents setMonth:0];
    [timeComponents setDay:0];
    
    if ([rightLabel_1 isHighlighted]) {
        NSDate *selectedTime= [calendar dateFromComponents:timeComponents];
        rightLabel_1.text = [timeFormatter stringFromDate:selectedTime];
    }
    else if ([rightLabel_2 isHighlighted]) {
        NSDate *selectedEndTime= [calendar dateFromComponents:timeComponents];
        rightLabel_2.text = [self.timeFormatter stringFromDate:selectedEndTime];
    }
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component{
    
    rightLabel.text = [recurring objectAtIndex:row];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [recurring count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [recurring objectAtIndex:row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}


#pragma mark -
#pragma mark Text view delegate methods
/*
 - (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {
  
 return YES;
}
 
 - (BOOL)textViewShouldEndEditing:(UITextView *)aTextView {
 return YES;
 }
 
 - (void) textViewDidBeginEditing:(UITextView *)textView{    
  NSLog(@"EDITING BEGAN");
 }
 
 - (void) textViewDidEndEditing:(UITextView *)textView{
 [self.textView resignFirstResponder];
 }
 
*/
#pragma mark - EVENTS & ACTIONS

- (void) addPickerResizeViews:(UIView *)picker1 removePicker:(UIView *)picker2 {
    [textView resignFirstResponder];
    //PICKER Start and End frames
    if (picker1.superview == nil) {
        [bottomView addSubview:picker1];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        
        if (picker2 == datePicker && ([rightLabel_1 isHighlighted]||[rightLabel_2 isHighlighted])) {
            [UIView setAnimationDidStopSelector:@selector(removeDatePicker)];
         }
        else if (picker2 == timePicker && [leftLabel isHighlighted] ){
            NSLog(@"ADDED datePicker from addPickerResizeView")
            ;            [UIView setAnimationDidStopSelector:@selector(removeTimePicker)];
        }
        
        //PICKER: move into place
        picker1.frame = CGRectMake(0.0,
                              datePicker.frame.origin.y, datePicker.frame.size.width, datePicker.frame.size.height);
        picker2.frame = CGRectMake(-320,
                                   datePicker.frame.origin.y, datePicker.frame.size.width, datePicker.frame.size.height);
        [UIView commitAnimations];

        }
        if (dateToolBar.superview == nil){
            NSLog(@"ADDING TOOLBAR FROM addPickerResizeViews method");    
        [bottomView addSubview:dateToolBar];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];    
        [UIView setAnimationDelegate:self];
        
        //TEXTVIEW: shrink by 40
        CGRect endFrame = textView.frame;
        endFrame.size.height -= 40;
        textView.frame = endFrame;
        //MIDVIEW: move up 40
        endFrame = midView.frame;
        endFrame.origin.y -= 40;
        midView.frame = endFrame;
        //BOTTOMVIEW: move up 40
        endFrame = bottomViewRect;
        endFrame.origin.y -= 40;
        bottomView.frame = endFrame;
        
        //TOOLBAR: move into place
        endFrame = CGRectMake(0.0, 0.0, 320, 40);            
        dateToolBar.frame = endFrame;

        [UIView commitAnimations];
    }
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    UITouch *touch = [touches anyObject];

    if (touch.view.tag == 12) {
        [leftLabel setHighlighted:YES];
        [rightLabel_1 setHighlighted:NO];
        [rightLabel_2 setHighlighted:NO];
        [self  addPickerResizeViews:datePicker removePicker:timePicker];
    }
    if (touch.view.tag == 13) {
        [rightLabel_1 setHighlighted:YES];
        [leftLabel setHighlighted:NO];
        [rightLabel_2 setHighlighted:NO];
        [self addPickerResizeViews:timePicker removePicker:datePicker];
    }
    if (touch.view.tag == 14) {
        [rightLabel_2 setHighlighted:YES];
        [leftLabel setHighlighted:NO];
        [rightLabel_1 setHighlighted:NO];
        [self addPickerResizeViews:timePicker removePicker:datePicker];
    }
}

- (void) textViewDidBeginEditing:(UITextView *)textView{
    if (self.textView.frame.size.height < 100) {
    }
}
- (void) textViewDidEndEditing:(UITextView *)textView{
    if (leftLabel.superview == nil && rightLabel.superview == nil){
        return;
    }
    else {
        CGRect frame = bottomView.frame;
        frame.origin.y -= 45;
        bottomView.frame = frame;
        if (self.textView.frame.size.height <100){
            frame = self.textView.frame;
            frame.size.height += 40;
            self.textView.frame = frame;
            
            frame = midView.frame;
            frame.origin.y += 40;
            midView.frame = frame;
        }
        [UIView commitAnimations];
    }
}

- (void) dismissKeyboard{
    //Check if textView is firstResponder. If yes, dismiss the keyboard by calling resignFirstResponder;
    if ([textView isFirstResponder]){
    [textView resignFirstResponder];
        }
    //Check if one of the pickerViews is on the screen.
    if (datePicker.superview != nil || timePicker.superview != nil || pickerView.superview !=nil) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];    
        [UIView setAnimationDelegate:self];
        
        if (datePicker !=nil) {
    
            [UIView setAnimationDidStopSelector:@selector(removeDatePicker)];  
        }
        else if (timePicker !=nil){
            [UIView setAnimationDidStopSelector:@selector(removeTimePicker)];   
            }
        else if (pickerView !=nil){
            [UIView setAnimationDidStopSelector:@selector(removePickerView)];   
        }
        datePicker.frame = CGRectMake(320,datePicker.frame.origin.y, datePicker.frame.size.width, datePicker.frame.size.height);
        timePicker.frame = CGRectMake(320,timePicker.frame.origin.y, timePicker.frame.size.width, timePicker.frame.size.height);
        pickerView.frame = CGRectMake(320,pickerView.frame.origin.y, pickerView.frame.size.width, pickerView.frame.size.height);
                                        
        dateToolBar.frame = CGRectMake(320, dateToolBar.frame.origin.y, dateToolBar.frame.size.width, dateToolBar.frame.size.height);    
  
        bottomView.frame = bottomViewRect;
        if (textView.frame.size.height <100){
        CGRect frame = textView.frame;
        frame.size.height = textViewHeight;
        textView.frame = frame;
        frame = midView.frame;
        frame.origin.y += 40;
        midView.frame = frame;
        }
      
        [UIView commitAnimations];
        [self.navigationController.navigationBar setHidden:NO];
    }
}
         
- (void) removeDatePicker {
    
    if (datePicker.superview != nil) {
        [datePicker removeFromSuperview];
        NSLog(@"datePicker removed from Superview");
        }
    if (timePicker.superview == nil && pickerView.superview == nil) {
        [dateToolBar removeFromSuperview];
        NSLog(@"Removed DateToolBar with removeDatePicker method");
    }
}    

- (void) removeTimePicker {
    if (timePicker.superview != nil) {
        [timePicker removeFromSuperview];
    }
    if (datePicker.superview == nil && pickerView.superview == nil) {
        [dateToolBar removeFromSuperview];
    }
    
}  
- (void) removePickerView {
    if (pickerView.superview != nil) {
        [pickerView removeFromSuperview];
    }
    if (timePicker.superview == nil && datePicker.superview == nil) {
        [dateToolBar removeFromSuperview];
    }
    
}  
- (void) setAppointmentDate{
    if ([tableViewController isKindOfClass:[AddEntityTableViewController class]]) {

        if (rightLabel_1.superview == nil) {
            [midView addSubview:rightLabel_1];
            rightLabel_1.text = @"Starts:";
            }    
        if (timePicker.superview == nil) {
            [bottomView addSubview:timePicker];
            }
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.4];    
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(removeDatePicker)];        
            
            CGRect endFrame = CGRectMake(leftLabel.frame.origin.x+leftLabel.frame.size.width+10, 0, 77, leftLabel.frame.size.height);
            rightLabel_1.frame = endFrame;
            endFrame = CGRectMake(-320, dateToolBar.frame.size.height,datePicker.frame.size.width, datePicker.frame.size.height);
            datePicker.frame = endFrame;
            endFrame = CGRectMake(0.0, dateToolBar.frame.size.height,
                                  timePicker.frame.size.width, timePicker.frame.size.height);
            timePicker.frame = endFrame;                      
            [UIView commitAnimations];
    }
    
    else if ([tableViewController isKindOfClass:[TasksTableViewController class]]){
        if (rightLabel.superview == nil) {
            [self.view addSubview:rightLabel];
        }    
        CGRect startFrame = CGRectMake(320.0,textView.frame.origin.y+textView.frame.size.height+15,
                                       154, leftLabel.frame.size.height);    
        CGRect endFrame = CGRectMake(leftLabel.frame.origin.x+leftLabel.frame.size.width+10, textView.frame.origin.y+textView.frame.size.height+15, 154, leftLabel.frame.size.height);
        [self animateViews:rightLabel startFrom:startFrame endAt:endFrame];
    }
    
    /*-- DATE/TIME: Get selected Date from the time Picker; put it in the date text field --*/
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:[datePicker date]];
    [dateComponents setYear:[dateComponents year]];
    [dateComponents setMonth:[dateComponents month]];
    [dateComponents setDay:[dateComponents day]];
    [dateComponents setHour:12];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    NSDate *selectedDate = [[calendar dateFromComponents:dateComponents] retain];
    leftLabel.text = [dateFormatter stringFromDate:selectedDate];
    [selectedDate release];
    
    if ([tableViewController isKindOfClass:[AddEntityTableViewController class]]) {
        [leftLabel resignFirstResponder];
        [rightLabel_1 setHighlighted:YES];
        [dateToolBar.firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
        [dateToolBar.firstButton setAction:@selector(setAppointmentTime)];
        [dateToolBar.firstButton setTitle:@"Set Time"];      
    }
    else if ([tableViewController isKindOfClass:[TasksTableViewController class]]){
        [leftLabel setHighlighted:NO];
        [rightLabel setHighlighted:YES];
        [rightLabel setHighlightedTextColor:[UIColor greenColor]];
        [dateToolBar.firstButton setImage:[UIImage imageNamed:@"save.png"]];
        [dateToolBar.firstButton setAction:@selector(doneAction)];
        [dateToolBar.firstButton setTitle:@"Done"];            
    }
    //if (!swappingViews) {
    //    [self swapViews];
    //}
    return;
    
}

- (void) setAppointmentTime{
    if (rightLabel_2.superview == nil) {
        [midView addSubview:rightLabel_2];
    }    
    CGRect startFrame = CGRectMake(320.0,0.0, 76, midViewRect.size.height);
    CGRect endFrame = CGRectMake(rightLabel_1.frame.origin.x+rightLabel_1.frame.size.width+2, 0, 76, midViewRect.size.height);
    [rightLabel_2 setText:@"Ends"];
    [self animateViews:rightLabel_2 startFrom:startFrame endAt:endFrame];
    
    /*--DATE/TIME: Get selected Time from the time Picker; put it in the time text field --*/
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[timePicker date]];    
    [timeComponents setHour:[timeComponents hour]];
    [timeComponents setMinute:[timeComponents minute]];
    [timeComponents setSecond:[timeComponents second]];
    [timeComponents setYear:0];
    [timeComponents setMonth:0];
    [timeComponents setDay:0];
    NSDate *selectedTime = [[calendar dateFromComponents:timeComponents] retain];
    rightLabel_1.text = [timeFormatter stringFromDate:selectedTime];
    [selectedTime release];
    [rightLabel_1 setHighlighted:NO];
    [rightLabel_2 setHighlighted:YES];
    [rightLabel_2 setHighlightedTextColor:[UIColor grayColor]];
    [dateToolBar.firstButton setImage:[UIImage imageNamed:@"save.png"]];
    [dateToolBar.firstButton setAction:@selector(doneAction)];
    [dateToolBar.firstButton setTitle:@"Done"];
    
    //if (!swappingViews) {
    //    [self swapViews];
    //}
}

- (void) setAlarm {
    return;
}
- (void) setRecurring {
    return;
}


- (void) doneAction {    
    if ([tableViewController isKindOfClass:[AddEntityTableViewController class]]) {
        
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Appointment"
                                       inManagedObjectContext:managedObjectContext];
        Appointment *newAppointment = [[Appointment alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [newAppointment setText:textView.text];
        //Add condition for reedit = if creationDate != nil then break
        [newAppointment setCreationDate:[NSDate date]];
        [newAppointment setType:[NSNumber numberWithInt:1]];
        [newAppointment setDoDate:[dateFormatter dateFromString:leftLabel.text]];
        [newAppointment setDoTime:[timeFormatter dateFromString:rightLabel_1.text]];
        [newAppointment setEndTime:[timeFormatter dateFromString:rightLabel_2.text]];
        /*--Save the MOC--*/	
        NSError *error;
        if(![managedObjectContext save:&error]){ 
            NSLog(@"APPOINTMENTS VIEWCONTROLLER MOC: DID NOT SAVE");
        } 
        [newAppointment release];
    }
    else if ([tableViewController isKindOfClass:[AddEntityTableViewController class]]) {
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Task"
                                       inManagedObjectContext:managedObjectContext];
        Task *newTask = [[Task alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [newTask setText:textView.text];
        //Add condition for reedit = if creationDate != nil then break
        [newTask setCreationDate:[NSDate date]];
        [newTask setType:[NSNumber numberWithInt:1]];
        [newTask setDoDate:[dateFormatter dateFromString:leftLabel.text]];
        [newTask setRecurring:rightLabel.text];
        /*--Save the MOC--*/	
        NSError *error;
        if(![managedObjectContext save:&error]){ 
            NSLog(@"APPOINTMENTS VIEWCONTROLLER MOC: DID NOT SAVE");
        } 
        [newTask release];
    }
    [self.view endEditing:YES];
    [textView setText:@""];
    [leftLabel setText:@""];
    [rightLabel setText:@""];
    [rightLabel_1 setText:@""];
    [rightLabel_2 setText:@""];
    [dateToolBar.firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
    [dateToolBar.firstButton setTitle:@"Set Date"];
    [dateToolBar.firstButton setAction:@selector(setAppointmentDate)];
    [dateToolBar.dismissKeyboard setAction:@selector(dismissKeyboard)];    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeAllAddedViews)];

    leftLabel.frame = CGRectMake(-155, 0, leftLabel.frame.size.width, midViewRect.size.height);
    rightLabel.frame = CGRectMake(screenRect.size.width, 0, rightLabel.frame.size.width, midViewRect.size.height);
    rightLabel_1.frame = CGRectMake(screenRect.size.width, 0, rightLabel_1.frame.size.width, midViewRect.size.height);
    rightLabel_2.frame = CGRectMake(screenRect.size.width, 0, rightLabel_2.frame.size.width, midViewRect.size.height);
    dateToolBar.frame = toolBarRect;
    datePicker.frame = CGRectMake(-screenRect.size.width, datePicker.frame.origin.y, screenRect.size.width, datePicker.frame.size.height);
    timePicker.frame = CGRectMake(-screenRect.size.width, timePicker.frame.origin.y, screenRect.size.width, timePicker.frame.size.height);
    textView.frame = CGRectMake(0, navBarHeight, screenRect.size.width, textViewHeight);
    midView.frame = CGRectMake(0, midViewRect.origin.y, midViewRect.size.width, midViewRect.size.height);
    bottomView.frame = bottomViewRect;
    
    tableViewController = nil;
    tableViewController = [[CurrentTableViewController alloc]init];
    [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
    [tableViewController.tableView setSectionHeaderHeight:13];
    tableViewController.tableView.rowHeight = 30.0;
    //[tableViewController.tableView setTableHeaderView:tableLabel];
    [bottomView addSubview:tableViewController.tableView];
    tableViewController.tableView.frame = CGRectMake(0, 0, screenRect.size.width, bottomView.frame.size.height);
    
    [UIView commitAnimations];
    
}
     - (void) removeAllAddedViews{
         [datePicker removeFromSuperview];
         [timePicker removeFromSuperview];
         [leftLabel removeFromSuperview];
         [rightLabel removeFromSuperview];
         [rightLabel_1 removeFromSuperview];
         [rightLabel_2 removeFromSuperview];
         [dateToolBar removeFromSuperview];
         
         
     }

- (void) makeActionSheet:(id) sender{
   // UIBarButtonItem *actionButton = sender;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"DO" delegate:self cancelButtonTitle:@"Later" destructiveButtonTitle:nil otherButtonTitles:@"Save to Folder", @"Append to File", @"Send as Email", @"Send as Message", nil];
    //[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    actionSheet.layer.backgroundColor = [UIColor blueColor].CGColor;
    //[actionSheet showFromBarButtonItem:actionButton animated:YES];
    //[actionSheet showInView:self.view];
     UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(50, 340, 220, 65)];
     CGRect myframe = CGRectMake(myView.frame.origin.x, myView.frame.origin.y, myView.frame.size.width, myView.frame.size.height);
     CALayer *mylayer = [[CALayer alloc] init];
     [mylayer setFrame:myframe];
     [mylayer setCornerRadius:10.0];
     [myView.layer addSublayer:mylayer];
     [myView.layer setMask:mylayer];
     [actionSheet showInView:myView];
     [actionSheet setAlpha:0.6];
     [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
    [myView release];
    [mylayer release];
    [textView becomeFirstResponder];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 4:
            NSLog(@"Cancel Button Clicked on Main View action sheet");
            break;
        case 3:   
            NSLog(@"4nd Button Clicked on action sheet");
            
            break;
        case 2:
            NSLog(@"3nd Button Clicked on action sheet");
            break;
        case 1:
            if ([textView hasText] || rightLabel.superview == nil) {
            [self.view addSubview:rightLabel];
            //[rightLabel setPlaceholder:@"New File"];
            CGRect startFrame = CGRectMake(320, textView.frame.origin.y+textView.frame.size.height+15, 154,30);
            CGRect endFrame = CGRectMake(165, textView.frame.origin.y+textView.frame.size.height+15, 154,30);
            [self animateViews:rightLabel startFrom:startFrame endAt:endFrame]; 
            }
                break;
        case 0:
            if ([textView hasText]) {
                [self.view addSubview:rightLabel];
                //[rightLabel setPlaceholder:@"New Folder:"];
                CGRect startFrame = CGRectMake(320, textView.frame.origin.y+textView.frame.size.height+15, 154,30);
                CGRect endFrame = CGRectMake(165, textView.frame.origin.y+textView.frame.size.height+15, 154,30);
                [self animateViews:rightLabel startFrom:startFrame endAt:endFrame];
            }
            break;
        default:
            break;
    }
}

- (void) addNewFolder{
    //FoldersViewController *addViewController = [[FoldersViewController alloc] initWithNibName:nil bundle:nil];
    // Create a new managed object context for the new task -- set its persistent store coordinator to the same as that from the fetched results controller's context.
    /*
     NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
     addViewController.managedObjectContext = addingContext;
     [addingContext release];	
     [addViewController.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
     NSLog(@"After managedObjectContext: %@",  addViewController.managedObjectContext);
     */
    if (newMemo.text == nil) {
        if (![textView hasText]){
            //[addViewController release];
            return;
        }
        NSLog(@"Trying to Create a newMemo");
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Memo"
                                       inManagedObjectContext:managedObjectContext];
        newMemo = [[Memo alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [newMemo setText:textView.text];
        //Add condition for reedit = if creationDate != nil then break
        [newMemo setCreationDate:[NSDate date]];
        [newMemo setType:0];
        [newMemo setEditDate:[NSDate date]];
    }
    //addViewController.newMemo = newMemo;	
    //[self presentModalViewController:addViewController animated:YES];	
    previousTextInput = textView.text;
    NSLog(@"Previous Text: %@", previousTextInput);
    [textView setText:@""];
    [textView resignFirstResponder];
   // [addViewController release];
    
}

- (void) saveMemo {
    if (![textView hasText]){
        return;
    }
    NSString *newTextInput = [NSString stringWithFormat: @"%@", textView.text];//copy contents of textView to newTextInput
    NSLog(@"newTextInput = %@", newTextInput);
    NSLog(@"Trying to Create a newMemo");
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Memo"
                                   inManagedObjectContext:managedObjectContext];
    
    newMemo = [[Memo alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    [newMemo setText:textView.text];
    //Add condition for reedit = if creationDate != nil then break
    [newMemo setCreationDate:[NSDate date]];
    [newMemo setType:0];
    [newMemo setEditDate:[NSDate date]];
    
    /*--TODO:   SAVE(MEMO/NOTE) option. When the user has added and saved text, then returns to editing but does not add any text. 
     // if (![newTextInput isEqualToString:previousTextInput]){
     
     -*/
    /* -- 
     NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
     self.managedObjectContext = addingContext;	
     [self.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
     [addingContext release];
     --*/
    NSLog(@"newMemo.text = %@", newMemo.text);
    NSLog(@"newMemo.creationDate = %@", newMemo.creationDate);
    NSLog(@"newMemo.type = %d", [newMemo.type intValue]);
    NSLog(@"newMemo.editDate = %@", newMemo.editDate);
    
    NSError *error;
    if(![self.managedObjectContext save:&error]){ 
        NSLog(@"MainViewController MOC: DID NOT SAVE");
    }
    
    // [[NSNotificationCenter defaultCenter] postNotificationName:NSManagedObjectContextDidSaveNotification object:nil];
    
    previousTextInput = newTextInput;
    NSLog(@"Previous Text: %@", previousTextInput);
    [textView setText:@""];
    [textView resignFirstResponder];    
}

- (void) addNewAppointment {
    if (![textView hasText]){
        return;
    }
    [self.view endEditing:YES];
    
    NSString *newTextInput = [NSString stringWithFormat: @"%@", textView.text];//copy contents of textView to newTextInput
    NSLog(@"newTextInput = %@", newTextInput);
    /* --
     NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
     self.managedObjectContext = addingContext;	
     [self.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
     [addingContext release];
     --*/
    
    AddEntityViewController *viewController =[[AddEntityViewController alloc] initWithNibName:nil bundle:nil];
    viewController.managedObjectContext = self.managedObjectContext;
    viewController.newText = textView.text;
    [self presentModalViewController:viewController animated:YES];
    [viewController release];
    [textView resignFirstResponder];
    
    previousTextInput = newTextInput;
    NSLog(@"Previous Text: %@", previousTextInput);
    [textView setText:@""];
}

- (void) addNewTask {
    if (![textView hasText]){
        return;
        }
    [self.view endEditing:YES];
    NSString *newTextInput = [NSString stringWithFormat: @"%@", textView.text];//copy contents of textView to newTextInput
    NSLog(@"newTextInput = %@", newTextInput);
    // if (![newTextInput isEqualToString:previousTextInput]){
    
    //   }
    /*--the text is NOT the same as previous call of method --> insert a new instance of MemoText in the MOC and copy new text to this instance--
     CASE: When the user has added and saved text, then returns to editing but does not add any text ---*/
    /* --
     NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
     self.managedObjectContext = addingContext;	
     [self.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
     [addingContext release];
     --*/
    TasksViewController *viewController = [[TasksViewController alloc] initWithNibName:nil bundle:nil];
    viewController.managedObjectContext = self.managedObjectContext;
    
    viewController.newText = textView.text;
    
    [self presentModalViewController:viewController animated:YES];
    
    [viewController release];
    
    [textView resignFirstResponder];
    
    previousTextInput = newTextInput;
    NSLog(@"Previous Text: %@", previousTextInput);
    [textView setText:@""];
}

- (void) addEntity:(id)sender {
    
    NSLog(@"Adding Entity");
    AddEntityViewController *viewController = [[AddEntityViewController alloc] initWithNibName:nil bundle:nil];
    viewController.sender = [sender title];
    viewController.newText = [textView text];
    [self presentModalViewController:viewController animated:YES];
    [viewController release];
}

- (void) animateViews:(UIView *)view startFrom:(CGRect)fromFrame endAt:(CGRect)toFrame{
    view.frame = fromFrame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];    
    [UIView setAnimationDelegate:self];
    view.frame = toFrame;
    [UIView commitAnimations];    
}



- (void) swapViews {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [transition setType:@"kCATransitionPush"];	
    [transition setSubtype:@"kCATransitionFromLeft"];
    
    swappingViews = YES;
    transition.delegate = self;
    
    [self.view.layer addAnimation:transition forKey:nil];
    
}


@end
