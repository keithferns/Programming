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


@interface AppointmentsViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
    
    NSManagedObjectContext *managedObjectContext, *managedObjectContextTV;
	NSFetchedResultsController *_fetchedResultsController;
	UITableView *tableView;	
    BOOL swappingViews;
    UIToolbar *appointmentsToolbar;
    NSString *newTextInput;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext, *managedObjectContextTV;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) UIActionSheet *goActionSheet;
@property (nonatomic, retain) UIToolbar *appointmentsToolbar;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UITextField *dateTextField, *timeTextField;
@property (nonatomic, retain) NSString *newTextInput;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) UILabel *tableLabel;

- (void) swapViews;

- (void) backAction;

- (void) setAppointmentDate;

- (void) makeToolbar;

- (IBAction)datePickerChanged:(id)sender;

- (NSFetchedResultsController *) fetchedResultsControllerWithPredicate:(NSPredicate *)aPredicate; 

@end



