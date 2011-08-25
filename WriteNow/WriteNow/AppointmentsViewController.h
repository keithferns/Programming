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
        }

    @property (nonatomic, retain) Appointment *newAppointment;
    @property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
    @property (nonatomic, retain) IBOutlet UITableViewController *tableViewController;



    @property (nonatomic, retain) IBOutlet UIDatePicker *datePicker, *timePicker;
    @property (nonatomic, retain) UIToolbar *appointmentsToolbar;
    @property (nonatomic, retain) UITextView *textView;
    @property (nonatomic, retain) UITextField *dateField, *timeField;
    @property (nonatomic, retain) NSDateFormatter *dateFormatter, *timeFormatter;
    @property (nonatomic, retain) UIView *containerView;
    @property (nonatomic, retain) NSDate *selectedDate, *selectedTime;
    @property (nonatomic, retain) NSString *newText;

    - (void) swapViews;
    - (void) backAction;    
    - (void) setAppointmentDate;
    - (void) setAppointmentTime;
    - (void) makeToolbar;
    
    - (IBAction)datePickerChanged:(id)sender;
    - (IBAction)timePickerChanged:(id)sender;
    - (void) doneAction;


@end