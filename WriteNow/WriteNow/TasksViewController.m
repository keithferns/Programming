//
//  TasksViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WriteNowAppDelegate.h"


#import "TasksViewController.h"

@implementation TasksViewController

@synthesize managedObjectContext;
@synthesize newTask;

@synthesize datePicker;
@synthesize taskToolbar;
@synthesize dateField,textView,containerView;
@synthesize dateFormatter;
@synthesize tableViewController;
@synthesize selectedDate;
@synthesize newText;

- (void)dealloc {
    [super dealloc];
	[datePicker release];
    //[taskToolbar release];   
    [dateField release];
    [textView release];
    [dateFormatter release];
    //[selectedDate release];
    [newTask release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dateFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self.dateField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dateFieldDidBeginEditing:) name:UITextFieldTextDidEndEditingNotification object:self.dateField];
    
    /*-- Initializing the managedObjectContext--*/
	if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    }
    /*--Done Initializing the managedObjectContext--*/
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];

    
    /*-- VIEW:   Setting Up the Views   -- */
    NSLog(@"IN TASKS VIEWCONTROLLER");
 
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [containerView.layer setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1].CGColor];
    //[containerView.layer setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor].CGColor];
    [containerView.layer setOpacity:0.9];
    [self.view addSubview:containerView];
    
    /* SCREEN:LABEL:    --*/
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [label  setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    label.text = @"New Task";
    [label setFont:[UIFont fontWithName:@"Georgia-BoldItalic" size:17]];
    [containerView addSubview:label];
    
    /*--setup the textView for the input text--*/
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 22, 300, 40)];
    textView.contentInset = UIEdgeInsetsMake(0, 2, 0, 2);
    //textView.layer.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1].CGColor;
    [textView.layer setBorderWidth:1.0];
    [textView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [textView.layer setCornerRadius:10.0];
    
    CALayer *shadowSublayer = [CALayer layer];
    [shadowSublayer setShadowOffset:CGSizeMake(0, 3)];
    [shadowSublayer setShadowRadius:5.0];
    [shadowSublayer setShadowColor:[UIColor blackColor].CGColor];
    [shadowSublayer setShadowOpacity:0.8];
    [shadowSublayer setCornerRadius:10.0];
    [shadowSublayer setFrame:CGRectMake(textView.layer.frame.origin.x+5, textView.layer.frame.origin.y+5, textView.frame.size.width-10, textView.frame.size.height-10)];
    [textView.layer addSublayer:shadowSublayer];
    [textView setFont:[UIFont boldSystemFontOfSize:14]];
    [textView setDelegate:self];
    [textView setAlpha:1.0];
    textView.text = newText;
    [containerView addSubview:textView];

    /*--Adding the Date Field--*/
    
    dateField = [[UITextField alloc] initWithFrame:CGRectMake(10, 65, 145, 25)];
    [dateField setBorderStyle:UITextBorderStyleRoundedRect];
    //[dateField setBackgroundColor:[UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1]];
    [dateField setPlaceholder:@"Set Date"];
    [dateField setFont:[UIFont systemFontOfSize:14]];
    [dateField setInputView:datePicker];

    [containerView addSubview:dateField];    
    
    [containerView addSubview:tableViewController.view];    
    [label release];
    
    [datePicker setDate:[NSDate date]];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)]];
    datePicker.timeZone = [NSTimeZone systemTimeZone];
    [datePicker setTag:0];
    
    swappingViews = NO;    
    
}

- (void)dateFieldDidBeginEditing:(NSNotification *)notification{
    [self makeToolbar];
    [dateField setInputAccessoryView:taskToolbar];
}

- (void) dateFieldDidEndEditing:(NSNotification *)notification{
    [dateField.inputView removeFromSuperview];
    
}
    
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.datePicker = nil;
    self.dateFormatter = nil;
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
	swappingViews = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)datePickerChanged:(id)sender{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:[datePicker date]];
    [dateComponents setYear:[dateComponents year]];
    [dateComponents setMonth:[dateComponents month]];
    [dateComponents setDay:[dateComponents day]];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    selectedDate = [calendar dateFromComponents:dateComponents];
    NSLog(@"Selected Date: %@", selectedDate);
    dateField.text = [self.dateFormatter stringFromDate:selectedDate];
    
    [[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"GetDateNotification" object:self.selectedDate];

}

