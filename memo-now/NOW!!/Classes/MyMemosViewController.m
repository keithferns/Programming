//
//  MyMemosViewController.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyMemosViewController.h"

@implementation MyMemosViewController

@synthesize segmentedControl;
@synthesize tableViewController;
@synthesize bottomView, topView, myTestLabel;


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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"will add an instance of MyMemosTableViewController to the view");	

    [super viewDidLoad];
	[self.view	addSubview:bottomView];
	[self.view addSubview:topView];
	
	CGRect mytestFrame = CGRectMake(0, 0, 320, 193);
	UIImageView	*myTestImage = [[UIImageView alloc] initWithFrame:mytestFrame];
	[myTestImage setImage:[UIImage imageNamed:@"testImage.png"]];
	[self.topView addSubview: myTestImage];
		
		//[mytestlabel initWithFrame: myTestFrame];
		//[self.bottomView addSubview:myTestLabel];
		//[myTestLabel setText:@"this is another test"];
	/*
	[myTestLabel setText:@"this is a test"];
	[myTestLabel setTextAlignment:UITextAlignmentCenter];
	[self.bottomView addSubview:myTestLabel];
	*/
	[self.bottomView addSubview:tableViewController.tableView];
	NSLog(@"added an instance of MyMemosTableViewController to the view");	
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
	[segmentedControl release];
	[topView release];
	[bottomView release];
	[myTestLabel release];
    [super dealloc];
}


@end
