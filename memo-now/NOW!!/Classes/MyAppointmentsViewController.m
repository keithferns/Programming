//
//  MyAppointmentsViewController.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyAppointmentsViewController.h"


@implementation MyAppointmentsViewController

@synthesize segmentedControl, bottomView, topView, label, textView, tableViewController;


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
 
 [self.view addSubview:label];
 [self.view addSubview:segmentedControl];
 [self.view addSubview:bottomView];
 [self.view addSubview:topView];
 [topView addSubview:textView];
 [bottomView addSubview:tableViewController.tableView];
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
	[segmentedControl release];
	[bottomView release];
	[topView release];
	[label release];
	[textView release];
}


@end
