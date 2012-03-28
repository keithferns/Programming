//
//  CalendarViewController.m
//  iDoit
//
//  Created by Keith Fernandes on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarViewController.h"
#import "ScheduleView.h"
#import "UINavigationController+NavControllerCategory.h"
#import "Contants.h"
#import "iDoitAppDelegate.h"

@implementation CalendarViewController

    
@synthesize actionsPopover;
@synthesize isScheduling;
@synthesize theItem;
@synthesize topView, bottomView;
@synthesize scheduleView;
@synthesize toolbar;
@synthesize segmentedControl;
@synthesize flipIndicatorButton;
@synthesize frontViewIsVisible;
@synthesize calendarView, flipperImageForDateNavigationItem, flipperView, listImageForFlipperView;
@synthesize managedObjectContext;
@synthesize tableViewController;

- (void) dealloc{
    [super dealloc];
    [actionsPopover dealloc];
    [theItem release];
    [toolbar release];
    [topView release];
    [bottomView release];
    [scheduleView release];
    [flipIndicatorButton release];
    [calendarView release];
    [flipperView release];
    [flipperImageForDateNavigationItem release];
    [listImageForFlipperView release];
    [flipIndicatorButton release];
    [tableViewController release];
    NSLog(@"CalendarViewController:dealloc -> deallocing");
}

- (void)viewDidUnload{
    [super viewDidUnload];

    actionsPopover = nil;
    theItem = nil;
    toolbar = nil;
    topView     = nil;
    bottomView = nil;
    scheduleView = nil;
    flipIndicatorButton = nil;
    flipperView = nil;
    calendarView = nil;
    flipperImageForDateNavigationItem = nil;
    listImageForFlipperView = nil;
    segmentedControl = nil;
    tableViewController = nil;
    NSLog(@"CalendarViewController:viewDidUnload -> Unloading");
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Warning Received from CalendarViewController");
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    NSLog(@"CalendaViewController:viewDidLoad - loading View");
    
    [super viewDidLoad];
        
    frontViewIsVisible = YES;

    //Navigation Bar SetUP
 
    
    //Init and add the top and bottom Views. These views will be used to animate the transitions the table and calendar Views. 
    if (bottomView.superview == nil && bottomView == nil) {
        bottomView = [[UIView alloc] initWithFrame:kBottomViewRect];
        bottomView.backgroundColor = [UIColor blackColor];
    }
    if (topView.superview == nil && topView == nil) {
        topView = [[UIView alloc] initWithFrame:kTopViewRect];
        topView.backgroundColor = [UIColor blackColor];
    }    
    //View Heirarchy: topView - bottomview
    [self.view addSubview:bottomView];
    [self.view addSubview:topView];
    
    //Initialize the toolbar. disable 'save' and 'send' buttons.
    if (toolbar == nil) {
        
    toolbar = [[CustomToolBar alloc] init];
    [toolbar.firstButton setTarget:self];
    [toolbar.secondButton setTarget:self];
    [toolbar.thirdButton setTarget:self];
    [toolbar.fourthButton setTarget:self];
    [toolbar.fifthButton setTarget:self];
    }
        
    tableViewController = [[CalendarTableViewController alloc]init ];
    
    tableViewController.tableView.frame = CGRectMake(0,kNavBarHeight,kScreenWidth, kScreenHeight-kNavBarHeight);
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    searchBar.tintColor = [UIColor blackColor];
    
    tableViewController.tableView.tableHeaderView = searchBar;
    [searchBar release];
        
    
    if (!isScheduling){
        
        /*-- Point current instance of the MOC to the main managedObjectContext --*/
        if (managedObjectContext == nil) { 
            managedObjectContext = [(iDoitAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
            NSLog(@"CURRENT VIEWCONTROLLER: After managedObjectContext: %@",  managedObjectContext);
        }    
        
        /*-ADD FLIPPER VIEW -*/
        flipperView = [[UIView alloc] initWithFrame:mainFrame];
        [flipperView setBackgroundColor:[UIColor blackColor]];
        [self.view   addSubview:flipperView];
        
        if (calendarView.superview==nil) {
            calendarView = 	[[TKCalendarMonthView alloc] init];        
            calendarView.delegate = self;
            calendarView.dataSource = self;            
    
            calendarView.frame = CGRectMake(0, -calendarView.frame.size.height, calendarView.frame.size.width, calendarView.frame.size.height);
            // Ensure this is the last "addSubview" because the calendar must be the top most view layer	
            [self.flipperView addSubview:calendarView];
            [calendarView reload];
            
            //[self.flipperView addSubview:tableViewController.tableView];
            tableViewController.tableView.frame = CGRectMake(0, 0, flipperView.frame.size.width, flipperView.frame.size.height);
            [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
            [tableViewController.tableView setSectionHeaderHeight:13];
            tableViewController.tableView.rowHeight = 58.0;
            //[tableViewController.tableView setTableHeaderView:tableLabel]
        }
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        
        calendarView.frame = CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height);
        
        UIImage *image = self.listImageForFlipperView;
        CGSize theSize = image.size;
        
        UIButton *tempButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, theSize.width, theSize.height)];    
        
        self.flipIndicatorButton=tempButton;
        [flipIndicatorButton setBackgroundImage:image forState:UIControlStateNormal];
        flipIndicatorButton.layer.cornerRadius = 4.0;
        flipIndicatorButton.layer.borderWidth = 1.0;
        [tempButton release];
                    
        UIBarButtonItem *flipButtonBarItem=[[UIBarButtonItem alloc] initWithCustomView:flipIndicatorButton];	
        
        [self.navigationItem setRightBarButtonItem:flipButtonBarItem animated:YES];
        [flipButtonBarItem release];
        [flipIndicatorButton addTarget:self action:@selector(toggleCalendar:) forControlEvents:(UIControlEventTouchDown)];
        [UIView commitAnimations];
        
        frontViewIsVisible = YES;
        
        NSArray *items = [NSArray arrayWithObjects:@"Month", @"Week",@"Day", nil];
        segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        [segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [segmentedControl setWidth:60 forSegmentAtIndex:0];
        [segmentedControl setWidth:60 forSegmentAtIndex:1];
        [segmentedControl setWidth:60 forSegmentAtIndex:2];
        [segmentedControl setSelectedSegmentIndex:0];
        
        self.navigationItem.titleView = segmentedControl;
        [segmentedControl release];
        
        UIBarButtonItem *leftNavButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentActionsPopover:)];
        leftNavButton.tag = 1;
        self.navigationItem.leftBarButtonItem = leftNavButton;
        [leftNavButton release];
        /*
        UIBarButtonItem *rightNavButton = [self.navigationController addListButton];
        //UIBarButtonItem *rightNavButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(presentActionsPopover:)];
        rightNavButton.tag = 2;
        self.navigationItem.rightBarButtonItem = rightNavButton;    
        [rightNavButton release];
         */
    }
}

