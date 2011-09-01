//
//  AppointmentsViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppointmentsViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate> {
        Appointment *newAppointment;
        NSManagedObjectContext *managedObjectContext;
        BOOL swappingViews;
        NSString *newText;
        UIView *bottomView;
        UITableView *myTableView;
        }
    @property (nonatomic, retain) IBOutlet UIView *bottomView;
    @property (nonatomic, retain) IBOutlet UITableView *myTableView;
    @property (nonatomic, retain) Appointment *newAppointment;
    @property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
    @property (nonatomic, retain) IBOutlet UITableViewController *tableViewController;
    @property (nonatomic, retain) IBOutlet UIDatePicker *datePicker, *timePicker;
    @property (nonatomic, retain) UIToolbar *appointmentsToolbar;
    @property (nonatomic, retain) UITextView *textView;
    @property (nonatomic, retain) UITextField *dateField, *timeField, *recurringField;
    @property (nonatomic, retain) NSDateFormatter *dateFormatter, *timeFormatter;
    @property (nonatomic, retain) NSDate *selectedDate, *selectedTime;
    @property (nonatomic, retain) UIView *containerView;
    @property (nonatomic, retain) NSString *newText;

    - (void) backAction;    

    - (void) backAction;    
    - (void) dismissKeyboard;
    - (IBAction)datePickerChanged:(id)sender;
    - (IBAction)timePickerChanged:(id)sender;
    - (void) setAppointmentDate;
    - (void) setAppointmentTime;
    - (void) setAlarm;
    - (void) setRecurring;

    - (void) doneAction;


@end