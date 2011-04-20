    //
//  MyPlanner.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyPlanner.h"
#import "DateTimeViewController.h"

@implementation MyPlanner

//@synthesize backButton, newButton, wallButton;
@synthesize todayButton, tomorrowButton, somedayButton, thisdayButton, thisWeekButton, nextWeekButton, thisMonthButton, thisYearButton;
@synthesize segmentedControl;

#pragma mark -
#pragma mark Navigation
/*
- (IBAction)backAction:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
	
}
- (IBAction)newmemoAction:(id)sender{
		//SAME AS ON ALL SCREENS. 	
}

- (IBAction)gotowallAction:(id)sender{
		//SAME AS ON ALL SCREENS
}
*/
-(IBAction) segmentedControlAction:(id)sender{
	switch (self.segmentedControl.selectedSegmentIndex) {
		case 0:
			[self dismissModalViewControllerAnimated:YES];	
			break;
		case 1:
			[self dismissModalViewControllerAnimated:YES];	
			break;
		case 2:
			[self dismissModalViewControllerAnimated:YES];	
			break;
		default:
			break;
	}
}

#pragma mark -
#pragma mark Functions

- (IBAction)todayAction:(id)sender{	
		//save to reminders and return to main screen
}

- (IBAction)tomorrowAction:(id)sender{	
		//save to reminders and return to main screen
}


- (IBAction)someDayAction:(id)sender{
		//save to reminders and return to main screen
}
- (IBAction)thisDayAction:(id)sender{
		//Creates new object. 
		//FIX: This is a temporary measure. Finally, move to calendar should dismiss current screen and release all objects associated with this screen. 
	DateTimeViewController *datetimeView = [[[DateTimeViewController alloc] initWithNibName:@"DateTimeViewController" bundle:nil] autorelease];
	[self presentModalViewController:datetimeView animated:YES];
}
- (IBAction)thisWeekAction:(id)sender{
		
}
- (IBAction)nextweekAction:(id)sender{
	
}
- (IBAction)thisMonthAction:(id)sender{
	
		//get current month popup/modalview
}

- (IBAction)thisYearAction:(id)sender{
	
		//Creates new object. 
		//FIX: This is a temporary measure. Finally, move to calendar should dismiss current screen and release all objects associated with this screen. 
	DateTimeViewController *datetimeView = [[[DateTimeViewController alloc] initWithNibName:@"DateTimeViewController" bundle:nil] autorelease];
	[self presentModalViewController:datetimeView animated:YES];
	
}

#pragma mark -
#pragma mark View Management
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES; 
}

#pragma mark -
#pragma mark Memory Management

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
	[todayButton release];
	[tomorrowButton release];
	[thisdayButton release];
	[somedayButton release];
	[thisWeekButton	release];
	[nextWeekButton release];
	[thisMonthButton release];
	[thisYearButton release];
	[segmentedControl release];
    [super dealloc];
}

@end
