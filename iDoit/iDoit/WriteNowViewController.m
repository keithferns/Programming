//
//  WriteNowViewController.m
//  iDoit
//
//  Created by Keith Fernandes on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WriteNowViewController.h"
#import "ArchiveViewController.h"
#import "UINavigationController+NavControllerCategory.h"
#import "Contants.h"


@implementation WriteNowViewController

@synthesize topView, bottomView, scheduleView, textView;
@synthesize toolbar;
@synthesize calendarView, actionsPopover;
@synthesize tableView;
@synthesize archiveView;

#pragma mark - Memory Management

- (void)dealloc {
    [super dealloc];
    [topView release];
    [bottomView release];
    [scheduleView release];
    [textView release];
    [calendarView release];
    [toolbar release];
    [tableView release];
    [archiveView release];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    topView = nil;
    bottomView = nil;
    textView = nil;
    calendarView = nil;
    scheduleView = nil;
    toolbar = nil;
    tableView = nil;
    archiveView = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"WriteNowViewController: Memory Warning Received");
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    //Navigation Bar
    self.navigationController.navigationBar.topItem.title = @"Write Now";    
    
    //Initialize topView
    topView = [[UIView alloc] initWithFrame:kTopViewRect];
    topView.backgroundColor = [UIColor clearColor];
    
    //Initialize bottomView
    bottomView = [[UIView alloc] initWithFrame:kBottomViewRect];
    bottomView.backgroundColor = [UIColor clearColor];
    
    //View Heirarchy: topView - bottomview
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];
}

- (void) viewWillAppear:(BOOL)animated{
    [self.navigationController hidesBottomBarWhenPushed];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //Initialize the toolbar. disable 'save' and 'send' buttons.
    toolbar = [[CustomToolBar alloc] init];
    [toolbar.firstButton setTarget:self];
    [toolbar.secondButton setTarget:self];
    [toolbar.thirdButton setTarget:self];
    [toolbar.fourthButton setTarget:self];
    [toolbar.fifthButton setTarget:self];
    
    //Initialize the textView.
    textView = [[CustomTextView alloc] initWithFrame:kTextViewRect];
    textView.inputAccessoryView = toolbar;
    textView.delegate = self;
    
    //Initialize the tableview
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBottomViewRect.size.height)];
    tableView.backgroundColor = [UIColor blackColor];
    
    // flip textView and raise tableView into place 
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:topView cache:YES];    

    [topView addSubview:textView];
    [bottomView addSubview:tableView];

    [UIView commitAnimations];
}

- (void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.calendarView removeFromSuperview];
    self.calendarView = nil;
    
    CGRect frame = topView.frame;
    frame.size.height = kTopViewRect.size.height;
    topView.frame = frame;
    frame = textView.frame;
    frame.size.height = kTextViewRect.size.height;
    textView.frame = frame;
    frame = bottomView.frame;
    frame.origin.y = kBottomViewRect.origin.y;
    frame.size.height = kBottomViewRect.size.height;
    bottomView.frame = frame;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Internal View Management

- (void) toggleTextAndScheduleView:(id) sender{
    NSLog(@"Toggling Text and Schedule Views");
    if (self.scheduleView == nil){
        //Initialize the scheduleView. 
        scheduleView = [[ScheduleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, topView.frame.size.height)]; 
        
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
    
    // setup the animation group
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedScheduleTextViewTransition)];
	
	// swap the views and transition
    if (textView.superview != nil) {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:topView cache:YES];
        [textView removeFromSuperview];
        
        [self.topView addSubview:scheduleView];
        [scheduleView.dateField becomeFirstResponder];
        
        //Add Cancel Button to the Nav Bar. Set it to call method to toggle text/shedule view
        self.navigationItem.leftBarButtonItem = [self.navigationController addCancelButton];
        [self.navigationItem.rightBarButtonItem setTarget:self];
        
        //Add Done Button to the Nav Bar. Set it to call method to save input and to return to editing
        self.navigationItem.rightBarButtonItem =[self.navigationController addDoneButton];
        [self.navigationItem.rightBarButtonItem setTarget:self];
        
        [toolbar changeToSchedulingButtons];
        toolbar.fourthButton.enabled = YES;
                    
    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:topView cache:YES];        
        [scheduleView removeFromSuperview];
        [self.topView addSubview:textView];
        [toolbar changeToEditingButtons];

        if ([self.textView hasText]){
            self.navigationItem.leftBarButtonItem = [self.navigationController addAddButton];
            self.navigationItem.rightBarButtonItem = [self.navigationController addDoneButton];
            toolbar.firstButton.enabled = YES;
            toolbar.fourthButton.enabled = YES;
        }
        else {
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = nil;
            toolbar.firstButton.enabled = NO;
            toolbar.fourthButton.enabled = NO;
        }
    }
	[UIView commitAnimations];
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


