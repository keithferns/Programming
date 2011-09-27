//  CalendarViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "WriteNowAppDelegate.h"
#import "CalendarViewController.h"
#import "AddEntityTableViewController.h"
#import "TasksTableViewController.h"

#import "CustomTextView.h"
#import "CustomToolBar.h"
#import "CustomTextField.h"

#import "MyDataObject.h"
#import "AppDelegateProtocol.h"

@implementation CalendarViewController

@synthesize tableViewController, managedObjectContext;
@synthesize sender, recurring,dateFormatter, timeFormatter;
@synthesize datePicker, timePicker, pickerView;
@synthesize textView, leftField, rightField_1, rightField_2, rightField;
@synthesize toolBar, navPopover;

@synthesize midView;


#define screenRect [[UIScreen mainScreen] applicationFrame]
#define navBarHeight 44.0
#define toolBarRect CGRectMake(screenRect.size.width, 0, screenRect.size.width, 40)
#define textViewRect CGRectMake(5, navBarHeight+10, screenRect.size.width-10, 140)
#define midViewRect CGRectMake(0, textViewRect.origin.y+textViewRect.size.height+5, screenRect.size.width, 40)
#define bottomViewRect CGRectMake(0, textViewRect.origin.y+textViewRect.size.height+10, screenRect.size.width, screenRect.size.height)



- (void)setAlarm:(id)sender { //Create Popover to set Alarms
	NSLog(@"Alarm-> Button Pressed");
    if(!navPopover) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 120, 30)];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setText:@"Set Reminders"];
        UITextField *alarm1 = [[UITextField alloc] initWithFrame:CGRectMake(0, 35, 120, 30)];
        [alarm1 setEnabled:YES];
        [alarm1 setPlaceholder:@"Alarm 1"];
        [alarm1 setBackgroundColor:[UIColor whiteColor]];
        [alarm1 setTextAlignment:UITextAlignmentCenter];
        [alarm1 setInputView:pickerView];
        [alarm1 setInputAccessoryView:toolBar];
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(30, 80, 60, 40)];
        [button1 setTitle:@"Done" forState:UIControlStateNormal];
        [button1 setTag:1];
        [button1 addTarget:self action:@selector(setAlarm) forControlEvents:UIControlEventTouchUpInside];
        
        UIViewController *viewCon = [[UIViewController alloc] init];
        viewCon.contentSizeForViewInPopover = CGSizeMake(120, 150);
        [viewCon.view addSubview:button1];
        [viewCon.view addSubview:alarm1];
        [viewCon.view addSubview:label];
        
        [button1 release];
        [alarm1 release];
        [label release];
        navPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        [navPopover setDelegate:self];
        [viewCon release];
    } 
    
    if([navPopover isPopoverVisible]) {
        [navPopover dismissPopoverAnimated:YES];
        [navPopover setDelegate:nil];
        [navPopover autorelease];
        navPopover = nil;
    } else {
        //CGRect screenBounds = [UIScreen mainScreen].bounds;
        [navPopover presentPopoverFromRect:CGRectMake(70, 200, 50, 57)
                                    inView:self.view 
                  permittedArrowDirections:UIPopoverArrowDirectionDown
                                  animated:YES];
    }
}
- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Did dismiss");
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Should dismiss");
    return YES;
}


- (MyDataObject *) myDataObject; {// Get the shared Data object
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	MyDataObject* myDataObject;
	myDataObject = (MyDataObject*) theDelegate.myDataObject;
	return myDataObject;
}


