//  AddEntityViewController.h
//  WriteNow
//  Created by Keith Fernandes on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
#import "CustomToolBar.h"
#import "CustomTextView.h"
#import "CustomTextField.h"
#import "WEPopoverController.h"

@interface CalendarViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationBarDelegate, PopoverControllerDelegate> {
        UITableViewController *tableViewController;
        NSManagedObjectContext *managedObjectContext;    
        CustomTextView *textView;    
        NSString *sender;
        WEPopoverController *navPopover;
        BOOL swappingViews, isSelected;
    }
@property (nonatomic, retain) UITableViewController *tableViewController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSString *sender;
@property (nonatomic, retain) CustomTextView *textView;
@property (nonatomic, retain) CustomTextField *leftField,*rightField, *rightField_1, *rightField_2;//
@property (nonatomic, retain) CustomToolBar *toolBar;
@property (nonatomic, retain) NSDateFormatter *dateFormatter, *timeFormatter;
@property (nonatomic, retain) UIDatePicker *datePicker, *timePicker;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSArray *recurring;
@property (nonatomic, retain) WEPopoverController *navPopover;

- (void) backAction;    //cancel action
- (void) dismissKeyboard;
- (IBAction)datePickerChanged:(id)sender;
- (IBAction)timePickerChanged:(id)sender;
- (void) setAlarm;
- (void) setAlarm:(id)sender;
- (void)setDateTime:(id)sender;
- (void) moveTableViewUp;
- (void) moveTableViewDown;

//- (void) addPickerResizeViews:(UIView *)picker1 removePicker:(UIView *)picker2;
//- (void) swapViews;
//- (void) animateViews:(UIView *)view startFrom:(CGRect)fromFrame endAt:(CGRect)toFrame;


@end

/* Popover Logic
 
 Controls:  scheduleButton, setDateButton, setStartTimeButton, setEndTimeButton, setRecurringButton, cancelPopOverButton, popOverDoneButton 
 dateField, startTimeField, EndtimeField, recurringField
 datePicker, timePicker, recurringPicker.
 
 
 Control/event                          Action
 1a. scheduleButton touched             presents popover Screen left
 dateField present, cancelButton present, doneButton present. 
 datefield 1st responder -> 3
 
 b. textView has text                   all above happens on viewWillAppear
 
 2. DatePicker Time changed.            textView displays selected date
 tableView displays appointments/tasks for selected date.
 
 3a. dateField is firstResponder        datepicker appears
 tableView appears Screen right
 button changes to 'set_date'
 
 b. dateField hasDate & istouched      -> 3 
 ???
 
 4. setDateButton touched               startTimeField slides in 
 startTimeField is FirstResponder -> 5
 
 5. startTimeField is FirstResponder    button changes to setStartTimeButton      
 timePicker becomes inputView.
 
 6. setStartTimeButton touched          endTimeField slides in 
 endTimeField is FirstResponder -> 7
 
 7. startTimeField is FirstResponder    button changes to setStartTimeButton      
 timePicker becomes inputView.           
 NOTE: Perhaps have a durationPicker to set duration instead of absolute endTime.
 
 */

