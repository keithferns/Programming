//
//  CurrentViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomToolBarMainView.h"
#import "CustomTextView.h"
#import "WEPopoverController.h"
#import "SchedulePopoverViewController.h"
#import "TKCalendarMonthView.h"
#import "NewItemOrEvent.h"

typedef enum{
    ADD_DATE_FIELD = 1,
    ADD_START_FIELD = 2,
    ADD_END_FIELD = 3,
    ADD_RECUR_FIELD = 4
}AddField;

@interface CurrentViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, PopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, TKCalendarMonthViewDelegate,TKCalendarMonthViewDataSource, NewItemOrEventDelegate > {
    
    NSManagedObjectContext *managedObjectContext;
    UITableViewController *tableViewController;
    BOOL swappingViews;
    WEPopoverController *navPopover;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UITableViewController *tableViewController;
@property (nonatomic, retain) CustomTextView *textView;
@property (nonatomic, retain) CustomToolBarMainView *toolBar;
@property (nonatomic, retain) WEPopoverController *navPopover, *schedulerPopover, *reminderPopover;
@property (nonatomic, retain) UIView *topView, *bottomView;
@property (nonatomic, retain) NSArray *recurring;
@property (nonatomic, retain) UIDatePicker *datePicker, *timePicker;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, readwrite) AddField addField;
@property (nonatomic, retain) TKCalendarMonthView *calendarView;
@property (nonatomic, retain) NSDateFormatter *dateFormatter, *timeFormatter;
@property (nonatomic, retain) UIButton *flipIndicatorButton, *cancelButton, *addButton, *editButton, *saveButton;
@property (readonly) UIImage *flipperImageForDateNavigationItem;
@property (assign) BOOL frontViewIsVisible;
@property (nonatomic, retain) NewItemOrEvent *newItem;

- (void) dismissKeyboard;
- (void) setEditingView;

- (void) presentReminderPopover:(id)sender;
- (void) presentSchedulerPopover:(id)sender;
- (void) cancelPopover:(id)sender;

- (void) moveTableViewUp;
- (void) moveTableViewDown;

- (void) addDateField;
- (void) addStartTimeField;
- (void) addEndTimeField;
- (void) addRecurringField;
- (void) setAlarm;
- (void) toggleLeftBarButtonItem:(id) sender;
- (void) toggleRightBarButtonItem:(id) sender;
- (void) toggleCalendar:(id) sender;

- (void)datePickerChanged:(id)sender;
- (void)timePickerChanged:(id)sender;
- (void) addPickerControls:(id)sender;

- (void)myTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;


@end

