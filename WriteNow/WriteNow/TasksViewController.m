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
    
    /*Setting Up the Views*/
    NSLog(@"IN TASKS VIEWCONTROLLER");

    /*-- Initializing the managedObjectContext--*/
	if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    }
    /*--Done Initializing the managedObjectContext--*/
    

        
    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1];    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [containerView.layer setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor].CGColor];
    [containerView.layer setOpacity:0.9];
    [self.view addSubview:containerView];
    
    /*--setup the textView for the input text--*/
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 35, 300, 40)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    [textView.layer setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor].CGColor];
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
    label.text = @"New Task";
    [label setFont:[UIFont fontWithName:@"Georgia-BoldItalic" size:18]];
    
    
    /*--Adding the Date and Time Fields--*/
    
    dateField = [[UITextField alloc] initWithFrame:CGRectMake(10, 80, 145, 25)];
    
    [dateField setBorderStyle:UITextBorderStyleRoundedRect];
    //[dateField setBackgroundColor:[UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1]];
    [dateField setPlaceholder:@"Set Date"];
        
    [self.view addSubview:containerView];
    [containerView addSubview:label];
    [containerView addSubview:textView];
    [containerView addSubview:dateField];
    [containerView addSubview:tableViewController.view];    
    
    [self makeToolbar];
    [self.view addSubview:taskToolbar];
    [label release];
    
    [datePicker setFrame:CGRectMake(0, 245, 320, 216)];
    //[datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePicker setDate:[NSDate date]];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)]];
    datePicker.timeZone = [NSTimeZone systemTimeZone];
    [datePicker setTag:0];
    [self.view addSubview:datePicker];
    datePicker.hidden = NO;
    
    swappingViews = NO;

    
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
    UIBarButtonItem *timeButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];
    [timeButton setTag:3];
    [timeButton setWidth:90];
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
    CGRect buttonBarFrame = CGRectMake(0, 200, 320, 45);
    taskToolbar = [[[UIToolbar alloc] initWithFrame:buttonBarFrame] autorelease];
    [taskToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [taskToolbar setTintColor:[UIColor blackColor]];
    UIBarButtonItem *saveAsButton = [[UIBarButtonItem alloc] initWithTitle:@"BACK" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];
    [saveAsButton setTag:0];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"Set Date" style:UIBarButtonItemStyleBordered target:self action:@selector(setTaskDate)];
    [newButton setTag:1];
    UIBarButtonItem *gotoButton = [[UIBarButtonItem alloc] initWithTitle:@"GO TO.." style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];
    [gotoButton setTag:2];
    
    [saveAsButton setWidth:90];
    [newButton setWidth:90];
    [gotoButton setWidth:90];
    
    //UIButton *customView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //Possible to use this with the initWithCustomView method of  UIBarButtonItems
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
    
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithObjects:flexSpace, saveAsButton, flexSpace, newButton, flexSpace, gotoButton, flexSpace,nil];
    [taskToolbar setItems:toolbarItems];
    [saveAsButton release];
    [newButton release];
    [gotoButton release];
    [flexSpace release];
    /*--End Setting up the Toolbar */
}

@end
