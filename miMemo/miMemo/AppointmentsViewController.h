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


@interface AppointmentsViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, UITextFieldDelegate> {
    
    NSManagedObjectContext *managedObjectContext;
    MemoText *newMemoText;
    NSDate *appointmentDate;
    BOOL swappingViews;
	UIDatePicker *datePicker, *timePicker;
    UIActionSheet *goActionSheet;
    UITextView *textView;
    UIToolbar *appointmentsToolbar;
    UITextField *timeTextField, *dateTextField;   
    NSString *newTextInput;
    //UIView *monthView, *datetimeView;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) MemoText *newMemoText;
@property (nonatomic, retain) NSDate *appointmentDate;
@property (nonatomic, retain) UIDatePicker *datePicker, *timePicker;
@property (nonatomic, retain) UIActionSheet *goActionSheet;
@property (nonatomic, retain) UIToolbar *appointmentsToolbar;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UITextField *dateTextField, *timeTextField;
@property (nonatomic, retain) NSString *newTextInput;

//@property (nonatomic, retain) IBOutlet UIView *monthView, *datetimeView;

- (void) swapViews;

- (void) backAction;

- (void) setAppointmentDate;
- (void) setAppointmentTime;

- (void) makeToolbar;

//- (IBAction)monthAction:(id)sender;

@end
