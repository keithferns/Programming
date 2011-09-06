//
//  CalendarViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "WriteNowAppDelegate.h"
#import "CalendarViewController.h"
#import "AddEntityTableViewController.h"
#import "TasksTableViewController.h"

#import "CustomTextView.h"
#import "CustomToolBar.h"
#import "CustomTextField.h"

@implementation CalendarViewController

@synthesize tableViewController;
@synthesize managedObjectContext;

@synthesize sender, newText, recurring;
@synthesize datePicker, timePicker, pickerView;
@synthesize textView;
@synthesize dateField, startTimeField, endTimeField, recurringField;
@synthesize selectedDate, selectedTime;
@synthesize dateFormatter, timeFormatter;
@synthesize toolbar;


- (void)dealloc {
    [super dealloc];
    [sender release];
    [newText release];
    [recurring release];
    [datePicker release];
    [timePicker release];
    [pickerView release];
    [dateField release];
    [startTimeField release];
    [endTimeField release];
    [dateFormatter release];
    [timeFormatter release];
    [tableViewController release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    datePicker = nil;
    timePicker = nil;
    pickerView = nil;
    timeFormatter = nil;
    dateField = nil;
    selectedDate = nil;
    selectedTime = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    swappingViews = NO;     
    isSelected = NO;
    
    recurring = [[NSArray alloc] initWithObjects:@"Never",@"Daily",@"Weekly", @"Fortnightly", @"Monthy", @"Annualy",nil];

    [self.view setFrame:[[UIScreen mainScreen] applicationFrame]];
    
    if (managedObjectContext == nil){
        managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"ADDENTITYVIEWCONTROLLER After managedObjectContext: %@",  managedObjectContext);        
    }

    
    /*--NOTIFICATIONS: register --*/
    
    // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dateFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:dateField];
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timeFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:startTimeField];
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recurringFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:endTimeField];
    
    /* Search Bar Notification sent from FolderTable View to the Main view to accommodate the moving TableView 
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown)  name:UIKeyboardDidShowNotification object:foldersViewController.searchBar];
     */
    
    // Observe keyboard hide and show notifications to resize the text view appropriately.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
    /*-- VIEWS:BASE: setup and initialize --*/
    [self setTitle:@"Calendar"];//TODO:When user selects Appointment then this label must change to "Calendar: New Appointment"

    [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
    //previousTextInput = @"";
    
    /*--NAVIGATION ITEMS --*/    
    
    /*-Initialize the TOOLBAR-*/
    
    toolbar = [[CustomToolBar alloc] initWithFrame:CGRectMake(0, 195, 320, 40)];
    [toolbar.firstButton setTarget:self];
    //Action: change the label, change the button image
    
    [toolbar.secondButton setTarget:self];
    // [toolbar.datetimeButton setAction:@selector(newAppointment)];
    
    [toolbar.dismissKeyboard setTarget:self];
    [toolbar.dismissKeyboard setAction:@selector(dismissKeyboard)];
    
    /*- Initialize the Navigation Bar -*/
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"todo_nav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addPlan:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    self.navigationItem.leftBarButtonItem.tag = 0;
    [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];

    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setDate:[NSDate date]];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)]];
    datePicker.timeZone = [NSTimeZone systemTimeZone];
    [datePicker sizeToFit];
    [datePicker setTag:0];
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
       
    //TABLEVIEWCONTROLLER
    
    tableViewController = [[AddEntityTableViewController alloc] init]; //init the tableViewController to appropriateTableView
    [tableViewController.tableView setFrame:CGRectMake(0, 205, 320, 204)];    
    //[tableViewController.tableView.layer setCornerRadius:10.0];
    [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
    [tableViewController.tableView setSectionHeaderHeight:13];
    tableViewController.tableView.rowHeight = 30.0;
    //[tableViewController.tableView setTableHeaderView:tableLabel];
    [self.view addSubview:tableViewController.tableView];
    
    //IS THIS NECESSARY HERE?
    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateFormat:@"EEE, MMM d, yyy"];
    self.timeFormatter = [[NSDateFormatter alloc]init];
	[self.timeFormatter setTimeStyle:NSDateFormatterShortStyle];
}

