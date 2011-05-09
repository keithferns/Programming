//
//  MyMemosViewController.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "MyMemosViewController.h"

@implementation MyMemosViewController

@synthesize tableViewController;
@synthesize bottomView, topView, myTestLabel, viewSelectedMemo;


-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
		case 1:
			[self dismissModalViewControllerAnimated:YES];	
			break;
		case 2:
			[self dismissModalViewControllerAnimated:YES];	
			break;
		case 3:
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

    [super viewDidLoad];
	
	isSearching = NO;
	[self.view	addSubview:bottomView];
	[self.view addSubview:topView];
	NSLog(@"added an instance of topView and bottomView to view");
	
	[self.topView addSubview:viewSelectedMemo];
	NSLog(@"added an instance of viewSelectedMemo to the view");	
	NSLog(@"will add an instance of MyMemosTableViewController to the view");	
	
	[self.bottomView addSubview:tableViewController.tableView];
	NSLog(@"added an instance of MyMemosTableViewController to the view");	
	
	
	
}


- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	
	NSLog(@"isSearching is set to %d", isSearching);
	isSearching = YES;
	NSLog(@"isSearching is now set to %d", isSearching);
	
		//create new subview and initialize with the frame for the topView
	CGRect mytestFrame = CGRectMake(0, 0, 320, 192);
	UIView *myNewView = [[[UIView	alloc] initWithFrame:mytestFrame] autorelease];
		//When the user taps inside the search bar, the new subview is set to blue background and the tableView is added to it. 
	
	if (isSearching) {
		
		[myNewView setBackgroundColor:[UIColor blueColor]];
		[self.view addSubview:myNewView];
		[myNewView addSubview:tableViewController.tableView];
	}
	
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
	[tableViewController release];
	[topView release];
	[bottomView release];
	[myTestLabel release];
    [super dealloc];
}

@end

/* 
 CODE TO TEST IMAGE INSERTION
 CGRect mytestFrame = CGRectMake(0, 0, 320, 193);
 UIImageView	*myTestImage = [[UIImageView alloc] initWithFrame:mytestFrame];
 [myTestImage setImage:[UIImage imageNamed:@"testImage.png"]];
 [self.topView addSubview: myTestImage];
 [myTestImage release];
 
 CODE TO TEST INSERTION INTO SUBVIEWS. 
 [mytestlabel initWithFrame: myTestFrame];
 [self.bottomView addSubview:myTestLabel];
 [myTestLabel setText:@"this is another test"];
 [myTestLabel setText:@"this is a test"];
 [myTestLabel setTextAlignment:UITextAlignmentCenter];
 [self.bottomView addSubview:myTestLabel];
 */

