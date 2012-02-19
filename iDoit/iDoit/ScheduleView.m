//
//  ScheduleView.m
//  iDoit
//
//  Created by Keith Fernandes on 12/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScheduleView.h"
#import "Contants.h"
#import "CustomToolBar.h"
@implementation ScheduleView

@synthesize alarmView, tagView;
@synthesize dateField, startTimeField, endTimeField, recurringField, locationField;
@synthesize alarm1Field, alarm2Field, alarm3Field, alarm4Field;
@synthesize tag1Field, tag2Field, tag3Field;
@synthesize tagButton;
@synthesize datePicker, timePicker;
@synthesize recurringPicker, alarmPicker, tagPicker, locationPicker;
@synthesize recurringArray, alarmArray, tagArray, locationArray;
@synthesize tableView;
@synthesize isBeingEdited;


#define textFieldFont 14

- (void)dealloc {
    [super dealloc];
    [dateField release];
    [startTimeField release];
    [endTimeField release];
    [recurringField release];
    [locationField release];
    [alarm1Field release];
    [alarm2Field release];
    [alarm3Field release];
    [alarm4Field release];
    [datePicker release];
    [timePicker release];
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker setDate:[NSDate date]];
        [datePicker setMinimumDate:[NSDate date]];
        [datePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:(2*60*60*24*365)]];
        datePicker.timeZone = [NSTimeZone systemTimeZone];
        [datePicker sizeToFit];
        datePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];  

        timePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        timePicker.datePickerMode = UIDatePickerModeTime;
        [timePicker setMinuteInterval:10];
        timePicker.timeZone = [NSTimeZone systemTimeZone];
        [timePicker sizeToFit];
        timePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        //timePicker.date = [timeFormatter dateFromString:@"12:00 PM"]; 
        [timePicker addTarget:self action:@selector(timePickerChanged:) forControlEvents:UIControlEventValueChanged];        
        
        recurringPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        [recurringPicker setDataSource:self];
        [recurringPicker setDelegate:self];
        recurringPicker.showsSelectionIndicator = YES;
        [recurringPicker setTag:1];
        
        locationPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        [locationPicker setDataSource:self];
        [locationPicker setDelegate:self];
        locationPicker.showsSelectionIndicator = YES;
        [locationPicker setTag:2];
        
        recurringArray = [[NSArray alloc] initWithObjects:@"Never",@"Daily",@"Weekly", @"Fortnightly", @"Monthy", @"Annualy",nil];
        locationArray = [[NSArray alloc] initWithObjects:@"Home", @"Work", @"School", @"Gym", nil];
        
        dateField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, 150, 35)];
        dateField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:dateField];
        dateField.placeholder = @"Date";
        dateField.tag = 1;
        dateField.inputView = datePicker;
        [dateField setFont:[UIFont systemFontOfSize:textFieldFont]];
        dateField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        startTimeField = [[UITextField alloc] initWithFrame:CGRectMake(5, 40, 75, 35)];
        startTimeField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:startTimeField];
        startTimeField.placeholder = @"Starts At";
        startTimeField.tag = 2;
        startTimeField.inputView = timePicker;
        [startTimeField setFont:[UIFont systemFontOfSize:textFieldFont]];
        startTimeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
        endTimeField = [[UITextField alloc] initWithFrame:CGRectMake(80, 40, 75, 35)];
        endTimeField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:endTimeField];
        endTimeField.placeholder = @"Ends At";
        endTimeField.tag = 3;
        endTimeField.inputView = timePicker;
        [endTimeField setFont:[UIFont systemFontOfSize:textFieldFont]];
        endTimeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        recurringField = [[UITextField alloc] initWithFrame:CGRectMake(5, 75, 150, 35)];
        recurringField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:recurringField];
        recurringField.placeholder = @"Recurring:";
        recurringField.tag = 4;
        [recurringField setFont:[UIFont systemFontOfSize:textFieldFont]];
        recurringField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        recurringField.inputView = recurringPicker;

        locationField = [[UITextField alloc] initWithFrame:CGRectMake(5, 110, 150, 35)];
        locationField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:locationField];
        locationField.placeholder = @"Place";
        locationField.tag = 5;
        [locationField setFont:[UIFont systemFontOfSize:textFieldFont]];
        locationField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        locationField.inputView = locationPicker;

        tableView = [[UITableView alloc] initWithFrame:CGRectMake(160, 5, 155, 140)];
        tableView.rowHeight = 25.0;
        [self addSubview:tableView];
    }
    return self;
}