- (void) viewWillAppear:(BOOL)animated{    
    
    /*--VIEWS:CONTROL VIEWS -*/
    
    //TEXTVIEW
    textView = [[CustomTextView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, 320, 100)];
    textView.delegate = self;
    [textView setText:newText];
    [textView setDelegate:self];
    [textView setInputAccessoryView:toolbar];
    [self.view addSubview:textView];
    
    //TEXTFIELDS
    dateField = [[CustomTextField alloc] initWithFrame:CGRectMake(1, textView.frame.origin.y+textView.frame.size.height+10, 154, 30)];
    [dateField setPlaceholder:@"Date:"];
    [dateField setInputView:datePicker];
    [dateField setInputAccessoryView:toolbar];
    [dateField setTag:0];
    [dateField setDelegate:self];
    [self.view addSubview:dateField];
    
    startTimeField = [[CustomTextField alloc] initWithFrame:CGRectMake(dateField.frame.origin.x+dateField.frame.size.width+10, dateField.frame.origin.y, 77, dateField.frame.size.height)];
    [startTimeField setPlaceholder:@"Starts"];
    [startTimeField setInputView:timePicker];
    [startTimeField setInputAccessoryView:toolbar];
    [startTimeField setDelegate:self];
    [startTimeField setTag:1];
    [self.view addSubview:startTimeField];
    
    endTimeField = [[CustomTextField alloc] initWithFrame:CGRectMake(startTimeField.frame.origin.x+startTimeField.frame.size.width, startTimeField.frame.origin.y, 77, startTimeField.frame.size.height)];
    [endTimeField setPlaceholder:@"Ends:"];
    [endTimeField setInputView:timePicker];
    [endTimeField setInputAccessoryView:toolbar];
    [endTimeField setDelegate:self];
    [endTimeField setTag:2];
    [self.view addSubview:endTimeField];
    [endTimeField setEnabled:NO];

    recurringField = [[CustomTextField alloc] initWithFrame:CGRectMake(dateField.frame.origin.x+dateField.frame.size.width+10, dateField.frame.origin.y, 154, dateField.frame.size.height)];
    [recurringField setPlaceholder:@"Repeats:"];
    [recurringField setInputView:pickerView];
    [recurringField setInputAccessoryView:toolbar];
    [recurringField setDelegate:self];
    [recurringField setTag:3];
    [self.view addSubview:recurringField];
    [recurringField setHidden:YES];
    
}

- (void) viewWillDisappear:(BOOL)animated{
    self.title = @"Calendar";
    [endTimeField release];
    [startTimeField release];
    [dateField release];
    [recurringField release];
    [textView release];
}

#pragma -
#pragma Navigation Controls and Actions


- (void) addPlan:(UIBarButtonItem *) barButtonItem{
    
    if (barButtonItem.tag == 0) {
        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"clock_running.png"]];
        self.navigationItem.leftBarButtonItem.tag = 1;
        [startTimeField setHidden:YES];
        [endTimeField setHidden:YES];
        [recurringField setHidden:NO];
        self.title = @"New To Do";
        tableViewController = nil;
        tableViewController = [[TasksTableViewController alloc]init];
        [tableViewController.tableView setFrame:CGRectMake(0, 205, 320, 204)];    
        //[tableViewController.tableView.layer setCornerRadius:10.0];
        [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
        [tableViewController.tableView setSectionHeaderHeight:13];
        tableViewController.tableView.rowHeight = 30.0;
        //[tableViewController.tableView setTableHeaderView:tableLabel];
        [self.view addSubview:tableViewController.tableView];
    }
    else if (barButtonItem.tag == 1){
        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"todo_nav.png"]];
        self.navigationItem.leftBarButtonItem.tag = 0;
        [startTimeField setHidden:NO];
        [endTimeField setHidden:NO];
        [recurringField setHidden:YES];
        self.title = @"New Appointment";
        tableViewController = nil;
        tableViewController = [[AddEntityTableViewController alloc]init];
        [tableViewController.tableView setFrame:CGRectMake(0, 205, 320, 204)];    
        //[tableViewController.tableView.layer setCornerRadius:10.0];
        [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
        [tableViewController.tableView setSectionHeaderHeight:13];
        tableViewController.tableView.rowHeight = 30.0;
        //[tableViewController.tableView setTableHeaderView:tableLabel];
        [self.view addSubview:tableViewController.tableView];
        
    }
    
}

- (void) changeView:(UIBarButtonItem *)barButtonItem{
    
}



