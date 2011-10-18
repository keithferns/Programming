//  AddEntityViewController.m
//  WriteNow
//  Created by Keith Fernandes on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

//TODO: Add function for searching for durations that are free within some time frame. Say you want to make a doctor's appointment, what you need to do is specify a duration, for eg. 2 hrs, between 12 noon and 6 pm, in the up coming week. The system should find and list all such durations. 

//TODO: Change the tableView cell configuration when the tableView is present in the topView. the date should appear in the short form, the text should be smaller.


#import "WriteNowAppDelegate.h"
#import "CalendarViewController.h"
#import "AppointmentsTableViewController.h"
#import "TasksTableViewController.h"
#import "CalendarTableViewController.h"


#import "CustomTextView.h"
#import "CustomToolBar.h"

#import "MyDataObject.h"
#import "AppDelegateProtocol.h"

@implementation CalendarViewController
@synthesize tableViewController;
@synthesize managedObjectContext;
@synthesize textView;
@synthesize toolBar;
@synthesize pickerView,recurring;
@synthesize dateFormatter, timeFormatter;
@synthesize schedulerPopover, reminderPopover;
@synthesize datePicker, timePicker;
@synthesize newAppointment, newTask;
@synthesize addField;
@synthesize flipIndicatorButton;
@synthesize frontViewIsVisible;
@synthesize calendarView, flipperImageForDateNavigationItem, flipperView;

- (MyDataObject *) myDataObject; {
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	MyDataObject* myDataObject;
	myDataObject = (MyDataObject*) theDelegate.myDataObject;
	return myDataObject;
}

//static int calendarShadowOffset = (int)-20;
#define screenRect [[UIScreen mainScreen] applicationFrame]
#define statusBarRect [[UIApplication sharedApplication] statusBarFrame];
#define tabBarHeight self.tabBarController.tabBar.frame.size.height
#define navBarHeight self.navigationController.navigationBar.frame.size.height
#define toolBarRect CGRectMake(screenRect.size.width, 0, screenRect.size.width, 40)
#define textViewRect CGRectMake(5, navBarHeight+5, screenRect.size.width-10, 140)
#define bottomViewRect CGRectMake(0, textViewRect.origin.y+textViewRect.size.height+10, screenRect.size.width, screenRect.size.height-textViewRect.origin.y-textViewRect.size.height-10)
#define mainFrame CGRectMake(screenRect.origin.x, self.navigationController.navigationBar.frame.origin.y+navBarHeight, screenRect.size.width, screenRect.size.height-navBarHeight)

- (void)dealloc {
    [super dealloc];
    [textView release];
    //    [toolBar release];
    [dateFormatter release];
    [timeFormatter release];
    [tableViewController release];
    [datePicker release];
    [timePicker release];
    [pickerView release];
    [recurring release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITableViewSelectionDidChangeNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
    NSLog(@"CALENDAR VIEWCONTROLLER: MEMORY WARNING");
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    dateFormatter = nil;
    timeFormatter = nil;
    textView = nil;    
    datePicker = nil;
    timePicker = nil;
    pickerView = nil;
    recurring = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITableViewSelectionDidChangeNotification object:nil];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //FIXME: IS THIS MOC NEEDED?
    
    if (managedObjectContext == nil){
        managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"ADDENTITYVIEWCONTROLLER After managedObjectContext: %@",  managedObjectContext);        
    } 
    
    //[self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
    UIImage *background = [UIImage imageNamed:@"wallpaper.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:background]];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;    
    addField = 1;
    textView = nil;
    
}

- (void) viewWillAppear:(BOOL)animated{  
    NSLog(@"SUBVIEWS OF MAIN VIEW ON LOADING ARE:%@", [self.view subviews]);
    
    /*--NOTIFICATIONS: register --*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displaySelectedRow:) name:UITableViewSelectionDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    /*--NAVIGATION ITEMS --*/
    //Set Navigation Bar Visible
    if (self.navigationController.navigationBarHidden == YES){
        self.navigationController.navigationBarHidden = NO;
    }
    //Initialize the TOOLBAR
    toolBar = [[CustomToolBar alloc] initWithFrame:toolBarRect];
    [toolBar.firstButton setTarget:self];
    [toolBar.firstButton setAction:@selector(presentSchedulerPopover:)];
    [toolBar.firstButton setTag:1];
    [toolBar.secondButton setTarget:self];
    [toolBar.secondButton setAction:@selector(presentReminderPopover:)];
    [toolBar.dismissKeyboard setTarget:self];
    [toolBar.dismissKeyboard setAction:@selector(dismissKeyboard)];  
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setDate:[NSDate date]];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)]];
    datePicker.timeZone = [NSTimeZone systemTimeZone];
    [datePicker sizeToFit];
    datePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];  
    
    timePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    [timePicker setMinuteInterval:10];
    timePicker.timeZone = [NSTimeZone systemTimeZone];
    [timePicker sizeToFit];
    timePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [timePicker addTarget:self action:@selector(timePickerChanged:) forControlEvents:UIControlEventValueChanged];
    //timePicker.date = [timeFormatter dateFromString:@"12:00 PM"]; 
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
    pickerView.showsSelectionIndicator = YES;
    recurring = [[NSArray alloc] initWithObjects:@"Never",@"Daily",@"Weekly", @"Fortnightly", @"Monthy", @"Annualy",nil];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, MMM d, yyyy"];    
    timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"h:mm a"];
    
    /*-ADD FLIPPER VIEW -*/
    flipperView = [[UIView alloc] initWithFrame:mainFrame];
    [flipperView setBackgroundColor:[UIColor yellowColor]];
    [self.view   addSubview:flipperView];
    
        if (calendarView.superview==nil) {
        NSLog(@"Adding calendarView");
        calendarView = 	[[TKCalendarMonthView alloc] init];        
        calendarView.delegate = self;
        calendarView.dataSource = self;
        calendarView.frame = CGRectMake(0, mainFrame.size.height, mainFrame.size.width, mainFrame.size.height);
        
        //calendarView.frame = CGRectMake(0, screenRect.size.height, calendarView.frame.size.width, calendarView.frame.size.height);
        //calendarView.frame = CGRectMake(0, -calendarView.frame.size.height+calendarShadowOffset, calendarView.frame.size.width, calendarView.frame.size.height);
        // Ensure this is the last "addSubview" because the calendar must be the top most view layer	
        [self.flipperView addSubview:calendarView];
        [calendarView reload];
        
        //[self.flipperView addSubview:tableViewController.tableView];
        tableViewController.tableView.frame = CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height);
        [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
        [tableViewController.tableView setSectionHeaderHeight:13];
        tableViewController.tableView.rowHeight = 40.0;
        //[tableViewController.tableView setTableHeaderView:tableLabel]
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    calendarView.frame = CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height);
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleBordered target:self action:@selector(addItem:)]; //right button - add NEW item - persists as long as cal/tv is full screen
    self.navigationItem.leftBarButtonItem  = leftButton;
    [leftButton release];
    self.navigationItem.leftBarButtonItem.tag = 1;
    [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];  
    
    //UIImage *menuButtonImage = [self flipperImageForDateNavigationItem];
    UIImage *menuButtonImage = [UIImage imageNamed:@"list_white_on_blue_bkg.png"];
    UIButton *localFlipIndicator=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height)];
	//UIButton *localFlipIndicator=[[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    self.flipIndicatorButton=localFlipIndicator;
	[localFlipIndicator release];
    [flipIndicatorButton setBackgroundImage:menuButtonImage forState:UIControlStateNormal];	
    [flipIndicatorButton.layer setCornerRadius:4.0];
	UIBarButtonItem *flipButtonBarItem;
	flipButtonBarItem=[[UIBarButtonItem alloc] initWithCustomView:flipIndicatorButton];	
	[self.navigationItem setRightBarButtonItem:flipButtonBarItem animated:YES];
	[flipButtonBarItem release];
	[flipIndicatorButton addTarget:self action:@selector(toggleCalendar) forControlEvents:(UIControlEventTouchDown)];
    
    [UIView commitAnimations];
    
    NSLog(@"SUBVIEWS OF MAIN VIEW ON LOADING ARE:%@", [self.view subviews]);
    frontViewIsVisible = YES;
    
    MyDataObject *myData = [self myDataObject]; //Create instance of Shared Data Object (SDO)- autoreleases.
    if ([myData.noteType intValue] == 1) {//TODO: Add code here relevant to creating Appointments.
        NSLog(@"SETTING NEW APPOINTMENT");
        [self addNewAppointment];
        if (tableViewController == nil) {
            tableViewController = [[AppointmentsTableViewController alloc] init];
        }
    }
    else if ([myData.noteType intValue] == 2){//TODO: Add code here relevant to creating Tasks.
        NSLog(@"SETTING NEW TASK");
        [self addNewTask];
        if (self.tableViewController == nil){
            tableViewController = [[TasksTableViewController alloc]init];
        }
    }
    else {//when tab is selected, tableview/calendar is shown full screen - table view has both tasks and appointments for each date
        //TODO: TABLEVIEW CONTROLLER WITH BOTH TASKS AND APPOINTMENTS/CALENDER VIEW
        tableViewController = [[AppointmentsTableViewController alloc] init];
    }
}
/*
 UIImage *buttonImageNormal = [UIImage imageNamed:@"action-normal.png"];
 UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
 [playButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
 
 UIImage *buttonImagePressed = [UIImage imageNamed:@"action-pressed.png"];
 UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
 [playButton setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
 */
