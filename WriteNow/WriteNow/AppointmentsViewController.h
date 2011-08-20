//
//  AppointmentsViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppointmentsViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
        
        Appointment *newAppointment;
        NSManagedObjectContext *managedObjectContext, *managedObjectContextTV;
        NSFetchedResultsController *_fetchedResultsController;
        UITableView *tableView;	
        BOOL swappingViews;
        }

    @property (nonatomic, retain) Appointment *newAppointment;
    @property (nonatomic, retain) NSManagedObjectContext *managedObjectContext, *managedObjectContextTV;
    @property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
    @property (nonatomic, retain) UITableView *tableView;
    @property (nonatomic, retain) IBOutlet UIDatePicker *datePicker, *timePicker;
    @property (nonatomic, retain) UIToolbar *appointmentsToolbar;
    @property (nonatomic, retain) UITextView *textView;
    @property (nonatomic, retain) UITextField *dateField, *timeField;
    @property (nonatomic, retain) UILabel *tableLabel;
    @property (nonatomic, retain) NSDateFormatter *dateFormatter, *timeFormatter;
        @property (nonatomic, retain) UIView *containerView;

    - (void) swapViews;
    - (void) backAction;    
    - (void) setAppointmentDate;
    - (void) setAppointmentTime;
    - (void) makeToolbar;
    
    - (IBAction)datePickerChanged:(id)sender;
    - (IBAction)timePickerChanged:(id)sender;
    - (void) doneAction;

    
    - (NSFetchedResultsController *) fetchedResultsControllerWithPredicate:(NSPredicate *)aPredicate; 
@end