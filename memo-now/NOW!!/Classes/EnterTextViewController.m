//  EnterTextViewController.m
//  NOW!!
//  Created by Keith Fernandes on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "MyFoldersViewController.h"	
#import "MyRemindersViewController.h"
#import "EnterTextViewController.h"
#import	"SaveFileViewController.h"
#import "DateTimeViewController.h"
#import	"MyPlanner.h"
#import "AppendFileViewController.h"
#import "MyAppointmentsViewController.h"
#import "MyMemosViewController.h"
#import "MyWallViewController.h"
#import "NOW__AppDelegate.h"


@implementation EnterTextViewController
@synthesize goActionSheet, saveActionSheet;
@synthesize editmemoTextView, topView, bottomView, memoTitleLabel, lastMemoView, urgentMemoView; 
@synthesize memoArray, managedObjectContext;

#pragma mark -
#pragma mark Navigation	

-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
		case 1:
			if ([editmemoTextView hasText]) {
				[self addTimeStamp];
				}
			self.goActionSheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Go To"			
								  delegate:self cancelButtonTitle:@"Later"
								  destructiveButtonTitle:nil 
								  otherButtonTitles:@"My Folders", @"My Appointments", @"My To-Do's", @"The Wall", nil];
			[goActionSheet showInView:self.view];
			[goActionSheet release];
			NSLog(@"The Go To Action was Shown");
						break;
		case 2:
			if ([editmemoTextView hasText]) {
				[self addTimeStamp];
				}
			MyMemosViewController *viewController = [[[MyMemosViewController alloc] initWithNibName:@"MyMemosViewController" bundle:nil] autorelease];
			editmemoTextView.text = @"";
			[self presentModalViewController:viewController animated:YES];	
			break;
			
		case 3:
			if ([editmemoTextView hasText]) {
				[self addTimeStamp];
				}
			self.saveActionSheet = [[UIActionSheet alloc] 
									initWithTitle:@"Choose An Option"
									delegate:self 
									cancelButtonTitle:@"Later"
									destructiveButtonTitle:nil
									otherButtonTitles:@"Name and Save as File", @"Append To an Existing File", @"Set Appointment Time", @"Set To Do Reminder", nil];
			goActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
			[saveActionSheet showInView:self.view];
			[saveActionSheet release]; 
			
			break;
		default:
			break;
	}
}

	//fetch Memo Records, then get the most recent memo. Is there a more economical way to do this? 
-(void) fetchMemoRecords{NSLog(@"Going to fetch Memo records now");
		//defining table to use
	NSEntityDescription *aMemo = [NSEntityDescription entityForName:@"Memo" inManagedObjectContext:managedObjectContext];
		//setting up the fetch request
	NSFetchRequest *request	= [[NSFetchRequest alloc] init];
	[request setEntity:aMemo];
		//defines how to sort the records
	NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortByDate];//note: if adding other sortdescriptors, then use method -arraywithObjects. If the fetch request must meet some conditions, then use the NSPredicate class 
	[request setSortDescriptors:sortDescriptors];
	[sortByDate release];
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	if (!mutableFetchResults) {
			//
	}
	[self setMemoArray:mutableFetchResults];//save fetched data to an array
	[mutableFetchResults release];
	[request release];	
}

