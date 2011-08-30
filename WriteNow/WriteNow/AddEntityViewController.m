//
//  AddEntityViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "AddEntityViewController.h"
#import "AddEntityTableViewController.h"
#import "AppointmentsTableViewController.h"
#import "TasksTableViewController.h"

#import "ContainerView.h"
#import "CustomTextView.h"
#import "CustomToolBar.h"

@implementation AddEntityViewController

@synthesize tableViewController;
@synthesize managedObjectContext;

@synthesize sender, newText;
@synthesize datePicker, timePicker;
@synthesize dateField, startTimeField, endTimeField, recurringField;
@synthesize selectedDate, selectedTime;
@synthesize dateFormatter, timeFormatter;
@synthesize toolbar;

- (void)dealloc {
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    self.timeFormatter = [[NSDateFormatter alloc]init];
	[self.timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    ContainerView *topView = [[ContainerView alloc] initWithFrame:CGRectMake(0, 0, 320, 205)];
    ContainerView *bottomView = [[ContainerView alloc] initWithFrame:CGRectMake(0, 205, 320, 260)];
    CustomTextView *textView = [[CustomTextView alloc] initWithFrame:CGRectMake(5, 25, 310, 135)];
    toolbar = [[CustomToolBar alloc] initWithFrame:CGRectMake(0, 195, 320, 40)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [label  setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"Georgia-BoldItalic" size:20]];
    [label setTextColor:[UIColor whiteColor]];
    
    if (sender == @"Appointment") {
    tableViewController = [[AddEntityTableViewController alloc] init];
    label.text = @"New Appointment";
        
        startTimeField = [[UITextField alloc] initWithFrame:CGRectMake(110, 165, 100, 35)];
        [startTimeField setBorderStyle:UITextBorderStyleRoundedRect];
        [startTimeField setPlaceholder:@"From:"];
        [startTimeField setInputView:timePicker];
        [startTimeField setInputAccessoryView:toolbar];
        [startTimeField setDelegate:self];
        [startTimeField setTag:1];
        [topView addSubview:startTimeField];
        
        
        endTimeField = [[UITextField alloc] initWithFrame:CGRectMake(215, 165, 100, 35)];
        [endTimeField setBorderStyle:UITextBorderStyleRoundedRect];
        [endTimeField setPlaceholder:@"To:"];
        [endTimeField setInputView:timePicker];
        [endTimeField setInputAccessoryView:toolbar];
        [endTimeField setDelegate:self];
        [endTimeField setTag:2];
        [topView addSubview:endTimeField];
    }
    else if (sender == @"To Do") {
    tableViewController = [[TasksTableViewController alloc] init];
    label.text = @"New To Do";
        
        recurringField = [[UITextField alloc] initWithFrame:CGRectMake(215, 165, 100, 35)];
        [recurringField setBorderStyle:UITextBorderStyleRoundedRect];
        [recurringField setPlaceholder:@"Repeat:"];
        [recurringField setInputView:timePicker];
        [recurringField setInputAccessoryView:toolbar];
        [recurringField setDelegate:self];
        [recurringField setTag:2];
        [topView addSubview:recurringField];
    }

    [toolbar.backButton setTarget:self];
    [toolbar.backButton setAction:@selector(backAction)];
    [toolbar.dismissKeyboard setTarget:self];
    [toolbar.dismissKeyboard setAction:@selector(dismissKeyboard)];
    
    [textView setInputAccessoryView:toolbar];
    [textView setText:newText];
 
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];
    [topView addSubview:textView];
    [topView addSubview:label];
    
    [tableViewController.tableView setFrame:CGRectMake(0, 0, 320, 260)];    
    [tableViewController.tableView.layer setCornerRadius:10.0];
    [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
    [tableViewController.tableView setSectionHeaderHeight:18];
    tableViewController.tableView.rowHeight = 30.0;
    //[tableViewController.tableView setTableHeaderView:tableLabel];
    [bottomView addSubview:tableViewController.tableView];
    
    /*--Adding the Date Field--*/
    
    dateField = [[UITextField alloc] initWithFrame:CGRectMake(5, 165, 100, 35)];
    [dateField setBorderStyle:UITextBorderStyleRoundedRect];
    [dateField setPlaceholder:@"Date:"];
    [dateField setInputView:datePicker];
    [dateField setInputAccessoryView:toolbar];
    [dateField setTag:0];
    [dateField setDelegate:self];
        // [dateField becomeFirstResponder];
    [topView addSubview:dateField];
    
}

#pragma mark -- ACTIONS

- (IBAction)datePickerChanged:(id)sender{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:[datePicker date]];
    [dateComponents setYear:[dateComponents year]];
    [dateComponents setMonth:[dateComponents month]];
    [dateComponents setDay:[dateComponents day]];
    [dateComponents setHour:12];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    selectedDate = [calendar dateFromComponents:dateComponents];
    NSLog(@"Selected Date: %@", selectedDate);
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
    
    //if (!swappingViews) {
    //    [self swapViews];
    //}
    [startTimeField becomeFirstResponder];
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
    
}

- (void) setAlarm{
    return;
}
- (void) setRecurring {
    return;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark NAVIGATION

- (void) backAction{
	[self dismissModalViewControllerAnimated:YES];		
}

- (void) dismissKeyboard {
    [self.view endEditing:YES];
}

@end
