    //
//  MemoDetailViewController.m
//  Memo
//
//  Created by Keith Fernandes on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MemoDetailViewController.h"
#import "MemoTableViewController.h"

@implementation MemoDetailViewController

@synthesize memoTextView, creationDateView, memoREView;
@synthesize selectedMemoText;
@synthesize managedObjectContext;

	//FIXME: This is only configured to show the details of a Memo and not an Appointment. The text appears correctly for Appointment selection but the date does not appear.
	//FIXME: the appointmentTime variable of the Appointment is not being called properly. Cannot read the appointment time off the object instance. 
	//TODO: Put the creationDate as a ivar of the MemoText. This seems logical as the memoText is the base of the rest. THEN add a general "doDate" to all the entities. Copy the value of creationDate to the doDate as default. For an appointment or Task the doDate will be eventually be the scheduled or due date. For memos, the doDate will eventually be the time the memo was last edited. 

- (IBAction) backToTable{
	
[self dismissModalViewControllerAnimated:YES];	
		//TODO: the current "Back" button should be the Save As.. Button. We want the option to save an existing memo as an appointment or save an existing appointment as a recurring event. Use notifications to tell the RootViewController which button on the action sheet was pressed --> dismiss the current modalView --> from the RootViewController initiate the action appropriate to the notification sent up by the modal view. DO NOT import another modalView from any modal view unless it is a detailView. 
		//TODO: the current Save button should toggle between a Done button and New Button. The Done ends editing (dimisses the keyboard and saves the memo/appointment but the current memoText is retained in the view. The New button dismisses the current text and makes the keyboard first responder. Maybe the main view should have the same setup. Opening the application starts it up in editing mode with the textView as firstResponder. The user can dismiss the keyboard at will by pressing the Done button to reveal the table. 
}



- (void) textViewDidBeginEditing:(UITextView *)textView{
			//create new subview and initialize with the frame for the topView
	CGRect mytestFrame = CGRectMake(0, 0, 320, 192);
	UIView *myNewView = [[[UIView	alloc] initWithFrame:mytestFrame] autorelease];
	[myNewView setBackgroundColor:[UIColor blueColor]];
	[self.view addSubview:myNewView];
	[myNewView addSubview:memoTextView];
}


-(IBAction) saveSelectedMemo{

	[self.view endEditing:YES];
	
	selectedMemoText.memoText = memoTextView.text;
	selectedMemoText.savedMemo.memoRE = memoREView.text;
	
	NSLog(@"After Editing the text is %@", selectedMemoText.memoText);
	NSLog(@"After Naming, RE: %@", selectedMemoText.savedMemo.memoRE);
	
	NSError *error;
	if(![managedObjectContext save:&error]){
	}
	
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:managedObjectContextSavedNotification object:nil];
			
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (managedObjectContext == nil) 
	{ 
		managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
	}
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EEEE, dd MMMM yyyy h:mm a"];
	}	
	if ([selectedMemoText.noteType intValue] == 0){
		[creationDateView setText: [dateFormatter stringFromDate:[selectedMemoText.savedMemo creationDate]]];
	}
		else if ([selectedMemoText.noteType intValue] == 1){
			[creationDateView setText: [dateFormatter stringFromDate:[selectedMemoText.savedAppointment creationDate]]];

		}
	[memoTextView setText:[NSString stringWithFormat:@"%@", selectedMemoText.memoText]];	
	[memoREView setText:[NSString stringWithFormat:@"%@", selectedMemoText.savedMemo.memoRE]];
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
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[creationDateView release];
	[memoTextView release];
	[memoREView release];
}


@end