- (void) addTimeStamp{
	NSLog(@"firing addTimeStamp");
	NSString *mytext = [NSString stringWithFormat: @"%@", editmemoTextView.text];//copy contents of editmemoTextView to mytext
	if ([memoArray count]>0) {
		
	if ([mytext isEqualToString:[[memoArray objectAtIndex:0] valueForKey:@"memoText"]]) {
			//compare the current contents of the text view to the contents saved in the memoArray and if they are the same then gets out of addTimeStamp.
		return;
	}
	}
	Memo *newMemo = (Memo *)[NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext: managedObjectContext];	//Initialize a new Memo Object and Insert it into Memo table in the ManagedObjectContext
	[newMemo setTimeStamp:[NSDate	date]];//sets the timeStamp of the new Memo
	[newMemo setMemoText:mytext];//copies the input text to the new Memo. 
	NSLog(@"%@", mytext);
	NSError *error;
	if(![managedObjectContext save:&error]){  //???
	}
	[memoArray insertObject:newMemo atIndex:0];
	NSLog(@"the memo at index 0 is %@", [[memoArray objectAtIndex:0] valueForKey:@"memoText"]);
	[lastMemoView setText:[[memoArray objectAtIndex:0] valueForKey:@"memoText"]];
}
 - (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if (actionSheet	== saveActionSheet){
		switch (buttonIndex) {
			case 4:
				NSLog(@"Cancel Button Clicked on saveAlert");
				break;
			case 3:
				NSLog(@"1st Button Clicked on saveAlert");
			{MyPlanner *gotoView = [[[MyPlanner alloc] initWithNibName:@"MyPlanner" bundle:nil] autorelease];
			[self presentModalViewController:gotoView animated:YES];}
				break;
			case 2:
			NSLog(@"2nd Button Clicked on saveAlert");
			{DateTimeViewController *gotoView = [[[DateTimeViewController alloc] initWithNibName:@"DateTimeViewController" bundle:nil] autorelease];
			[self presentModalViewController:gotoView animated:YES];}
				break;
			case 1:
				NSLog(@"3rd Button Clicked on saveAlert");
			{AppendFileViewController *gotoView = [[[AppendFileViewController alloc] initWithNibName:@"AppendFileViewController" bundle:nil] autorelease];
				[self presentModalViewController:gotoView animated:YES]; }
				break;
			case 0:
				NSLog(@"4th Button Clicked on saveAlert");
			{SaveFileViewController *gotoView = [[[SaveFileViewController alloc] initWithNibName:@"SaveFileViewController" bundle:nil] autorelease];
			[self presentModalViewController:gotoView animated:YES];}
				break;
			default:
				break;
		}
	}
	else if (actionSheet == goActionSheet){
		switch (buttonIndex){
		case 3:
			NSLog(@"1st Button Clicked on WallAlert");
			{MyWallViewController *viewController = [[[MyWallViewController alloc] initWithNibName:@"MyWallViewController" bundle:nil] autorelease];
				[self presentModalViewController:viewController animated:YES];}
			break;
		case 2:
			NSLog(@"2nd Button Clicked on WallAlert");
			MyRemindersViewController *viewController = [[[MyRemindersViewController alloc] initWithNibName:@"MyRemindersViewController" bundle:nil] autorelease];			
			[self presentModalViewController:viewController animated:YES];
			break;
		case 1:
			NSLog(@"3rd Button Clicked on WallAlert");
			{MyAppointmentsViewController *viewController = [[[MyAppointmentsViewController alloc] initWithNibName:@"MyAppointmentsViewController" bundle:nil] autorelease];
				[self presentModalViewController:viewController animated:YES];}
			break;
		case 0:
			NSLog(@"4th Button Clicked on WallAlert");
			{MyFoldersViewController *viewController = [[[MyFoldersViewController alloc] initWithNibName:@"MyFoldersViewController" bundle:nil] autorelease];		
				[self presentModalViewController:viewController animated:YES];}
			break;
		case 4:
			NSLog(@"Cancel Button Clicked on wallAlert");
		default:
			break;
		}
	}
 }

/* 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.view addSubview:memoTitleLabel];
	[self.view addSubview:topView];
	[self.view addSubview:bottomView];
	NSLog(@"adding editmemoTextView to view");
	[self.topView addSubview:editmemoTextView];
	NSLog(@"adding lastMemoView and urgentMemoView to view");
	[self.bottomView addSubview:lastMemoView];
    [self.bottomView addSubview:urgentMemoView];
	
	UIButton *myTestButton = [[UIButton alloc] init];
	[self.topView addSubview:myTestButton];
	
	if (managedObjectContext == nil) 
	{ 
        managedObjectContext = [(NOW__AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
	}
	
	/* Fetch Records and Get text of last Memo*/
	[self fetchMemoRecords];
	int myInt = [memoArray count];
	NSLog(@"Number of Memos in the data store: %d", myInt);
	if (myInt>0) { //calling up the last memo and putting the text on the textview1 of the bottomView. 
		Memo *lastMemo = [memoArray objectAtIndex:0];
		NSLog(@"trying to get the value for memoText for the last Memo");
		NSString *lastMemoText = [lastMemo valueForKey:@"memoText"];
		NSLog(@"This is the text of the last Memo: %@", lastMemoText);
		[lastMemoView setText:lastMemoText];
	}
}
#pragma mark -
#pragma mark DATA MANAGEMENT





