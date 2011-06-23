//  DateTimeViewController.m
//  NOW!!
//  Created by Keith Fernandes on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "DateTimeViewController.h"

int appYear;
int appMonth;
int appDay;
float appTime;
int appHour;
int appMinute;
int appPriority;
int count;

@implementation DateTimeViewController

@synthesize backslash, timeButton;
@synthesize topLabel, bottomLabel;
@synthesize monthView, dateView, timeView, priorityView;
@synthesize prioritySlider;

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
		//TO DO: IF the user enters the date before the month, and this exceeds the number of days for the month selected, then give an error warning.
}

- (IBAction)dayAction:(id)sender{
		//FIX correct this for Feb
	appDay = appDay*10 + [sender tag];
	if (appMonth==2||appMonth==4||appMonth==6||appMonth==9||appMonth==11) {
		if (appDay > 30) {
			appDay = 0;
				//appDay = [sender tag];
		}
		[bottomLabel setText:[NSString stringWithFormat:@"%i",appDay]];
		return;
	}
	else if (appDay > 31) {
		appDay = 0;
			//appDay = [sender tag];
	}
	[bottomLabel setText:[NSString stringWithFormat:@"%i",appDay]];
	return;
}

- (IBAction)timeAction:(id)sender{
	NSLog(@"button pressed %i times", count);
	if ([sender tag]==10 && count < 2) {
		if (count==0) { 
				//[bottomLabel setText:@"."];
			}
		count = 2;
		return;
		}	
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
	
	[bottomLabel setText:[NSString stringWithFormat:@"%.2f", appTime]];

	
		//FIX: NEED A RESET BUTTON in case the user makes an input mistake.
		//TO DO: Put a feature to revise the appointment time in the My Appointments view.
}

- (IBAction)sliderValueChanged:(UISlider *)sender{
		appPriority = [sender value];
		NSLog(@"the priority is %d", appPriority);
}

- (IBAction) doneAction{
	appHour = appTime;
	NSLog(@"The appointment hour is %d", appHour);
	
	appMinute = (appTime - appHour) * 100;
	NSLog(@"The appointment minute is %d", appMinute);
	
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[dateComponents setMonth:appMonth];
	[dateComponents setDay:appDay];
	[dateComponents setHour:appHour];
	[dateComponents setMinute:appMinute];
	[dateComponents setYear:2011];
	NSDate *newDate = [gregorian dateFromComponents:dateComponents];
	[dateComponents release];
	
	NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:newDate];
	int weekday = [weekdayComponents weekday];
	NSLog(@"Day of week is %d", weekday);
	[self dismissModalViewControllerAnimated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view addSubview:timeView];
	[self.view addSubview:priorityView];
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
	[monthView removeFromSuperview];
	[dateView removeFromSuperview];
	[topLabel setText:@"Priority"];
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
	[priorityView release];
	[prioritySlider release];
    [super dealloc];
}

@end
