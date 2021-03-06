//
//  NewTaskViewController.m
//  Memo
//
//  Created by Keith Fernandes on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewTaskViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate_Shared.h"
#import "NSManagedObjectContext-insert.h"

@implementation NewTaskViewController

@synthesize managedObjectContext;
@synthesize datePicker, timePicker;
@synthesize newMemoText, newTask;
@synthesize goActionSheet;
@synthesize taskToolbar;
@synthesize dateTextField, timeTextField, textView, newTextInput;
@synthesize taskDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    /*Setting Up the Views*/
    NSLog(@"In NewTaskViewController");

    newTask = [managedObjectContext insertNewObjectForEntityForName:@"ToDo"];

    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [myView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    myView.hidden = NO;
    self.view = myView;
    
    [self makeToolbar];
    [self.view addSubview:taskToolbar];
    
    /*--Adding the Text View */
    /*--The Text View --*/
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 45, 300, 160)];
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
    [dateTextField setPlaceholder:@"Set Task Date"];
    [self.view addSubview:dateTextField];
    
    
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EE, dd MMMM"];
    }	
    /*--Done Setting Up the Views--*/
    
    
    /*-- Initializing the managedObjectContext--*/
	if (managedObjectContext == nil) { 
		managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    }
    /*--Done Initializing the managedObjectContext--*/
    
    newMemoText = [managedObjectContext insertNewObjectForEntityForName:@"MemoText"];
    
    [newMemoText setMemoText:textView.text];
    [newMemoText setNoteType:[NSNumber numberWithInt:2]];
    [newMemoText setCreationDate:[NSDate date]];
    
    swappingViews = NO;
    
    /*-- Add and Initialize date and time pickers --*/
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 245, 320, 215)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.view addSubview:datePicker];
    datePicker.minimumDate = [NSDate date];		//Now
	datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)];
	datePicker.date = [NSDate date];
    datePicker.timeZone = [NSTimeZone systemTimeZone];
    datePicker.hidden = NO;

    
    /* Following is for version with Date/Time set with Buttons*/
    //datetimeView.hidden = YES;
    //[bottomview addSubview:monthView];
    //[bottomview addSubview:datetimeView];
}

#pragma mark -
#pragma mark Navigation

-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
		case 0:
            [self backAction];
            break;            
		case 1:
            [self setTaskDate];
			break;
		case 2:
			self.goActionSheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Go To" delegate:self cancelButtonTitle:@"Later"
								  destructiveButtonTitle:nil otherButtonTitles:@"Memos, Files and Folders", @"Task", @"Tasks", nil];
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
    [timePicker release];
    [goActionSheet release];
    [taskToolbar release];
    [taskDate release];
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

- (void) setTaskDate{
    NSDate *tempDate = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE,dd MMMM, yyyy"];
    taskDate = [dateFormatter stringFromDate:tempDate];
    newTask.doDate = taskDate;
    newTask.memoText = newMemoText;
    
    dateTextField.text = taskDate;
    [dateFormatter release];

    NSError *error;
	if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
	}
    
    
    //TODO: Add a fetchRequest here to get existing Task for the date selected.  display a table with existing Task for that date in the top View. This ideally should happen in sync with the change of datePicker to timePicker. 
    
    if (!swappingViews) {
        [self swapViews];
    }
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"NEW" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [doneButton setTag:3];
    [doneButton setWidth:90];
    NSUInteger newButton = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:taskToolbar.items] retain];
    
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 1) {
            newButton = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButton withObject:doneButton];
    taskToolbar.items = toolbarItems;
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
	//monthView.hidden = YES;
	//datetimeView.hidden = NO;	
}

- (void) makeToolbar {
    /*Setting up the Toolbar */
    CGRect buttonBarFrame = CGRectMake(0, 208, 320, 37);
    taskToolbar = [[[UIToolbar alloc] initWithFrame:buttonBarFrame] autorelease];
    [taskToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [taskToolbar setTintColor:[UIColor blackColor]];
    UIBarButtonItem *saveAsButton = [[UIBarButtonItem alloc] initWithTitle:@"BACK" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [saveAsButton setTag:0];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
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
    [taskToolbar setItems:toolbarItems];
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