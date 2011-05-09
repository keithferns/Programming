//  DateTimeViewController.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "DateTimeViewController.h"

int appMonth;
int appDay;
float appTime;
int count;

@implementation DateTimeViewController

@synthesize backslash, timeButton;
@synthesize topLabel, bottomLabel;
@synthesize monthView, dateView, timeView;

#pragma mark -
#pragma mark Navigation

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

- (IBAction) doneAction{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark SetMonth
- (IBAction)monthAction:(id)sender{
	appMonth = [sender tag];
	switch ([sender tag]) {
		case 1:
			[topLabel setText:@"January"];
			break;
		case 2:
			[topLabel setText:@"February"];			
			break;
		case 3:
			[topLabel setText:@"March"];
			break;
		case 4:
			[topLabel setText:@"April"];
			break;
		case 5:
			[topLabel setText:@"May"];
			break;
		case 6:
			[topLabel setText:@"June"];
			break;
		case 7:
			[topLabel setText:@"July"];
			break;
		case 8:
			[topLabel setText:@"August"];
			break;
		case 9:
			[topLabel setText:@"September"];
			break;
		case 10:
			[topLabel setText:@"October"];
			break;
		case 11:
			[topLabel setText:@"November"];
			break;
		case 12:
			[topLabel setText:@"December"];
			break;
		default:
			break;
	}
}

- (IBAction)dayAction:(id)sender{
		appDay = appDay*10 + [sender tag];
	if (appDay > 31) {
		appDay = [sender tag];
	}
	[bottomLabel setText:[NSString stringWithFormat:@"%i",appDay]];

		//FIX correct this for months with 30 days, and for Feb
		/*if (appMonth < 8 && appMonth%2 !=0) {
		}
		else  (appMonth > 7 && appMonth%2 ==0)
		*/	
}

- (IBAction)timeAction:(id)sender{
	NSLog(@"button pressed %i times", count);
	if ([sender tag]==10 && count < 2) {
		if (count==0) { 
			[bottomLabel setText:@"."];
			}
		count = 2;
		return;
		}	
		//NSLog(@"isMinutes is %i", isMinutes);
		//NSLog(@"the sender tag is %i", [sender tag]);
	switch (count) {
		case 0:
			appTime = [sender tag];
			count = count + 1;
		break;
		case 1:
			if ((appTime*10 + [sender tag])>12){
				return;
			}
			appTime = appTime*10 + [sender tag];
			count = count + 1;
			break;
		case 2:
			if ([sender tag]>5) {
				return;
			}
			appTime = appTime + [sender tag]*0.1;
			count = count + 1;
			break;
		case 3:
			appTime = appTime + [sender tag]*0.01;
			count += 1;
			break;
	default:
		break;
	}
	[bottomLabel setText:[NSString stringWithFormat:@"%.2f",appTime]];
	
		//FIX: NEED A RESET BUTTON in case the user makes an input mistake.
		//TO DO: Put a feature to revise the appointment time in the My Appointments view.
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
	[self.view addSubview:timeView];
	[self.view addSubview:monthView];
	[self.view addSubview:dateView];
	[self.view addSubview:topLabel];
	[topLabel setText:@"Month"];
	[self.view addSubview:bottomLabel];
	[bottomLabel setText:@"Date"];
	count = 0;
	appTime = 0;
	
}
	
- (IBAction) timeButtonAction{
	[dateView removeFromSuperview];
	[bottomLabel setText:@"Time"];
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
	[bottomLabel release];
	[topLabel release];
	[dateView release];
	[monthView release];
	[backslash release];
	[timeButton release];
    [super dealloc];
}

@end
