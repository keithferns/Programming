//
//  AppointmentsViewController.m
//  Memo
//
//  Created by Keith Fernandes on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppointmentsViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation AppointmentsViewController
@synthesize viewLabel, datetimeLabel;
@synthesize bottomview2; //monthView, datetimeView;
@synthesize datePicker;
@synthesize newAppointment;

- (IBAction) backAction{
	[self dismissModalViewControllerAnimated:YES];		
}

- (IBAction) setAppointmentDate{
	
	NSDate * appointmentTime = [datePicker date];
	NSString * appointmentTimeString = [appointmentTime description];
	NSLog(@"The appointment is et for %@", appointmentTimeString);

	datetimeLabel.text = appointmentTimeString;
	
	newAppointment.appointmentTime = appointmentTime;
	NSLog(@"The appointment is et for %@", newAppointment.appointmentTime);
	bottomview2.hidden = YES;
	
}


- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view addSubview:bottomview2];
		//swappingViews = NO;
		//datetimeView.hidden = YES;
		//[bottomview addSubview:monthView];
		//[bottomview addSubview:datetimeView];
	[viewLabel setText:@"Appointment Details"];
	
	
}

/*
 #pragma mark -
 #pragma mark SetMonth
 - (IBAction)monthAction:(id)sender{
 if (!swappingViews) {
 [self swapViews];
 }
 switch ([sender tag]) {
 case 1:
 [datetimeLabel setText:@"January"];
 break;
 case 2:
 [datetimeLabel setText:@"February"];			
 break;
 case 3:
 [datetimeLabel setText:@"March"];
 break;
 case 4:
 [datetimeLabel setText:@"April"];
 break;
 case 5:
 [datetimeLabel setText:@"May"];
 break;
 case 6:
 [datetimeLabel setText:@"June"];
 break;
 case 7:
 [datetimeLabel setText:@"July"];
 break;
 case 8:
 [datetimeLabel setText:@"August"];
 break;
 case 9:
 [datetimeLabel setText:@"September"];
 break;
 case 10:
 [datetimeLabel setText:@"October"];
 break;
 case 11:
 [datetimeLabel setText:@"November"];
 break;
 case 12:
 [datetimeLabel setText:@"December"];
 break;
 default:
 break;
 }
 //TO DO: IF the user enters the date before the month, and this exceeds the number of days for the month selected, then give an error warning.
 }
 

- (void) swapViews{
	
	CATransition *transition = [CATransition animation];
	transition.duration = 0.5;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[transition setType:@"kCATransitionPush"];	
	[transition setSubtype:@"kCATransitionFromRight"];
	
	swappingViews = YES;
	transition.delegate = self;
	
	[self.view.layer addAnimation:transition forKey:nil];
	
	monthView.hidden = YES;
	datetimeView.hidden = NO;
	
}


-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	swappingViews = NO;
}
*/

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
	datePicker = nil;
	datePicker.minimumDate = [NSDate date];		//Now
	datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:(60*60*25*365)];
	datePicker.date = [NSDate date];
}


- (void)dealloc {
    [super dealloc];
	[viewLabel release];
	[datetimeLabel release];
	[bottomview2 release];
	[datePicker release];
		//[monthView release];
		//[datetimeView release];
}


@end