- (void) finishedScheduleTextViewTransition{
    self.topView.userInteractionEnabled = YES;
    [self.textView becomeFirstResponder];
    
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

#pragma mark - TextViewDelegate Methods

- (void) textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"TextView Did Begin Editing");
}

- (void) textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"TextView Did End Editing");
}

- (void) textViewDidChange:(UITextView *)textView {
    //textView has text so enable the Save and Send buttons
    //FIXME: this method is called and the loop condition is checked each time a character is changed.  
    if (self.navigationItem.rightBarButtonItem == nil && [self.textView hasText]) {
        self.navigationItem.rightBarButtonItem = [self.navigationController addDoneButton];
        self.navigationItem.rightBarButtonItem.action = @selector(saveMemo:);
        
        self.navigationItem.leftBarButtonItem = [self.navigationController addAddButton]; 

        self.navigationItem.leftBarButtonItem.action = @selector(startNewItem:);
    }
    
    if (toolbar.firstButton.enabled == NO && toolbar.fourthButton.enabled == NO && [self.textView hasText]) {
        toolbar.firstButton.enabled = YES;
        toolbar.fourthButton.enabled = YES;
    }    
}

#pragma mark Responding to keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]; // Get the origin of the keyboard when it's displayed.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];//??
    CGFloat keyboardTop = keyboardRect.origin.y;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];    //Check the height of the topView. If height is at minimum value, then grow
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:animationDuration];

    if (self.topView.frame.origin.y + self.topView.frame.size.height < keyboardTop){
        //grow topView
        CGRect frame = topView.frame;
        frame.size.height = keyboardTop - self.topView.frame.origin.y;
        self.topView.frame = frame;
        
        //grow textView
        frame = textView.frame;
        frame.size.height = topView.frame.size.height - 2;
        self.textView.frame = frame;
        
        //move bottomView below toolbar.
        frame = bottomView.frame;
        frame.origin.y = keyboardTop + self.toolbar.frame.size.height;
        self.bottomView.frame = frame;
    }
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    //Shrink topView
    CGRect frame = topView.frame;
    frame.size.height = kTopViewRect.size.height;
    self.topView.frame = frame;
    
    if (textView.superview != nil) {
    //Shrink textView
    frame = self.textView.frame;
    frame.size.height = kTextViewRect.size.height;
    self.textView.frame = frame;
    //Raise the bottomView
    frame = self.bottomView.frame;
    frame.origin.y = kBottomViewRect.origin.y;
    self.bottomView.frame = frame;
    }
    [UIView commitAnimations];
}

#pragma mark - TextField Delegate and Navigation 