#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    /* Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard. */
    if ([textView isFirstResponder]){
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
    [tableViewController.tableView setFrame:CGRectMake(0, 0, 320, 155)];
    [tableViewController.tableView setBackgroundColor:[UIColor whiteColor]];
    [tableViewController.tableView setAlpha:0.4];
    [textView setAlpha:1.0];
    
    [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
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
#pragma mark Class Methods




#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component{

    recurringField.text = [recurring objectAtIndex:row];
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
    selectedDate = [calendar dateFromComponents:dateComponents];
    NSLog(@"DatePicker Changed. Selected Date: %@", selectedDate);
    dateField.text = [self.dateFormatter stringFromDate:selectedDate];
    
    [[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"GetDateNotification" object:self.selectedDate];
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
    
    selectedTime= [calendar dateFromComponents:timeComponents];
    NSLog(@"Selected Time: %@", selectedTime);
    startTimeField.text = [self.timeFormatter stringFromDate:selectedTime];
}

- (void) setAppointmentDate{
    
    /*-- DATE/TIME: Get selected Date from the time Picker; put it in the date text field --*/
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:[datePicker date]];
    [dateComponents setYear:[dateComponents year]];
    [dateComponents setMonth:[dateComponents month]];
    [dateComponents setDay:[dateComponents day]];
    [dateComponents setHour:12];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    selectedDate = [[calendar dateFromComponents:dateComponents] retain];
    dateField.text = [dateFormatter stringFromDate:selectedDate];
    
    if (sender == @"Appointment") {
        
        [dateField resignFirstResponder];
        [startTimeField becomeFirstResponder];
    }
    else if (sender == @"To Do"){
        
        /*--TOOLBAR: Change  Set Time button to Done  --*/
        //UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
        [doneButton setTitle:@"Done"];
        [doneButton setWidth:50.0];
        [doneButton setTag:6];
        NSUInteger newButton = 0;
        NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:toolbar.items] retain];
        
        for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
            UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
            if (barButtonItem.tag == 1) {
                newButton = i;
                break;
            }
        }
        [toolbarItems replaceObjectAtIndex:newButton withObject:doneButton];
        toolbar.items = toolbarItems;
        [doneButton release];
        [toolbarItems release];
        /*-- TOOLBAR: Finished changing button --*/
    }
    // if (!swappingViews) {
    //     [self swapViews];
    // }
}

- (void) setAppointmentTime{
    /*--DATE/TIME: Get selected Time from the time Picker; put it in the time text field --*/
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[timePicker date]];    
    [timeComponents setHour:[timeComponents hour]];
    [timeComponents setMinute:[timeComponents minute]];
    [timeComponents setSecond:[timeComponents second]];
    [timeComponents setYear:0];
    [timeComponents setMonth:0];
    [timeComponents setDay:0];
    selectedTime = [[calendar dateFromComponents:timeComponents] retain];
    startTimeField.text = [timeFormatter stringFromDate:selectedTime];
    
    /*--TOOLBAR: Change  Set Time button to Done  --*/
    //UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    [doneButton setTitle:@"Done"];
    [doneButton setWidth:50.0];
    [doneButton setTag:6];
    NSUInteger newButton = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:toolbar.items] retain];
    
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 5) {
            newButton = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButton withObject:doneButton];
    toolbar.items = toolbarItems;
    [doneButton release];
    [toolbarItems release];
    /*-- TOOLBAR: Finished changing button --*/
    
    //if (!swappingViews) {
    //    [self swapViews];
    //}
}

- (void) setAlarm{
    return;
}
- (void) setRecurring {
    return;
}


- (void) doneAction {
    
    if (sender == @"Appointment") {
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Appointment"
                                       inManagedObjectContext:managedObjectContext];
        Appointment *newAppointment = [[Appointment alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [newAppointment setText:textView.text];
        //Add condition for reedit = if creationDate != nil then break
        [newAppointment setCreationDate:[NSDate date]];
        [newAppointment setType:[NSNumber numberWithInt:1]];
        [newAppointment setDoDate:selectedDate];
        [newAppointment setDoTime:selectedTime];
        /*--Save the MOC--*/	
        NSError *error;
        if(![managedObjectContext save:&error]){ 
            NSLog(@"APPOINTMENTS VIEWCONTROLLER MOC: DID NOT SAVE");
        } 
        [newAppointment release];
        
    }
    else if (sender == @"To Do") {
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Task"
                                       inManagedObjectContext:managedObjectContext];
        Task *newTask = [[Task alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [newTask setText:textView.text];
        //Add condition for reedit = if creationDate != nil then break
        [newTask setCreationDate:[NSDate date]];
        [newTask setType:[NSNumber numberWithInt:1]];
        [newTask setDoDate:selectedDate];

        /*--Save the MOC--*/	
        NSError *error;
        if(![managedObjectContext save:&error]){ 
            NSLog(@"APPOINTMENTS VIEWCONTROLLER MOC: DID NOT SAVE");
        } 
        [newTask release];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

/*
 - (void) swapViews {
 
 CATransition *transition = [CATransition animation];
 transition.duration = 1.0;
 transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 [transition setType:@"kCATransitionPush"];	
 [transition setSubtype:@"kCATransitionFromRight"];
 
 swappingViews = YES;
 transition.delegate = self;
 
 [self.view.layer addAnimation:transition forKey:nil];
 }
 
 */
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
 

 
*/