- (void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *firstItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentActionsPopover:)];
    //firstItem.title = @"Do Something";
    [firstItem setTag:1];
    
    
    UIBarButtonItem *secondItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(presentActionsPopover:)];
    
    [secondItem setTag:2];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIToolbar *bottomBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight-kTabBarHeight, kScreenWidth, kTabBarHeight)];
    [bottomBar setItems:[NSArray arrayWithObjects:flexSpace, firstItem,flexSpace,secondItem,flexSpace, nil]];
    bottomBar.tintColor = [UIColor clearColor];
    [firstItem release];
    [secondItem release];
    [flexSpace release];
    [self.view addSubview:bottomBar];
    [bottomBar release];
    
    if (isScheduling){
        [self flipScheduleView:nil];
    }
    
    
    if (!tableViewController){
        tableViewController = [[CalendarTableViewController alloc]init ];
        
        tableViewController.tableView.frame = CGRectMake(0,kNavBarHeight,kScreenWidth, kScreenHeight-kNavBarHeight);
    }
    
}
-(void) viewWillDisappear:(BOOL)animated{
    
    //KJF: 3/12. Why was  tableViewController set to nil here??? 
    tableViewController = nil;   
    
    //Check for visisble instance of actionsPopover. if yes dismiss.
    if([actionsPopover isPopoverVisible]) {
        [actionsPopover dismissPopoverAnimated:YES];
        [actionsPopover setDelegate:nil];
        [actionsPopover autorelease];
        actionsPopover = nil;
    }
}


- (void) toggleAppointmentTaskLists: (id) sender{
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    
    
    if (segControl.selectedSegmentIndex == 0) {
        NSNumber *num = [NSNumber numberWithInt:1];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetEventTypeNotification" object:num userInfo:nil]; 
    }else if (segControl.selectedSegmentIndex == 1){
        
        NSNumber *num = [NSNumber numberWithInt:2];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetEventTypeNotification" object:num userInfo:nil]; 
    }
    
    
}


