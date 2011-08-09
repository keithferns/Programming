//
//  MyAppointmentsViewController.h
//  Memo
//
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemoText.h"
#import "Appointment.h"

@interface MyAppointmentsViewController : UIViewController <UIActionSheetDelegate> {

	UITableViewController *tableViewController;

}


@property (nonatomic, retain) IBOutlet UITableViewController *tableViewController;
@property (nonatomic, retain) UIActionSheet *goActionSheet, *saveActionSheet;
@property (nonatomic, retain) UIToolbar *toolbar;


- (void) makeToolbar;

- (IBAction) navigationAction:(id)sender;

@end

/*
*/