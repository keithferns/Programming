//
//  AddEntityViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

//TODO: Add function for searching for durations that are free within some time frame. Say you want to make a doctor's appointment, what you need to do is specify a duration, for eg. 2 hrs, between 12 noon and 6 pm, in the up coming week. The system should find and list all such durations. 

#import "WriteNowAppDelegate.h"
#import "AddEntityViewController.h"
#import "AddEntityTableViewController.h"
#import "TasksTableViewController.h"

#import "CustomTextView.h"
#import "CustomToolBar.h"

#import "MyDataObject.h"
#import "AppDelegateProtocol.h"

@implementation AddEntityViewController

@synthesize navBar, titleItem, doneButton, backButton;
@synthesize tableViewController;
@synthesize managedObjectContext;
@synthesize sender;
@synthesize textView;
@synthesize dateToolBar;
@synthesize recurring;
@synthesize datePicker, timePicker, pickerView, dateFormatter, timeFormatter;

@synthesize leftField, rightField, rightField_1, rightField_2;
@synthesize bottomView;
//@synthesize midView;
@synthesize navPopover;

#define screenRect [[UIScreen mainScreen] applicationFrame]
#define navBarHeight 44.0
#define toolBarRect CGRectMake(screenRect.size.width, 0, screenRect.size.width, 40)
#define textViewRect CGRectMake(5, navBarHeight+10, screenRect.size.width-10, 140)
//#define midViewRect CGRectMake(0, textViewRect.origin.y+textViewRect.size.height+5, screenRect.size.width, 40)
//#define bottomViewRect CGRectMake(0, midViewRect.origin.y+midViewRect.size.height+10, screenRect.size.width, screenRect.size.height-midViewRect.origin.y-midViewRect.size.height-10)
#define bottomViewRect CGRectMake(0, textViewRect.origin.y+textViewRect.size.height+10, screenRect.size.width, screenRect.size.height-textViewRect.origin.y-textViewRect.size.height-10)


- (void)setDateTime:(id)sender {
	NSLog(@"DateTime-> Button Pressed");
    
    /* Popover Logic
     Control            Event               Action
     
     
     
     */
    
    
    [self moveTableViewUp];
    
 
    //[dateToolBar.firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
    [dateToolBar.firstButton setAction:@selector(setAppointmentDate)];
    [dateToolBar.firstButton setTitle:@"Set Date"];   
    
    if(!navPopover) {
        
        /*
         UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 120, 30)];
         [label setTextAlignment:UITextAlignmentCenter];
         [label setBackgroundColor:[UIColor clearColor]];
         [label setTextColor:[UIColor whiteColor]];
         [label setText:@"Set Date and Time"];
         */        
    
        leftField = [[CustomTextField alloc] init];
        [leftField setFrame:CGRectMake(0, 5, 140, 40)];
        leftField.tag = 12;
        [leftField setInputView:datePicker];
        [leftField setInputAccessoryView:dateToolBar];
        [leftField setPlaceholder:@"Date:"];
                
        
        rightField_1 = [[CustomTextField alloc] init];
        [rightField_1 setFrame:CGRectMake(150, 50, 68, 40)];
        rightField_1.tag = 13;
        [rightField_1 setInputView:timePicker];
        [rightField_1 setInputAccessoryView:dateToolBar];
        [rightField_1 setPlaceholder:@"From:"];
                
        rightField_2 = [[CustomTextField alloc]init];
        [rightField_2 setFrame:CGRectMake(150, 50, 68, 40)];
        rightField_2.tag = 14;
        [rightField_2 setInputView:timePicker];
        [rightField_2 setInputAccessoryView:dateToolBar];
        [rightField_2 setPlaceholder:@"Till:"];
        
        rightField = [[CustomTextField alloc] init];
        [rightField setFrame:CGRectMake(150, 95, 140, 40)];
        rightField.tag = 15;
        [rightField setInputView:pickerView];
        [rightField setInputAccessoryView:dateToolBar];
        [rightField setPlaceholder:@"Recurring: Never"];
        //[rightField setText:[recurring objectAtIndex:0]];            

        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(40, 145, 60, 40)];
        [button1 setTitle:@"Done" forState:UIControlStateNormal];
        [button1 setBackgroundImage:[UIImage imageNamed:@"bluebutton.png"] forState:UIControlStateNormal];
        [button1 setTag:1];
        [button1.layer setCornerRadius:10.0];
        [button1 addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIViewController *viewCon = [[UIViewController alloc] init];
        viewCon.contentSizeForViewInPopover = CGSizeMake(140, 180);
        [viewCon.view addSubview:button1];
        [viewCon.view addSubview:leftField];
        //[viewCon.view addSubview:rightField_1];
        //[viewCon.view addSubview:rightField_2];
        //[viewCon.view addSubview:rightField];
        [viewCon.view   setAlpha:0.8];
        [leftField becomeFirstResponder];

        //[viewCon.view addSubview:label];
        
        [button1 release];
        //[leftField release];
        //[rightField_1 release];
        //[rightField_2 release];
        // [label release];
        navPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        [navPopover setDelegate:self];
        [viewCon release];
    } 
    
    if([navPopover isPopoverVisible]) {
        [navPopover dismissPopoverAnimated:YES];
        [navPopover setDelegate:nil];
        [navPopover autorelease];
        navPopover = nil;
        [self moveTableViewDown];
    } else {
        //CGRect screenBounds = [UIScreen mainScreen].bounds;
        [navPopover presentPopoverFromRect:CGRectMake(15, 205, 50, 57)
                                    inView:self.view 
                  permittedArrowDirections:UIPopoverArrowDirectionDown
                                  animated:YES];
    }
}