- (UIImage *)flipperImageForDateNavigationItem {
	// returns a 30 x 30 image to display the flipper button in the navigation bar
	CGSize itemSize=CGSizeMake(30.0,30.0);
	UIGraphicsBeginImageContext(itemSize);
	UIImage *backgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"calendar_date_background.png"]];
	CGRect calendarRectangle = CGRectMake(0,0, itemSize.width, itemSize.height);
	[backgroundImage drawInRect:calendarRectangle];
    // draw the element name
	[[UIColor whiteColor] set];
    // draw the date 
    NSDateFormatter *imageDateFormatter = [[NSDateFormatter alloc] init];
    [imageDateFormatter setDateFormat:@"d"];
    UIFont *font = [UIFont boldSystemFontOfSize:7];
	//CGPoint point = CGPointMake(1,1);
    CGSize stringSize = [[imageDateFormatter stringFromDate:[NSDate date]] sizeWithFont:font];
    CGPoint point = CGPointMake((calendarRectangle.size.width-stringSize.width)/2+5,16);    
	[[imageDateFormatter stringFromDate:[NSDate date]] drawAtPoint:point withFont:font];
    // draw the month    
    [imageDateFormatter setDateFormat:@"MMM"];
	font = [UIFont boldSystemFontOfSize:8];
    stringSize = [[imageDateFormatter stringFromDate:[NSDate date]] sizeWithFont:font];
    point = CGPointMake((calendarRectangle.size.width-stringSize.width)/2,9);
    NSLog(@"date is %@",[imageDateFormatter stringFromDate:[NSDate date]]);
	[[imageDateFormatter stringFromDate:[NSDate date]] drawAtPoint:point withFont:font];
    [imageDateFormatter release];
	UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return theImage;
}

- (UIImage *) listImageForFlipperView {
    CGSize itemSize=CGSizeMake(30.0,30.0);
	UIGraphicsBeginImageContext(itemSize);
	UIImage *backgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"list_nav.png"]];
	CGRect buttonRectange = CGRectMake(2,4, backgroundImage.size.width, backgroundImage.size.height);
	[backgroundImage drawInRect:buttonRectange];
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();
	return theImage;
    
}
- (void)toggleCalendar:(id) sender {
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
        self. tableViewController.tableView.frame = CGRectMake(0, 0, flipperView.frame.size.width, flipperView.frame.size.height);
        [self.flipperView addSubview:tableViewController.tableView];

        self.navigationItem.titleView = nil;
        NSArray *items = [NSArray arrayWithObjects:@"Appointments", @"Tasks", nil];
        segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        [segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [segmentedControl setWidth:90 forSegmentAtIndex:0];
        [segmentedControl setWidth:90 forSegmentAtIndex:1];
        [segmentedControl setSelectedSegmentIndex:0];
        [segmentedControl addTarget:self
                             action:@selector(toggleAppointmentTaskLists:)
                   forControlEvents:UIControlEventValueChanged];
        
        self.navigationItem.titleView = segmentedControl;
        [segmentedControl release];
        
    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:flipperView cache:YES];
        [tableViewController.tableView removeFromSuperview];
        [self.flipperView addSubview:calendarView];        
        
        self.navigationItem.titleView = nil;
        NSArray *items = [NSArray arrayWithObjects:@"Month", @"Week",@"Day", nil];
        segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        [segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [segmentedControl setWidth:60 forSegmentAtIndex:0];
        [segmentedControl setWidth:60 forSegmentAtIndex:1];
        [segmentedControl setWidth:60 forSegmentAtIndex:2];
        [segmentedControl setSelectedSegmentIndex:0];
        
        self.navigationItem.titleView = segmentedControl;
        [segmentedControl release];
       
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

		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:flipIndicatorButton cache:YES];
		[flipIndicatorButton setBackgroundImage:self.listImageForFlipperView forState:UIControlStateNormal];
	}
	[UIView commitAnimations];
    frontViewIsVisible=!frontViewIsVisible;
    
}

- (void)myTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	// re-enable user interaction when the flip is completed.
	flipIndicatorButton.userInteractionEnabled = YES;
    flipperView.userInteractionEnabled = YES;
}