- (void) addReminderFields {
    if (alarmView.superview == nil) {
        if (tagView == nil) {
    alarmView = [[UIView alloc] initWithFrame:CGRectMake(155, self.frame.size.height, kScreenWidth-155, self.frame.size.height)];
        }
    [self addSubview:alarmView];
    
    alarmPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [alarmPicker setDataSource:self];
    [alarmPicker setDelegate:self];
    alarmPicker.showsSelectionIndicator = YES;
    [alarmPicker setTag:3];

    alarmArray = [[NSArray alloc] initWithObjects:@"15 minutes before", @"30 minutes before", @"1 hour before", @"1 day before", @"1 week before", nil];
    
    //Check if any of the alarmFields exist, if YES, then add the alarmFields
    if (alarm1Field == nil) {
        NSLog(@"Adding Alarm Fields");

        alarm1Field = [[UITextField alloc] initWithFrame:CGRectMake(0, 5, 155, 35)];
        alarm1Field.borderStyle = UITextBorderStyleRoundedRect;
        [alarmView addSubview:alarm1Field];
        alarm1Field.placeholder = @"Alarm 1:";
        alarm1Field.tag = 6;
        alarm1Field.inputView = alarmPicker;
        [alarm1Field setFont:[UIFont systemFontOfSize:textFieldFont]];
        alarm1Field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
        alarm2Field = [[UITextField alloc] initWithFrame:CGRectMake(0, 40, 155, 35)];
        alarm2Field.borderStyle = UITextBorderStyleRoundedRect;
        [alarmView addSubview:alarm2Field];
        alarm2Field.placeholder = @"Alarm 2:";
        alarm2Field.tag = 7;
        alarm2Field.inputView = alarmPicker;
        [alarm2Field setFont:[UIFont systemFontOfSize:textFieldFont]];
        alarm2Field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

        alarm3Field = [[UITextField alloc] initWithFrame:CGRectMake(0, 75, 155, 35)];
        alarm3Field.borderStyle = UITextBorderStyleRoundedRect;
        [alarmView addSubview:alarm3Field];
        alarm3Field.placeholder = @"Alarm 3:";
        alarm3Field.tag = 8;
        alarm3Field.inputView = alarmPicker;
        [alarm3Field setFont:[UIFont systemFontOfSize:textFieldFont]];
        alarm3Field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

        alarm4Field = [[UITextField alloc] initWithFrame:CGRectMake(0, 110, 155, 35)];
        alarm4Field.borderStyle = UITextBorderStyleRoundedRect;
        [alarmView addSubview:alarm4Field];
        alarm4Field.placeholder = @"Alarm 4:";
        alarm4Field.tag = 9;
        alarm4Field.inputView = alarmPicker;
        [alarm4Field setFont:[UIFont systemFontOfSize:textFieldFont]];
        alarm4Field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;   
        }
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedAlarmTransition)];
    
    CGRect frame = alarmView.frame;
    frame.origin.y = 0;
    alarmView.frame = frame;
    if (tableView.superview != nil){
        frame = tableView.frame;
        frame.origin.y = - tableView.frame.size.height;
        tableView.frame = frame;
    }
    if (tagView.superview !=nil){
        frame = tagView.frame;
        frame.origin.y = tagView.frame.size.height;
        tagView.frame = frame;
    }
    [UIView commitAnimations];
}

- (void) addTagFields {
    if (tagView.superview == nil) {
    if (tagView == nil){
            tagView = [[UIView alloc] initWithFrame:CGRectMake(155, self.frame.size.height, kScreenWidth-155, self.frame.size.height)];
        }
    [self addSubview:tagView];
    
    tagPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [tagPicker setDataSource:self];
    [tagPicker setDelegate:self];
    tagPicker.showsSelectionIndicator = YES;
    [tagPicker setTag:4];
    
    tagArray = [[NSArray alloc] initWithObjects:@"Bill",@"Anniversary", @"Doctor", nil];
    
    //Check if any of the alarmFields exist, if YES, then add the alarmFields
    if (tag1Field == nil) {
        NSLog(@"Adding Tag Fields");
        
        tag1Field = [[UITextField alloc] initWithFrame:CGRectMake(0, 5, 155, 35)];
        tag1Field.borderStyle = UITextBorderStyleRoundedRect;
        [tagView addSubview:tag1Field];
        tag1Field.placeholder = @"Tag 1:";
        tag1Field.tag = 10;
        tag1Field.inputView = tagPicker;
        [tag1Field setFont:[UIFont systemFontOfSize:textFieldFont]];
        tag1Field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        tag2Field = [[UITextField alloc] initWithFrame:CGRectMake(0, 40, 155, 35)];
        tag2Field.borderStyle = UITextBorderStyleRoundedRect;
        [tagView addSubview:tag2Field];
        tag2Field.placeholder = @"Tag 2:";
        tag2Field.tag = 11;
        tag2Field.inputView = tagPicker;
        [tag2Field setFont:[UIFont systemFontOfSize:textFieldFont]];
        tag2Field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        tag3Field = [[UITextField alloc] initWithFrame:CGRectMake(0, 75, 155, 35)];
        tag3Field.borderStyle = UITextBorderStyleRoundedRect;
        [tagView addSubview:tag3Field];
        tag3Field.placeholder = @"Tag 3:";
        tag3Field.tag = 12;
        tag3Field.inputView = tagPicker;
        [tag3Field setFont:[UIFont systemFontOfSize:textFieldFont]];
        tag3Field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        tagButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 110, 155, 35)];
        [tagButton setImage:[UIImage imageNamed:@"tag_add_24"] forState:UIControlStateNormal];
        [tagView addSubview:tagButton];        
        }
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedTagTransition)];
    
    CGRect frame = tagView.frame;
    frame.origin.y = 0;
    tagView.frame = frame;
    if (tableView.superview != nil){
        frame = tableView.frame;
        frame.origin.y = - tableView.frame.size.height;
        tableView.frame = frame;
    }
    if (alarmView.superview !=nil) {
        frame = alarmView.frame;
        frame.origin.y = alarmView.frame.size.height;
        alarmView.frame = frame;
    }
    [UIView commitAnimations];
}

