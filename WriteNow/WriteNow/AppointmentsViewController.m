//
//  AppointmentsViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WriteNowAppDelegate.h"

#import "AppointmentsViewController.h"
#import "AppointmentCustomCell.h"

@implementation AppointmentsViewController

@synthesize managedObjectContext;
@synthesize tableViewController;

@synthesize datePicker, timePicker;
@synthesize dateField, timeField, recurringField, textView;
@synthesize newAppointment;
@synthesize dateFormatter, timeFormatter;
@synthesize containerView;
@synthesize newText;
@synthesize bottomView;
@synthesize myTableView;

@synthesize appointmentsToolbar;

@synthesize selectedDate, selectedTime;

- (void)dealloc {
    [super dealloc];
    [tableViewController release];
	[datePicker release];
    [timePicker release];    
    [dateField release];
    [timeField release];
    [textView release];
    [dateFormatter release];
    [timeFormatter release];
    [containerView release];
    [newText release];

    //[appointmentsToolbar release];  //WHY CAN'T I RELEASE THIS??????  
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
  
    NSLog(@"Received Memory Warning!");
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dateFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self.dateField];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timeFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self.timeField];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recurringFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self.recurringField];
    
    [super viewDidLoad];
    
    NSLog(@"In AppointmentsViewController");
    /*-- Initializing the managedObjectContext--*/
    if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    }
    /*--Done Initializing the managedObjectContext--*/

    NSLog(@"Trying to Create a newAppointment");
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    self.timeFormatter = [[NSDateFormatter alloc]init];
	[self.timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    /*Setting Up the Views*/
    CGRect topframe = CGRectMake(0, 0, 320, 200);
    CGRect bottomframe = CGRectMake(0, 200, 320, 260);
    
    bottomView = [[UIView alloc] initWithFrame:bottomframe];
    [bottomView setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    [bottomView setAlpha:1.0];
    
    containerView = [[UIView alloc] initWithFrame:topframe];
    [containerView.layer setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1].CGColor];
    
    //[containerView.layer setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor].CGColor];
    [self.view addSubview:containerView];
    
    /*--setup the textView for the input text--*/
    textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 25, 310, 135)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
   // textView.layer.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1].CGColor;
    [textView.layer setBorderWidth:1.0];
    [textView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [textView.layer setCornerRadius:10.0];
    [textView setFont:[UIFont boldSystemFontOfSize:15]];
    [textView setDelegate:self];
    [textView setAlpha:1.0];
    textView.text = newText;
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [label  setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    label.text = @"New Appointment";
    [label setFont:[UIFont fontWithName:@"Georgia-BoldItalic" size:16]];

    /*--Adding the Date and Time Fields--*/

    dateField = [[UITextField alloc] initWithFrame:CGRectMake(5, 165, 100, 25)];
    [dateField setBorderStyle:UITextBorderStyleRoundedRect];
    [dateField setPlaceholder:@"Set Date"];
    [dateField setInputView:datePicker];
    [dateField setTag:0];
    [dateField setDelegate:self];

   // [dateField becomeFirstResponder];
    
    timeField = [[UITextField alloc] initWithFrame:CGRectMake(110, 165, 100, 25)];
    [timeField setBorderStyle:UITextBorderStyleRoundedRect];
    [timeField setPlaceholder:@"Set Time"];
    [timeField setInputView:timePicker];
    [timeField setDelegate:self];
    [timeField setTag:1];
    
    recurringField = [[UITextField alloc] initWithFrame:CGRectMake(215, 165, 100, 25)];
    [recurringField setBorderStyle:UITextBorderStyleRoundedRect];
    [recurringField setPlaceholder:@"Repeat?"];
    [recurringField setTag:2];
    [recurringField setDelegate:self];

    [self.view addSubview:containerView];
    [containerView addSubview:label];
    [containerView addSubview:textView];
    [containerView addSubview:dateField];
    [containerView addSubview:timeField];    
    [containerView addSubview:recurringField];

    [self.view addSubview:bottomView];;
    //[label release];
 
    //datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 245, 320, 216)];
    //[datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setDate:[NSDate date]];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)]];
    datePicker.timeZone = [NSTimeZone systemTimeZone];
    
    //timePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 245, 320, 216)];    
    //[timePicker setDatePickerMode:UIDatePickerModeTime];
    timePicker.timeZone = [NSTimeZone systemTimeZone];
    [timePicker setTag:1];
        
    //tableLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, 20)];
    //[tableLabel setBackgroundColor:[UIColor lightGrayColor]];
    //[tableLabel setTextColor:[UIColor whiteColor]];
    //[tableLabel setTextAlignment:UITextAlignmentCenter];
    //[tableLabel setText:@"All Appointments"];
    //[self.view addSubview:tableLabel];
    
    [myTableView setFrame:CGRectMake(5, 5, 310, 255)];
    [myTableView setSeparatorColor:[UIColor blackColor]];
    [myTableView setSectionHeaderHeight:18];
    [myTableView.layer setCornerRadius:5.0];
    //[self.tableView setTableHeaderView:tableLabel];
    myTableView.rowHeight = 30.0;
    
    [bottomView addSubview:myTableView];    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.dateFormatter = nil;
    self.datePicker = nil;
    self.timePicker = nil;
    self.selectedDate = nil;
    self.selectedTime = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textView.inputAccessoryView == nil) {
        [self makeToolbar];
    }
    [self.textView setInputAccessoryView:appointmentsToolbar];
    return YES;
    
    }   

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
        if (textField.tag == 0){
        NSLog(@"IN DATEFIELD");
    
        if (dateField.inputAccessoryView == nil){
            [self makeToolbar];
        }
            if (self.appointmentsToolbar.tag == 1){
                UIBarButtonItem *datetimeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar_24.png"]style:UIBarButtonItemStylePlain target:self action:@selector(setAppointmentTime)];
                [datetimeButton setTitle:@"Set Date"];
                [datetimeButton setTag:1];
                [datetimeButton setWidth:50.0];
                NSUInteger newButton = 0;
                NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:appointmentsToolbar.items] retain];
                
                for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
                    UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
                    if (barButtonItem.tag == 5) {
                        newButton = i;
                        break;
                    }
                }
                [toolbarItems replaceObjectAtIndex:newButton withObject:datetimeButton];
                appointmentsToolbar.items = toolbarItems;
                [datetimeButton release];
                [toolbarItems release];
                [appointmentsToolbar setTag:0];
            }
                NSLog(@"Setting up the dateField accessory View");
       
                [dateField setInputAccessoryView:appointmentsToolbar];
                [myTableView removeFromSuperview];
                [myTableView setFrame:CGRectMake(5, 5, 310, 155)];
                [myTableView setBackgroundColor:[UIColor clearColor]];
                [myTableView setAlpha:0.8];
                [textView setAlpha:0.2];
                [containerView addSubview:myTableView];
            
        }
    
    else if (textField.tag == 1){
        NSLog(@"IN TIMEFIELD");
        NSLog(@"TimeField is editing");    
        
        if (self.appointmentsToolbar.tag == 0){     
            /*--TOOLBAR:BUTTON: Change Set Date to Set Time  --*/
            //UIBarButtonItem *timeButton = [[UIBarButtonItem alloc] initWithTitle:@"Set Time" style:UIBarButtonItemStyleBordered target:self action:@selector(setAppointmentTime)];
            UIBarButtonItem *datetimeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clock_24.png"]style:UIBarButtonItemStylePlain target:self action:@selector(setAppointmentTime)];
            [datetimeButton setTitle:@"Set Time"];
            [datetimeButton setTag:5];
            [datetimeButton setWidth:50.0];
            NSUInteger newButton = 0;
            NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:appointmentsToolbar.items] retain];
            
            for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
                UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
                if (barButtonItem.tag == 1) {
                    newButton = i;
                    break;
                }
            }
            [toolbarItems replaceObjectAtIndex:newButton withObject:datetimeButton];
            appointmentsToolbar.items = toolbarItems;
            [datetimeButton release];
            [toolbarItems release];
            [appointmentsToolbar setTag:1];
            /*-- TOOLBAR:  done --*/
        }    
        [timeField setInputAccessoryView:appointmentsToolbar];
    }
    else if (textField.tag == 2){
        NSLog(@"IN recurringFIELD");
        NSLog(@"recurringField is editing");
        [recurringField setInputAccessoryView:appointmentsToolbar];
        [myTableView removeFromSuperview];
        [textView setAlpha:1.0];

        }
    return YES;
}

