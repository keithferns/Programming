//  ScheduleView.h
//  iDoit
//
//  Created by Keith Fernandes on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>

@interface ScheduleView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>{
    UIView *alarmView, *tagView;
    UITextField *dateField, *startTimeField, *endTimeField, *recurringField, *locationField;
    UITextField *alarm1Field, *alarm2Field,*alarm3Field, *alarm4Field;
    UITextField *tag1Field, *tag2Field, *tag3Field;
    UIButton *tagButton;
    UIDatePicker *datePicker, *timePicker;
    UIPickerView *recurringPicker, *locationPicker, *alarmPicker, *tagPicker;
    UITableView *tableView;
    NSNumber *isBeingEdited;
    NSArray *recurringArray, *locationArray, *alarmArray, *tagArray;
}

@property (nonatomic, retain) UIView *alarmView, *tagView;
@property (nonatomic, retain) UITextField *dateField, *startTimeField, *endTimeField, *recurringField, *locationField;
@property (nonatomic, retain) UITextField *alarm1Field, *alarm2Field,*alarm3Field, *alarm4Field;
@property (nonatomic, retain) UITextField *tag1Field, *tag2Field, *tag3Field;
@property (nonatomic, retain) UIButton *tagButton;
@property (nonatomic, retain) UIDatePicker *datePicker,*timePicker;
@property (nonatomic, retain) UITableView *tableView;;
@property (nonatomic, retain) NSNumber *isBeingEdited;
@property (nonatomic, retain) UIPickerView *recurringPicker, *locationPicker, *alarmPicker, *tagPicker;
@property (nonatomic, retain) NSArray *recurringArray, *locationArray, *alarmArray, *tagArray;

- (void) addReminderFields;
- (void) addTagFields;
- (void) textFieldResignFirstResponder;
- (void) textFieldBecomeFirstResponder;
- (void) moveToPreviousField;
- (void) moveToNextField;



@end