- (void) viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UITableViewSelectionDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    self.title = @"Calendar"; // reset the tabBarItem and navigationBar titles to Calendar
    [schedulerPopover setDelegate:nil];
    [schedulerPopover autorelease];
    schedulerPopover = nil;
    [tableViewController.tableView removeFromSuperview];
    [tableViewController release];
    tableViewController = nil;
    [toolBar release];
    MyDataObject *myData = [self myDataObject];
    if (![textView hasText] || ![textView isUserInteractionEnabled]) {
        [textView removeFromSuperview];
        [textView release];
        textView = nil;
        myData.noteType = [NSNumber numberWithInt:0];
        myData.isEditing = [NSNumber numberWithInt:0];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    [datePicker release];
    [timePicker release];
    [pickerView release];
    datePicker = nil;
    timePicker = nil;
    pickerView = nil;
    [flipIndicatorButton release];
    flipIndicatorButton = nil;
    [dateFormatter release];
    [timeFormatter release];
    dateFormatter = nil;
    timeFormatter = nil;
    [flipperView removeFromSuperview];
    [flipperView release];
    flipperView = nil;
    [calendarView removeFromSuperview];
    [calendarView release];
    calendarView = nil;
    NSLog(@"SUBVIEWS OF MAIN VIEW ON LOADING ARE:%@", [self.view subviews]);
}



#pragma mark -- 
#pragma mark - Scheduler ACTIONS

