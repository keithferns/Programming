    //
//  AppendFileViewController.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppendFileViewController.h"


@implementation AppendFileViewController


@synthesize segmentedControl;
@synthesize myfilesTableViewController;
@synthesize myfiles;

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
 
 editmemoTextView = [[EditTextView alloc] initWithFrame:CGRectMake	(0, 0, 320, 195)];
 [editmemoTextView setBackgroundColor:[UIColor blackColor]];
 [editmemoTextView setTextColor:[UIColor whiteColor]];
 [editmemoTextView setFont:[UIFont fontWithName:@"Helvetica" size:16]];
 [editmemoTextView setText:@"Time:[put_timestamp]. Place:[put_location]\n"];
 [editmemoTextView setUserInteractionEnabled:YES];
 [editmemoTextView setEditable:YES];
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[segmentedControl release];
	[myfilesTableViewController release];
	[myfiles release];
    [super dealloc];
}


@end