- (void)dealloc {
    [super dealloc];
    [sender release];
    [recurring release];
    [datePicker release];
    [timePicker release];
    [pickerView release];
    [leftField release];
    [rightField_1 release];
    [rightField_2 release];
    [dateFormatter release];
    [timeFormatter release];
    [tableViewController release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    datePicker = nil;
    timePicker = nil;
    pickerView = nil;
    timeFormatter = nil;
    dateFormatter = nil;
    leftField = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    swappingViews = NO;     
    isSelected = NO;
    [self.view setFrame:[[UIScreen mainScreen] applicationFrame]];
  

    if (managedObjectContext == nil){
        managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"ADDENTITYVIEWCONTROLLER After managedObjectContext: %@",  managedObjectContext);        
    }

    MyDataObject *myData = [self myDataObject]; //Create instance of Shared Data Object (SDO)- autoreleases.
    
    NSLog(@"MY DATA OBJECT newNote.text = %@", myData.myNote.text);
    
    Note *newNote = myData.myNote; // Point instance of Note to Note object in SDO
    
        if ([newNote.type intValue] == 1) {
            NSLog(@"SETTING NEW APPOINTMENT");
            //TODO: Add code here relevant to creating Appointments.
        }
        else if ([newNote.type intValue] == 2){
            NSLog(@"SETTING NEW TASK");
            //TODO: Add code here relevant to creating Tasks.
        }
    
    
    /*--NOTIFICATIONS: register --*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPlan:) name:@"ScheduleSomethingNotification" object:nil];
    // Observe keyboard hide and show notifications to resize the text view appropriately.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    /*-----------------------------*/
    
    
    isSelected = NO; //????
    
    if (sender == @""){// FOR the toggle button at top of Calendar View
        sender = @"Appointment";
    }
    recurring = [[NSArray alloc] initWithObjects:@"Never",@"Daily",@"Weekly", @"Fortnightly", @"Monthy", @"Annualy",nil];
    
    
    //IS THIS NECESSARY HERE?
    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateFormat:@"EEE, MMM d, yyy"];
    self.timeFormatter = [[NSDateFormatter alloc]init];
	[self.timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    /*-----------------------------*/

    /*-- VIEWS:BASE: setup and initialize --*/
    [self setTitle:@"Calendar"];//TODO:When user selects Appointment then this label must change to "Calendar: New Appointment"

    [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
    //previousTextInput = @"";
    
    //MIDVIEW
    midView = [[UIView alloc]initWithFrame:midViewRect];
    [self.view addSubview:midView];
    

     /*--NAVIGATION BAR ITEMS --*/    
    /*- Initialize the Navigation Bar -*/
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"todo_nav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addPlan:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    self.navigationItem.leftBarButtonItem.tag = 0;
    [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
   
    /*--VIEWS:CONTROL VIEWS -*/

    /*-Initialize the toolBar-*/
    toolBar = [[CustomToolBar alloc] initWithFrame:toolBarRect];
    [toolBar.firstButton setTarget:self];
    [toolBar.firstButton setAction:@selector(setAppointmentDate)];    
    [toolBar.secondButton setTarget:self];
    [toolBar.secondButton setAction:@selector(setAlarm:)];
    [toolBar.dismissKeyboard setTarget:self];
    [toolBar.dismissKeyboard setAction:@selector(dismissKeyboard)];
    
    /*-- Input Views --*/
    UIImage *patternImage = [UIImage imageNamed:@"54700.png"];//background image for the input views
    
    //TEXTVIEW: setup and add to self.view    
    textView = [[CustomTextView alloc] initWithFrame:textViewRect];
    self.textView.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    [textView setDelegate:self];
    [textView setInputView:datePicker];
    [textView setInputAccessoryView:toolBar];
    [self.view addSubview:textView];    
    [textView setText:myData.myNote.text];

    //TEXTFIELDS
    //DATE FIELD ENTERS FROM LEFT.
    leftField = [[CustomTextField alloc] initWithFrame:CGRectMake(-150, 0, 150, 30)];
    [leftField setPlaceholder:@"Date:"];
    [leftField setInputView:datePicker];
    [leftField setInputAccessoryView:toolBar];
    [leftField setTag:12];
    [leftField setDelegate:self];
    [leftField setBorderStyle:UITextBorderStyleNone];
    [leftField setBackground:[UIImage imageNamed:@"54700.png"]];
    [leftField.layer setCornerRadius:5.0];
    [leftField setTextAlignment:UITextAlignmentCenter];
    [leftField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [leftField setTextColor:[UIColor blackColor]];
    
    //START TIME FIELD ENTERS FROM RIGHT
    rightField_1 = [[CustomTextField alloc] initWithFrame:CGRectMake(screenRect.size.width, 0, 75, 30)];
    [rightField_1 setPlaceholder:@"Starts"];
    [rightField_1 setInputView:timePicker];
    [rightField_1 setInputAccessoryView:toolBar];
    [rightField_1 setTag:13];
    [rightField_1 setDelegate:self];
    [rightField_1 setBorderStyle:UITextBorderStyleNone];
    [rightField_1 setBackground:[UIImage imageNamed:@"54700.png"]];
    [rightField_1.layer setCornerRadius:5.0];
    [rightField_1 setTextAlignment:UITextAlignmentCenter];
    [rightField_1 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];

    [rightField_1 setTextColor:[UIColor blackColor]];

    //END TIME FIELD ENTERS FROM RIGHT
    rightField_2 = [[CustomTextField alloc]initWithFrame:CGRectMake(screenRect.size.width, 0, 75, 30)];
    [rightField_2 setPlaceholder:@"Ends:"];
    [rightField_2 setInputView:timePicker];
    [rightField_2 setInputAccessoryView:toolBar];
    [rightField_2 setTag:14];
    [rightField_2 setDelegate:self];
    [rightField_2 setBorderStyle:UITextBorderStyleNone];
    [rightField_2 setBackground:[UIImage imageNamed:@"54700.png"]];
    [rightField_2.layer setCornerRadius:5.0];
    [rightField_2 setTextAlignment:UITextAlignmentCenter];
    [rightField_2 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [rightField_2 setTextColor:[UIColor blackColor]];
    
    //RECURRINGFIELD ENTER FROM RIGHT
    rightField = [[CustomTextField alloc] initWithFrame:CGRectMake(screenRect.size.width, 0, 150, 30)];
    [rightField setPlaceholder:@"Repeats:"];
    [rightField setInputView:pickerView];
    [rightField setInputAccessoryView:toolBar];
    [rightField setTag:14];
    [rightField setDelegate:self];
    [rightField setBorderStyle:UITextBorderStyleNone];
    [rightField setBackground:[UIImage imageNamed:@"54700.png"]];
    [rightField.layer setCornerRadius:5.0];
    [rightField setTextAlignment:UITextAlignmentCenter];
    [rightField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [rightField setTextColor:[UIColor blackColor]];    
    
    // PICKERS
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setDate:[NSDate date]];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)]];
    //datePicker.timeZone = [NSTimeZone systemTimeZone];
    [datePicker sizeToFit];
    [datePicker setTag:0];
    [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];

    [datePicker setTimeZone:[NSTimeZone localTimeZone]];

    datePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    timePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    [timePicker setMinuteInterval:10];
    timePicker.timeZone = [NSTimeZone systemTimeZone];
    
    [timePicker sizeToFit];
    [timePicker setTag:1];
    timePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [timePicker addTarget:self action:@selector(timePickerChanged:) forControlEvents:UIControlEventValueChanged];
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
    pickerView.showsSelectionIndicator = YES;
    
    
    /*-------------------*/
    //TABLEVIEWCONTROLLER
    tableViewController = [[AddEntityTableViewController alloc] init]; //init the tableViewController to appropriateTableView
    [tableViewController.tableView setFrame:bottomViewRect];    
    //[tableViewController.tableView.layer setCornerRadius:10.0];
    [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
    [tableViewController.tableView setSectionHeaderHeight:18];
    tableViewController.tableView.rowHeight = 30.0;
    //[tableViewController.tableView setTableHeaderView:tableLabel];    
}

- (void) viewWillAppear:(BOOL)animated{    
    MyDataObject *mydata = [self myDataObject];
    tableViewController = nil;
    [textView setText:mydata.myNote.text];

    if (leftField.superview == nil) {
        [midView addSubview:leftField]; 
        [leftField setInputView:datePicker];
        }
    if ([mydata.noteType intValue] == 2) { //Setting up the view to Add Task
        self.title = @"New To Do";
        tableViewController = [[TasksTableViewController alloc]init];
        if (tableViewController.tableView.superview == nil) {
            [self.view addSubview:tableViewController.tableView];
            }
        CGRect startFrame = CGRectMake(-screenRect.size.width, bottomViewRect.origin.y, bottomViewRect.size.width, bottomViewRect.size.height);
        tableViewController.tableView.frame = startFrame;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        CGRect endFrame = bottomViewRect;
        tableViewController.tableView.frame = endFrame;
        leftField.frame = CGRectMake(4, 0, 150, midViewRect.size.height);
        [UIView commitAnimations];    
        }
    else {//Setting up the view to Add Appointment
        self.title = @"New Appointment";
        tableViewController = [[AddEntityTableViewController alloc]init];
        if (tableViewController.tableView.superview == nil) {
            [self.view addSubview:tableViewController.tableView];
            }
        CGRect startFrame = CGRectMake(-screenRect.size.width, bottomViewRect.origin.y, bottomViewRect.size.width, bottomViewRect.size.height);
        tableViewController.tableView.frame = startFrame;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        tableViewController.tableView.frame = bottomViewRect;
        textView.frame = CGRectMake(textViewRect.origin.x, textViewRect.origin.y, textViewRect.size.width, textViewRect.size.height-midViewRect.size.height);
        midView.frame = CGRectMake(midViewRect.origin.x, textView.frame.origin.y+textView.frame.size.height+5, midViewRect.size.width, midViewRect.size.height);
        leftField.frame = CGRectMake(4, 0, 150, midViewRect.size.height);
        [UIView commitAnimations];    
    }   
}

- (void) viewWillDisappear:(BOOL)animated{
    self.title = @"Calendar";
    [leftField removeFromSuperview];
    [rightField_1 removeFromSuperview];
    [rightField_2 removeFromSuperview];
    [rightField removeFromSuperview];
    [tableViewController.tableView removeFromSuperview];
    [toolBar.firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
    [toolBar.firstButton setTitle:@"Set Date"];
    [toolBar.firstButton setAction:@selector(setAppointmentDate)];
}

#pragma mark -
#pragma mark Text View Delegate Methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textView.inputAccessoryView == nil) {
        }
    [self.textView setInputAccessoryView:toolBar];
    return YES;    
}  

- (void) textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 0 || textField.text == @"") {
        return; //FIXME: IF THERE IS NO DATE, THEN NO ACTION
    }
  //  NSDate *newDate = [dateFormatter dateFromString:leftField.text];
  //  [datePicker setDate:newDate];
}