- (void) flipScheduleView:(id) sender{
    if (self.scheduleView == nil){
        [self.navigationItem.leftBarButtonItem setTitle:@"Cancel"];
        [self.navigationController.navigationItem.leftBarButtonItem setTitle:@"Cancel"];
        NSLog(@"CalendarViewController: flipping Schedule Views");

        //Initialize the scheduleView. 
        //scheduleView = [[ScheduleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, topView.frame.size.height)]; 
        scheduleView = [[ScheduleView alloc] init];
        scheduleView.dateField.delegate = self;
        scheduleView.startTimeField.delegate = self;
        scheduleView.endTimeField.delegate = self;
        scheduleView.recurringField.delegate = self;
        scheduleView.locationField.delegate = self;
        
        scheduleView.dateField.inputAccessoryView = self.toolbar;
        scheduleView.startTimeField.inputAccessoryView = self.toolbar;
        scheduleView.endTimeField.inputAccessoryView = self.toolbar;
        scheduleView.recurringField.inputAccessoryView = self.toolbar;
        scheduleView.locationField.inputAccessoryView = self.toolbar;
    }
    // disable user interaction during the flip
    topView.userInteractionEnabled = NO;
	//flipIndicatorButton.userInteractionEnabled = NO;
    
 
    
    [UIView commitAnimations];
    
    [self.topView addSubview:scheduleView];

    // setup the animation group
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedFlippingScheduleView)];
	
	// swap the views and transition
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:topView cache:YES];
        
    self.scheduleView.frame = CGRectMake(0, 0, kScreenWidth, topView.frame.size.height);
        
    //self.navigationItem.leftBarButtonItem setAction:@selector(clearEvent:)
    //FIXME: add the clearEvent: method to delete any to do or appointment
        
    //Add Done Button to the Nav Bar. Set it to call method to save input and to return to editing
        self.navigationItem.leftBarButtonItem = [self.navigationController addCancelButton];
        self.navigationItem.leftBarButtonItem.target = self;
        self.navigationItem.leftBarButtonItem.action = @selector(cancelScheduling);
    
        self.navigationItem.rightBarButtonItem =[self.navigationController addDoneButton];
        [self.navigationItem.rightBarButtonItem setTarget:self];
        //FIXME:
        [self.navigationItem.rightBarButtonItem setAction:@selector(saveSchedule:)];
        
        [toolbar changeToSchedulingButtons];
        toolbar.fourthButton.enabled = YES;
            
        [UIView commitAnimations];
        [scheduleView.dateField becomeFirstResponder];

    /*
     [UIView beginAnimations:nil context:nil];
     [UIView setAnimationDuration:0.75];
     [UIView setAnimationDelegate:self];
     [UIView setAnimationDidStopSelector:@selector(myTransitionDidStop:finished:context:)];
     
     if (frontViewIsVisible==YES) {
     [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:flipIndicatorButton cache:YES];
     [flipIndicatorButton setBackgroundImage:self.flipperImageForDateNavigationItem forState:UIControlStateNormal];
     } 
     else {
     UIImage *image = [UIImage imageNamed:@"list_white_on_blue_button.png"];
     [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:flipIndicatorButton cache:YES];
     [flipIndicatorButton setBackgroundImage:image forState:UIControlStateNormal];
     
     }
     [UIView commitAnimations];
     frontViewIsVisible=!frontViewIsVisible;
     */
}


- (void) finishedFlippingScheduleView {
    NSLog(@"Method: finishedScheduleTransition -> enabling topView, making TV FR");
    self.topView.userInteractionEnabled = YES;
    
}




- (void) addReminders {
    NSLog(@"Adding Reminders");
    [scheduleView addReminderFields];
    scheduleView.alarm1Field.delegate = self;
    scheduleView.alarm1Field.inputAccessoryView = self.toolbar;
    scheduleView.alarm2Field.delegate = self;
    scheduleView.alarm2Field.inputAccessoryView = self.toolbar;
    scheduleView.alarm3Field.delegate = self;
    scheduleView.alarm3Field.inputAccessoryView = self.toolbar;
    scheduleView.alarm4Field.delegate = self;
    scheduleView.alarm4Field.inputAccessoryView = self.toolbar;
    
    [scheduleView.alarm1Field becomeFirstResponder];
}

- (void) addTags {
    NSLog(@"Adding Tags");
    [scheduleView addTagFields];
    scheduleView.tag1Field.delegate = self;
    scheduleView.tag1Field.inputAccessoryView = self.toolbar;
    scheduleView.tag2Field.delegate = self;
    scheduleView.tag2Field.inputAccessoryView = self.toolbar;
    scheduleView.tag3Field.delegate = self;
    scheduleView.tag3Field.inputAccessoryView = self.toolbar;
    
    [scheduleView.tag1Field becomeFirstResponder];
}

