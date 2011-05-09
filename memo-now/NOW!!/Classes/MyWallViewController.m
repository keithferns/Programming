//
//  MyWallViewController.m
//  NOW!!
//
//  Created by Keith Fernandes on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyWallViewController.h"


@implementation MyWallViewController


-(IBAction)showActionSheet:(id)sender{
	
	UIActionSheet *myActionSheet = [[UIActionSheet alloc] initWithTitle:@"My Action Sheet" delegate:self cancelButtonTitle:@"Later" destructiveButtonTitle:nil otherButtonTitles:@"My Folders", @"My Appointments", @"My To-Do's", @"The Wall", nil];
	[myActionSheet showInView:self.view];
	[myActionSheet release];
}

- (void)actionSheet:(UIActionSheet *)myActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

	switch (buttonIndex) {
		case 0:
			NSLog(@"1st Button Clicked on actionSheet");
			break;
		case 1:
			NSLog(@"2nd Button Clicked on saveAlert");
			break;
		case 2:
			NSLog(@"3rd Button Clicked on saveAlert");
			break;
		case 3:
			NSLog(@"4th Button Clicked on saveAlert");
			break;
		case 4:
			NSLog(@"5t Button Clicked on saveAlert");
			break;
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
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

- (void)viewDidLoad {
    [super viewDidLoad];
}

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
    [super dealloc];
}


@end
