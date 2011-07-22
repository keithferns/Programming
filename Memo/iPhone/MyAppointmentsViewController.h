//
//  MyAppointmentsViewController.h
//  Memo
//
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Memo.h"
#import "File.h"
#import "Appointment.h"
#import "MemoText.h"

@interface MyAppointmentsViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate> {

	NSManagedObjectContext *managedObjectContext;
	UITableViewController *tableViewController;
	UIBarButtonItem *doneButton, *newMemoButton;
	NSString *previousTextInput;
	UIActionSheet *goActionSheet, *saveActionSheet;

}


@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITableViewController *tableViewController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton, *newMemoButton;
@property (nonatomic, retain) NSString *previousTextInput;
@property (nonatomic, retain) UIActionSheet *goActionSheet, *saveActionSheet;


- (IBAction) navigationAction:(id)sender;

@end

/*
*/