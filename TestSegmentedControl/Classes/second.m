//
//  second.m
//  TestSegmentedControl
//
//  Created by Keith Fernandes on 4/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "second.h"


@implementation second
@synthesize segmentLabel;
@synthesize segmentedControl;


-(IBAction) segmentedControlIndexChanged{
	switch (self.segmentedControl.selectedSegmentIndex) {
		case 0:
			self.segmentLabel.text =@"Segment 1 selected.";
			break;
		case 1:
			self.segmentLabel.text =@"Segment 2 selected.";
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
	self.segmentLabel.text =@"Segment 1 selected.";

	/*
		//Create label
	UILabel *label = [[UILabel alloc] init];
	label.frame = CGRectMake(10, 10, 300, 40);
	label.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:label]; 
	
	NSArray *itemArray = [NSArray arrayWithObjects: @"One", @"Two", @"Three", nil];
	
	myseg = [[UISegmentedControl alloc] initWithItems:itemArray];

	myseg.frame = CGRectMake(0, 210, 320, 50);
	myseg.segmentedControlStyle = UISegmentedControlStyleBar;
	myseg.selectedSegmentIndex = 0;
	[myseg addTarget:self action:@selector(pickone:) forControlEvents: UIControlEventValueChanged];
	
	[self.view	addSubview:myseg];
    
	[myseg release];*/
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
	[segmentLabel release];
	[segmentedControl release];
    [super dealloc];
}



@end