- (void) textFieldDidBeginEditing:(UITextField *)textField{
    
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
- (void) textFieldDidEndEditing:(UITextField *)textField{
    //
}

#pragma mark - ToolBar Actions

- (void) moveToPreviousField{
    [scheduleView moveToPreviousField];
}
- (void) moveToNextField{
    [scheduleView moveToNextField];
}
- (void) dismissKeyboard {    
    if([actionsPopover isPopoverVisible]) {
        [actionsPopover dismissPopoverAnimated:YES];
    }
    if ([textView isFirstResponder]){
        [textView resignFirstResponder];       
    }
    self.navigationItem.leftBarButtonItem.action = @selector(startNewItem:);

}
- (void) toggleCalendar:(id)sender {    
    if([actionsPopover isPopoverVisible]) {
        [actionsPopover dismissPopoverAnimated:YES];
    }
    
    if ([textView isFirstResponder]) {
        //Check if textView is first responder. If it is, resign first responder and disable user interaction
        [textView resignFirstResponder];
        self.textView.userInteractionEnabled = NO;
        }
        [scheduleView textFieldResignFirstResponder];
    
    if (calendarView == nil) {
        //Check if the calendar obect exists. If it is not in view, it should not exist. Initialize and slide into view from bottom.
        calendarView = 	[[TKCalendarMonthView alloc] init];        
        calendarView.delegate = self;
        calendarView.dataSource = self;
        [self.topView addSubview:calendarView];
        [calendarView reload];
        calendarView.frame = CGRectMake(0, kScreenHeight, calendarView.frame.size.width, calendarView.frame.size.height);
        
        //Add Nav buttons to dismiss the calendar (left) and to add date selected from the calendar to a new event or an event that is in the process of being created. If the user taps the calendar button before inputting any text, create a new Event object and add the selected date. If there is already some text input, create a new Event object and add both the selected date and the text to the event object. 
        self.navigationItem.leftBarButtonItem = [self.navigationController addCancelButton];
        self.navigationItem.leftBarButtonItem.target = self;
        self.navigationItem.leftBarButtonItem.action = @selector(toggleCalendar:);
        
        self.navigationItem.rightBarButtonItem = [self.navigationController addAddButton];
        self.navigationItem.rightBarButtonItem.target = self;
        self.navigationItem.rightBarButtonItem.action = @selector(addDateToCurrentEvent);
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
    
        CGRect frame = topView.frame;
        frame.size.height = calendarView.frame.size.height;
        self.topView.frame = frame;
        frame = bottomView.frame;
        frame.origin.y = topView.frame.origin.y + topView.frame.size.height;    
        self.bottomView.frame = frame;
        calendarView.frame = CGRectMake(0, 0, calendarView.frame.size.width, calendarView.frame.size.height);
    
        [UIView commitAnimations];
        }
    else {
        NSLog(@"Dismissing Calendar");
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(finishedCalendarTransition)];
        if (textView.superview != nil) {
            //check to see if the textView is below the calendar view.
        CGRect frame = topView.frame;
        frame.size.height = kTopViewRect.size.height+35.0;
        self.topView.frame = frame;
        frame = textView.frame;
        frame.size.height = kTextViewRect.size.height+35.0;
        textView.frame = frame;
        frame = bottomView.frame;
        frame.origin.y = kBottomViewRect.origin.y+85;    
        self.bottomView.frame = frame;
        }
        else if (scheduleView.superview != nil){
            //check to see if the ScheduleView is below the calendar view
            CGRect frame = topView.frame;
            frame.size.height = kTopViewRect.size.height+35;
            self.topView.frame = frame;
            frame = bottomView.frame;
            frame.origin.y = kBottomViewRect.origin.y+85;
            self.bottomView.frame = frame;
        }
        calendarView.frame = CGRectMake(0, kScreenHeight, calendarView.frame.size.width, calendarView.frame.size.height);
        
        [UIView commitAnimations];
    }
}
- (void) finishedCalendarTransition{
    [calendarView removeFromSuperview];
    calendarView = nil;
    if (textView.superview !=nil) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        [textView becomeFirstResponder];
        [textView setUserInteractionEnabled:YES];
        }
    else if (scheduleView.superview != nil){
        //Add Cancel Button to the Nav Bar. Set it to call method to toggle text/shedule view
        self.navigationItem.leftBarButtonItem = [self.navigationController addCancelButton];
        self.navigationItem.leftBarButtonItem.target = self;
        self.navigationItem.leftBarButtonItem.action = @selector(toggleTextAndScheduleView:);
        
        //Add Done Button to the Nav Bar. Set it to call method to save input and to return to editing
        self.navigationItem.rightBarButtonItem = [self.navigationController addDoneButton];
        self.navigationItem.rightBarButtonItem.target = self;
        self.navigationItem.rightBarButtonItem.action = @selector(toggleTextAndScheduleView:);
        
        
        //Call method to return control to the textfield that was editing when the calendar was called
        [scheduleView textFieldBecomeFirstResponder];
    }
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
- (void) addDateToCurrentEvent{
    //
    [self toggleCalendar:nil];
    return;
}
#pragma mark - Popover Management
- (void) presentActionsPopover:(id) sender{
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(0, 0, 100, 39);
    [label1 setBackgroundColor:[UIColor clearColor]];
    label1.textColor = [UIColor lightTextColor];
    label1.font = [UIFont boldSystemFontOfSize:18];
    label1.layer.borderWidth = 2;
    label1.layer.borderColor = [UIColor clearColor].CGColor;
    
    UIButton *button1 = [[UIButton alloc] init];
    button1.frame = CGRectMake(0, 40, 100, 39);
 
    button1.backgroundColor = [UIColor darkGrayColor];
    button1.alpha = 0.4;
    [button1 setTitle:@"Event" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    UIButton *button2 = [[UIButton alloc] init];
    button2.frame = CGRectMake(0, 81, 100, 39);
    button2.backgroundColor = [UIColor darkGrayColor];
    button2.alpha = 0.4;
    [button2 setTitle:@"To Do" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    UIViewController *viewCon = [[UIViewController alloc] init];
    viewCon.contentSizeForViewInPopover = CGSizeMake(100, 120);

    [viewCon.view addSubview:label1];
    [viewCon.view addSubview:button1];
    [viewCon.view addSubview:button2];
    
    if(!actionsPopover) {
        actionsPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        [actionsPopover setDelegate:self];
    } 
    if([actionsPopover isPopoverVisible]) {
        [actionsPopover dismissPopoverAnimated:YES];
        [actionsPopover setDelegate:nil];
        [actionsPopover autorelease];
        actionsPopover = nil;
    } else {
        switch ([sender tag]) {
            case 1:
            label1.text = @"Save To";
            button1.titleLabel.text = @"Folder";
            button2.titleLabel.text = @"Document";
            [button1 setTitle:@"Folder" forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(saveToFolderOrFile:) forControlEvents:UIControlEventTouchUpInside];
            [button2 setTitle:@"Document" forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(saveToFolderOrFile:) forControlEvents:UIControlEventTouchUpInside];
            
            [actionsPopover presentPopoverFromRect:CGRectMake(20, 192, 50, 40) inView:self.view
                          permittedArrowDirections: UIPopoverArrowDirectionDown animated:YES name:@"Plan"];  
            break;
        case 2:
            label1.text = @"Create";
            button1.titleLabel.text = @"Event";
            button2.titleLabel.text = @"To Do";
            [button1 setTitle:@"Event" forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(addNewEvent:) forControlEvents:UIControlEventTouchUpInside];
            [button2 setTitle:@"To Do" forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(addNewEvent:) forControlEvents:UIControlEventTouchUpInside];
            
            [actionsPopover presentPopoverFromRect:CGRectMake(75, 192, 50, 40) inView:self.view
                          permittedArrowDirections: UIPopoverArrowDirectionDown animated:YES name:@"Plan"];    
            break;
        case 3:
            break;        
        case 4:
            [label1 setText:@"Send as"];
            button1.titleLabel.text = @"Email";
            [button1 setTitle:@"Email" forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(sendItem:) forControlEvents:UIControlEventTouchUpInside];

            button2.titleLabel.text = @"Message";
            [button2 setTitle:@"Message" forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(sendItem:) forControlEvents:UIControlEventTouchUpInside];
            
            [actionsPopover presentPopoverFromRect:CGRectMake(192, 192, 50, 50) inView:self.view
                      permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES name:@"Send"]; 
            break;
        default:
            break;
        }   
    }
    [button1 release];
    [button2 release];
    [label1 release];
    [viewCon release];
    return;
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

#pragma mark - Data Management

- (void) startNewItem:(id) sender{
    //Called by Left Nav ADD_ITEM Button.
    NSLog(@"Start New Item");
    //Make textView the first responder
    if (![self.textView isFirstResponder]){
        [self.textView becomeFirstResponder];
    }
    
    //Clear the text.
    textView.text = nil;
    
    //Save memo if not saved
    //...
    //remove the nav Buttons
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    //disable save and send buttons
    toolbar.firstButton.enabled = NO;
    toolbar.fourthButton.enabled = NO;
    return;
}

- (void) saveMemo:(id) sender {
    //Called by Right Nav DONE Button.
    
    //save the memo etc.
    NSLog(@"Save Memo");
    self.textView.userInteractionEnabled = NO; 
    
    if ([self.textView hasText]){
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem =  [self.navigationController addEditButton];
        self.navigationItem.rightBarButtonItem.target = self;
    }
    return;
}


- (void) editTextView:(id) sender {
    //Returns User to Editing the TextView
    self.textView.userInteractionEnabled = YES;
    if (![self.textView isFirstResponder]){
        [self.textView becomeFirstResponder];
    
        //set cursor to end of text - this is the default
        
    }
    
    //reset the right nav button.
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [self.navigationController addDoneButton];
    self.navigationItem.rightBarButtonItem.action = @selector(saveMemo:);
    self.navigationItem.rightBarButtonItem.target = self;
    
}

- (void)saveToFolderOrFile:(id)sender {
    [actionsPopover dismissPopoverAnimated:YES];

    ArchiveViewController *archiveViewController = [[ArchiveViewController alloc] init];
    archiveViewController.hidesBottomBarWhenPushed = YES;
    archiveViewController.isSaving = YES;
    [self.navigationController pushViewController:archiveViewController animated:YES];

    return;
}


- (void) addNewEvent:(id)sender {
    NSLog(@"Add New Event");
    [actionsPopover dismissPopoverAnimated:YES];
    [self toggleTextAndScheduleView:nil];
    return;
}

- (void) sendItem:(id)sender {
    [actionsPopover dismissPopoverAnimated:YES];
    return;
}

@end
