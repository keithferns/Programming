//
//  AddEntityViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "WriteNowAppDelegate.h"
#import "AddEntityViewController.h"
#import "AddEntityTableViewController.h"
#import "AppointmentsTableViewController.h"
#import "TasksTableViewController.h"

#import "ContainerView.h"
#import "CustomTextView.h"
#import "CustomToolBar.h"

@implementation AddEntityViewController

@synthesize tableViewController;
@synthesize managedObjectContext;

@synthesize sender, newText;
@synthesize datePicker, timePicker;
@synthesize textView;
@synthesize dateField, startTimeField, endTimeField, recurringField;
@synthesize selectedDate, selectedTime;
@synthesize dateFormatter, timeFormatter;
@synthesize toolbar;
@synthesize bottomView, topView;

- (void)dealloc {
    [super dealloc];
    [sender release];
    [newText release];
    [datePicker release];
    [timePicker release];
    [dateField release];
    [startTimeField release];
    [endTimeField release];
    [dateFormatter release];
    [timeFormatter release];
    [tableViewController release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (managedObjectContext == nil){
        managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"ADDENTITYVIEWCONTROLLER After managedObjectContext: %@",  managedObjectContext);        
    }
    
    /*--NOTIFICATIONS: register --*/
    
    /* Search Bar Notification sent from FolderTable View to the Main view to accommodate the moving TableView 
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown)  name:UIKeyboardDidShowNotification object:foldersViewController.searchBar];
     */
    
    // Observe keyboard hide and show notifications to resize the text view appropriately.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    /*-- VIEWS:BASE: setup and initialize --*/
    
    topView = [[ContainerView alloc] initWithFrame:CGRectMake(0, 0, 320, 205)];
    bottomView = [[ContainerView alloc] initWithFrame:CGRectMake(0, 205, 320, 255)];
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];
    
    /*--VIEWS:TOPVIEW:INPUT: setup and init the TEXTVIEW and the TEXTFIELDS --*/
    
    toolbar = [[CustomToolBar alloc] initWithFrame:CGRectMake(0, 195, 320, 40)];
    [toolbar.backButton setTarget:self];
    [toolbar.backButton setAction:@selector(backAction)];
    
    [toolbar.datetimeButton setTarget:self];
    [toolbar.datetimeButton setAction:@selector(setAppointmentDate)];
    
    [toolbar.dismissKeyboard setTarget:self];
    [toolbar.dismissKeyboard setAction:@selector(dismissKeyboard)];
    
    //TEXTVIEW
    textView = [[CustomTextView alloc] initWithFrame:CGRectMake(5, 25, 310, 135)];
    [textView setText:newText];
    [textView setDelegate:self];
    [topView addSubview:textView];
    [textView setInputAccessoryView:toolbar];

    /*--DATEFIELD--*/
    
    dateField = [[UITextField alloc] initWithFrame:CGRectMake(5, 165, 100, 35)];
    [dateField setBorderStyle:UITextBorderStyleRoundedRect];
    [dateField setPlaceholder:@"Date:"];
    [dateField setInputView:datePicker];
    [dateField setInputAccessoryView:toolbar];
    [dateField setTag:0];
    [dateField setDelegate:self];
    // [dateField becomeFirstResponder];
    [topView addSubview:dateField];
    
    if (sender == @"Appointment") {
        tableViewController = [[AddEntityTableViewController alloc] init]; //init the tableViewController to appropriateTableView
        topView.label.text = @"New Appointment";
        
        startTimeField = [[UITextField alloc] initWithFrame:CGRectMake(110, 165, 100, 35)];
        [startTimeField setBorderStyle:UITextBorderStyleRoundedRect];
        [startTimeField setPlaceholder:@"From:"];
        [startTimeField setInputView:timePicker];
        [startTimeField setInputAccessoryView:toolbar];
        [startTimeField setDelegate:self];
        [startTimeField setTag:1];
        [topView addSubview:startTimeField];
        
        endTimeField = [[UITextField alloc] initWithFrame:CGRectMake(215, 165, 100, 35)];
        [endTimeField setBorderStyle:UITextBorderStyleRoundedRect];
        [endTimeField setPlaceholder:@"To:"];
        [endTimeField setInputView:timePicker];
        [endTimeField setInputAccessoryView:toolbar];
        [endTimeField setDelegate:self];
        [endTimeField setTag:2];
        [topView addSubview:endTimeField];
    }
    else if (sender == @"To Do") {
        tableViewController = [[TasksTableViewController alloc] init];
        topView.label.text = @"New To Do";
        
        recurringField = [[UITextField alloc] initWithFrame:CGRectMake(215, 165, 100, 35)];
        [recurringField setBorderStyle:UITextBorderStyleRoundedRect];
        [recurringField setPlaceholder:@"Repeat:"];
        [recurringField setInputView:timePicker];
        [recurringField setInputAccessoryView:toolbar];
        [recurringField setDelegate:self];
        [recurringField setTag:2];
        [topView addSubview:recurringField];
    }
       
    [tableViewController.tableView setFrame:CGRectMake(0, 0, 320, 255)];    
    [tableViewController.tableView.layer setCornerRadius:10.0];
    [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
    [tableViewController.tableView setSectionHeaderHeight:18];
    tableViewController.tableView.rowHeight = 30.0;
    //[tableViewController.tableView setTableHeaderView:tableLabel];
    [bottomView addSubview:tableViewController.tableView];

    
    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    self.timeFormatter = [[NSDateFormatter alloc]init];
	[self.timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    
   // swappingViews = NO;

}

#pragma mark -
#pragma mark Text View Delegate Methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textView.inputAccessoryView == nil) {
    }
    [self.textView setInputAccessoryView:toolbar];
    return YES;    
}  

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 0){
        NSLog(@"IN DATEFIELD");
        
        if (dateField.inputAccessoryView == nil){
           // [self makeToolbar];
        }
        if (self.toolbar.tag == 1){
            UIBarButtonItem *datetimeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar_24.png"]style:UIBarButtonItemStylePlain target:self action:@selector(setAppointmentTime)];
            [datetimeButton setTitle:@"Set Date"];
            [datetimeButton setTag:1];
            [datetimeButton setWidth:50.0];
            NSUInteger newButton = 0;
            NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:toolbar.items] retain];
            
            for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
                UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
                if (barButtonItem.tag == 5) {
                    newButton = i;
                    break;
                }
            }
            [toolbarItems replaceObjectAtIndex:newButton withObject:datetimeButton];
            toolbar.items = toolbarItems;
            [datetimeButton release];
            [toolbarItems release];
            [toolbar setTag:0];
        }
        NSLog(@"Setting up the dateField accessory View");
        
        [dateField setInputAccessoryView:toolbar];
    }
    
    else if (textField.tag == 1){
        NSLog(@"IN TIMEFIELD");
        NSLog(@"TimeField is editing");    
        
        if (self.toolbar.tag != 1){     
            /*--TOOLBAR:BUTTON: Change Set Date to Set Time  --*/
            //UIBarButtonItem *timeButton = [[UIBarButtonItem alloc] initWithTitle:@"Set Time" style:UIBarButtonItemStyleBordered target:self action:@selector(setAppointmentTime)];
            UIBarButtonItem *datetimeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clock_24.png"]style:UIBarButtonItemStylePlain target:self action:@selector(setAppointmentTime)];
            [datetimeButton setTitle:@"Set Time"];
            [datetimeButton setTag:5];
            [datetimeButton setWidth:50.0];
            NSUInteger newButton = 0;
            NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:toolbar.items] retain];
            
            for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
                UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
                if (barButtonItem.tag == 1) {
                    newButton = i;
                    break;
                }
            }
            [toolbarItems replaceObjectAtIndex:newButton withObject:datetimeButton];
            toolbar.items = toolbarItems;
            [datetimeButton release];
            [toolbarItems release];
            [toolbar setTag:1];
            /*-- TOOLBAR:  done --*/
        }    
        [startTimeField setInputAccessoryView:toolbar];
    }
    else if (textField.tag == 2){
        NSLog(@"IN recurringFIELD");
        NSLog(@"recurringField is editing");
        [recurringField setInputAccessoryView:toolbar];
        //[tableViewController.tableView removeFromSuperview];
        [textView setAlpha:1.0];
    }
    return YES;
}
/*
- (void) dateFieldDidEndEditing:(NSNotification *)notification{
 //   [dateField.inputView removeFromSuperview];   
}

- (void) timeFieldDidEndEditing:(NSNotification *)notification{
   // [startTimeField.inputView removeFromSuperview];
}

- (void) recurringFieldDidEndEditing:(NSNotification *)notification{
    //[recurringField.inputView removeFromSuperview];
}
 -(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
 //swappingViews = NO;
 }
 */



