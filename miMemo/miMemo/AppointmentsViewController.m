//
//  AppointmentsViewController.m
//  Memo
//
//  Created by Keith Fernandes on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppointmentsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "miMemoAppDelegate.h"
#import "NSManagedObjectContext-insert.h"

@implementation AppointmentsViewController

@synthesize managedObjectContext;
@synthesize datePicker;
@synthesize goActionSheet;
@synthesize appointmentsToolbar;
@synthesize dateTextField, timeTextField, textView, newTextInput;
@synthesize selectedDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    /*Setting Up the Views*/
    NSLog(@"In NewTaskViewController");
    

    /*Setting Up the main view */
    //UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    //[myView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    //myView.hidden = NO;
    //self.view = myView;
    
    [self makeToolbar];

    [self.view addSubview:appointmentsToolbar];

    /*--Adding the Text View */
    self.view.layer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
        /*--The Text View --*/
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 45, 300, 50)];
    [self.view addSubview:textView];
    [textView setFont:[UIFont systemFontOfSize:18]];
    textView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    textView.layer.cornerRadius = 7.0;
    textView.layer.frame = CGRectInset(textView.layer.frame, 5, 10);
    textView.layer.contents = (id) [UIImage imageNamed:@"lined_paper_320x200.png"].CGImage;    
    [textView setText:[NSString stringWithFormat:@"%@", newTextInput]];
    [self.view addSubview:textView];
    [textView setDelegate:self];
        /*--Adding the Date and Time Fields--*/

    dateTextField = [[UITextField alloc] init];
    [dateTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [dateTextField setFont:[UIFont systemFontOfSize:15]];
    [dateTextField setFrame:CGRectMake(12, 20, 145, 31)];
    [dateTextField setPlaceholder:@"Set Appointment Date"];
    [self.view addSubview:dateTextField];

    
    timeTextField = [[UITextField alloc] init];
    [timeTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [timeTextField setFont:[UIFont systemFontOfSize:15]];
    [timeTextField setFrame:CGRectMake(160, 20, 145, 31)];
    [timeTextField setPlaceholder:@"Set Appointment Time"];
    [self.view addSubview:timeTextField];
    
    
    /*--Done Setting Up the Views--*/



    
 
    swappingViews = NO;

    
    /*-- Add and Initialize date and time pickers --*/
    //datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 245, 320, 215)];
    //[datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.view addSubview:datePicker];
    datePicker.minimumDate = [NSDate date];		//Now
	datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)];
	datePicker.date = [NSDate date];
    datePicker.timeZone = [NSTimeZone systemTimeZone];
    datePicker.hidden = NO;
    /*
    timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 245, 320, 215)];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    [self.view addSubview:timePicker];
    //TODO: Initialize timePicker to 12:00 PM
    timePicker.hidden = YES;
    */
}

#pragma mark -
#pragma mark Navigation

-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
		case 0:
            [self backAction];
            break;            
		case 1:
            [self setAppointmentDate];
			break;
		case 2:
			self.goActionSheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Go To" delegate:self cancelButtonTitle:@"Later"
								  destructiveButtonTitle:nil otherButtonTitles:@"Memos, Files and Folders", @"Appointments", @"Tasks", nil];
			[goActionSheet showInView:self.view];            
			break;
        case 3:
            [self dismissModalViewControllerAnimated:YES];
            break;     
		default:
			break;
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
		switch (buttonIndex){
			case 3:
			default:
				break;
			case 2:			
				break;
			case 1:			
				break;
			case 0:
				break;				
    }
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	swappingViews = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
 }

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	datePicker = nil;
}

- (void)dealloc {
    [super dealloc];
	[datePicker release];
    [goActionSheet release];
    [appointmentsToolbar release];
    [dateTextField release];
    [timeTextField release];
    [textView release];

    
		//[monthView release];
		//[datetimeView release];
}

#pragma mark -
#pragma mark Class Methods

- (void) backAction{
	[self dismissModalViewControllerAnimated:YES];		
}