- (void)presentSchedulerPopover:(id)sender {//CREATE THE POPOVER AND ADD TO THE VIEW
    [tableViewController.tableView removeFromSuperview];
	[textView removeFromSuperview];
    [self.view addSubview:textView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];    
    NSLog(@"Changing the textframe");
    textView.frame = CGRectMake(5, textViewRect.origin.y, textViewRect.size.width-10, textViewRect.size.height);
    [UIView commitAnimations];
    NSLog(@"SUBVIEW OF MAIN VIEW = %@", [self.view subviews]);
    if ([textView isFirstResponder]) {
        [textView resignFirstResponder];
    }
    if ([reminderPopover isPopoverVisible]) {
        [reminderPopover dismissPopoverAnimated:YES];
    }
    
    if (self.navigationController.navigationBarHidden == NO){
        self.navigationController.navigationBarHidden = YES;
    }
    //[self moveTableViewUp];// move tableView to screen right

    if(!schedulerPopover) {
        
        if ([[schedulerPopover returnName] isEqualToString:@"Scheduler"]) {
            NSLog(@"schedulerPopover is not Scheduler");
            [self cancelPopover:nil];
        }
        /*       
        MyDataObject *mydata = [self myDataObject];
        if (mydata.selectedAppointment !=nil && [mydata.selectedAppointment.isEditing intValue] ==1){
            [rightField_1 setFrame:CGRectMake(0, 95, 68, 40)];
            [rightField_2 setFrame:CGRectMake(72, 95, 68, 40)];
            [rightField setFrame:CGRectMake(0, 140, 140, 40)];
            [viewCon.view addSubview:rightField_1];
            [viewCon.view addSubview:rightField_2];
            [viewCon.view addSubview:rightField];
            [leftField setText:[dateFormatter stringFromDate:mydata.selectedAppointment.doDate]];
            [rightField_1 setText:[timeFormatter stringFromDate:mydata.selectedAppointment.doTime]];
            [rightField_2 setText:[timeFormatter stringFromDate:mydata.selectedAppointment.endTime]];
            [rightField setText:mydata.selectedAppointment.recurring];
        } else if (mydata.selectedTask !=nil && [mydata.selectedTask.isEditing intValue]==1){
            [rightField setFrame:CGRectMake(0, 140, 140, 40)];
            [viewCon.view addSubview:rightField];
            [leftField setText:[dateFormatter stringFromDate:mydata.selectedAppointment.doDate]];
            [rightField setText:mydata.selectedAppointment.recurring];
        }
        */

        [schedulerPopover addName:@"Scheduler"];
        SchedulePopoverViewController *viewCon = [[SchedulePopoverViewController alloc]init];
        [viewCon.button1 addTarget:self action:@selector(cancelPopover:) forControlEvents:UIControlEventTouchUpInside];
        
        //viewCon.tableViewController = [[UITableViewController alloc] init];
        //viewCon.tableViewController = self.tableViewController;
        
        //[viewCon.view addSubview:tableViewController.tableView];
        //tableViewController.tableView.frame = CGRectMake(145, 120, 160, 200);
        viewCon.contentSizeForViewInPopover = CGSizeMake(300, 180);
        schedulerPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        [schedulerPopover setDelegate:self];
        [viewCon release];
        }
    
    [schedulerPopover presentPopoverFromRect:CGRectMake(15, 205, 0, 57)
                                    inView:self.view 
                  permittedArrowDirections:UIPopoverArrowDirectionDown
                                  animated:YES name:@"Scheduler"];
    
    switch (addField) {
    case 1:
            [self addDateField];
            break;
    case 2: 
            [self addDateField];
            [self addStartTimeField];   
            break;
    case 3:
            [self addDateField];
            [self addStartTimeField];
            [self addEndTimeField];
            break;
    case 4: 
            [self addDateField];
            [self addStartTimeField];
            [self addEndTimeField];
            [self addRecurringField];
            break;
        case 5:
            [self addRecurringField];

        default:
            break;
    }
}
- (void) addDateField{
    [toolBar.firstButton setAction:@selector(setAppointmentDate:)];
    [toolBar.firstButton setTitle:@"Set Date"];   
    [toolBar.firstButton setTag:2];
    NSNumber *num = [NSNumber numberWithInt:1];
    NSArray *objects = [NSArray arrayWithObjects:self.datePicker, self.toolBar,num, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"picker", @"toolbar",@"num", nil];
    NSDictionary *inputObjects = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopOverShouldUpdateNotification" object:nil userInfo:inputObjects];
}
- (void)datePickerChanged:(id)sender{
    NSLog(@"DatePicker Changed");
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:[datePicker date]];
    [dateComponents setYear:[dateComponents year]];
    [dateComponents setMonth:[dateComponents month]];
    [dateComponents setDay:[dateComponents day]];
    [dateComponents setHour:12];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    NSDate *selectedDate = [calendar dateFromComponents:dateComponents];
    if (newAppointment != nil){
        newAppointment.doDate = selectedDate;
    }
    else if (newTask != nil){
        newTask.doDate = selectedDate;
    }
    
    NSNumber *num = [NSNumber numberWithInt:2];
    NSArray *objects = [NSArray arrayWithObjects:num, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"num", nil];
    NSDictionary *inputObjects = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetDateNotification" object:selectedDate userInfo:inputObjects]; 
    
}
- (void) setAppointmentDate:(id)sender{
    //CASE: the popOver has not been created or it is not visible.
    if (!schedulerPopover || ![schedulerPopover isPopoverVisible]) {
        [self presentSchedulerPopover:nil];
        MyDataObject *myDate = [self myDataObject];
        if ([myDate.noteType intValue]== 1) {
            addField = 1;
        }
        else if ([myDate.noteType intValue]== 2){
            addField = 5;   
        }
    }
    //CASE: popOver is view, DATEPICKER date selected & SETDATE button tapped --> 
    [self addStartTimeField];  //Call method to add the next field.   
    //NOTE: newAppointment.date is set in the datePickerChanged method
}
- (void) addStartTimeField{
    if ([schedulerPopover isPopoverVisible]) {
    [toolBar.firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
    [toolBar.firstButton setAction:@selector(setStartTime:)];
    [toolBar.firstButton setTitle:@"Start Time"];   
    [toolBar.firstButton setTag:3];

    NSNumber *num = [NSNumber numberWithInt:3];
    NSArray *objects = [NSArray arrayWithObjects:self.timePicker, self.toolBar, num, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"picker", @"toolbar", @"num",nil];
    NSDictionary *inputObjects = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopOverShouldUpdateNotification"object:nil userInfo:inputObjects];
    }
}
- (void)timePickerChanged:(id)sender{
    NSLog(@"TimePicker Changed");
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[timePicker date]];    
    [timeComponents setHour:[timeComponents hour]];
    [timeComponents setMinute:[timeComponents minute]];
    [timeComponents setSecond:[timeComponents second]];
    [timeComponents setYear:0];
    [timeComponents setMonth:0];
    [timeComponents setDay:0];
    NSDate *selectedTime= [calendar dateFromComponents:timeComponents];
    NSNumber *num = [NSNumber numberWithInt:4];
    NSArray *objects = [NSArray arrayWithObjects:num, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"num", nil];
    NSDictionary *inputObjects = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"PopOverShouldUpdateNotification" object:selectedTime userInfo:inputObjects];
}
- (void) setStartTime:(id)sender{
    if (!schedulerPopover || ![[schedulerPopover returnName] isEqualToString:@"Scheduler"]){
        [self cancelPopover:nil];
        [self presentSchedulerPopover:nil];
        addField = 2;
    }
    //CASE: the popOver in view, TIMEPICKER time selected and  STARTTIME button tapped -> 
    else if ([schedulerPopover isPopoverVisible] && [sender tag] == 3) {
        [self addEndTimeField]; //call method to add the next field.   
        MyDataObject *myData = [self myDataObject];

        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[timePicker date]];    
        [timeComponents setYear:0];
        [timeComponents setMonth:0];
        [timeComponents setDay:0];
        NSDate *selectedTime= [calendar dateFromComponents:timeComponents];
        if ([myData.noteType intValue]== 1){
            [timeComponents setHour:[timeComponents hour]];
            [timeComponents setMinute:[timeComponents minute]];
            [timeComponents setSecond:[timeComponents second]];
        newAppointment.doTime = selectedTime;
        }
        else {
            [timeComponents setHour:0];
            [timeComponents setMinute:0];
            [timeComponents setSecond:0];
            selectedTime = [calendar dateFromComponents:timeComponents];
            newTask.doDate = selectedTime;
        }
    }
}
- (void) addEndTimeField{
    if ([schedulerPopover isPopoverVisible]) {
        [toolBar.firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
        [toolBar.firstButton setAction:@selector(setEndTime:)];
        [toolBar.firstButton setTitle:@"End Time"];   
        [toolBar.firstButton setTag:4];
        //PostNotification to schedulepopover  
        NSNumber *num = [NSNumber numberWithInt:5];
        NSArray *objects = [NSArray arrayWithObjects:self.timePicker, self.toolBar, num, nil];
        NSArray *keys = [NSArray arrayWithObjects:@"picker", @"toolbar", @"num",nil];
        NSDictionary *inputObjects = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PopOverShouldUpdateNotification"object:newAppointment userInfo:inputObjects];
    }
}
- (void) setEndTime:(id)sender{
    //Put end time in popOver view
    if (!schedulerPopover || ![schedulerPopover isPopoverVisible]) {
        [self presentSchedulerPopover:nil];
        addField = 3;
    }
    //CASE: popOver in view, TIMEPICKER time selected and the ENDTIME button is tapped --> 
    else if ([schedulerPopover isPopoverVisible] && [sender tag] == 4) {
        [self addRecurringField];//Call method to add next field
        MyDataObject *myData = [self myDataObject];

        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[timePicker date]];    
        [timeComponents setYear:0];
        [timeComponents setMonth:0];
        [timeComponents setDay:0];
        [timeComponents setHour:[timeComponents hour]];
        [timeComponents setMinute:[timeComponents minute]];
        [timeComponents setSecond:[timeComponents second]];
        NSDate *selectedTime= [calendar dateFromComponents:timeComponents];

        if ([myData.noteType intValue]== 1){
            newAppointment.endTime = selectedTime;
        }
        else {
            [timeComponents setHour:0];
            [timeComponents setMinute:0];
            [timeComponents setSecond:0];
            selectedTime = [calendar dateFromComponents:timeComponents];
            newTask.doDate = selectedTime;
        }
    }
}
- (void) addRecurringField{
    if ([schedulerPopover isPopoverVisible]) {
        [toolBar.firstButton setImage:[UIImage imageNamed:@"11-clock.png"]];
        [toolBar.firstButton setAction:@selector(setRecurrance:)];
        [toolBar.firstButton setTitle:@"Recurring"];   
        [toolBar.firstButton setTag:4];
        //PostNotification to schedulepopover  
        NSNumber *num = [NSNumber numberWithInt:6];
        NSArray *objects = [NSArray arrayWithObjects:self.pickerView, self.toolBar, num, nil];
        NSArray *keys = [NSArray arrayWithObjects:@"picker", @"toolbar", @"num",nil];
        NSDictionary *inputObjects = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PopOverShouldUpdateNotification"object:newAppointment userInfo:inputObjects];
    }
}
- (void) setRecurrance:(id)sender{
    
    [self cancelPopover:nil];
    [textView becomeFirstResponder];
    return;
}
#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component{
    NSNumber *num = [NSNumber numberWithInt:7];
    NSArray *objects = [NSArray arrayWithObjects:num, nil];
    NSArray *keys   = [NSArray arrayWithObjects:@"num", nil];
    NSDictionary *inputObjects = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopOverShouldUpdateNotification"object:newAppointment userInfo:inputObjects];
    
    MyDataObject *myData = [self myDataObject];
    if ([myData.noteType intValue] == 1) {
        newAppointment.recurring = [recurring objectAtIndex:row];
    }
    else {
        newTask.recurring = [recurring objectAtIndex:row];
    }
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // tell the picker how many rows are available for a given component
    return [recurring count];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    // tell the picker how many components it will have
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    // tell the picker the title for a given component
    return [recurring objectAtIndex:row];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    // tell the picker the width of each row for a given component
    int sectionWidth = 300;    
    return sectionWidth;
}
- (void) cancelPopover:(id)sender {
    NSLog(@"CANCELLING POPOVER");
    if (self.navigationController.navigationBarHidden == YES) {
        self.navigationController.navigationBarHidden = NO;
    }
    if([schedulerPopover isPopoverVisible]) {
        [schedulerPopover dismissPopoverAnimated:YES];
        [schedulerPopover setDelegate:nil];
        [schedulerPopover autorelease];
        schedulerPopover = nil;
    } else if ([reminderPopover isPopoverVisible]){
        [reminderPopover dismissPopoverAnimated:YES];
        [reminderPopover setDelegate:nil];
        [reminderPopover autorelease];
        reminderPopover = nil;
    }
        
        //[self moveTableViewDown];
        if ([sender tag] == 1){
            [toolBar.firstButton setImage:[UIImage imageNamed:@"calendar_24.png"]];
            [toolBar.firstButton setTitle:@"Schedule"];
            [toolBar.firstButton setAction:@selector(presentSchedulerPopover:)];
            [toolBar.firstButton setTag:1];
    }        
}
- (void) showSchedule {    
    
       //TODO: Add recurrance to textView
    NSLog(@"Saving Schedule");
    MyDataObject *myData = [self myDataObject];

    CustomTextField * dateField = [[CustomTextField alloc] init];
    [dateField setText:[NSString stringWithFormat:@"Scheduled for %@", [dateFormatter stringFromDate:newAppointment.doDate]]];
    [dateField setFrame:CGRectMake(-screenRect.size.width, textViewRect.origin.y, textViewRect.size.width, 30)];
    
    CustomTextField * timeField = [[CustomTextField alloc] init];
    [timeField setText:[NSString stringWithFormat:@"From %@ Till %@",[timeFormatter stringFromDate:newAppointment.doTime], [timeFormatter stringFromDate:newAppointment.endTime]]];
    [timeField setFrame:CGRectMake(screenRect.size.width, dateField.frame.origin.y+35, textViewRect.size.width, 30)];
    
    [self.view addSubview:dateField];
     
    if ([myData.noteType intValue] == 1) {
        [self.view addSubview:timeField];
        }
  
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    [dateField setFrame:CGRectMake(textViewRect.origin.x, textViewRect.origin.y, textViewRect.size.width, 30)];
    [timeField setFrame:CGRectMake(textViewRect.origin.x, dateField.frame.origin.y+35, textViewRect.size.width, 30)];
    CGRect frame = textViewRect;
    frame.origin.y = timeField.frame.origin.y+timeField.frame.size.height+5;
    frame.size.height = textViewRect.size.height - 70;
    [textView setFrame:frame];
    [UIView commitAnimations];
    
    [dateField setUserInteractionEnabled:NO];
    [timeField setUserInteractionEnabled:NO];
   
    [dateField release];
    [timeField release];
}
//Create Popover to set Alarms
- (void)presentReminderPopover:(id)sender {
    //TODO: VIEW - ADD PICKER VIEW FOR REMINDERS.
    //TODO: VIEW - ADD OPTION TO HAVE MORE THAN 3 Reminders.
    //TODO: DATA - CHECK FOR INTERVAL TO APPOINTMENT OR TASK. IF EVENT IS MORE THAN 1 MONTH AWAY, REMIND AT 1 WEEK PRIOR, 1 DAY PRIOR AND MORNING OFF. 
    //TODO: FUNCTION: ADDING EVENT TYPE - THE EQUIVALENT OF TAG - FOR EXAMPLE, DOCTOR APPOINTMENT, ANNIVERSARY, TRAIN DEPARTURE, EXAM ETC.
    //TODO: DATA - LINK EVENT TYPE TO REMINDERS AND OTHER FUNCTIONS.
    //TODO: LOCAL NOTIFICATION: PRESENT SUMMARY OF NEXT DAY'S EVENT IN A PUSH NOTIFICATION AT THE END OF THE CURRENT DAY AND THEN AGAIN AT THE MORNING OF THE DAY IN QUESTION. PRESENT THE POSSIBILITY TO EDIT THE DAY PLANNER IN EACH CASE. 
    
    NSLog(@"Reminder_Button Pressed");

    if ([schedulerPopover isPopoverVisible]) {
        [schedulerPopover dismissPopoverAnimated:YES];
    }
    [self.navigationController.navigationBar setHidden:YES];
    if (tableViewController.tableView.frame.origin.y < bottomViewRect.origin.y) {
        [self moveTableViewDown];
        }
    if(!reminderPopover) {
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        //[button1 setTitle:@"Done" forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"red_round.png"] forState:UIControlStateNormal];
        [button1 setTag:1];
        [button1.layer setCornerRadius:10.0];
        [button1 addTarget:self action:@selector(cancelPopover:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(95, 5, 40, 40)];
        //[button2 setTitle:@"Done" forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"blue_round.png"] forState:UIControlStateNormal];
        [button2 setTag:2];
        [button2.layer setCornerRadius:10.0];
        [button2 addTarget:self.parentViewController action:@selector(setAlarm) forControlEvents:UIControlEventTouchUpInside];
        
        CustomTextField *alarm1 = [[CustomTextField alloc] init];
        [alarm1 setFrame:CGRectMake(0, 50, 140, 40)];
        alarm1.tag = 12;
       // [alarm1 setInputView:pickerView];
        [alarm1 setInputAccessoryView:toolBar];
        [alarm1 setPlaceholder:@"Alarm 1"];
        
        CustomTextField *alarm2 = [[CustomTextField alloc] init];
        [alarm2 setFrame:CGRectMake(0, 95, 140, 40)];
        alarm2.tag = 13;
        //[alarm2 setInputView:pickerView];
        [alarm2 setInputAccessoryView:toolBar];
        [alarm2 setPlaceholder:@"Alarm 2"];
        
        CustomTextField *alarm3 = [[CustomTextField alloc] init];
        [alarm3 setFrame:CGRectMake(0, 140, 140, 40)];
        alarm3.tag = 14;
      //  [alarm3 setInputView:pickerView];
        [alarm3 setInputAccessoryView:toolBar];
        [alarm3 setPlaceholder:@"Alarm 3"];
        
        UIViewController *viewCon = [[UIViewController alloc] init];
        viewCon.contentSizeForViewInPopover = CGSizeMake(140, 180);
        [viewCon.view addSubview:button1];
        [viewCon.view addSubview:button2];
        [viewCon.view addSubview:alarm1];
        [viewCon.view addSubview:alarm2];
        [viewCon.view addSubview:alarm3];
        [viewCon.view   setAlpha:0.8];
        [alarm1 becomeFirstResponder];

        [button1 release];
        [button2 release];
        [alarm1 release];
        [alarm2 release];
        [alarm3 release];
        reminderPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        [reminderPopover setDelegate:self];
        [viewCon release];
    } 
    if([reminderPopover isPopoverVisible]) {
        [reminderPopover dismissPopoverAnimated:YES];
        if (self.navigationController.navigationBarHidden ==YES) {
            self.navigationController.navigationBarHidden = NO;
        }
        [reminderPopover setDelegate:nil];
        [reminderPopover autorelease];
        reminderPopover = nil;
    } else {
        [reminderPopover presentPopoverFromRect:CGRectMake(70, 205, 50, 57)
                                    inView:self.view 
                  permittedArrowDirections:UIPopoverArrowDirectionDown
                                  animated:YES name:@"ReminderPopover"];
    }
}
- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Did dismiss");
}
- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Should dismiss");
    return YES;
}