//Create Popover to set Alarms
- (void)setAlarm:(id)sender {
    if (tableViewController.tableView.frame.origin.y < bottomViewRect.origin.y) {
        [self moveTableViewDown];
    }
	NSLog(@"Alarm-> Button Pressed");
    if(!navPopover) {
        /*
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 120, 30)];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setText:@"Set Reminders"];
        */
        
        leftField = [[CustomTextField alloc] init];
        [leftField setFrame:CGRectMake(0, 15, 140, 40)];
        leftField.tag = 12;
        [leftField setInputView:pickerView];
        [leftField setInputAccessoryView:dateToolBar];
        [leftField setPlaceholder:@"Alarm 1"];
        
        rightField_1 = [[CustomTextField alloc] init];
        [rightField_1 setFrame:CGRectMake(0, 70, 68, 40)];
        rightField_1.tag = 13;
        [rightField_1 setInputView:pickerView];
        [rightField_1 setInputAccessoryView:dateToolBar];
        [rightField_1 setPlaceholder:@"Alarm 2"];
        
        rightField_2 = [[CustomTextField alloc]init];
        [rightField_2 setFrame:CGRectMake(72, 70, 68, 40)];
        rightField_2.tag = 14;
        [rightField_2 setInputView:pickerView];
        [rightField_2 setInputAccessoryView:dateToolBar];
        [rightField_2 setPlaceholder:@"Alarm 3"];
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(40, 120, 60, 40)];
        [button1 setTitle:@"Done" forState:UIControlStateNormal];
        [button1 setBackgroundImage:[UIImage imageNamed:@"bluebutton.png"] forState:UIControlStateNormal];
        [button1 setTag:1];
        [button1.layer setCornerRadius:10.0];
        [button1 addTarget:self action:@selector(setAlarm) forControlEvents:UIControlEventTouchUpInside];
        
        UIViewController *viewCon = [[UIViewController alloc] init];
        viewCon.contentSizeForViewInPopover = CGSizeMake(140, 180);
        [viewCon.view addSubview:button1];
        [viewCon.view addSubview:leftField];
        [viewCon.view addSubview:rightField_1];
        [viewCon.view addSubview:rightField_2];
        [viewCon.view   setAlpha:0.8];
        
        //[viewCon.view addSubview:label];
        
        [button1 release];
        //[label release];
        navPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        [navPopover setDelegate:self];
        [viewCon release];
    } 
    if([navPopover isPopoverVisible]) {
        [navPopover dismissPopoverAnimated:YES];
        [navPopover setDelegate:nil];
        [navPopover autorelease];
        navPopover = nil;
    } else {
        //CGRect screenBounds = [UIScreen mainScreen].bounds;
        [navPopover presentPopoverFromRect:CGRectMake(70, 205, 50, 57)
                                    inView:self.view 
                  permittedArrowDirections:UIPopoverArrowDirectionDown
                                  animated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Did dismiss");
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Should dismiss");
    return YES;
}
- (MyDataObject *) myDataObject; {
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	MyDataObject* myDataObject;
	myDataObject = (MyDataObject*) theDelegate.myDataObject;
	return myDataObject;
}

- (void)dealloc {
    [super dealloc];
    [sender release];
    [textView release];
//    [dateToolBar release];
    [datePicker release];
    [timePicker release];
    [pickerView release];
    [dateFormatter release];
    [timeFormatter release];
    [recurring release];
    [tableViewController release];
    [leftField release];
    [rightField_1 release];
    [rightField_2 release];
    [rightField release];
    //[midView release];
    [bottomView release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
    NSLog(@"ADDENTITYVIEWCONTROLLER: MEMORY WARNING");
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    datePicker = nil;
    timePicker = nil;
    pickerView = nil;
    dateFormatter = nil;
    timeFormatter = nil;
    leftField = nil;
    rightField = nil;
    rightField_1 = nil;
    rightField_2 = nil;
    recurring = nil;
    textView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
     
   // swappingViews = NO;     
    isSelected = NO;
    if (managedObjectContext == nil){
        managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"ADDENTITYVIEWCONTROLLER After managedObjectContext: %@",  managedObjectContext);        
    }
    
    //SET NOTE TO MYDATAOBJECT NOTE AND COPY THE TEXT TO THE TEXTVIEW.
    MyDataObject *myDataObject = [self myDataObject];
    textView.text = myDataObject.myNote.text;
    /*--NOTIFICATIONS: register --*/
 
    // Observe keyboard hide and show notifications to resize the text view appropriately.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
    //NOTE: navBar here is only relevant to AddEntity controller
    navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.height, navBarHeight)];
    [navBar setTintColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
    [navBar setTranslucent:YES];
    [self.view addSubview:navBar];
    //UINavigationItem *navTitle = [[UINavigationItem alloc] initWithTitle:@"title text"];
    //[navBar pushNavigationItem:navTitle animated:YES];
    //[navTitle release];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    self.navigationItem.leftBarButtonItem.tag = 0;
    [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];
    self.navigationItem.leftBarButtonItem  = leftButton;
    self.navigationItem.rightBarButtonItem.tag = 1;
    [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];  
    [rightButton release];
    self.navigationItem.title =  @"DO SOMETHING";
    UIImage *patternImage = [UIImage imageNamed:@"54700.png"];

    //TEXTVIEW: setup and add to self.view
    textView = [[CustomTextView alloc] initWithFrame:textViewRect];
    textView.delegate = self;    
    textView.inputAccessoryView = dateToolBar;
    self.textView.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    [self.view addSubview:textView];

    
    //BOTTOMVIEW: setup and add the datePicker and dateToolBar
    bottomView = [[UIView alloc] initWithFrame:bottomViewRect];
    [bottomView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:bottomView];

    
    
    //DATETOOLBAR: setup
    dateToolBar = [[CustomToolBar alloc] initWithFrame:toolBarRect];
    [dateToolBar.firstButton setTarget:self];
    [dateToolBar.firstButton setAction:@selector(setDateTime:)];
    [dateToolBar.secondButton setTarget:self];
    [dateToolBar.secondButton setAction:@selector(setAlarm:)];
    [dateToolBar.dismissKeyboard setTarget:self];
    [dateToolBar.dismissKeyboard setAction:@selector(dismissKeyboard)];

    //DATEPICKER ENTERS FROM LEFT
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(-screenRect.size.width, dateToolBar.frame.size.height, screenRect.size.width, bottomView.frame.size.height-dateToolBar.frame.size.height)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setDate:[NSDate date]];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)]];
    datePicker.timeZone = [NSTimeZone systemTimeZone];
    [datePicker sizeToFit];
    [datePicker setTag:0];
    datePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, MMM d, yyyy"];
    //datePicker.date = [dateFormatter dateFromString:leftField.text];
    
    //TIMEPICKER ENTERS FROM RIGHT
    timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(screenRect.size.width, toolBarRect.size.height, screenRect.size.width, bottomView.frame.size.height-toolBarRect.size.height)];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    [timePicker setMinuteInterval:10];
    timePicker.timeZone = [NSTimeZone systemTimeZone];
    [timePicker sizeToFit];
    [timePicker setTag:1];
    timePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [timePicker addTarget:self action:@selector(timePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"h:mm a"];
    //timePicker.date = [timeFormatter dateFromString:leftField.text]; 
    
    //PICKERVIEW ENTER FROM RIGHT
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(screenRect.size.width, dateToolBar.frame.size.height, screenRect.size.width, bottomView.frame.size.height-dateToolBar.frame.size.height)];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
    pickerView.showsSelectionIndicator = YES;
    recurring = [[NSArray alloc] initWithObjects:@"Never",@"Daily",@"Weekly", @"Fortnightly", @"Monthy", @"Annualy",nil];
    
    /*
    [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
    [tableViewController.tableView setFrame:CGRectMake(0, 0, screenRect.size.width, bottomView.frame.size.height)];  
    [tableViewController.tableView setSectionHeaderHeight:18];
    tableViewController.tableView.rowHeight = 20.0;
    //[tableViewController.tableView setTableHeaderView:tableLabel];
     */
}
- (void) viewWillAppear:(BOOL)animated{  
    MyDataObject *mydata = [self myDataObject];
    tableViewController = nil;
    [textView becomeFirstResponder];
    if (sender == @"Appointment" || [mydata.noteType intValue] == 1) {
        self.title = @"New Appointment";

        tableViewController = [[AddEntityTableViewController alloc]init];
        [self.view addSubview:tableViewController.tableView];
        
        CGRect startFrame = CGRectMake(-screenRect.size.width, 0, screenRect.size.width, bottomViewRect.size.height);
        tableViewController.tableView.frame = startFrame;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        CGRect endFrame = bottomViewRect;
        tableViewController.tableView.frame = endFrame;
        
        [UIView commitAnimations];    
    }
    else if (sender == @"To Do" || [mydata.noteType intValue] == 2) {
        self.title = @"New To Do";
        
        tableViewController = [[TasksTableViewController alloc]init];
        [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
        [tableViewController.tableView setSectionHeaderHeight:13];
        tableViewController.tableView.rowHeight = 20.0;
        //[tableViewController.tableView setTableHeaderView:tableLabel];
        [self.bottomView addSubview:tableViewController.tableView];
        CGRect startFrame = CGRectMake(-320, 0, 320, 204);
        tableViewController.tableView.frame = startFrame;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        
        CGRect endFrame = CGRectMake(0, 0, 320, 204);
        tableViewController.tableView.frame = endFrame;

        [UIView commitAnimations];  
    }
}
 
#pragma mark -
#pragma mark Text View Delegate Methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textView.inputAccessoryView == nil) {
    }
    [self.textView setInputAccessoryView:dateToolBar];
    return YES;    
}  

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
    //[self.navigationController.navigationBar setHidden:YES];
    CGRect endFrame = bottomView.frame;
    endFrame.origin.y  = keyboardTop;
    bottomView.frame = endFrame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (rightField_1.superview == nil||rightField_2.superview == nil){
        return;
        //FIXME: the tableview should only go down once all the date/time input is done. Currently it goes away after the startTime is set
    }
    NSDictionary* userInfo = [notification userInfo];    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    [tableViewController.tableView setBackgroundColor:[UIColor whiteColor]];
    [tableViewController.tableView setAlpha:1.0];
    [textView setAlpha:1.0];
    
    tableViewController.tableView.frame = CGRectMake(0, 205, 320, 200);
    
    [self.navigationController.navigationBar setHidden:NO];
    
    [UIView commitAnimations];
}