- (void)newPlan:(NSNotification *)notification { 
    NSLog(@"GOT NEW NOTE NOTIFICATION");
    Note *newNote = [notification object];
    NSLog(@"GOT A NEW NOTE with the text %@", newNote.text);
    textView.text = newNote.text;
}

#pragma -
#pragma Navigation Controls and Actions

- (void) addPlan:(UIBarButtonItem *) barButtonItem{
    if (barButtonItem.tag == 0) {
        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"clock_running.png"]];
        sender = @"To Do";
        self.navigationItem.leftBarButtonItem.tag = 1;
        [rightField_1 setHidden:YES];
        [rightField_2 setHidden:YES];
        [rightField setHidden:NO];
        self.title = @"New To Do";
        tableViewController = nil;
        tableViewController = [[TasksTableViewController alloc]init];
        [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
        [tableViewController.tableView setSectionHeaderHeight:13];
        tableViewController.tableView.rowHeight = 30.0;
        //[tableViewController.tableView setTableHeaderView:tableLabel];
        [self.view addSubview:tableViewController.tableView];
        CGRect startFrame = CGRectMake(-320, 0, 320, 204);
        CGRect endFrame = bottomViewRect;
        [self animateViews:tableViewController.tableView startFrom:startFrame endAt:endFrame];
    }
    else if (barButtonItem.tag == 1){
        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"todo_nav.png"]];
        sender = @"Appointment";
        self.navigationItem.leftBarButtonItem.tag = 0;
        [rightField_1 setHidden:NO];
        [rightField_2 setHidden:NO];
        [rightField setHidden:YES];
        self.title = @"New Appointment";
        tableViewController = nil;
        tableViewController = [[AddEntityTableViewController alloc]init];
        [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
        [tableViewController.tableView setSectionHeaderHeight:13];
        tableViewController.tableView.rowHeight = 30.0;
        //[tableViewController.tableView setTableHeaderView:tableLabel];
        [self.view addSubview:tableViewController.tableView];
        CGRect startFrame = CGRectMake(320, 205, 320, 204);
        CGRect endFrame = bottomViewRect;
        [self animateViews:tableViewController.tableView startFrom:startFrame endAt:endFrame];
    }
}