- (void) setAppointmentDate{
    
    MemoText *newMemoText = [managedObjectContext insertNewObjectForEntityForName:@"MemoText"];
    [newMemoText setMemoText:textView.text];
    [newMemoText setNoteType:[NSNumber numberWithInt:1]];
    [newMemoText setCreationDate:[NSDate date]];
    
    Appointment *newAppointment = [managedObjectContext insertNewObjectForEntityForName:@"Appointment"];

    newAppointment.memoText = newMemoText;
    newAppointment.selectedDate = [datePicker date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE,dd MMMM, yyyy"];
    newAppointment.doDate = [dateFormatter stringFromDate:newAppointment.selectedDate];
    dateTextField.text = newAppointment.doDate;
    [dateFormatter release];

    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"hh:mm a"];
	newAppointment.doTime = [timeFormatter stringFromDate:newAppointment.selectedDate];
    timeTextField.text = newAppointment.doTime;
    [timeFormatter release];
    //TODO: Add a fetchRequest here to get existing appointments for the date selected.  display a table with existing appointments for that date in the top View. This ideally should happen in sync with the change of datePicker to timePicker. 

    
    //FIXME: add: if the text in textView != newMemoText.memoText then change the value of memoText.Text to textView.text
    
    NSLog(@"new appointment text = %@", newAppointment.memoText.memoText);
    NSLog(@"new appointment due date = %@", newAppointment.doDate);
    NSLog(@"new appointment due date = %@", newAppointment.doDate);

    /*--Save the MOC--*/	
	NSError *error;
	if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
	}
    
    
    if (!swappingViews) {
        [self swapViews];
    }
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [doneButton setTag:3];
    [doneButton setWidth:90];
    NSUInteger newButton = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:appointmentsToolbar.items] retain];
    
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 1) {
            newButton = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButton withObject:doneButton];
    appointmentsToolbar.items = toolbarItems;
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
	//datePicker.hidden = YES;
	//monthView.hidden = YES;
	//datetimeView.hidden = NO;	
}

- (void) makeToolbar {
    /*Setting up the Toolbar */
    CGRect buttonBarFrame = CGRectMake(0, 208, 320, 37);
    appointmentsToolbar = [[[UIToolbar alloc] initWithFrame:buttonBarFrame] autorelease];
    [appointmentsToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [appointmentsToolbar setTintColor:[UIColor blackColor]];
    UIBarButtonItem *saveAsButton = [[UIBarButtonItem alloc] initWithTitle:@"BACK" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [saveAsButton setTag:0];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"Time" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [newButton setTag:1];
    UIBarButtonItem *gotoButton = [[UIBarButtonItem alloc] initWithTitle:@"GO TO.." style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [gotoButton setTag:2];
    
    [saveAsButton setWidth:90];
    [newButton setWidth:90];
    [gotoButton setWidth:90];
    
    //UIButton *customView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //Possible to use this with the initWithCustomView method of  UIBarButtonItems
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
    
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithObjects:flexSpace, saveAsButton, flexSpace, newButton, flexSpace, gotoButton, flexSpace,nil];
    [appointmentsToolbar setItems:toolbarItems];
    /*--End Setting up the Toolbar */
}


@end

/*
 #pragma mark -
 #pragma mark SetMonth
 - (IBAction)monthAction:(id)sender{
 if (!swappingViews) {
 [self swapViews];
 }
 switch ([sender tag]) {
 case 1:
 [datetimeLabel setText:@"January"];
 break;
 case 2:
 [datetimeLabel setText:@"February"];			
 break;
 case 3:
 [datetimeLabel setText:@"March"];
 break;
 case 4:
 [datetimeLabel setText:@"April"];
 break;
 case 5:
 [datetimeLabel setText:@"May"];
 break;
 case 6:
 [datetimeLabel setText:@"June"];
 break;
 case 7:
 [datetimeLabel setText:@"July"];
 break;
 case 8:
 [datetimeLabel setText:@"August"];
 break;
 case 9:
 [datetimeLabel setText:@"September"];
 break;
 case 10:
 [datetimeLabel setText:@"October"];
 break;
 case 11:
 [datetimeLabel setText:@"November"];
 break;
 case 12:
 [datetimeLabel setText:@"December"];
 break;
 default:
 break;
 }
 //TO DO: IF the user enters the date before the month, and this exceeds the number of days for the month selected, then give an error warning.
 }
*/