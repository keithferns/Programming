//  CalendarViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomToolBar.h"
#import "CustomTextView.h"
#import "WEPopoverController.h"

@interface CalendarViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, PopoverControllerDelegate> {

    UITableViewController *tableViewController;
    NSManagedObjectContext *managedObjectContext;
    CustomTextView *textView;
    CustomToolBar *toolBar;
    NSString *sender;    
    WEPopoverController *navPopover;
    BOOL swappingViews, isSelected;
    
}
@property (nonatomic, retain) UITableViewController *tableViewController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSString *sender;
@property (nonatomic, retain) CustomTextView *textView;
@property (nonatomic, retain) UITextField *leftField, *rightField_1, *rightField_2, *rightField;
@property (nonatomic, retain) UIDatePicker *datePicker, *timePicker;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) CustomToolBar *toolBar;
@property (nonatomic, retain) NSDateFormatter *dateFormatter, *timeFormatter;
@property (nonatomic, retain) NSArray *recurring;
@property (nonatomic, retain) UIView *midView;//

@property (nonatomic, retain) WEPopoverController *navPopover;

- (void) swapViews;
- (void) backAction;    
- (void) dismissKeyboard;
- (void)datePickerChanged:(id)sender;
- (IBAction)timePickerChanged:(id)sender;
- (void) setAppointmentDate;
- (void) setAppointmentTime;
- (void) doneAction;
- (void) addPlan:(UIBarButtonItem *) barButtonItem;//
- (void) changeView:(UIBarButtonItem *)barButtonItem;//
- (void) animateViews:(UIView *)view startFrom:(CGRect)fromFrame endAt:(CGRect)toFrame;
//- (void) addPickerResizeViews:(UIView *)picker1 removePicker:(UIView *)picker2;//
- (void) setAlarm;
- (void) setAlarm:(id)sender;

@end


