//
//  MyFoldersViewController.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyFoldersViewController.h"


@implementation MyFoldersViewController

@synthesize tableViewController;
@synthesize	tableView;
@synthesize topView, bottomView, viewLabel, textView, textField;

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

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view addSubview:viewLabel];
	[self.view addSubview:topView];
	[self.view addSubview:bottomView];
	[self.topView addSubview:textView];
	[self.bottomView addSubview:tableViewController.tableView];
	
		//[self.topView addSubview:textField];
	
		//[self.textView addSubview:doneButton];
		//[doneButton addTarget:self action:@selector(clearButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
		//create new subview and initialize with the frame for the topView
	CGRect mytestFrame = CGRectMake(0, 0, 320, 192);
	UIView *myNewView = [[[UIView	alloc] initWithFrame:mytestFrame] autorelease];
		//When the user taps inside the search bar, the new subview is set to blue background and the tableView is added to it. 
		[myNewView setBackgroundColor:[UIColor blueColor]];
		[self.view addSubview:myNewView];
		[myNewView addSubview:tableViewController.tableView];	
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
	[viewLabel release];
	[topView release];
	[bottomView release];
	[tableViewController release];
}

@end