- (UIImage *)flipperImageForDateNavigationItem {
	// returns a 30 x 30 image to display the flipper button in the navigation bar
	CGSize itemSize=CGSizeMake(30.0,30.0);
	UIGraphicsBeginImageContext(itemSize);
	UIImage *backgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"calendar_bkg_on_blue_bkg.png"]];
	CGRect calendarRectangle = CGRectMake(0,0, itemSize.width, itemSize.height);
	[backgroundImage drawInRect:calendarRectangle];
        // draw the element name
	[[UIColor whiteColor] set];
        // draw the date 
    NSDateFormatter *imageDateFormatter = [[NSDateFormatter alloc] init];
    [imageDateFormatter setDateFormat:@"d"];
    UIFont *font = [UIFont boldSystemFontOfSize:8];
	//CGPoint point = CGPointMake(1,1);
    CGSize stringSize = [[imageDateFormatter stringFromDate:[NSDate date]] sizeWithFont:font];
    CGPoint point = CGPointMake((calendarRectangle.size.width-stringSize.width)/2+5,18);    
	[[imageDateFormatter stringFromDate:[NSDate date]] drawAtPoint:point withFont:font];
        // draw the month    
    [imageDateFormatter setDateFormat:@"MMM"];
	font = [UIFont systemFontOfSize:10];
    stringSize = [[imageDateFormatter stringFromDate:[NSDate date]] sizeWithFont:font];
    point = CGPointMake((calendarRectangle.size.width-stringSize.width)/2,10);
    NSLog(@"date is %@",[imageDateFormatter stringFromDate:[NSDate date]]);
	[[imageDateFormatter stringFromDate:[NSDate date]] drawAtPoint:point withFont:font];
	UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return theImage;
    [imageDateFormatter release];
}

