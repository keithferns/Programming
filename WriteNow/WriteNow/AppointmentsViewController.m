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
@synthesize dateField, timeField, textView;
@synthesize newAppointment;
@synthesize dateFormatter, timeFormatter;
@synthesize containerView;
@synthesize newText;

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

    //[selectedDate release]; //Releasing this causes a problem. WHY?
    //[selectedTime release]; //Releasing this causes a problem. WHY?
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
  
    NSLog(@"Received Memory Warning!");
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    /*Setting Up the Views*/
    NSLog(@"In AppointmentsViewController");
    /*-- Initializing the managedObjectContext--*/
    if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    }
    
    NSLog(@"Trying to Create a newAppointment");
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    self.timeFormatter = [[NSDateFormatter alloc]init];
	[self.timeFormatter setTimeStyle:NSDateFormatterShortStyle];

    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1];    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [containerView.layer setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor].CGColor];
    [containerView.layer setOpacity:0.9];
    [self.view addSubview:containerView];
    
    /*--setup the textView for the input text--*/
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 35, 300, 40)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    textView.layer.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1].CGColor;
    [textView.layer setBorderWidth:1.0];
    [textView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [textView.layer setCornerRadius:10.0];
    [textView setFont:[UIFont boldSystemFontOfSize:15]];
    [textView setDelegate:self];
    [textView setAlpha:1.0];
    textView.text = newText;
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [label  setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    label.text = @"New Appointment";
    [label setFont:[UIFont fontWithName:@"Georgia-BoldItalic" size:18]];
    
    /*--Adding the Date and Time Fields--*/

    dateField = [[UITextField alloc] initWithFrame:CGRectMake(10, 80, 145, 25)];
    
    [dateField setBorderStyle:UITextBorderStyleRoundedRect];
    //[dateField setBackgroundColor:[UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1]];
    [dateField setPlaceholder:@"Set Date"];
    
    timeField = [[UITextField alloc] initWithFrame:CGRectMake(165, 80, 145, 25)];
    [timeField setBorderStyle:UITextBorderStyleRoundedRect];
    //[timeField setBackgroundColor:[UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1]];
    [timeField setPlaceholder:@"Set Time"];
        
    [self.view addSubview:containerView];
    [containerView addSubview:label];
    [containerView addSubview:textView];
    [containerView addSubview:dateField];
    [containerView addSubview:timeField];    
    //[containerView addSubview:tableView];

    [containerView addSubview:tableViewController.view];    

    [label release];
    
    [self makeToolbar];
    [self.view addSubview:appointmentsToolbar];
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 245, 320, 216)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setDate:[NSDate date]];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)]];
    datePicker.timeZone = [NSTimeZone systemTimeZone];
    [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    datePicker.hidden = NO;
    
    timePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 245, 320, 216)];    
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    timePicker.timeZone = [NSTimeZone systemTimeZone];
    [timePicker setTag:1];
    [timePicker addTarget:self action:@selector(timePickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:timePicker];
    timePicker.hidden = YES;
    
    

    /*--Done Initializing the managedObjectContext--*/
    swappingViews = NO;
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

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
	swappingViews = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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


- (void) backAction{
    
	[self dismissModalViewControllerAnimated:YES];		
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
    
    if (!swappingViews) {
        [self swapViews];
    }
    
    /*--TOOLBAR:BUTTON: Change Set Date to Set Time  --*/
    //UIBarButtonItem *timeButton = [[UIBarButtonItem alloc] initWithTitle:@"Set Time" style:UIBarButtonItemStyleBordered target:self action:@selector(setAppointmentTime)];
    UIBarButtonItem *datetimeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clock_24.png"]style:UIBarButtonItemStylePlain target:self action:@selector(setAppointmentTime)];
    [datetimeButton setTitle:@"Time"];
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
    /*-- TOOLBAR:  done --*/

    /*-- DATEPICKER: hide --*/
    datePicker.hidden = YES;
    timePicker.hidden = NO;
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

#pragma mark -
#pragma mark Navigation

- (void) makeToolbar {
    /*Setting up the Toolbar */
    CGRect buttonBarFrame = CGRectMake(0, 195, 320, 50);
    appointmentsToolbar = [[[UIToolbar alloc] initWithFrame:buttonBarFrame] autorelease];
    [appointmentsToolbar setBarStyle:UIBarStyleDefault];
    [appointmentsToolbar setTintColor:[UIColor colorWithRed:0.34 green:0.36 blue:0.42 alpha:0.3]];

    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    [backButton setTitle:@"Back"];
    [backButton setWidth:50.0];
    [backButton setTag:0];    
    
    UIBarButtonItem *datetimeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar_24.png"]style:UIBarButtonItemStylePlain target:self action:@selector(setAppointmentDate)];
    [datetimeButton setTitle:@"Schedule"];
    [datetimeButton setTag:1];
    [datetimeButton setWidth:50.0];
    
    UIBarButtonItem *recurrenceButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_circle_left_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(setRecurring)];
    [recurrenceButton setTitle:@"Repeat"];
    [recurrenceButton setWidth:50.0];
    [recurrenceButton setTag:3];
    
    UIBarButtonItem *alarmButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"alarm_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(setAlarm)];
    [alarmButton setTitle:@"Remind"];
    [alarmButton setWidth:50.0];
    [alarmButton setTag:2];
    
    UIBarButtonItem *dismissKeyboard = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"keyboard_down.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard)];
    [dismissKeyboard setWidth:50.0];
    [dismissKeyboard setTag:4];
    
    //UIButton *customView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //Possible to use this with the initWithCustomView method of  UIBarButtonItems
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
    
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithObjects: backButton, flexSpace, datetimeButton, flexSpace,alarmButton, flexSpace, recurrenceButton,flexSpace,dismissKeyboard, nil];
    [appointmentsToolbar setItems:toolbarItems];
    [backButton release];
    [datetimeButton release];
    [alarmButton release];
    [dismissKeyboard release];
    [flexSpace release];
    /*--End Setting up the Toolbar */
}

@end
