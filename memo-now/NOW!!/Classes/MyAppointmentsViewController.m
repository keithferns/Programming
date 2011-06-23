//
//  MyAppointmentsViewController.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyAppointmentsViewController.h"


@implementation MyAppointmentsViewController

@synthesize bottomView, topView, label, textView, tableViewController;


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
 
	[self.view addSubview:label];
	[self.view addSubview:bottomView];
	[self.view addSubview:topView];
	[topView addSubview:textView];
	[bottomView addSubview:tableViewController.tableView];
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
	[bottomView release];
	[topView release];
	[label release];
	[textView release];
}


@end