#pragma mark - 
#pragma mark DATE/TIME PICKER ACTIONS
- (void)datePickerChanged:(id)sender{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:[datePicker date]];
    [dateComponents setYear:[dateComponents year]];
    [dateComponents setMonth:[dateComponents month]];
    [dateComponents setDay:[dateComponents day]];
    [dateComponents setHour:12];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    NSDate *selectedDate = [calendar dateFromComponents:dateComponents];
    NSLog(@"DatePicker Changed. Selected Date: %@", selectedDate);
    leftField.text = [dateFormatter stringFromDate:selectedDate];

    [[NSNotificationCenter defaultCenter] 
	 postNotificationName:@"GetDateNotification" object:selectedDate];
    
    MyDataObject *myDataObject = [self myDataObject];
    myDataObject.myDate = selectedDate;
}

- (void)timePickerChanged:(id)sender{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[timePicker date]];    
    [timeComponents setHour:[timeComponents hour]];
    [timeComponents setMinute:[timeComponents minute]];
    [timeComponents setSecond:[timeComponents second]];
    [timeComponents setYear:0];
    [timeComponents setMonth:0];
    [timeComponents setDay:0];
    if ([rightField_1 isFirstResponder]) {
        NSDate *selectedTime= [calendar dateFromComponents:timeComponents];
        rightField_1.text = [timeFormatter stringFromDate:selectedTime];
    }
    else if ([rightField_2 isFirstResponder]) {
        NSDate *selectedEndTime= [calendar dateFromComponents:timeComponents];
        rightField_2.text = [self.timeFormatter stringFromDate:selectedEndTime];
    }
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component{
    
    rightField.text = [recurring objectAtIndex:row];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [recurring count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [recurring objectAtIndex:row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

#pragma mark -
#pragma mark - EVENTS & ACTIONS
- (void) dismissKeyboard{
    [self.view endEditing:YES];
    [navPopover dismissPopoverAnimated:YES];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void) moveTableViewUp{
    if (tableViewController.tableView.superview == nil){
        [self.view addSubview:tableViewController.tableView];
    }
    tableViewController.tableView.frame = bottomViewRect; 
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];

    [self.navigationController.navigationBar setHidden:YES];
    
    [tableViewController.tableView setFrame:CGRectMake(160, 3, 155, 189)];
    [tableViewController.tableView setRowHeight:25.0];
    [tableViewController.tableView.layer setCornerRadius:5.0];
    [tableViewController.tableView setBackgroundColor:[UIColor whiteColor]];
    [tableViewController.tableView setAlpha:0.6];
    [UIView commitAnimations];
    
}

- (void) moveTableViewDown{

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    tableViewController.tableView.frame = bottomViewRect; 
    [tableViewController.tableView setRowHeight:25.0];
    [tableViewController.tableView.layer setCornerRadius:0.0];
    [tableViewController.tableView setBackgroundColor:[UIColor whiteColor]];
    [tableViewController.tableView setAlpha:1.0];
    [UIView commitAnimations];
    
}

- (void) setAppointmentDate{
    if ([tableViewController isKindOfClass:[AddEntityTableViewController class]]) {
        if (rightField_1.superview == nil) {
            [navPopover.contentViewController.view addSubview:rightField_1];
            rightField_1.text = @"Starts:";
        }    
     
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];    
        [UIView setAnimationDelegate:self];
        [rightField_1 setFrame:CGRectMake(0, 50, 68, 40)];
                  
        [UIView commitAnimations];
        [leftField resignFirstResponder];
        [rightField_1 becomeFirstResponder];
        [dateToolBar.firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
        [dateToolBar.firstButton setAction:@selector(setAppointmentTime)];
        [dateToolBar.firstButton setTitle:@"Start Time"]; 
    }
    
    else if ([tableViewController isKindOfClass:[TasksTableViewController class]]){
        if (rightField.superview == nil) {
          //  [midView addSubview:rightField];
            rightField.text = [recurring objectAtIndex:0];            
        }   
        if (pickerView.superview == nil) {
            [bottomView addSubview:pickerView];
        }
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];    
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(removeDatePicker)];  
        CGRect endFrame = CGRectMake(leftField.frame.origin.x+leftField.frame.size.width+10, 0, 150, leftField.frame.size.height);
        rightField.frame = endFrame;
        endFrame = CGRectMake(-320, dateToolBar.frame.size.height,pickerView.frame.size.width, pickerView.frame.size.height);
        datePicker.frame = endFrame;
        endFrame = CGRectMake(0.0, dateToolBar.frame.size.height,
                              timePicker.frame.size.width, pickerView.frame.size.height);
        pickerView.frame = endFrame;                      
        [UIView commitAnimations];
    }
    
    /*-- DATE/TIME: Get selected Date from the time Picker; put it in the date text field --*/
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:[datePicker date]];
    [dateComponents setYear:[dateComponents year]];
    [dateComponents setMonth:[dateComponents month]];
    [dateComponents setDay:[dateComponents day]];
    [dateComponents setHour:12];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    NSDate *selectedDate = [[calendar dateFromComponents:dateComponents] retain];
    leftField.text = [dateFormatter stringFromDate:selectedDate];
    [selectedDate release];
    
    if ([tableViewController isKindOfClass:[AddEntityTableViewController class]]) {
     
    }
    else if ([tableViewController isKindOfClass:[TasksTableViewController class]]){
        [leftField resignFirstResponder];
        [rightField becomeFirstResponder];
        [dateToolBar.firstButton setImage:[UIImage imageNamed:@"save.png"]];
        [dateToolBar.firstButton setAction:@selector(doneAction)];
        [dateToolBar.firstButton setTitle:@"Done"];            
    }

    return;
}
- (void) setAppointmentTime{
       /*--DATE/TIME: Get selected Time from the time Picker; put it in the time text field --*/
    if (rightField_2.superview == nil) {
        [navPopover.contentViewController.view addSubview:rightField_2];
        rightField_2.text = @"Ends:";
    }    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];    
    [UIView setAnimationDelegate:self];
    [rightField_2 setFrame:CGRectMake(72, 50, 68, 40)];
    
    [UIView commitAnimations];
    [rightField_1 resignFirstResponder];
    [rightField_2 becomeFirstResponder];
    [dateToolBar.firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
    [dateToolBar.firstButton setAction:@selector(setEndTime)];
    [dateToolBar.firstButton setTitle:@"End Time"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[timePicker date]];    
    [timeComponents setHour:[timeComponents hour]];
    [timeComponents setMinute:[timeComponents minute]];
    [timeComponents setSecond:[timeComponents second]];
    [timeComponents setYear:0];
    [timeComponents setMonth:0];
    [timeComponents setDay:0];
    NSDate *selectedTime = [[calendar dateFromComponents:timeComponents] retain];
    rightField_1.text = [timeFormatter stringFromDate:selectedTime];
    
}