- (void) finishedAlarmTransition{
    [tableView removeFromSuperview];
    [tagView removeFromSuperview];
}

- (void) finishedTagTransition{
    [tableView removeFromSuperview];
    [alarmView removeFromSuperview];
}

- (void) textFieldResignFirstResponder{
    switch ([isBeingEdited intValue]) {
        case 1:
            [self.dateField resignFirstResponder];
            break;
        case 2:
            [self.startTimeField resignFirstResponder];
            break;
        case 3:
            [self.endTimeField resignFirstResponder];
            break;
        case 4:
            [self.recurringField resignFirstResponder];
            break;
        case 5:
            [self.locationField resignFirstResponder];
            break;
        case 6:
            [self.alarm1Field resignFirstResponder];
            break;
        case 7:
            [self.alarm2Field resignFirstResponder];
            break;
        case 8:
            [self.alarm3Field resignFirstResponder];
            break;
        case 9:
            [self.alarm4Field resignFirstResponder];
            break;
        case 10:
            [self.tag1Field resignFirstResponder];
            break;
        case 11:
            [self.tag2Field resignFirstResponder];
            break;
        case 12:
            [self.tag3Field resignFirstResponder];
            break;
        default:
            break;
    }    
}

- (void) textFieldBecomeFirstResponder{
   
    switch ([isBeingEdited intValue]) {
        case 1:
            [self.dateField becomeFirstResponder];
            break;
        case 2:
            [self.startTimeField becomeFirstResponder];
            break;
        case 3:
            [self.endTimeField becomeFirstResponder];
            break;
        case 4:
            [self.recurringField becomeFirstResponder];
            break;
        case 5:
            [self.locationField becomeFirstResponder];
            break;
        case 6:
            [self.alarm1Field becomeFirstResponder];
            break;
        case 7:
            [self.alarm2Field becomeFirstResponder];
            break;
        case 8:
            [self.alarm3Field becomeFirstResponder];
            break;
        case 9:
            [self.alarm4Field becomeFirstResponder];
            break;
        case 10:
            [self.tag1Field becomeFirstResponder];
            break;
        case 11:
            [self.tag2Field becomeFirstResponder];
            break;
        case 12:
            [self.tag3Field becomeFirstResponder];
            break;
        default:
            break;
    }
}

#pragma mark - Date & Time Picker Methods

- (void) datePickerChanged:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, MMM dd, yyyy"];
     
    self.dateField.text = [dateFormatter stringFromDate:[datePicker date]];
    [dateFormatter release];
}

- (void) timePickerChanged:(id) sender{
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"h:mm a"];
    if ([isBeingEdited intValue] == 2) {
        self.startTimeField.text = [timeFormatter stringFromDate:[timePicker date]];
    }
    else if ([isBeingEdited intValue] == 3){
        self.endTimeField.text = [timeFormatter stringFromDate:[timePicker date]];
    }
    
    [timeFormatter release];
}