- (void) changeView:(UIBarButtonItem *)barButtonItem{
}

#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    /* Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard. */
    if ([textView isFirstResponder]|| [rightField isFirstResponder]||[rightField_1 isFirstResponder]||[rightField_2 isFirstResponder]){
        return;
    }
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
    
    [tableViewController.tableView setFrame:CGRectMake(160, 0, 160, 200)];
    [tableViewController.tableView.layer setCornerRadius:5.0];
    [tableViewController.tableView setBackgroundColor:[UIColor whiteColor]];
    [tableViewController.tableView setAlpha:0.7];
    [textView setAlpha:1.0];
    [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (rightField_1.superview == nil||rightField_2.superview == nil){
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
    
    tableViewController.tableView.frame = bottomViewRect;    
    tableViewController.tableView.layer.cornerRadius = 0.0;
    [self.navigationController.navigationBar setHidden:NO];
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark RESPOND TO TOUCHES


-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    UITouch *touch = [touches anyObject];
    if (touch.view.tag == 12) {
        [leftField setHighlighted:YES];
        [rightField_1 setHighlighted:NO];
        [rightField_2 setHighlighted:NO];
    }
    else if (touch.view.tag == 13) {
        [rightField_1 setHighlighted:YES];
        [leftField setHighlighted:NO];
        [rightField_2 setHighlighted:NO];
    }
    else if (touch.view.tag == 14) {
        [rightField_2 setHighlighted:YES];
        [leftField setHighlighted:NO];
        [rightField_1 setHighlighted:NO];
    }
    else {
        [rightField setHighlighted:YES];
        [leftField setHighlighted:NO];
    }
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component{

    rightField.text = [recurring objectAtIndex:row];
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

//DATE PICKER METHODS

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
    leftField.text = [dateFormatter stringFromDate:selectedDate];
    
    [[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"GetDateNotification" object:selectedDate];
    MyDataObject *myDataObject = [self myDataObject];
    myDataObject.myDate = selectedDate;
}

- (IBAction)timePickerChanged:(id)sender{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[timePicker date]];    
    [timeComponents setHour:[timeComponents hour]];
    [timeComponents setMinute:[timeComponents minute]];
    [timeComponents setSecond:[timeComponents second]];
    [timeComponents setYear:0];
    [timeComponents setMonth:0];
    [timeComponents setDay:0];
    
    if ([rightField_1 isFirstResponder]) {
        NSDate *selectedTime= [calendar dateFromComponents:timeComponents];
        rightField_1.text = [timeFormatter stringFromDate:selectedTime];
    }
    else if ([rightField_2 isFirstResponder]) {
        NSDate *selectedEndTime= [calendar dateFromComponents:timeComponents];
        rightField_2.text = [self.timeFormatter stringFromDate:selectedEndTime];
    }
}

- (void) setAppointmentDate{
    if ([tableViewController isKindOfClass:[AddEntityTableViewController class]]) {
        [leftField resignFirstResponder];
        [toolBar.firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
        [toolBar.firstButton setAction:@selector(setAppointmentTime)];
        [toolBar.firstButton setTitle:@"Set Time"];   
        if (rightField_1.superview == nil) {
            [midView addSubview:rightField_1];
            [rightField_1 setInputView:timePicker];
            [rightField_1 becomeFirstResponder];
        }    
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];    
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(removeDatePicker)];        
        CGRect endFrame = CGRectMake(leftField.frame.origin.x+leftField.frame.size.width+10, 0, 75, leftField.frame.size.height);
        rightField_1.frame = endFrame;

        [UIView commitAnimations];

    }
    else if ([tableViewController isKindOfClass:[TasksTableViewController class]]){
        [leftField resignFirstResponder];
        [toolBar.firstButton setImage:[UIImage imageNamed:@"save.png"]];
        [toolBar.firstButton setAction:@selector(doneAction)];
        [toolBar.firstButton setTitle:@"Done"];
        if (rightField.superview == nil) {
            [midView addSubview:rightField];
            [rightField setInputView:pickerView];
            rightField.text = [recurring objectAtIndex:0];  
            [rightField becomeFirstResponder];
        }    
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];    
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(removeDatePicker)];  
        CGRect endFrame = CGRectMake(leftField.frame.origin.x+leftField.frame.size.width+10, 0, 150, leftField.frame.size.height);
        rightField.frame = endFrame;
               
        [UIView commitAnimations];
    }
    /*-- DATE/TIME: Get selected Date from the time Picker; put it in the date text field --*/
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:[datePicker date]];
    [dateComponents setYear:[dateComponents year]];
    [dateComponents setMonth:[dateComponents month]];
    [dateComponents setDay:[dateComponents day]];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    NSDate *selectedDate = [[calendar dateFromComponents:dateComponents] retain];
    leftField.text = [dateFormatter stringFromDate:selectedDate];
    NSLog(@"DO DATE is %@", selectedDate);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [tableViewController.tableView setFrame:CGRectMake(160, 0, 160, 200)];
    [tableViewController.tableView.layer setCornerRadius:10.0];
    [tableViewController.tableView setBackgroundColor:[UIColor whiteColor]];
    [tableViewController.tableView setAlpha:0.7];
    [textView setAlpha:1.0];
    [UIView commitAnimations];    
    return;
}