- (void) cancelScheduling{
    
    [self.navigationController popViewControllerAnimated:YES];

}
- (void) saveSchedule:(id)sender {
    
    NSLog(@"CalendarViewController: Saving Schedule");
    
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];    
    [gregorian setLocale:[NSLocale currentLocale]];
    [gregorian setTimeZone:[NSTimeZone localTimeZone]];
    //[gregorian setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDateComponents *timeComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[scheduleView.datePicker date]];    
    [timeComponents setYear:[timeComponents year]];
    [timeComponents setMonth:[timeComponents month]];
    [timeComponents setDay:[timeComponents day]];
    NSDate *selectedDate= [gregorian dateFromComponents:timeComponents];
        
    NSLog(@"the selectedDate is %@", selectedDate);
    
    if (theItem.theToDo == nil && theItem.theAppointment !=nil) {
        //set the Appointment date
        
        [theItem.theAppointment setADate:selectedDate];
        timeComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:[scheduleView.timePicker date]]; 
        [timeComponents setYear:0];
        [timeComponents setMonth:0];
        [timeComponents setDay:0];
        [timeComponents setSecond:0];
        [timeComponents setHour:[timeComponents hour]];
        [timeComponents setMinute:[timeComponents minute]];
        selectedDate = [gregorian dateFromComponents:timeComponents];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        
        [timeFormatter setDateFormat:@"h:mm a"];
        selectedDate = [timeFormatter dateFromString:scheduleView.startTimeField.text];
        
            [theItem.theAppointment setAStartTime:selectedDate];
        selectedDate = [timeFormatter dateFromString:scheduleView.endTimeField.text];
            [theItem.theAppointment setAEndTime:selectedDate];
        
        NSLog(@"this appointment date is %@",theItem.theAppointment.aDate);
        
        [timeFormatter release];
        
    }
    
    else if (theItem.theToDo != nil && theItem.theAppointment == nil){
        
        // set the To Do due date
        
        theItem.theToDo.aDate = selectedDate; 
        NSLog(@"this todo date is %@", theItem.theToDo.aDate);
        //set Recurrence.
        theItem.theToDo.aRecurrence = scheduleView.recurringField.text;
        
        //set Alarms
        //create an alarm in NewItemOrEvent
        //set the selected time value for this alarm here
        //add alarm object to theAppointment
        
    }
    //Programmatically return to parentViewController//
    
    [self.theItem saveNewItem];
    [self.navigationController popViewControllerAnimated:YES];
    
    return;
}

#pragma mark - TextField Delegate and Navigation 


- (void) textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Method: textfieldDidEndEditing -> currently commands");
    //
}

#pragma mark - ToolBar Actions

- (void) moveToPreviousField{
    [scheduleView moveToPreviousField];
}
- (void) moveToNextField{
    [scheduleView moveToNextField];
}


#pragma mark - TKCalendarMonthViewDelegate methods
- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)d {
	NSLog(@"calendarMonthView didSelectDate: %@", d);
    //ADD DATE TO CURRENT EVENT
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetDateNotification" object:d userInfo:nil]; 
}
- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthDidChange:(NSDate *)d {
	NSLog(@"calendarMonthView monthDidChange");	
    
    CGRect frame = topView.frame;
    frame.size.height = calendarView.frame.size.height;
    topView.frame = frame;
    frame = bottomView.frame;
    frame.origin.y = topView.frame.origin.y + topView.frame.size.height;
    bottomView.frame = frame;
}
#pragma mark - TKCalendarMonthViewDataSource methods
//get dates with events
- (NSArray *)fetchDatesForTimedEvents { 
    NSLog(@"Will get array of timed event objects from store");
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init]autorelease]; 
    [request setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext]]; 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"aDate" ascending:YES]; 
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]]; 
    [sortDescriptor release]; 
    
    //NSArray *events = [NSArray arrayWithObjects:@"1",@"2", nil];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"aType == %@" argumentArray:events];
    //[request setPredicate:predicate];
    
    // Release the datesArray, if it already exists 
    NSError *anyError = nil; 
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&anyError]; 
    if( !results ) 
    { NSLog(@"Error = %@", anyError);
        ///deal with error
    } 
    
    NSLog(@"Did get array of timed event objects from store");
    
    //kjf the array data contains Event objects. need to convert this to an array which has date objects 
    NSLog(@"Number of objects in results = %d", [results count]);
    NSMutableArray *data = [[[NSMutableArray alloc]init]autorelease];
    //NSMutableArray *data = [NSMutableArray arrayWithCapacity:[results count]];
    for (int i=0; i<[results count]; i++) {
        NSLog(@"Will get data Array");
        
        if ([[results objectAtIndex:i] isKindOfClass:[Appointment class]]){
            Appointment *tempAppointment = [results objectAtIndex:i];
            [data addObject:tempAppointment.aDate];
            NSLog(@"Appointment date is %@", tempAppointment.aDate);
        } 
        
        else if ([[results objectAtIndex:i] isKindOfClass:[ToDo class]]){
            ToDo *tempToDo = [results objectAtIndex:i];
            [data addObject:tempToDo.aDate];
            NSLog(@"ToDo date is %@", tempToDo.aDate);
        }
        else{
            NSLog(@"Object at index %d is not an Appointment or ToDo", i);
        }
        
    }
    NSLog(@"Number of objects in data = %d", [data count]);
    
    NSLog(@"Contents of data array = %@", data);
    
    return data;    
}