- (void) dateFieldDidEndEditing:(NSNotification *)notification{
    [dateField.inputView removeFromSuperview];   
}

- (void) timeFieldDidEndEditing:(NSNotification *)notification{
    [timeField.inputView removeFromSuperview];
}


- (void) recurringFieldDidEndEditing:(NSNotification *)notification{
    [recurringField.inputView removeFromSuperview];
}

#pragma mark -
#pragma mark Class Methods

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
    timeField.text = [self.timeFormatter stringFromDate:selectedTime];
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

    [timeField becomeFirstResponder];
    
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
    timeField.text = [timeFormatter stringFromDate:selectedTime];
    
    /*--TOOLBAR: Change  Set Time button to Done  --*/
    //UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    [doneButton setTitle:@"Done"];
    [doneButton setWidth:50.0];
    [doneButton setTag:6];
    NSUInteger newButton = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:appointmentsToolbar.items] retain];
    
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 5) {
            newButton = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButton withObject:doneButton];
    appointmentsToolbar.items = toolbarItems;
    [doneButton release];
    [toolbarItems release];
    /*-- TOOLBAR: Finished changing button --*/
    
}

- (void) setAlarm{
    return;
}
- (void) setRecurring{
    return;
}

#pragma mark -
#pragma mark Navigation

- (void) doneAction{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Appointment"
                                   inManagedObjectContext:managedObjectContext];
    newAppointment = [[Appointment alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    [newAppointment setText:textView.text];
    //Add condition for reedit = if creationDate != nil then break
    [newAppointment setCreationDate:[NSDate date]];
    [newAppointment setType:[NSNumber numberWithInt:1]];
    [newAppointment setDoDate:selectedDate];
    [newAppointment setDoTime:selectedTime];
    
    NSLog(@"newAppointment.text = %@", newAppointment.text);
    NSLog(@"newAppointment.creationDate = %@", newAppointment.creationDate);
    NSLog(@"newAppointment.type = %d", [newAppointment.type intValue]);
    /*--Save the MOC--*/	
	NSError *error;
	if(![managedObjectContext save:&error]){ 
        NSLog(@"APPOINTMENTS VIEWCONTROLLER MOC: DID NOT SAVE");
	} 
    [self dismissModalViewControllerAnimated:YES];
}



- (void) backAction{
    
	[self dismissModalViewControllerAnimated:YES];		
}
- (void) dismissKeyboard{
    [self.view endEditing:YES];
    [self.view resignFirstResponder];
}



@end