- (void)toggleCalendar {
    
    // disable user interaction during the flip
    flipperView.userInteractionEnabled = NO;
	flipIndicatorButton.userInteractionEnabled = NO;

    // setup the animation group
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(myTransitionDidStop:finished:context:)];
	
	// swap the views and transition
    if (frontViewIsVisible==YES) {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:flipperView cache:YES];
        [calendarView removeFromSuperview];
        [self.flipperView addSubview:tableViewController.tableView];

    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:flipperView cache:YES];
        [tableViewController.tableView removeFromSuperview];
        [self.flipperView addSubview:calendarView];
    }
	[UIView commitAnimations];
    
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(myTransitionDidStop:finished:context:)];

	if (frontViewIsVisible==YES) {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:flipIndicatorButton cache:YES];
        [flipIndicatorButton setBackgroundImage:self.flipperImageForDateNavigationItem forState:UIControlStateNormal];

	} 
	else {
        UIImage *image = [UIImage imageNamed:@"list_white_on_blue_bkg.png"];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:flipIndicatorButton cache:YES];
		[flipIndicatorButton setBackgroundImage:image forState:UIControlStateNormal];

	}
	[UIView commitAnimations];
    frontViewIsVisible=!frontViewIsVisible;
    /*
	// If calendar is off the screen, show it, else hide it (both with animations)
	//if (calendarView.frame.origin.y == -calendarView.frame.size.height+calendarShadowOffset) {
	if (calendarView.frame.origin.y == screenRect.size.height) {
        NSLog(@"Showing Calendar: %.1f = %.1f", calendarView.frame.origin.y, screenRect.size.height);
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		calendarView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.origin.y+navBarHeight, calendarView.frame.size.width, calendarView.frame.size.height);
		[UIView commitAnimations];
	} else {
        NSLog(@"Hiding Calendar: %.1f = %.1f", calendarView.frame.origin.y, screenRect.size.height);
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		//calendarView.frame = CGRectMake(0, -calendarView.frame.size.height+calendarShadowOffset, calendarView.frame.size.width, calendarView.frame.size.height);	
        calendarView.frame = CGRectMake(0, screenRect.size.height, calendarView.frame.size.width, calendarView.frame.size.height);
		[UIView commitAnimations];
	}	
     */
}

- (void)myTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	// re-enable user interaction when the flip is completed.
	flipIndicatorButton.userInteractionEnabled = YES;
    flipperView.userInteractionEnabled = YES;
}

#pragma mark -
#pragma mark TKCalendarMonthViewDelegate methods

- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)d {
	NSLog(@"calendarMonthView didSelectDate");
}

- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthDidChange:(NSDate *)d {
	NSLog(@"calendarMonthView monthDidChange");	
}

#pragma mark -
#pragma mark TKCalendarMonthViewDataSource methods

- (NSArray*)calendarMonthView:(TKCalendarMonthView *)monthView marksFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate {	
	NSLog(@"calendarMonthView marksFromDate toDate");	
	NSLog(@"Make sure to update 'data' variable to pull from CoreData, website, User Defaults, or some other source.");
	// When testing initially you will have to update the dates in this array so they are visible at the
	// time frame you are testing the code.
	NSArray *data = [NSArray arrayWithObjects:
					 @"2011-09-01 00:00:00 +0000", @"2011-09-09 00:00:00 +0000", @"2011-09-22 00:00:00 +0000",
					 @"2011-09-10 00:00:00 +0000", @"2011-09-11 00:00:00 +0000", @"2011-09-12 00:00:00 +0000",
					 @"2011-09-15 00:00:00 +0000", @"2011-09-28 00:00:00 +0000", @"2011-09-04 00:00:00 +0000",					 
					 @"2011-09-16 00:00:00 +0000", @"2011-09-18 00:00:00 +0000", @"2011-09-19 00:00:00 +0000",					 
					 @"2011-09-23 00:00:00 +0000", @"2011-09-24 00:00:00 +0000", @"2011-09-25 00:00:00 +0000",					 					 
					 @"2011-10-01 00:00:00 +0000", @"2011-08-01 00:00:00 +0000", @"2011-04-01 00:00:00 +0000",
					 @"2011-05-01 00:00:00 +0000", @"2011-08-01 00:00:00 +0000", @"2011-07-01 00:00:00 +0000",
					 @"2011-08-01 00:00:00 +0000", @"2011-09-01 00:00:00 +0000", @"2011-10-01 00:00:00 +0000",
					 @"2011-11-01 00:00:00 +0000", @"2011-12-01 00:00:00 +0000", nil]; 
	
	
	// Initialise empty marks array, this will be populated with TRUE/FALSE in order for each day a marker should be placed on.
	NSMutableArray *marks = [NSMutableArray array];
	
	// Initialise calendar to current type and set the timezone to never have daylight saving
	NSCalendar *cal = [NSCalendar currentCalendar];
	[cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	// Construct DateComponents based on startDate so the iterating date can be created.
	// Its massively important to do this assigning via the NSCalendar and NSDateComponents because of daylight saving has been removed 
	// with the timezone that was set above. If you just used "startDate" directly (ie, NSDate *date = startDate;) as the first 
	// iterating date then times would go up and down based on daylight savings.
	NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | 
											  NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) 
									fromDate:startDate];
	NSDate *d = [cal dateFromComponents:comp];
	
	// Init offset components to increment days in the loop by one each time
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
	[offsetComponents setDay:1];	
	
	
	// for each date between start date and end date check if they exist in the data array
	while (YES) {
		// Is the date beyond the last date? If so, exit the loop.
		// NSOrderedDescending = the left value is greater than the right
		if ([d compare:lastDate] == NSOrderedDescending) {
			break;
		}
		
		// If the date is in the data array, add it to the marks array, else don't
		if ([data containsObject:[d description]]) {
			[marks addObject:[NSNumber numberWithBool:YES]];
		} else {
			[marks addObject:[NSNumber numberWithBool:NO]];
		}
		
		// Increment day using offset components (ie, 1 day in this instance)
		d = [cal dateByAddingComponents:offsetComponents toDate:d options:0];
	}
	
	[offsetComponents release];
	
	return [NSArray arrayWithArray:marks];
}

