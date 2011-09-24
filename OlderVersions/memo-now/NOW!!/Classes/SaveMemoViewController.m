//
//  SaveMemoViewController.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SaveMemoViewController.h"
#import "DateTimeViewController.h"

@implementation SaveMemoViewController

@synthesize backButton, newButton, wallButton;
@synthesize saveToFolderButton, appendToFileButton, callCalenderButton, callReminderButton, makeFolderButton, nameListButton, nameMemoButton;


#pragma mark -
#pragma mark Navigation

- (IBAction)backAction:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
	
}

- (IBAction)newmemoAction:(id)sender{
		//SAME AS ON ALL SCREENS. 	
}

- (IBAction)gotowallAction:(id)sender{
		//SAME AS ON ALL SCREENS
}

#pragma mark -
#pragma mark Functions


- (IBAction)makeNewFolderAction:(id)sender{	
}

- (IBAction)saveToFolderAction:(id)sender{
	
}
- (IBAction)nameFileAction:(id)sender{
	
}
- (IBAction)nameListAction:(id)sender{
	
}
- (IBAction)appendToFileAction:(id)sender{
	
}
- (IBAction)callReminderAction:(id)sender{
	
}

- (IBAction)callCalenderAction:(id)sender{
		//Creates new object. 
		//FIX: This is a temporary measure. Finally, move to calendar should dismiss current screen and release all objects associated with this screen. 
	DateTimeViewController *datetimeView = [[[DateTimeViewController alloc] initWithNibName:@"DateTimeViewController" bundle:nil] autorelease];
	[self presentModalViewController:datetimeView animated:YES];
	
}

#pragma mark -
#pragma mark View Management
	
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
	
	[backButton release];
    [super dealloc];
}


@end