- (NSArray*)calendarMonthView:(TKCalendarMonthView *)monthView marksFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate {	
	NSLog(@"calendarMonthView marksFromDate toDate");	
    
	NSArray *data = [NSArray arrayWithArray:[self fetchDatesForTimedEvents]];
    
	
	// Initialise empty marks array, this will be populated with TRUE/FALSE in order for each day a marker should be placed on.
	NSMutableArray *marks = [NSMutableArray array];
	
	// Initialise calendar to current type and set the timezone to never have daylight saving
	NSCalendar *cal = [NSCalendar currentCalendar];
	[cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	// Construct DateComponents based on startDate so the iterating date can be created.
	// Its massively important to do this assigning via the NSCalendar and NSDateComponents because of daylight saving has been removed 
	// with the timezone that was set above. If you just used "startDate" directly (ie, NSDate *date = startDate;) as the first 
	// iterating date then times would go up and down based on daylight savings.
	NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) fromDate:startDate];
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
		//if ([data containsObject:[d description]]) {
		if ([data containsObject:d]) {
            
			[marks addObject:[NSNumber numberWithBool:YES]];
		} else {
			[marks addObject:[NSNumber numberWithBool:NO]];
		}
		
		// Increment day using offset components (ie, 1 day in this instance)
		d = [cal dateByAddingComponents:offsetComponents toDate:d options:0];
	}
	
	[offsetComponents release];
	NSLog(@"Number of marks is %d",[marks count]);
    NSLog(@"Array contains %@", marks);
	return [NSArray arrayWithArray:marks];
}
- (void) addDateToCurrentEvent {
    /* the navigation bar needs to be changed for the schedule view 
     Left button = Cancel. Returns the user to the editing page.
     
     Right Button = ADD item - when the calendar is pulled up.
     If the textview has text then, check if there is an appointment or task event linked. 
     If not, selecting a date and hitting the ADD button, creates an event  if it doesn't already exist 
     and adds the date.
     If there is no text in TV, then create note and event. 
     
     Alternately, have two different looking buttons which show depending on whether there is text or not. 
     
     */
    
    //[self toggleCalendar:nil];
    return;
}


#pragma mark - Popover Management

- (void) presentActionsPopover:(id) sender {
    //Check for visisble instance of actionsPopover. if yes dismiss.
    if([actionsPopover isPopoverVisible]) {
        [actionsPopover dismissPopoverAnimated:YES];
        [actionsPopover setDelegate:nil];
        [actionsPopover autorelease];
        actionsPopover = nil;
        return;
    }
    
    if(!actionsPopover ) {
        
        UIViewController *viewCon = [[UIViewController alloc] init];
        
        switch ([sender tag]) {
            case 1://ADDING NEW FOLDERS OR FILES
            {
                NSLog(@"Saving");                        
                CGSize size = CGSizeMake(140, 150);
                viewCon.contentSizeForViewInPopover = size;
                
                viewCon.view =  [self addItemsView:CGRectMake(0, 0, size.width, size.height)];
                actionsPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
                [actionsPopover setDelegate:self];
                
                if (isSaving){
                    
                    [actionsPopover presentPopoverFromRect:CGRectMake(80, kScreenHeight-kTabBarHeight, 50, 40)
                                                    inView:self.view    
                                  permittedArrowDirections:UIPopoverArrowDirectionDown
                                                  animated:YES name:@"Save"];  
                }
                else if (!isSaving) {
                    [actionsPopover presentPopoverFromRect:CGRectMake(10, 0, 50, 40)
                                                    inView:self.view    
                                  permittedArrowDirections:UIPopoverArrowDirectionUp
                                                  animated:YES name:@"Save"];     
                }
                
                [viewCon release];
            }
                break;
                
            case 2:
            {
                NSLog(@"Organizing");
                
                CGSize size = CGSizeMake(140, 260);
                viewCon.contentSizeForViewInPopover = size;
                viewCon.view = [self organizerView: CGRectMake(0, 0, size.width, size.height)];
                
                actionsPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
                [actionsPopover setDelegate:self];
                
                if (isSaving) {
                    
                    [actionsPopover presentPopoverFromRect:CGRectMake(190, kScreenHeight-kTabBarHeight, 50, 40)
                                                    inView:self.view
                                  permittedArrowDirections: UIPopoverArrowDirectionDown
                                                  animated:YES name:@"Plan"];
                }
                else if (!isSaving) {
                    [actionsPopover presentPopoverFromRect:CGRectMake(280,0, 50, 40) inView:self.view
                                  permittedArrowDirections: UIPopoverArrowDirectionUp
                                                  animated:YES name:@"Organize"];
                }
                
                [viewCon release];
            }
                break;
            default:
                break;
        }    
        
    }
    
}
- (void) cancelPopover:(id)sender {
    NSLog(@"CANCELLING POPOVER");
    return;
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Did dismiss");
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Should dismiss");
    return YES;
}