- (void) setAppointmentTime{
    if (rightField_2.superview == nil) {
        [midView addSubview:rightField_2];
        [rightField_2 setInputView:timePicker];
        [rightField_1 resignFirstResponder];
        [rightField_2 becomeFirstResponder];
    }    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];    
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(removeDatePicker)];        
    CGRect endFrame = CGRectMake(rightField_1.frame.origin.x+rightField_1.frame.size.width+2, 0, 76, midViewRect.size.height);
    rightField_2.frame = endFrame;
    
    [UIView commitAnimations];
        
    /*--DATE/TIME: Get selected Time from the time Picker; put it in the time text field --*/
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *timeComponents = [calendar components:(NSYearCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[timePicker date]];    
    [timeComponents setHour:[timeComponents hour]];
    [timeComponents setMinute:[timeComponents minute]];
    [timeComponents setSecond:[timeComponents second]];
    [timeComponents setYear:[timeComponents year]];
    //[timeComponents setMonth:0];
    //[timeComponents setDay:0];
    NSDate *selectedTime = [[calendar dateFromComponents:timeComponents] retain];
    rightField_1.text = [timeFormatter stringFromDate:selectedTime];
    
    [toolBar.firstButton setImage:[UIImage imageNamed:@"save.png"]];
    [toolBar.firstButton setAction:@selector(doneAction)];
    [toolBar.firstButton setTitle:@"Done"];
    NSLog(@"DO TIME is %@", selectedTime);
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
        [newAppointment setDoDate:[dateFormatter dateFromString:leftField.text]];
        [newAppointment setDoTime:[timeFormatter dateFromString:rightField_1.text]];
        [newAppointment setEndTime:[timeFormatter dateFromString:rightField_2.text]];
        /*--Save the MOC--*/	
        NSError *error;
        if(![managedObjectContext save:&error]){ 
            NSLog(@"APPOINTMENTS VIEWCONTROLLER MOC: DID NOT SAVE");
            } 
        NSLog(@"DO DATE is %@", newAppointment.doDate);
        NSDateFormatter *temp = [[NSDateFormatter alloc] init];
        [temp setDateFormat:@"MM/dd/yyyy, HH:mm"];
        NSString *tempString = [temp stringFromDate:newAppointment.doDate];
        NSLog(@"DO DATE is also %@", tempString);
        NSLog(@"DO TIME is %@", newAppointment.doTime);
        NSLog(@"END TIME is %@", newAppointment.endTime);
        [temp release];
        [newAppointment release];
        }
    else if ([tableViewController isKindOfClass:[TasksTableViewController class]]) {
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Task"
                                       inManagedObjectContext:managedObjectContext];
        Task *newTask = [[Task alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [newTask setText:textView.text];
        //Add condition for reedit = if creationDate != nil then break
        [newTask setCreationDate:[NSDate date]];
        [newTask setType:[NSNumber numberWithInt:2]];
        [newTask setDoDate:[dateFormatter dateFromString:leftField.text]];
        [newTask setRecurring:rightField.text];
        /*--Save the MOC--*/	
        NSError *error;
        if(![managedObjectContext save:&error]){ 
            NSLog(@"APPOINTMENTS VIEWCONTROLLER MOC: DID NOT SAVE");
            } 
        NSLog(@"DO DATE is %@", newTask.doDate);
        [newTask release];
    }
    [self.view endEditing:YES];
    [textView setText:@""];
    [leftField setText:@""];
    [rightField_1 setText:@""];
    [rightField_2 setText:@""];
    [rightField setText:@""];
    [toolBar.firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
    [toolBar.firstButton setTitle:@"Set Date"];
    [toolBar.firstButton setAction:@selector(setAppointmentDate)];
    [toolBar.dismissKeyboard setAction:@selector(dismissKeyboard)];   
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(removeAllAddedViews)];

    leftField.frame = CGRectMake(-155, 0, leftField.frame.size.width, midViewRect.size.height);
    rightField.frame = CGRectMake(screenRect.size.width, 0, rightField.frame.size.width, midViewRect.size.height);
    rightField_1.frame = CGRectMake(screenRect.size.width, 0, rightField_1.frame.size.width, midViewRect.size.height);
    rightField_2.frame = CGRectMake(screenRect.size.width, 0, rightField_2.frame.size.width, midViewRect.size.height);
    toolBar.frame = toolBarRect;
    textView.frame = textViewRect;
    midView.frame = CGRectMake(0, midViewRect.origin.y, midViewRect.size.width, midViewRect.size.height);
    tableViewController.tableView.frame = bottomViewRect;
    [tableViewController.tableView reloadData];
    [UIView commitAnimations];
    
}
 