#pragma mark - PickerView DataSource and Delgate Methods
    
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{  
    NSLog(@"PickerView Changed");
    
    switch ([pickerView tag]) {
        case 1:
            //
            self.recurringField.text = [recurringArray objectAtIndex:row];
            break;
         case 2:
            self.locationField.text = [locationArray objectAtIndex:row];
            break;
        case 3:
            switch ([isBeingEdited intValue]) {
                case 6:
                    self.alarm1Field.text = [alarmArray objectAtIndex:row];
                    break;
                case 7:
                    self.alarm2Field.text = [alarmArray objectAtIndex:row];
                    break;
                case 8:
                    self.alarm3Field.text = [alarmArray objectAtIndex:row];
                    break;
                case 9:
                    self.alarm4Field.text = [alarmArray objectAtIndex:row];
                    break;
                default:
                    break;
                }
            break;
        case 4:
            switch ([isBeingEdited intValue]) {
                case 10:
                    self.tag1Field.text = [tagArray objectAtIndex:row];
                    break;
                case 11:
                    self.tag2Field.text = [tagArray objectAtIndex:row];
                    break;
                case 12:
                    self.tag3Field.text = [tagArray objectAtIndex:row];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // tell the picker how many rows are available for a given component
    NSInteger numberofrows;
    switch ([pickerView tag]) {
        case 1:
            numberofrows =  [recurringArray count];
            break;
        case 2:
            numberofrows =  [locationArray count];
            break;
        case 3:
            numberofrows =  [alarmArray count];
            break;
        case 4:
            numberofrows = [tagArray count];
        default:
            break;
    }
    return numberofrows;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    // tell the picker how many components it will have
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    // tell the picker the title for a given component
    NSString *titleforrow = [[[NSString alloc] init] autorelease];
    switch ([pickerView tag]) {
        case 1:
            titleforrow =  [recurringArray objectAtIndex:row];
            break;
        case 2:
            titleforrow =  [locationArray objectAtIndex:row];
            break;
        case 3:
            titleforrow =  [alarmArray objectAtIndex:row];
            break;
        case 4:
            titleforrow = [tagArray objectAtIndex:row];
        default:
            break;
    }
    return titleforrow;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    // tell the picker the width of each row for a given component
    int sectionWidth = 300;    
    return sectionWidth;
}

- (void) moveToPreviousField {
    //Check which textField is first responder. Move to previous textField. 
    
    [self textFieldResignFirstResponder];
    
    switch ([self.isBeingEdited intValue]) {
        case 2:
            self.isBeingEdited = [NSNumber numberWithInt:1];
            break;
        case 3:
            self.isBeingEdited = [NSNumber numberWithInt:2];
            break;
        case 4:
            self.isBeingEdited = [NSNumber numberWithInt:3];
            break;
        case 5:
            self.isBeingEdited = [NSNumber numberWithInt:4];
            break;
        case 6:
            self.isBeingEdited = [NSNumber numberWithInt:5];
            break;
        case 7:
            self.isBeingEdited = [NSNumber numberWithInt:6];
            break;
        case 8:
            self.isBeingEdited = [NSNumber numberWithInt:7];
            break;
        case 9:
            self.isBeingEdited = [NSNumber numberWithInt:8];
            break;
        case 10:
            self.isBeingEdited = [NSNumber numberWithInt:5];
            break;
        case 11:
            self.isBeingEdited = [NSNumber numberWithInt:10];
            break;
        case 12:
            self.isBeingEdited = [NSNumber numberWithInt:11];
        default:
            break;
    }
    [self textFieldBecomeFirstResponder];
}

- (void) moveToNextField{
    //Check which textField is first responder. Move to next textField. 
    [self textFieldResignFirstResponder];
    
    switch ([self.isBeingEdited intValue]) {
        case 1:
            self.isBeingEdited = [NSNumber numberWithInt:2];
            break;
        case 2:
            self.isBeingEdited = [NSNumber numberWithInt:3];
            break;
        case 3:
            self.isBeingEdited = [NSNumber numberWithInt:4];
            break;
        case 4:
            self.isBeingEdited = [NSNumber numberWithInt:5];
            break;
        case 5:
            if (self.alarmView.superview == nil) {
                self.isBeingEdited = [NSNumber numberWithInt:10];
            }
            else if (self.tagView.superview == nil){
                self.isBeingEdited = [NSNumber numberWithInt:6];
            }
            break;
        case 6:
            self.isBeingEdited = [NSNumber numberWithInt:7];
            break;
        case 7:
            self.isBeingEdited = [NSNumber numberWithInt:8];
            break;
        case 8:
            self.isBeingEdited = [NSNumber numberWithInt:9];
            break;
        case 9:
            self.isBeingEdited = [NSNumber numberWithInt:10];
            break;        
        case 10:
            self.isBeingEdited = [NSNumber numberWithInt:11];
            break;        
        case 11:
            self.isBeingEdited = [NSNumber numberWithInt:12];
            break;
        default:
            break;
    }
    [self textFieldBecomeFirstResponder];
}

@end