#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    /* Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard. */
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]; // Get the origin of the keyboard when it's displayed.
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    if (textView.frame.origin.y+textView.frame.size.height  > keyboardTop){
        newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    }
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    [tableViewController.tableView setFrame:CGRectMake(5, 5, 310, 155)];
    [tableViewController.tableView setBackgroundColor:[UIColor clearColor]];
    [tableViewController.tableView setAlpha:0.8];
    [textView setAlpha:0.2];
    //tableViewController.tableView.frame = newTextViewFrame;
    
    [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.*/
    
     NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
     NSTimeInterval animationDuration;
     [animationDurationValue getValue:&animationDuration];
     
     [UIView beginAnimations:nil context:NULL];
     [UIView setAnimationDuration:animationDuration];
     
    [tableViewController.tableView setBackgroundColor:[UIColor whiteColor]];
    [tableViewController.tableView setAlpha:1.0];
    [textView setAlpha:1.0];

     tableViewController.tableView.frame = self.view.bounds;
    //tableViewController.tableView.frame = bottomView.frame;
     
     [UIView commitAnimations];
}

/*
 #pragma mark -
 #pragma mark Accessory view action
 
 - (IBAction)tappedMe:(id)sender {
 
 // When the accessory view button is tapped, add a suitable string to the text view.
 NSMutableString *text = [textView.text mutableCopy];
 NSRange selectedRange = textView.selectedRange;
 
 [text replaceCharactersInRange:selectedRange withString:@"You tapped me.\n"];
 textView.text = text;
 [text release];
 }
 
 */

