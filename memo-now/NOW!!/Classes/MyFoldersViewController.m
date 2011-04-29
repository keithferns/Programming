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
@synthesize topView, bottomView, viewLabel, textView;
@synthesize segmentedControl;
	//@synthesize doneButton;

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

- (IBAction)segmentedControlAction:(id)sender{

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

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.view addSubview:viewLabel];
	[self.view addSubview:segmentedControl];
	[self.view addSubview:topView];
	[self.view addSubview:bottomView];
	[self.topView addSubview:textView];
	[self.bottomView addSubview:tableViewController.tableView];
		//[self.textView addSubview:doneButton];
		//[doneButton addTarget:self action:@selector(clearButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
}

	//- (void)clearButtonSelected{
	//textView.text = @"";

	//}	
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
	[segmentedControl release];
	[tableViewController release];
}

@end
