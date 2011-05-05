//
//  DateTimeViewController.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateTimeViewController.h"

int appMonth;
int appDay;

@implementation DateTimeViewController


@synthesize segmentedControl;
@synthesize  m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, d1, d2, d3, d4, d5, d6, d7, d8, d9, d0, backslash, timeButton;
@synthesize monthLabel, dateLabel;


#pragma mark -
#pragma mark Navigation

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

#pragma mark -
#pragma mark SetMonth
- (IBAction)monthAction:(id)sender{
	appMonth = [sender tag];
	switch ([sender tag]) {
		case 1:
			NSLog(@"January");
			[monthLabel setText:@"January"];
			break;
		case 2:
			NSLog(@"February");
			[monthLabel setText:@"February"];			
			break;
		case 3:
			NSLog(@"March");
			[monthLabel setText:@"March"];
			break;
		case 4:
			NSLog(@"April");
			[monthLabel setText:@"April"];
			break;
		case 5:
			NSLog(@"May");
			[monthLabel setText:@"May"];
			break;
		case 6:
			NSLog(@"June");
			[monthLabel setText:@"June"];
			break;
		case 7:
			NSLog(@"July");
			[monthLabel setText:@"July"];
			break;
		case 8:
			NSLog(@"August");
			[monthLabel setText:@"August"];
			break;
		case 9:
			NSLog(@"September");
			[monthLabel setText:@"September"];
			break;
		case 10:
			NSLog(@"October");
			[monthLabel setText:@"October"];
			break;
		case 11:
			NSLog(@"November");
			[monthLabel setText:@"November"];
			break;
		case 12:
			NSLog(@"December");
			[monthLabel setText:@"December"];
			break;
		default:
			break;
	}
}

	
#pragma mark -
#pragma mark SetDate

- (IBAction)dayAction:(id)sender{


	NSLog(@"DateButtonPressed");
	NSLog(@"The Month is %i", appMonth);
		appDay = appDay*10 + [sender tag];
	
	if (appDay > 31) {
		appDay = [sender tag];
	}
	[dateLabel setText:[NSString stringWithFormat:@"%i",appDay]];

	
		//correct this for months with 30 days, and for Feb
		//if (appMonth < 8 && appMonth%2 !=0) {
		//}
		//else  (appMonth > 7 && appMonth%2 ==0)
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
	[self.view addSubview:monthLabel];
	[monthLabel setText:@"Month"];
	[self.view addSubview:dateLabel];
	[dateLabel setText:@"Date"];
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
	[segmentedControl release];
	[dateLabel release];
	[monthLabel release];
	[d0 release];
	[d1 release];
	[d2 release];
	[d3 release];
	[d4 release];
	[d5 release];
	[d6 release];
	[d7 release];
	[d8 release];
	[d9 release];
	[backslash release];
	[m1 release];
	[m2 release];
	[m3 release];
	[m4 release];
	[m5 release];
	[m6 release];
	[m7 release];
	[m8 release];
	[m9 release];
	[m10 release];
	[m11 release];
	[m12 release];
    [super dealloc];
}


@end