#pragma mark - NOTIFICATIONS
/*
 - (void)keyboardWasShown{
 NSLog(@"Keyboard Was Shown");
 if ([textView isFirstResponder]) {
 return;
 }
 else {
 
 // [containerView setHidden:YES];    
 }
 }
 */



#pragma mark -
#pragma mark Class Methods

- (IBAction)datePickerChanged:(id)sender{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:[datePicker date]];
    [dateComponents setYear:[dateComponents year]];
    [dateComponents setMonth:[dateComponents month]];
    [dateComponents setDay:[dateComponents day]];
    [dateComponents setHour:12];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    selectedDate = [calendar dateFromComponents:dateComponents];
    NSLog(@"Selected Date: %@", selectedDate);
    dateField.text = [self.dateFormatter stringFromDate:selectedDate];
    
    [[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"GetDateNotification" object:self.selectedDate];
}

- (IBAction)timePickerChanged:(id)sender{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[timePicker date]];    
    [timeComponents setHour:[timeComponents hour]];
    [timeComponents setMinute:[timeComponents minute]];
    [timeComponents setSecond:[timeComponents second]];
    [timeComponents setYear:0];
    [timeComponents setMonth:0];
    [timeComponents setDay:0];
    
    selectedTime= [calendar dateFromComponents:timeComponents];
    NSLog(@"Selected Time: %@", selectedTime);
    startTimeField.text = [self.timeFormatter stringFromDate:selectedTime];
}

