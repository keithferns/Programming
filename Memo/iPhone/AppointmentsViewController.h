//
//  AppointmentsViewController.h
//  Memo
//
//  Created by Keith Fernandes on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Appointment.h"
#import "MemoText.h"
#import "AppDelegate_Shared.h"


@interface AppointmentsViewController : UIViewController {

	UILabel *viewLabel, *datetimeLabel;
	UIView *bottomview2; // *monthView, *datetimeView;
						 //BOOL swappingViews;
	UIDatePicker *datePicker;
	Appointment *newAppointment;
}

@property (nonatomic, retain) Appointment *newAppointment;

@property (nonatomic, retain) IBOutlet UILabel *viewLabel, *datetimeLabel;

@property (nonatomic, retain) IBOutlet UIView *bottomview2;// *monthView, *datetimeView;

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
	//- (void) swapViews;

- (IBAction) backAction;

- (IBAction) setAppointmentDate;

	//- (IBAction)monthAction:(id)sender;



@end