- (void) setEndTime{
    /*--DATE/TIME: Get selected Time from the time Picker; put it in the time text field --*/
    if (rightField.superview == nil) {
        [navPopover.contentViewController.view addSubview:rightField];
    }    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];    
    [UIView setAnimationDelegate:self];
    [rightField setFrame:CGRectMake(0, 95, 140, 40)];
    
    [UIView commitAnimations];
    [rightField_2 resignFirstResponder];
    [rightField becomeFirstResponder];
    [dateToolBar.firstButton setImage:[UIImage imageNamed:@"arrow_circle_left_24.png"]];
    [dateToolBar.firstButton setAction:@selector(doneAction)];
    [dateToolBar.firstButton setTitle:@"Set Recurring"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[timePicker date]];    
    [timeComponents setHour:[timeComponents hour]];
    [timeComponents setMinute:[timeComponents minute]];
    [timeComponents setSecond:[timeComponents second]];
    [timeComponents setYear:0];
    [timeComponents setMonth:0];
    [timeComponents setDay:0];
    NSDate *selectedTime = [[calendar dateFromComponents:timeComponents] retain];
    rightField_2.text = [timeFormatter stringFromDate:selectedTime];
}

- (void) doneAction {    
    if ([tableViewController isKindOfClass:[AddEntityTableViewController class]]) {
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Appointment"
                                       inManagedObjectContext:managedObjectContext];
        Appointment *newAppointment = [[Appointment alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [newAppointment setText:textView.text];
        //Add condition for reedit = if creationDate != nil then break
        [newAppointment setCreationDate:[NSDate date]];
        [newAppointment setType:[NSNumber numberWithInt:1]];
        [newAppointment setDoDate:[dateFormatter dateFromString:leftField.text]];
        [newAppointment setDoTime:[timeFormatter dateFromString:rightField_1.text]];
        [newAppointment setEndTime:[timeFormatter dateFromString:rightField_2.text]];
    
        /*--Save the MOC--*/	
        NSError *error;
        if(![managedObjectContext save:&error]){ 
            NSLog(@"ADDENTITY/Appointments VIEWCONTROLLER MOC: DID NOT SAVE");
        } 
        
        NSLog(@"DO DATE is %@", newAppointment.doDate);
        NSLog(@"DO TIME is %@", newAppointment.doTime);
        NSLog(@"END TIME is %@", newAppointment.endTime);

        [newAppointment release];
    }
    else if ([tableViewController isKindOfClass:[TasksTableViewController class]]) {
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Task"
                                       inManagedObjectContext:managedObjectContext];
        Task *newTask = [[Task alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
        [newTask setText:textView.text];
        //Add condition for reedit = if creationDate != nil then break
        [newTask setCreationDate:[NSDate date]];
        [newTask setType:[NSNumber numberWithInt:2]];
        [newTask setDoDate:[dateFormatter dateFromString:leftField.text]];
        [newTask setRecurring:rightField.text];
        /*--Save the MOC--*/	
        NSError *error;
        if(![managedObjectContext save:&error]){ 
            NSLog(@"ADDENTITY/Tasks VIEWCONTROLLER MOC: DID NOT SAVE");
        } 
        [newTask release];
    }
    [self.view endEditing:YES];
    [textView setText:@""];
    [leftField setText:@""];
    [rightField setText:@""];
    [rightField_1 setText:@""];
    [rightField_2 setText:@""];
    [dateToolBar.firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
    [dateToolBar.firstButton setTitle:@"Set Date"];
    [dateToolBar.firstButton setAction:@selector(setAppointmentDate)];
    [dateToolBar.dismissKeyboard setAction:@selector(dismissKeyboard)];    

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeAllAddedViews)];
    
    dateToolBar.frame = toolBarRect;
    datePicker.frame = CGRectMake(-screenRect.size.width, datePicker.frame.origin.y, screenRect.size.width, datePicker.frame.size.height);
    timePicker.frame = CGRectMake(-screenRect.size.width, timePicker.frame.origin.y, screenRect.size.width, timePicker.frame.size.height);
    textView.frame = textViewRect;
    //midView.frame = CGRectMake(0, midViewRect.origin.y, midViewRect.size.width, midViewRect.size.height);
    bottomView.frame = bottomViewRect;
    [UIView commitAnimations];
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark NAVIGATION

- (void) backAction{
	[self dismissModalViewControllerAnimated:YES];		
}

- (void) setAlarm {
    return;
}
- (void) setRecurring {
    return;
}

@end

/*
 
 - (void) removeAllAddedViews{
 [datePicker removeFromSuperview];
 [timePicker removeFromSuperview];
 [leftField removeFromSuperview];
 [rightField removeFromSuperview];
 [rightField_1 removeFromSuperview];
 [rightField_2 removeFromSuperview];
 [dateToolBar removeFromSuperview];
 }

 
 #pragma mark - 
 #pragma mark - ANIMATION
 
 - (void) animateViews:(UIView *)view startFrom:(CGRect)fromFrame endAt:(CGRect)toFrame{
 view.frame = fromFrame;
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationDuration:0.4];    
 [UIView setAnimationDelegate:self];
 view.frame = toFrame;
 [UIView commitAnimations];    
 }

 #pragma mark - 
 #pragma mark - ACTIONS
 - (void) dismissKeyboard{
 //Check if textView is firstResponder. If yes, dismiss the keyboard by calling resignFirstResponder;
 if ([textView isFirstResponder]){
 [textView resignFirstResponder];
 }
 //Check if one of the pickerViews is on the screen.
 if (datePicker.superview != nil || timePicker.superview != nil || pickerView.superview !=nil) {
 
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationDuration:0.4];    
 [UIView setAnimationDelegate:self];
 
 if (datePicker !=nil) {
 
 [UIView setAnimationDidStopSelector:@selector(removeDatePicker)];  
 }
 else if (timePicker !=nil){
 [UIView setAnimationDidStopSelector:@selector(removeTimePicker)];   
 }
 else if (pickerView !=nil){
 [UIView setAnimationDidStopSelector:@selector(removePickerView)];   
 }
 datePicker.frame = CGRectMake(320,datePicker.frame.origin.y, datePicker.frame.size.width, datePicker.frame.size.height);
 timePicker.frame = CGRectMake(320,timePicker.frame.origin.y, timePicker.frame.size.width, timePicker.frame.size.height);
 pickerView.frame = CGRectMake(320,pickerView.frame.origin.y, pickerView.frame.size.width, pickerView.frame.size.height);
 
 dateToolBar.frame = CGRectMake(320, dateToolBar.frame.origin.y, dateToolBar.frame.size.width, dateToolBar.frame.size.height);    
 
 bottomView.frame = bottomViewRect;
 if (textView.frame.size.height <100){
 textView.frame = textViewRect;
 //CGRect frame = midView.frame;
 //frame.origin.y += 40;
 //midView.frame = frame;
 }
 
 [UIView commitAnimations];
 [self.navigationController.navigationBar setHidden:NO];
 }
 }
 
 - (void) removeDatePicker {
 if (datePicker.superview != nil) {
 [datePicker removeFromSuperview];
 NSLog(@"datePicker removed from Superview");
 }
 if (timePicker.superview == nil && pickerView.superview == nil) {
 [dateToolBar removeFromSuperview];
 NSLog(@"Removed DateToolBar with removeDatePicker method");
 }
 }    
 
 - (void) removeTimePicker {
 if (timePicker.superview != nil) {
 [timePicker removeFromSuperview];
 NSLog(@"timePicker removed from Superview");
 
 }
 if (datePicker.superview == nil && pickerView.superview == nil) {
 [dateToolBar removeFromSuperview];
 NSLog(@"Removed DateToolBar with removeTimePicker method");
 
 }
 
 }  
 - (void) removePickerView {
 if (pickerView.superview != nil) {
 [pickerView removeFromSuperview];
 }
 if (timePicker.superview == nil && datePicker.superview == nil) {
 [dateToolBar removeFromSuperview];
 }    
 }  
 
- (void) addPickerResizeViews:(UIView *)picker1 removePicker:(UIView *)picker2 {
    [textView resignFirstResponder];
    //PICKER Start and End frames
    if (picker1.superview == nil) {
        [bottomView addSubview:picker1];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        
        if (picker2 == datePicker && ([rightField_1 isHighlighted]||[rightField_2 isHighlighted])) {
            [UIView setAnimationDidStopSelector:@selector(removeDatePicker)];
        }
        else if (picker2 == timePicker && [leftField isHighlighted] ){
            NSLog(@"ADDED datePicker from addPickerResizeView")
            ;            [UIView setAnimationDidStopSelector:@selector(removeTimePicker)];
        }
        
        //PICKER: move into place
        picker1.frame = CGRectMake(0.0,
                                   datePicker.frame.origin.y, datePicker.frame.size.width, datePicker.frame.size.height);
        picker2.frame = CGRectMake(-320,
                                   datePicker.frame.origin.y, datePicker.frame.size.width, datePicker.frame.size.height);
        [UIView commitAnimations];
    }
    if (dateToolBar.superview == nil){
        NSLog(@"ADDING TOOLBAR FROM addPickerResizeViews method");    
        [bottomView addSubview:dateToolBar];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];    
        [UIView setAnimationDelegate:self];
        
        
        //TOOLBAR: move into place
        CGRect endFrame = CGRectMake(0.0, 0.0, 320, 40);            
        dateToolBar.frame = endFrame;
        
        [UIView commitAnimations];
    }
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    UITouch *touch = [touches anyObject];
    if (touch.view.tag == 12) {
        [leftField setHighlighted:YES];
        [rightField_1 setHighlighted:NO];
        [rightField_2 setHighlighted:NO];
        [self  addPickerResizeViews:datePicker removePicker:timePicker];
    }
    else if (touch.view.tag == 13) {
        [rightField_1 setHighlighted:YES];
        [leftField setHighlighted:NO];
        [rightField_2 setHighlighted:NO];
        [self addPickerResizeViews:timePicker removePicker:datePicker];
    }
    else if (touch.view.tag == 14) {
        [rightField_2 setHighlighted:YES];
        [leftField setHighlighted:NO];
        [rightField_1 setHighlighted:NO];
        [self addPickerResizeViews:timePicker removePicker:datePicker];
    }
    else {
        [rightField setHighlighted:YES];
        [leftField setHighlighted:NO];
        [self addPickerResizeViews:pickerView removePicker:datePicker];
    }
}

*/

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

// [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dateFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];

//[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timeFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];

//[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recurringFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];

/* Search Bar Notification sent from FolderTable View to the Main view to accommodate the moving TableView 
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown)  name:UIKeyboardDidShowNotification object:nil];
 */