- (void) setAppointmentDate{
    
    /*-- DATE/TIME: Get selected Date from the time Picker; put it in the date text field --*/
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:[datePicker date]];
    [dateComponents setYear:[dateComponents year]];
    [dateComponents setMonth:[dateComponents month]];
    [dateComponents setDay:[dateComponents day]];
    [dateComponents setHour:12];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    selectedDate = [[calendar dateFromComponents:dateComponents] retain];
    dateField.text = [dateFormatter stringFromDate:selectedDate];
    
    if (sender == @"Appointment") {
    
    [dateField resignFirstResponder];
    [startTimeField becomeFirstResponder];
    }
    else if (sender == @"To Do"){
    
    /*--TOOLBAR: Change  Set Time button to Done  --*/
    //UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    [doneButton setTitle:@"Done"];
    [doneButton setWidth:50.0];
    [doneButton setTag:6];
    NSUInteger newButton = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:toolbar.items] retain];
    
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 1) {
            newButton = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButton withObject:doneButton];
    toolbar.items = toolbarItems;
    [doneButton release];
    [toolbarItems release];
    /*-- TOOLBAR: Finished changing button --*/
    }
    // if (!swappingViews) {
    //     [self swapViews];
    // }
}

- (void) setAppointmentTime{
    /*--DATE/TIME: Get selected Time from the time Picker; put it in the time text field --*/
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[timePicker date]];    
    [timeComponents setHour:[timeComponents hour]];
    [timeComponents setMinute:[timeComponents minute]];
    [timeComponents setSecond:[timeComponents second]];
    [timeComponents setYear:0];
    [timeComponents setMonth:0];
    [timeComponents setDay:0];
    selectedTime = [[calendar dateFromComponents:timeComponents] retain];
    startTimeField.text = [timeFormatter stringFromDate:selectedTime];
    
    /*--TOOLBAR: Change  Set Time button to Done  --*/
    //UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"save.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    [doneButton setTitle:@"Done"];
    [doneButton setWidth:50.0];
    [doneButton setTag:6];
    NSUInteger newButton = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:toolbar.items] retain];
    
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 5) {
            newButton = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButton withObject:doneButton];
    toolbar.items = toolbarItems;
    [doneButton release];
    [toolbarItems release];
    /*-- TOOLBAR: Finished changing button --*/
    
    //if (!swappingViews) {
    //    [self swapViews];
    //}
}

- (void) setAlarm{
    return;
}
- (void) setRecurring {
    return;
}


- (void) doneAction {
    
    if (sender == @"Appointment") {
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Appointment"
                                       inManagedObjectContext:managedObjectContext];
        Appointment *newAppointment = [[Appointment alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [newAppointment setText:textView.text];
        //Add condition for reedit = if creationDate != nil then break
        [newAppointment setCreationDate:[NSDate date]];
        [newAppointment setType:[NSNumber numberWithInt:1]];
        [newAppointment setDoDate:selectedDate];
        [newAppointment setDoTime:selectedTime];
        /*--Save the MOC--*/	
        NSError *error;
        if(![managedObjectContext save:&error]){ 
            NSLog(@"APPOINTMENTS VIEWCONTROLLER MOC: DID NOT SAVE");
        } 
        [newAppointment release];
    
        }
    else if (sender == @"To Do") {
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Task"
                                       inManagedObjectContext:managedObjectContext];
        Task *newTask = [[Task alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [newTask setText:textView.text];
        //Add condition for reedit = if creationDate != nil then break
        [newTask setCreationDate:[NSDate date]];
        [newTask setType:[NSNumber numberWithInt:1]];
        [newTask setDoDate:selectedDate];
        /*--Save the MOC--*/	
        NSError *error;
        if(![managedObjectContext save:&error]){ 
            NSLog(@"APPOINTMENTS VIEWCONTROLLER MOC: DID NOT SAVE");
        } 
        [newTask release];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

/*
- (void) swapViews {
	
	CATransition *transition = [CATransition animation];
	transition.duration = 1.0;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[transition setType:@"kCATransitionPush"];	
	[transition setSubtype:@"kCATransitionFromRight"];
	
	swappingViews = YES;
	transition.delegate = self;
	
	[self.view.layer addAnimation:transition forKey:nil];
}

*/
#pragma mark NAVIGATION

- (void) backAction{
    
	[self dismissModalViewControllerAnimated:YES];		
}
- (void) dismissKeyboard{
    [self.view endEditing:YES];
    //[tableViewController.tableView removeFromSuperview];
    //[tableViewController.tableView setFrame:CGRectMake(5, 205, 310, 255)];
    //[self.view addSubview:tableViewController.tableView];
}

@end
