//  AddEntityViewController.h
//  WriteNow
//  Created by Keith Fernandes on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
#import "CustomToolBarMainView.h"
#import "CustomTextView.h"
#import "WEPopoverController.h"
#import "SchedulePopoverViewController.h"
#import "TKCalendarMonthView.h"
#import "NewItemOrEvent.h"

typedef enum{
    ADDING_DATE_FIELD = 1,
    ADDING_START_FIELD = 2,
    ADDING_END_FIELD = 3,
    ADDING_RECUR_FIELD = 4
}AddingField;

@interface CalendarViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationBarDelegate, PopoverControllerDelegate,TKCalendarMonthViewDelegate,TKCalendarMonthViewDataSource > {
    
        UITableViewController *tableViewController;
        NSManagedObjectContext *managedObjectContext, *addingContext;    
        CustomTextView *textView;    
        BOOL tableIsTop, isSelected;
        Appointment *newAppointment;
        Task *newTask;
        NSArray *recurring;
        AddingField addField;    
        UIView *flipperView;
        TKCalendarMonthView *calendarView;
    }

@property (nonatomic, retain) UITableViewController *tableViewController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) CustomTextView *textView;
@property (nonatomic, retain) CustomToolBarMainView *toolBar;

@property (nonatomic, retain) WEPopoverController *schedulerPopover, *reminderPopover, *navPopover;
@property (nonatomic, retain) Appointment *newAppointment;
@property (nonatomic, retain) Task *newTask;
@property (nonatomic, retain) NSDateFormatter *dateFormatter, *timeFormatter;

@property (nonatomic, retain) UIDatePicker *datePicker, *timePicker;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSArray *recurring;
@property (nonatomic, readwrite) AddingField addField;
@property (nonatomic,retain) UIButton *flipIndicatorButton, *addButton, *cancelButton, *editButton;
@property (assign) BOOL frontViewIsVisible;
@property (nonatomic, retain) TKCalendarMonthView *calendarView;
@property (readonly) UIImage *flipperImageForDateNavigationItem;
@property (nonatomic, retain) UIView *flipperView;


- (void) addNewAppointment;
- (void) addNewTask;
- (void) dismissKeyboard;

- (void) setEditingView;

- (void) presentReminderPopover:(id)sender;
- (void) presentSchedulerPopover:(id)sender;
- (void) cancelPopover:(id)sender;

- (void) moveTableViewUp;
- (void) moveTableViewDown;

- (void) toggleCancel:(id) sender;
- (void) toggleDone:(id) sender;
- (void) toggleAddNew:(id) sender;
- (void) toggleEdit: (id) sender;

-(void) addDateField;
-(void) addStartTimeField;
-(void) addEndTimeField;
-(void) addRecurringField;
- (void) setAlarm;

- (void)datePickerChanged:(id)sender;
- (void)timePickerChanged:(id)sender;

- (void)myTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

//-(void)cancelAddingOrEditing;

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

