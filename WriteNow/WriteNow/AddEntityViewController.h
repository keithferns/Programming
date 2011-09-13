//
//  AddEntityViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomToolBar.h"
#import "CustomTextView.h"

@interface AddEntityViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationBarDelegate> {
    
    UITableViewController *tableViewController;
    NSManagedObjectContext *managedObjectContext;    
    BOOL swappingViews, isSelected;
    CustomTextView *textView;
    
    NSString *sender, *newText;
}

@property (nonatomic, retain) UITableViewController *tableViewController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

@property (nonatomic, retain) NSString *sender, *newText;

@property (nonatomic, retain) CustomTextView *textView;
@property (nonatomic, retain) UILabel *leftLabel,*rightLabel, *rightLabel_1, *rightLabel_2;

@property (nonatomic, retain) CustomToolBar *dateToolBar;

@property (nonatomic, retain) NSDateFormatter *dateFormatter, *timeFormatter;

@property (nonatomic, retain) UIView *midView, *bottomView;

@property (nonatomic, retain) UIDatePicker *datePicker, *timePicker;

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSArray *recurring;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton, *doneButton, *titleItem;

//- (void) swapViews;

- (void) backAction;    //cancel action
- (void) dismissKeyboard;
- (IBAction)datePickerChanged:(id)sender;
- (IBAction)timePickerChanged:(id)sender;


- (void) setAppointmentDate;
- (void) setAppointmentTime;
- (void) doneAction;

- (void) addPickerResizeViews:(UIView *)picker1 removePicker:(UIView *)picker2;

- (void) animateViews:(UIView *)view startFrom:(CGRect)fromFrame endAt:(CGRect)toFrame;
@end
