//  EnterTextViewController.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
#import "MyFoldersViewController.h"
#import "EnterTextViewController.h"
#import	"SaveFileViewController.h"
#import "DateTimeViewController.h"
#import	"MyPlanner.h"
#import "AppendFileViewController.h"
#import "MyMemosViewController.h"
#import "NOW__AppDelegate.h"


@implementation EnterTextViewController

@synthesize segmentedControl;
@synthesize editmemoTextView, topView, bottomView, memoTitleLabel, lastMemoView, urgentMemoView;
@synthesize saveAlert, wallAlert;
@synthesize memoArray, managedObjectContext;
	//@synthesize tableView;

-(IBAction) segmentedControlAction:(id)sender{
	switch (self.segmentedControl.selectedSegmentIndex) {
		case 0:
			if ([editmemoTextView hasText]) {
								
			[self addTimeStamp];
			}
			
				//testing
			MyFoldersViewController *modalViewController = [[[MyFoldersViewController alloc] initWithNibName:@"MyFoldersViewController" bundle:nil]autorelease];
			[self presentModalViewController:modalViewController animated:YES];
			
			/*FIX to bring up the modal view controllers'	
				//this action will bring up another alert window. Dismissing this will take us back to the EnterTextScreen, or to the appropriate modalviewcontrollers: My Folders, My Appointments, My R.
			
			self.wallAlert = [[UIAlertView alloc] 
							  initWithTitle:@"Choose An Option"
							  message:@"Take me to your Leader!" 
							  delegate:@"Now_AppDelegate" 
							  cancelButtonTitle:@"Later" 
							  otherButtonTitles:@"My Folders", @"My Appointments", @"My To-Do's", @"The Wall", nil];
			
			[wallAlert show];
			[wallAlert release];
			*/
			
			
			break;
		case 1:
			if ([editmemoTextView hasText]) {
				
			[self addTimeStamp];
			}
				//just testing
			MyMemosViewController *viewController = [[[MyMemosViewController alloc] initWithNibName:@"MyMemosViewController" bundle:nil] autorelease];
			editmemoTextView.text = @"";
			[self presentModalViewController:viewController animated:YES];	
		
			
			break;
		case 2:
			if ([editmemoTextView hasText]) {
				[self addTimeStamp];
			}
				
				//this action will bring up a pop-up window instead of a modalviewcontroller. Dismissing this will take us back to the EnterTextScreen, or to the appropriate modalviewcontrollers: Name and Save, Append, Schedule.
			self.saveAlert = [[UIAlertView alloc] 
							  initWithTitle:@"Choose An Option"
							  message:@"Manage Your Time ... or Folders?" 
							  delegate:self 
							  cancelButtonTitle:@"Later" 
							  otherButtonTitles:@"Name and Save as File", @"Append To an Existing File", @"Set Appointment Time", @"Set To Do Reminder", nil];
			[saveAlert show];
				//[saveAlert release]; 
			
			break;
		default:
			break;
	}
}

	//fetch Memo Records, then get the most recent memo. Is there a more economical way to do this? 
-(void) fetchMemoRecords{
	
	NSLog(@"Going to fetch Memo records now");
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
	
		//save fetched data to an array
	
	[self setMemoArray:mutableFetchResults];
	
	[mutableFetchResults release];
	[request release];
			
}


- (void) addTimeStamp{
	NSLog(@"firing addTimeStamp");
	
		
		//copy contents of editmemoTextView to nsstring variable
	NSString *mytext = [NSString stringWithFormat: @"%@", editmemoTextView.text]; 
			//Initialize a new Memo Object and Insert it into Memo table in the ManagedObjectContext
	Memo *newMemo = (Memo *)[NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext: managedObjectContext];
		//sets the timeStamp of the new Memo
	[newMemo setTimeStamp:[NSDate	date]]; 
		//copies the input text to the new Memo. 
	[newMemo setMemoText:mytext]; 
	
	NSLog(@"%@", mytext);

	NSError *error;
	if(![managedObjectContext save:&error]){  //???
	}
	
	[memoArray insertObject:newMemo atIndex:0];//NOTE: NOT used here as far as I can tell
	
	
	
}




	//Dismisses the saveAlert object by a system call. Note -1 is called if the CancelButton is not set. 
- (void)dismissViewAlert{
	
	[self.saveAlert dismissWithClickedButtonIndex:-1 animated:YES];
}

	//???what does this do???