- (void) setTaskDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:[datePicker date]];
    [dateComponents setYear:[dateComponents year]];
    [dateComponents setMonth:[dateComponents month]];
    [dateComponents setDay:[dateComponents day]];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    
    selectedDate = [[calendar dateFromComponents:dateComponents]retain];

    if (!swappingViews) {
        [self swapViews];
    }
    UIBarButtonItem *timeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save.png"]style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    [timeButton setTitle:@"Save"];
    [timeButton setTag:5];
    [timeButton setWidth:50.0];
    NSUInteger newButton = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:taskToolbar.items] retain];
    
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 1) {
            newButton = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButton withObject:timeButton];
    taskToolbar.items = toolbarItems;
    [timeButton release];
    [toolbarItems release];
    
}


- (void) doneAction{
    [self dismissModalViewControllerAnimated:YES];
    
    NSLog(@"Trying to Create a newTask");
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Task"
                                   inManagedObjectContext:managedObjectContext];
    
    newTask = [[Task alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    [newTask setText:textView.text];
    //Add condition for reedit = if creationDate != nil then break
    [newTask setCreationDate:[NSDate date]];
    [newTask setType:[NSNumber numberWithInt:2]];
    [newTask setDoDate:selectedDate];
    
    NSLog(@"newTask.text = %@", newTask.text);
    NSLog(@"newTask.creationDate = %@", newTask.creationDate);
    NSLog(@"newTask.type = %d", [newTask.type intValue]);
    NSLog(@"newTask.doDate = %@", newTask.doDate);
    
    NSError *error;
    if(![self.managedObjectContext save:&error]){ 
        NSLog(@"MainViewController MOC: DID NOT SAVE");
    }
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
    taskToolbar = [[[UIToolbar alloc] initWithFrame:buttonBarFrame] autorelease];
    [taskToolbar setBarStyle:UIBarStyleDefault];
    [taskToolbar setTintColor:[UIColor colorWithRed:0.34 green:0.36 blue:0.42 alpha:0.3]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    [backButton setTitle:@"Back"];
    [backButton setWidth:50.0];
    [backButton setTag:0];    
    
    UIBarButtonItem *datetimeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar_24.png"]style:UIBarButtonItemStylePlain target:self action:@selector(setTaskDate)];
    [datetimeButton setTitle:@"Set Date"];
    [datetimeButton setTag:1];
    [datetimeButton setWidth:50.0];
     
    UIBarButtonItem *alarmButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"alarm_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(setAlarm)];
    [alarmButton setTitle:@"Remind"];
    [alarmButton setWidth:50.0];
    [alarmButton setTag:2];
    
    UIBarButtonItem *recurrenceButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_circle_left_24.png"] style:UIBarButtonItemStylePlain target:self action:@selector(setRecurring)];
    [recurrenceButton setTitle:@"Repeat"];
    [recurrenceButton setWidth:50.0];
    [recurrenceButton setTag:3];
    
    UIBarButtonItem *dismissKeyboard = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"keyboard_down.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard)];
    [dismissKeyboard setWidth:50.0];
    [dismissKeyboard setTag:4];
    
    //UIButton *customView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //Possible to use this with the initWithCustomView method of  UIBarButtonItems
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
    
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithObjects: backButton, flexSpace, datetimeButton, flexSpace,alarmButton, flexSpace, recurrenceButton,flexSpace,dismissKeyboard, nil];
    [taskToolbar setItems:toolbarItems];
    [backButton release];
    [datetimeButton release];
    [alarmButton release];
    [dismissKeyboard release];
    [flexSpace release];
    /*--End Setting up the Toolbar */
}

@end