- (UIView *) addItemsView: (CGRect) frame {
    UIView *oView = [[[UIView alloc] initWithFrame:frame] autorelease];
    //FIXME: Potential Memory Leak for oView
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 29)];
    [addLabel setText:@"Add New:"];
    [addLabel setBackgroundColor:[UIColor clearColor]];
    addLabel.textColor = [UIColor lightTextColor];
    addLabel.font = [UIFont boldSystemFontOfSize:18];
    addLabel.layer.borderWidth = 2;
    addLabel.layer.borderColor = [UIColor clearColor].CGColor;
    
    UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 120, 39)];
    [b1 setTitle:@"Appointment" forState:UIControlStateNormal];
    b1.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    b1.backgroundColor = [UIColor darkGrayColor];
    b1.alpha = 0.8;
    [b1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    b1.layer.cornerRadius = 6.0;
    b1.layer.borderWidth = 1.0;
    [b1 addTarget:self action:@selector(pushingDetail) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *b2 = [[UIButton alloc] initWithFrame:CGRectMake(5, 70, 120, 39)];
    b2.backgroundColor = [UIColor darkGrayColor];
    b2.alpha = 0.8;
    [b2 setTitle:@"To Do" forState:UIControlStateNormal];
    b2.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    [b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    b2.layer.cornerRadius = 6.0;
    b2.layer.borderWidth = 1.0;
    
    UIButton *b3 = [[UIButton alloc] initWithFrame:CGRectMake(5, 110, 120, 39)];
    [b3 setTitle:@"Note" forState:UIControlStateNormal];
    b3.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    [b3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b3 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    b3.backgroundColor = [UIColor darkGrayColor];
    b3.alpha = 0.8;    
    b3.layer.cornerRadius = 6.0;
    b3.layer.borderWidth = 1.0;

    [oView addSubview:addLabel];

    [oView addSubview:b1];
    [oView addSubview:b2];
    [oView addSubview:b3];

    [b1 release];
    [b2 release];
    [b3 release];
    [addLabel release];
    
    return oView;
    
}

- (UIView *)organizerView: (CGRect)frame {
    UIView *oView = [[[UIView alloc] initWithFrame:frame] autorelease];
    //FIXME: Potental Memory Leak for oView
    UILabel *sortLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 29)];
    [sortLabel setText:@"Sort By"];
    [sortLabel setBackgroundColor:[UIColor clearColor]];
    sortLabel.textColor = [UIColor lightTextColor];
    sortLabel.font = [UIFont boldSystemFontOfSize:18];
    sortLabel.layer.borderWidth = 2;
    sortLabel.layer.borderColor = [UIColor clearColor].CGColor;
    UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 120, 39)];
    [b1 setTitle:@"Name" forState:UIControlStateNormal];
    b1.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    b1.backgroundColor = [UIColor darkGrayColor];
    b1.alpha = 0.4;
    [b1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    //b1.layer.borderWidth = 2;
    //b1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [b1 addTarget:self action:@selector(pushingDetail) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *b2 = [[UIButton alloc] initWithFrame:CGRectMake(5, 70, 120, 39)];
    b2.backgroundColor = [UIColor darkGrayColor];
    b2.alpha = 0.4;
    [b2 setTitle:@"Date Created" forState:UIControlStateNormal];
    b2.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    [b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    //b2.layer.borderWidth = 2;
    //b2.layer.borderColor = [UIColor darkGrayColor].CGColor;
    UIButton *b3 = [[UIButton alloc] initWithFrame:CGRectMake(5, 110, 120, 39)];
    [b3 setTitle:@"Date Modified" forState:UIControlStateNormal];
    b3.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    [b3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b3 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    b3.backgroundColor = [UIColor darkGrayColor];
    b3.alpha = 0.4;
    
    //b3.layer.borderWidth = 2;
    //b3.layer.borderColor = [UIColor darkGrayColor].CGColor;
    UIButton *b4 = [[UIButton alloc] initWithFrame:CGRectMake(5, 150, 120, 39)];
    [b4 setTitle:@"Other" forState:UIControlStateNormal];
    b4.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    b4.backgroundColor = [UIColor darkGrayColor];
    //b4.layer.borderWidth = 2;
    //b4.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [b4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b4 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    b4.alpha = 0.4;
    
    UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, 140, 29)];
    deleteLabel.backgroundColor = [UIColor clearColor];
    deleteLabel.textColor = [UIColor lightTextColor];
    [deleteLabel setText:@"Delete"];
    deleteLabel.font = [UIFont boldSystemFontOfSize:18];
    
    UIButton *b5 = [[UIButton alloc] initWithFrame:CGRectMake(5, 220, 120, 39)];
    [b5 setTitle:@"Delete" forState:UIControlStateNormal];
    //b5.layer.borderWidth = 2;
    //b5.layer.borderColor = [UIColor darkGrayColor].CGColor;
    b5.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    b5.alpha = 0.4;
    b5.backgroundColor = [UIColor darkGrayColor];
    [b5 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [b5 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [oView addSubview:sortLabel];
    [oView addSubview:b1];
    [oView addSubview:b2];
    [oView addSubview:b3];
    [oView addSubview:b4];
    [oView addSubview:deleteLabel];
    [oView addSubview:b5];
    
    [b1 release];
    [b2 release];
    [b3 release];
    [b4 release];
    [b5 release];
    [sortLabel release];
    [deleteLabel release];
    
    return oView;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}





- (void) textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"Method: textFieldDidBeginEditing -> applies in scheduleView, enables and/or disables the toolbar next and prev buttons");
    switch ([textField tag]) {
        case 1:
            scheduleView.isBeingEdited = [NSNumber numberWithInt:1];
            toolbar.firstButton.enabled = NO;
            toolbar.secondButton.enabled = YES;
            break;
        case 2:
            scheduleView.isBeingEdited = [NSNumber numberWithInt:2];
            toolbar.firstButton.enabled = YES;
            toolbar.secondButton.enabled = YES;
            break;
        case 3:
            scheduleView.isBeingEdited = [NSNumber numberWithInt:3];
            toolbar.firstButton.enabled = YES;
            toolbar.secondButton.enabled = YES;
            break;
        case 4:
            scheduleView.isBeingEdited = [NSNumber numberWithInt:4];
            toolbar.firstButton.enabled = YES;
            toolbar.secondButton.enabled = YES;
            break;
        case 5:
            scheduleView.isBeingEdited = [NSNumber numberWithInt:5];
            toolbar.firstButton.enabled = YES;
            if (scheduleView.alarm1Field.superview == nil) {
                toolbar.secondButton.enabled = NO;
            }
            else {
                toolbar.secondButton.enabled = YES;
            }
            break;
        case 6:
            scheduleView.isBeingEdited = [NSNumber numberWithInt:6];
            toolbar.firstButton.enabled = YES;
            toolbar.secondButton.enabled = YES;
            break;
        case 7:
            scheduleView.isBeingEdited = [NSNumber numberWithInt:7];
            toolbar.firstButton.enabled = YES;
            toolbar.secondButton.enabled = YES;
            break;
        case 8:
            scheduleView.isBeingEdited = [NSNumber numberWithInt:8];
            toolbar.firstButton.enabled = YES;
            toolbar.secondButton.enabled = YES;
            break;
        case 9:
            scheduleView.isBeingEdited = [NSNumber numberWithInt:9];
            toolbar.firstButton.enabled = YES;
            toolbar.secondButton.enabled = NO;
            break;
        case 10:
            scheduleView.isBeingEdited = [NSNumber numberWithInt:10];
            toolbar.firstButton.enabled = YES;
            toolbar.secondButton.enabled = YES;
            break;        
        case 11:
            scheduleView.isBeingEdited = [NSNumber numberWithInt:11];
            toolbar.firstButton.enabled = YES;
            toolbar.secondButton.enabled = YES;
            break;
        case 12:
            scheduleView.isBeingEdited = [NSNumber numberWithInt:12];
            toolbar.firstButton.enabled = YES;
            toolbar.secondButton.enabled = NO;
            break;
        default:
            break;
    }
}



@end