#pragma mark -
#pragma mark VIEW MANAGEMENT
/*
- (void)textViewDidEndEditing:(UITextView *)editmemoTextView{
	[self.editmemoTextView resignFirstResponder];
	 }
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES; 
}

#pragma mark -
#pragma mark Memory	Management

- (void)didReceiveMemoryWarning {
		// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
		// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[memoTitleLabel release];
	[memoArray release];
	[managedObjectContext release];
	[editmemoTextView release];
	[lastMemoView release];
	[urgentMemoView release];
	[topView release];
	[bottomView release];
	[saveActionSheet release];
	[goActionSheet release];
    [super dealloc];
}
@end

/*	CODE DOES NOT WORK AS IS. Part of the code is an attempt to test a generic NavButton class and the rest to programmatically code the navigation buttons. Not very successful at this point. 
 saveButton = [NavButton buttonWithType:UIButtonTypeCustom];
 [saveButton addTarget:self 
 action:@selector(aMethod:)
 forControlEvents:UIControlEventTouchDown];
 saveButton.frame = CGRectMake(220, 229, 100, 10);
 [saveButton setUserInteractionEnabled:YES];
 [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 [saveButton setHighlighted:YES];
 [saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
 [self.view addSubview:saveButton];
 */	


/*..........New Memo TEXT VIEW..............//	
 editmemoTextView = [[EditTextView alloc] initWithFrame:CGRectMake	(0, 0, 320, 195)];
 [editmemoTextView setBackgroundColor:[UIColor blackColor]];
 [editmemoTextView setTextColor:[UIColor whiteColor]];
 [editmemoTextView setFont:[UIFont fontWithName:@"Helvetica" size:16]];
 [editmemoTextView setText:@"Time:[put_timestamp]. Place:[put_location]\n"];
 [editmemoTextView setUserInteractionEnabled:YES];
 [editmemoTextView setEditable:YES];
 
 
 /*		Code Works Partially.  Lines beginning with //x do not work
 //	............Last Memo TEXT VIEW..........
 reeditmemoTextView = [[EditTextView alloc] initWithFrame:CGRectMake	(0, 245, 320, 215)];
 [reeditmemoTextView setBackgroundColor:[UIColor lightGrayColor]];
 [reeditmemoTextView	setTextColor:[UIColor blueColor]];
 [reeditmemoTextView setFont:[UIFont fontWithName:@"Helvetica" size:16]];
 [reeditmemoTextView setText:@"Time: 4/12/2011,11:30AM. Place: Home.\nType: TODO\nRE: The Place Field Content \nGet location from the maps (?) API. Prompt for a Tag if a location comes up on three separate occassions at least a day apart."];
 [reeditmemoTextView setUserInteractionEnabled:YES];
 [reeditmemoTextView setEditable:YES];
 
 //		[reeditmemoTextView setInputView:reeditmemoTextView];
 //		[reeditmemoTextView.inputView addTarget:self
 //									  action:@selector(touchesForView:)
 //									  forControlEvents:UIControlEventAllEvents];
 
 [self.view	addSubview:reeditmemoTextView];
 
 //X....  The following code came from attempts to get the lower textview 'reeditTextView'to move in response to an event. The isFirstResponder method is supposed to respond YES when the TextView is touched - the text view becomes firstresponder on touch - but it never did. Couldn't get control to enter the if section of the code. 
 
 if ([reeditmemoTextView.inputView  hastext]) {
 NSLog(@"I am inside while loop");
 
 [reeditmemoTextView becomeFirstResponder];
 //		if([editmemoTextView isFirstResponder]) {
 
 editmemoTextView.text = reeditmemoTextView.text; 
 [editmemoTextView setBackgroundColor:[UIColor lightGrayColor]];
 [reeditmemoTextView setFont:[UIFont boldSystemFontOfSize:30.0]];
 [reeditmemoTextView setEditable:YES];
 [self.view addSubview:reeditmemoTextView];
 
 //[reeditmemoTextView [setFrame:(CGRectMake(0, 0, 320, 215)]];
 //reeditmemoTextView.frame = CGRectOffset(editmemoTextView.frame, 222, 107);
 }
 */	