- (void)viewAlertCancel:(UIAlertView *)alertView
	{
		[saveAlert	release];
	}

	//Alert view to prompt the User to select the next action to perform with the memo. Save it as an Appointment (-> directly to the Appt scheduling screen for setting the date and time), as a To Do Reminder( -> the MyPlanner screen with simplified scheduler, save to a Folder or Append to an existing file.
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
	{
	
		  if (buttonIndex == 4) {
			  NSLog(@"1st Button Clicked on WallAlert");
			MyPlanner *gotoView = [[[MyPlanner alloc] initWithNibName:@"MyPlanner" bundle:nil] autorelease];
			[self presentModalViewController:gotoView animated:YES];
			}
		else if (buttonIndex == 3) {
			NSLog(@"2nd Button Clicked on WallAlert");

			DateTimeViewController *gotoView = [[[DateTimeViewController alloc] initWithNibName:@"DateTimeViewController" bundle:nil] autorelease];
			[self presentModalViewController:gotoView animated:YES];
			}
		else if (buttonIndex == 2) {
			NSLog(@"3rd Button Clicked on WallAlert");

			AppendFileViewController *gotoView = [[[AppendFileViewController alloc] initWithNibName:@"AppendFileViewController" bundle:nil] autorelease];
			[self presentModalViewController:gotoView animated:YES];
		} 
		else if (buttonIndex == 1) {
			NSLog(@"4th Button Clicked on WallAlert");

				SaveFileViewController *gotoView = [[[SaveFileViewController alloc] initWithNibName:@"SaveFileViewController" bundle:nil] autorelease];
				[self presentModalViewController:gotoView animated:YES];
			}	
		else if (buttonIndex == 0) {
			NSLog(@"Cancel Button Clicked on WallAlert");

				//CancelButton Clicked
		}
	
		[alertView release];
	}



- (IBAction)gotowallAction:(id)sender{

}

- (void)dimisswallAlert{
	[self.wallAlert dismissWithClickedButtonIndex:-1 animated:YES];
}



	//???what does this do???
- (void)wallAlertCancel:(UIAlertView *)alertView
{
	[wallAlert	release];
}
/*
	- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
	{
		
		if (buttonIndex == 4) {
			NSLog(@"1st Button Clicked on WallAlert");
			
			MyMemosTableViewController *tableController = [[MyMemosTableViewController alloc] initWithStyle:UITableViewStylePlain];												
			[self presentModalViewController:tableController animated:YES];
		}
		else if (buttonIndex == 3) {
			NSLog(@"2nd Button Clicked on WallAlert");
			
			
			MyMemosTableViewController *tableController = [[MyMemosTableViewController alloc] initWithStyle:UITableViewStylePlain];												
			[self presentModalViewController:tableController animated:YES];
		}
		else if (buttonIndex == 2) {
			NSLog(@"3rd Button Clicked on WallAlert");
			
			MyMemosTableViewController *tableController = [[MyMemosTableViewController alloc] initWithStyle:UITableViewStylePlain];												
			[self presentModalViewController:tableController animated:YES];
		}
		else if (buttonIndex == 1) {
			NSLog(@"4th Button Clicked on WallAlert");
			
			MyMemosTableViewController *tableController = [[MyMemosTableViewController alloc] initWithStyle:UITableViewStylePlain];												
			[self presentModalViewController:tableController animated:YES];
		}	
		else if (buttonIndex == 0) {
				//CancelButton Clicked
		}
		
		[alertView release];
	}
*/	


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
		
	
	
	[super viewDidLoad];
	[self.view addSubview:memoTitleLabel];
	[self.view addSubview:segmentedControl];
	[self.view addSubview:topView];
	[self.view addSubview:bottomView];
	NSLog(@"adding editmemoTextView to view");
	[self.topView addSubview:editmemoTextView];
	NSLog(@"adding lastMemoView and urgentMemoView to view");
	[self.bottomView addSubview:lastMemoView];
    [self.bottomView addSubview:urgentMemoView];


}


- (void)textViewDidEndEditing:(UITextView *)editmemoTextView{

	doneEditing = YES;
	
}

							
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
	self.editmemoTextView = nil;
	self.topView = nil;
	managedObjectContext = nil;
}

- (void)dealloc {
	[memoTitleLabel release];
	[memoArray release];
	[managedObjectContext release];
	[segmentedControl release];
	[editmemoTextView release];
	[lastMemoView release];
	[urgentMemoView release];
		//[tableView release];
	[topView release];
	[bottomView release];
    [super dealloc];
}


@end

	//DONE: FIX: Autorotation of the textviews. The code and the IB are not in synch. 

/*  Method Works. Intended to be used to pull up the designated modalviewcontroller but that design choice was abandoned in favor of Alert Window popups. The said view controller and nib file are in the folder labelled xSameMemoViewController.
 
 - (IBAction)savememoAction:(id)sender{	
 SaveMemoViewController *savememoView = [[[SaveMemoViewController alloc] initWithNibName:@"SaveMemoViewController" bundle:nil] autorelease];
 [self presentModalViewController:savememoView animated:YES];
 }
 */


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