- (void)addItem:(id)sender {
	NSLog(@"Bookmarks Button Pressed");
    
    if(!schedulerPopover) {
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 54, 54)];
        [button1 setImage:[UIImage imageNamed:@"task_button.png"] forState:UIControlStateNormal];
        [button1 setTag:1];
        [button1 addTarget:self action:@selector(addNewTask) forControlEvents:UIControlEventTouchUpInside];
        UILabel *appLabel = [[UILabel alloc] initWithFrame:CGRectMake(button1.frame.origin.x-10, button1.frame.size.height+5, button1.frame.size.width+20, 30)];
        [appLabel setBackgroundColor:[UIColor clearColor]];
        [appLabel setTextAlignment:UITextAlignmentCenter];
        [appLabel setTextColor:[UIColor whiteColor]];
        [appLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [appLabel setText:@"Task"];
        
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(button1.frame.size.width+30, 5, 54, 54)];
        [button2 setImage:[UIImage imageNamed:@"appointment_button.png.png"] forState:UIControlStateNormal];
        [button2 setTag:2];
        [button2 addTarget:self action:@selector(addNewAppointment) forControlEvents:UIControlEventTouchUpInside];
        UILabel *taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(button2.frame.origin.x-10, button2.frame.size.height+5, button2.frame.size.width+20, 30)];
        [taskLabel setBackgroundColor:[UIColor clearColor]];
        [taskLabel setTextAlignment:UITextAlignmentCenter];
        [taskLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [taskLabel setTextColor:[UIColor whiteColor]];
        [taskLabel setText:@"Appointment"];
        
        UIViewController *viewCon = [[UIViewController alloc] init];
        viewCon.contentSizeForViewInPopover = CGSizeMake(150, button1.frame.size.height+appLabel.frame.size.height);
        [viewCon.view addSubview:button1];
        [viewCon.view addSubview:button2];
        [viewCon.view addSubview:appLabel];
        [viewCon.view addSubview:taskLabel];
        
        [button1 release];
        [button2 release];
        [appLabel release];
        [taskLabel release];
        schedulerPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        [schedulerPopover setDelegate:self];
        [viewCon release];
    } 
    
    if([schedulerPopover isPopoverVisible]) {
        [schedulerPopover dismissPopoverAnimated:YES];
        [schedulerPopover setDelegate:nil];
        [schedulerPopover autorelease];
        schedulerPopover = nil;
    } else {
        
        [schedulerPopover presentPopoverFromRect:CGRectMake(20, 0, 50, 40) inView:self.view permittedArrowDirections: UIPopoverArrowDirectionUp animated:YES name:@"Planner"];
    }
}
- (void) addNewAppointment{
    self.title = @"New Appointment";
    MyDataObject *myData = [self myDataObject];
    myData.noteType = [NSNumber numberWithInt:1];
    addingContext = [[NSManagedObjectContext alloc] init];
    [addingContext setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
    NSLog(@"After AddingContext: %@",  addingContext);
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Appointment" inManagedObjectContext:addingContext];
    newAppointment = [[Appointment alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];
    [newAppointment setCreationDate:[NSDate date]];
    [newAppointment setType:[NSNumber numberWithInt:1]];
    
    //tableViewController = [[AppointmentsTableViewController alloc]init];
    
    myData.selectedAppointment = newAppointment;
    [self setEditingView];
    [self cancelPopover:nil];

}
- (void) addNewTask{
    self.title = @"New To Do";
    MyDataObject *myData = [self myDataObject];
    myData.noteType = [NSNumber numberWithInt:2];
    addingContext = [[NSManagedObjectContext alloc] init];
    [addingContext setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
    NSLog(@"After AddingContext: %@",  addingContext);

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:addingContext];
    newTask = [[Task alloc] initWithEntity:entity insertIntoManagedObjectContext:addingContext];
    [newTask setCreationDate:[NSDate date]];
    [newTask setType:[NSNumber numberWithInt:2]];
    
    
    [self setEditingView];
    [self cancelPopover:nil];
}

- (void) setEditingView {//Called only when on calendar/tv view
    MyDataObject *myData = [self myDataObject];
    if (textView !=nil) {
        [textView removeFromSuperview];
        [textView release];
        textView = nil;
    }
        NSLog(@"textView is nil. Adding textView");
        //TEXTVIEW: setup and add to self.view
        textView = [[CustomTextView alloc] initWithFrame:CGRectMake(screenRect.size.width, textViewRect.origin.y, textViewRect.size.width, textViewRect.size.height)];
        textView.delegate = self;    
        textView.inputAccessoryView = toolBar;
        [self.view addSubview:textView];
        [textView setText:myData.myText];
        [textView setUserInteractionEnabled:YES];
        [textView becomeFirstResponder];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAddingOrEditing)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    self.navigationItem.leftBarButtonItem.tag = 10;
    [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];  
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem  = rightButton;
    [rightButton release];
    self.navigationItem.rightBarButtonItem.tag = 1;
    [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain]; 
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
   // textView.frame = textViewRect;
   // tableViewController.tableView.frame = bottomViewRect;
    
    [UIView commitAnimations];
}
- (void) displaySelectedRow:(NSNotification *) notification {
    /*NOTE: USING NOTIFICATIONS WORKS JUST AS WELL.
    if ([[notification object] isKindOfClass:[Appointment class]]) {
        NSLog(@"THE SELECTED NOTIFICATION OBJECT IS AN APPOINTMENT");} */
    MyDataObject *myData = [self myDataObject];
    if (textView == nil){//TEXTVIEW: setup and add to self.view
        textView = [[CustomTextView alloc] initWithFrame:CGRectMake(textViewRect.origin.x, textViewRect.origin.y, textViewRect.size.width, textViewRect.size.height)];
        [self.view addSubview:textView];
        }
        [textView setUserInteractionEnabled:NO];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        textView.frame = textViewRect;
        //tableViewController.tableView.frame = bottomViewRect;
        CGRect frame = self.flipperView.frame;
        frame.origin.y = textViewRect.origin.y + textViewRect.size.height+5;
        self.flipperView.frame = frame;
    
    
    if (myData.selectedAppointment != nil && myData.selectedMemo == nil && myData.selectedTask == nil) {
        self.navigationItem.title = @"Appointment";//FIXME: change this to show the title of the appointment
        //get the appointment details passed in via the delegate data object
        NSString *selectedDate = [dateFormatter stringFromDate:myData.selectedAppointment.doDate];
        NSString *selectedStart = [timeFormatter stringFromDate:myData.selectedAppointment.doTime];
        NSString *selectedEnd = [timeFormatter stringFromDate:myData.selectedAppointment.endTime];
        NSMutableString *text = [NSMutableString stringWithFormat:@"Scheduled Date: %@\nStarts At: %@. Ends At: %@\n\n%@",selectedDate, selectedStart, selectedEnd, myData.selectedAppointment.text];
        textView.text = text;      
        }else if (myData.selectedAppointment == nil && myData.selectedMemo == nil && myData.selectedTask != nil) {
        self.navigationItem.title = @"To Do";//FIXME: change this to show the title of the todo
        //get the todo details passed in via the delegate data object
        NSString *selectedDate = [dateFormatter stringFromDate:myData.selectedTask.doDate];
        NSMutableString *text = [NSMutableString stringWithFormat:@"Scheduled Date: %@\n\n%@",selectedDate, myData.selectedAppointment.text];
        textView.text = text;      
        }

    
        UIImage *menuButtonImage = [UIImage imageNamed:@"edit_light.png"];
        UIImage *menuButtonImageHighlighted = [UIImage imageNamed:@"edit.png"];
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setImage:menuButtonImage forState:UIControlStateNormal];
        [menuButton setImage:menuButtonImageHighlighted forState:UIControlStateHighlighted];	
        menuButton.frame = CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height);
        UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        [menuButton addTarget:self action:@selector(editSelectedRow) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = menuBarButton;
        [menuBarButton release];

    NSLog(@"In displaySelectedRow Method");
    
    return;
}

- (void) editSelectedRow{
    NSLog(@"In editSelectRow.");
    MyDataObject *myData = [self myDataObject];
    textView.delegate = self;
    [textView setInputAccessoryView:toolBar];
    [myData.selectedAppointment setIsEditing:[NSNumber numberWithInt:1]]; //TODO:Set this back to 0 somewhere.
    if (myData.selectedAppointment != nil && myData.selectedMemo == nil && myData.selectedTask == nil) {
       // leftField.text = [dateFormatter stringFromDate:myData.selectedAppointment.doDate];
        //rightField_1.text = [timeFormatter stringFromDate:myData.selectedAppointment.doTime];
        //rightField_2.text = [timeFormatter stringFromDate:myData.selectedAppointment.endTime];        

        textView.text = myData.selectedAppointment.text;       
        [textView setUserInteractionEnabled:YES];
        [textView becomeFirstResponder];

        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
        self.navigationItem.rightBarButtonItem  = rightButton;
        [rightButton release];
        self.navigationItem.rightBarButtonItem.tag = 1;
    }
    [tableViewController.tableView setAllowsSelection:NO];
}

#pragma mark -
#pragma mark Text View Delegate Methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    if (self.textView.inputAccessoryView == nil) {
        [self.textView setInputAccessoryView:toolBar];
    }
    [self.textView setInputAccessoryView:toolBar];
    return YES;    
}  

#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"CalendarViewController: Keyboard will show notification received.");
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]; // Get the origin of the keyboard when it's displayed.
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
        CGFloat keyboardTop = keyboardRect.origin.y;
        CGRect flipperFrame = flipperView.frame;
    if (flipperFrame.origin.y < keyboardTop){
        NSLog(@"Trying to move the flipperView");
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    //[self.navigationController.navigationBar setHidden:YES];
        textView.frame = textViewRect;
        flipperFrame.origin.y  = keyboardTop;
        flipperView.frame = flipperFrame;
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    CGRect textViewFrame = textView.frame;
    CGRect flipperFrame = flipperView.frame;
    
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    if (textView.superview != nil) {
        //resize textView to allow more of the calendar to display
        textViewFrame.size.height -= 75;
        flipperFrame.origin.y = textViewFrame.origin.y + textViewFrame.size.height+3;
        }
    else {
        flipperFrame.origin.y = mainFrame.origin.y;
    }
    textView.frame = textViewFrame;
    flipperView.frame = flipperFrame;
    
    [textView setAlpha:1.0];
    [UIView commitAnimations];
    if (schedulerPopover.view.superview == nil){
        [self.navigationController.navigationBar setHidden:NO];
    }
    //set condition - if table is up then move table down.
    //[self moveTableViewDown];
}