- (void) setAlarm {
    return;
}
- (void) setRecurring {
    return;
}


#pragma mark NAVIGATION

- (void) backAction{
	[self dismissModalViewControllerAnimated:YES];		
}
- (void) dismissKeyboard{
    [self.view endEditing:YES];
    //[tableViewController.tableView removeFromSuperview];
    //[tableViewController.tableView setFrame:CGRectMake(5, 205, 310, 255)];
    //[self.view addSubview:tableViewController.tableView];
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

/*

NSArray * segControlItems = [NSArray arrayWithObjects:[UIImage imageNamed:@"clock_running.png"], [UIImage imageNamed:@"tasks_nav.png"], nil];
UISegmentedControl *leftButton = [[UISegmentedControl alloc] initWithItems:segControlItems];
leftButton.segmentedControlStyle = UISegmentedControlStyleBezeled;
[leftButton setTintColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
[leftButton setBackgroundColor:[UIColor clearColor]];
[leftButton setWidth:50.0 forSegmentAtIndex:0];
[leftButton setWidth:50.0 forSegmentAtIndex:1];
leftButton.momentary = NO;

UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
self.navigationItem.leftBarButtonItem = left;

segControlItems = [NSArray arrayWithObjects:[UIImage imageNamed:@"calendar_nav.png"], [UIImage imageNamed:@"list_nav.png"], nil];
UISegmentedControl *rightButton = [[UISegmentedControl alloc] initWithItems:segControlItems];
rightButton.segmentedControlStyle = UISegmentedControlStyleBezeled;
[rightButton setTintColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
[rightButton setBackgroundColor:[UIColor clearColor]];
[rightButton setWidth:50.0 forSegmentAtIndex:0];
[rightButton setWidth:50.0 forSegmentAtIndex:1];

rightButton.momentary = NO;

UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightButton];


self.navigationItem.rightBarButtonItem = right;    

[leftButton addTarget:self 
               action:@selector(scheduleSomething:) 
     forControlEvents:UIControlEventValueChanged];
[rightButton addTarget:self 
                action:@selector(changeView:) 
      forControlEvents:UIControlEventValueChanged];
 
 - (void) scheduleSomething:(UISegmentedControl *)segmentedControl {
 if ([segmentedControl selectedSegmentIndex] == 0) {
 
 self.title = @"Appointment";
 }
 
 else if ([segmentedControl selectedSegmentIndex] == 1){
 self.title = @"To Do";
 }
 return;
 }
  
 - (void) changeView:(UISegmentedControl *)segmentedControl {
 if ([segmentedControl selectedSegmentIndex] == 0) {
 
 self.title = @"Calendar";
 }
 
 else if ([segmentedControl selectedSegmentIndex] == 1){
 self.title = @"List";
 }
 return;
 }
 
 

 
 // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
 //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timeFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
 //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rightFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
 // Search Bar Notification sent from FolderTable View to the Main view to accommodate the moving TableView 
 //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown)  name:UIKeyboardDidShowNotification object:nil];

 
*/