#pragma mark -
#pragma mark - EVENTS & ACTIONS

- (void) dismissKeyboard{
    [self.view endEditing:YES];
    [schedulerPopover dismissPopoverAnimated:YES];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void) moveTableViewUp{
    /*
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tableViewMovedUpNotification" object:nil];
    [tableViewController.tableView removeFromSuperview];
    //if (tableViewController.tableView.superview == nil){
      //  [self.view addSubview:tableViewController.tableView];
    //}
    //UIView *topRight = [[UIView alloc] initWithFrame:CGRectMake(160, 5, 156, 189)];
    //[topRight setBackgroundColor:[UIColor blackColor]];
    //[topRight.layer setCornerRadius:5.0];
    //[self.view addSubview:topRight];
    //[tableViewController.tableView removeFromSuperview];
    //[topRight addSubview:tableViewController.tableView];
    
    //tableViewController.tableView.frame = CGRectZero;
    //CGRect frame = bottomViewRect;
    //frame.origin.x = 160.0;
    //frame.size.width = 155.0;
    //tableViewController.tableView.frame = self.view.frame; 
    
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.5];
    //[UIView setAnimationDelegate:self];

    //[self.navigationController.navigationBar setHidden:YES];
    [tableViewController.tableView setFrame:CGRectMake(160, 3, 155, 189)];

    //[tableViewController.tableView setRowHeight:25.0];
    //[tableViewController.tableView.layer setCornerRadius:5.0];
    //[tableViewController.tableView setBackgroundColor:[UIColor whiteColor]];
    //[tableViewController.tableView setAlpha:1];
    //[UIView commitAnimations];
     */
    return;
}

- (void) moveTableViewDown{
    /*
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tableViewMovedDownNotification" object:nil];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    //tableViewController.tableView.frame = bottomViewRect; 
    //[tableViewController.tableView setRowHeight:40.0];
    [tableViewController.tableView.layer setCornerRadius:0.0];
    [tableViewController.tableView setBackgroundColor:[UIColor whiteColor]];
    [tableViewController.tableView reloadData];
    [tableViewController.tableView setAlpha:1.0];

    [UIView commitAnimations];
     */
    return;
}
/*
- (UIImage *)flipperImageForAtomicElementNavigationItem {
*/


- (void) doneAction{

    
    MyDataObject *myData = [self myDataObject];

    UIImage *menuButtonImage = [UIImage imageNamed:@"edit_light.png"];
    UIImage *menuButtonImageHighlighted = [UIImage imageNamed:@"edit.png"];
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:menuButtonImage forState:UIControlStateNormal];
    [menuButton setImage:menuButtonImageHighlighted forState:UIControlStateHighlighted];	
    menuButton.frame = CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height);
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [menuButton addTarget:self action:@selector(editSelectedRow) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = menuBarButton;
    [menuBarButton release];
    
    if ([myData.noteType intValue]==1) {
        newAppointment.text = textView.text;
        NSString *selectedDate = [dateFormatter stringFromDate:newAppointment.doDate];
        NSString *selectedStart = [timeFormatter stringFromDate:newAppointment.doTime];
        NSString *selectedEnd = [timeFormatter stringFromDate:newAppointment.endTime];
        NSMutableString *text = [NSMutableString stringWithFormat:@"Scheduled Date: %@\nStarts At: %@. Ends At: %@\n\n%@",selectedDate, selectedStart, selectedEnd, newAppointment.text];
        textView.text = text;        
        if (newAppointment.doDate == nil || newAppointment.text == @""){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Appointment Date or Text" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
    } else if ([myData.noteType intValue] == 2){
        newTask.text = textView.text;
        if (newTask.doDate == nil || newTask.text == @""){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Appointment Date or Text" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
    }
    /*--Save the MOC--*/
    NSError *error;
    if(![addingContext save:&error]){ 
        NSLog(@"Calendar/Appointments VIEWCONTROLLER MOC: DID NOT SAVE");
        } 
  
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    [textView setFrame:textViewRect];
    [UIView commitAnimations];

    [textView setUserInteractionEnabled:NO];

    myData.selectedAppointment = nil;
    myData.selectedTask = nil;
    myData.isEditing = [NSNumber numberWithInt:0];
}

- (void) setAlarm {
    return;
}

-(void)cancelAddingOrEditing{
    MyDataObject *myData = [self myDataObject];
    myData.noteType = [NSNumber numberWithInt:0];
    self.title = @"Calender";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    if (textView.superview !=nil) {
        [textView removeFromSuperview];
        [textView release];
        textView = nil;
    }   
    if (tableViewController == nil){
        tableViewController = [[AppointmentsTableViewController alloc] init];
    }
    if (tableViewController.tableView.superview == nil){
        [self.view addSubview:tableViewController.tableView];
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    tableViewController.tableView.frame = mainFrame;
    
    //right button - add new item - persists as long as cal/tv is full screen
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleBordered target:self action:@selector(addItem:)];
    self.navigationItem.leftBarButtonItem  = leftButton;
    [leftButton release];
    self.navigationItem.leftBarButtonItem.tag = 1;
    [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];  
    
    [UIView commitAnimations];
    
}

@end

///NOTE: the following snippet will replace all the text in the textview
/*[textView selectAll:self];
 NSRange mySelectedRange = textView.selectedRange; */

/* 
 
 //ADD Date/Time etc to textView USING replaceCharactersInRange
 //NSMutableString *text = [NSMutableString stringWithString:textView.text];       
 //NSRange mySelectedRange = NSMakeRange(0, 0);
 //[text replaceCharactersInRange:mySelectedRange withString:[NSString stringWithFormat:@"%@",dateString]];
 //textView.text = text;

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
 
 toolBar.frame = CGRectMake(320, toolBar.frame.origin.y, toolBar.frame.size.width, toolBar.frame.size.height);    
 
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
 [toolBar removeFromSuperview];
 NSLog(@"Removed toolBar with removeDatePicker method");
 }
 }    
 
 - (void) removeTimePicker {
 if (timePicker.superview != nil) {
 [timePicker removeFromSuperview];
 NSLog(@"timePicker removed from Superview");
 
 }
 if (datePicker.superview == nil && pickerView.superview == nil) {
 [toolBar removeFromSuperview];
 NSLog(@"Removed toolBar with removeTimePicker method");
 
 }
 
 }  
 - (void) removePickerView {
 if (pickerView.superview != nil) {
 [pickerView removeFromSuperview];
 }
 if (timePicker.superview == nil && datePicker.superview == nil) {
 [toolBar removeFromSuperview];
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
    if (toolBar.superview == nil){
        NSLog(@"ADDING TOOLBAR FROM addPickerResizeViews method");    
        [bottomView addSubview:toolBar];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];    
        [UIView setAnimationDelegate:self];
        
        
        //TOOLBAR: move into place
        CGRect endFrame = CGRectMake(0.0, 0.0, 320, 40);            
        toolBar.frame = endFrame;
        
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

