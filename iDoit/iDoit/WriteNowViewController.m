//
//  WriteNowViewController.m
//  iDoit
//
//  Created by Keith Fernandes on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WriteNowViewController.h"
#import "Contants.h"


@implementation WriteNowViewController

@synthesize topView, bottomView, textView;
@synthesize leftNavButton, rightNavButton, toolbar;
@synthesize calendarView, actionsPopover;

#pragma mark - Memory Management

- (void)dealloc {
    [super dealloc];
    [topView release];
    [bottomView release];
    [textView release];
    [calendarView release];
    [leftNavButton release];
    [rightNavButton release];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    topView = nil;
    bottomView = nil;
    textView = nil;
    calendarView = nil;
    leftNavButton = nil;
    rightNavButton = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"WriteNowViewController: Memory Warning Received");
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    textView.delegate = self;
    self.navigationController.navigationBar.topItem.title = @"Write Now";    
    topView = [[UIView alloc] initWithFrame:kTopViewRect];
    [self.view addSubview:topView];
    bottomView = [[UIView alloc] initWithFrame:kBottomViewRect];
    [self.view addSubview:bottomView];
}

- (void) viewWillAppear:(BOOL)animated{
    toolbar = [[CustomToolBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    [toolbar.firstButton setTarget:self];
    [toolbar.firstButton setEnabled:NO];
    [toolbar.secondButton setTarget:self];
    [toolbar.thirdButton setTarget:self];
    [toolbar.fourthButton setTarget:self];
    [toolbar.fourthButton setEnabled:NO];
    [toolbar.dismissKeyboard setTarget:self];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:topView cache:YES];    
    
    textView = [[CustomTextView alloc] initWithFrame:kTextViewRect];
    textView.inputAccessoryView = toolbar;
    [topView addSubview:textView];
    
    [UIView commitAnimations];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBottomViewRect.size.height)];
    [bottomView addSubview:tableView];
    
    textView.delegate = self;
}

- (void) viewWillDisappear:(BOOL)animated {
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


#pragma mark - TextViewDelegate Methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView{  
    NSLog(@"TextView did begin editing.");
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    
    CGRect frame = topView.frame;
    frame.size.height += 35.0;
    self.topView.frame = frame;
    frame = self.textView.frame;
    frame.size.height += 35.0;
    self.textView.frame = frame;
    frame = bottomView.frame;
    frame.origin.y += 35.0;
    frame.size.height -= 35.0;
    self.bottomView.frame = frame;
    
    [UIView commitAnimations];
    return YES;
}

- (void) textViewDidChange:(UITextView *)textView {
    //textView has text so enable the Save and Send buttons
    if (toolbar.firstButton.enabled == NO && toolbar.fourthButton.enabled == NO) {
        toolbar.firstButton.enabled = YES;
        toolbar.fourthButton.enabled = YES;
    }
    
}


#pragma mark - ToolBar Actions

- (void) dismissKeyboard {
    NSLog(@"Dismissing Keyboard");
    [textView resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];    
    CGRect frame = topView.frame;
    frame.size.height -= 35.0;
    self.topView.frame = frame;
    frame = self.textView.frame;
    frame.size.height -= 35.0;
    self.textView.frame = frame;
    frame = bottomView.frame;
    frame.origin.y -= 35.0;
    frame.size.height += 35.0;
    self.bottomView.frame = frame;    
    [UIView commitAnimations];
}

- (void) toggleCalendar:(id)sender {
    if ([textView isFirstResponder]) {
        //Check if textView is first responder. If it is, resign first responder and disable user interaction
        [textView resignFirstResponder];
        self.textView.userInteractionEnabled = NO;
    }
    if (calendarView == nil) {
        //Check if the calendar obect exists. If it is not in view, it should not exist. Initialize and slide into view from bottom.
        calendarView = 	[[TKCalendarMonthView alloc] init];        
        calendarView.delegate = self;
        calendarView.dataSource = self;
        [self.topView addSubview:calendarView];
        [calendarView reload];
        calendarView.frame = CGRectMake(0, kScreenHeight, calendarView.frame.size.width, calendarView.frame.size.height);
        
        //Add Nav buttons to dismiss the calendar (left) and to add date selected from the calendar to a new event or an event that is in the process of being created. If the user taps the calendar button before inputting any text, create a new Event object and add the selected date. If there is already some text input, create a new Event object and add both the selected date and the text to the event object. 
        UIImage *leftImage = [UIImage imageNamed:@"cancel_clear_white_on_blue_button.png"];
        leftNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftNavButton setImage:leftImage forState:UIControlStateNormal];
        [leftNavButton setImage:leftImage forState:UIControlStateHighlighted];
        leftNavButton.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftNavButton];
        self.navigationItem.leftBarButtonItem  = leftButton;
        [leftButton release];
        [leftNavButton addTarget:self action:@selector(toggleCalendar:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *rightImage = [UIImage imageNamed:@"add_item_white_on_blue_button.png"];
        rightNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightNavButton setImage:rightImage forState:UIControlStateNormal];
        [rightNavButton setImage:rightImage forState:UIControlStateHighlighted];
        rightNavButton.frame = CGRectMake(0, 0, rightImage.size.width, rightImage.size.height);
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightNavButton];
        self.navigationItem.rightBarButtonItem  = rightButton;
        [rightButton release];
        [rightNavButton addTarget:self action:@selector(addDateToCurrentEvent) forControlEvents:UIControlEventTouchUpInside];
        
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
        
        CGRect frame = topView.frame;
        frame.size.height = kTopViewRect.size.height;
        self.topView.frame = frame;
        frame = textView.frame;
        frame.size.height = kTextViewRect.size.height;
        textView.frame = frame;
        frame = bottomView.frame;
        frame.origin.y = kBottomViewRect.origin.y;    
        self.bottomView.frame = frame;
        calendarView.frame = CGRectMake(0, kScreenHeight, calendarView.frame.size.width, calendarView.frame.size.height);
        
        [UIView commitAnimations];
    }
}

- (void) finishedCalendarTransition{
    [calendarView removeFromSuperview];
    calendarView = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [textView becomeFirstResponder];
    [textView setUserInteractionEnabled:YES];
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

#pragma mark - Popover Management

- (void) presentActionsPopover:(id) sender{

    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 54, 54)];
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(button1.frame.size.width+30, 5, 54, 54)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(button1.frame.origin.x-10, button1.frame.size.height+5, button1.frame.size.width+20, 30)];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setTextAlignment:UITextAlignmentCenter];
    [label1 setTextColor:[UIColor whiteColor]];
    [label1 setFont:[UIFont boldSystemFontOfSize:12]];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(button2.frame.origin.x, button2.frame.size.height+5, button2.frame.size.width, 30)];    
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setTextAlignment:UITextAlignmentCenter];
    [label2 setFont:[UIFont boldSystemFontOfSize:12]];
    [label2 setTextColor:[UIColor whiteColor]];
    
    UIViewController *viewCon = [[UIViewController alloc] init];
    viewCon.contentSizeForViewInPopover = CGSizeMake(150, button1.frame.size.height+label1.frame.size.height);
    [viewCon.view addSubview:button1];
    [viewCon.view addSubview:button2];
    [viewCon.view addSubview:label1];
    [viewCon.view addSubview:label2];
    
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
        if ([sender tag] == 1) {            
            NSLog(@"Saving");                
            [self saveMemo:nil];
            [button1 setImage:[UIImage imageNamed:@"folder_button.png"] forState:UIControlStateNormal];
            [button1 setImage:[UIImage imageNamed:@"folder_button_selected.png"] forState:UIControlStateHighlighted];
            [button1 addTarget:self action:@selector(saveToFolderOrFile:) forControlEvents:UIControlEventTouchUpInside];
            [button1 setTag:1];
            [button2 setImage:[UIImage imageNamed:@"files_button.png"] forState:UIControlStateNormal];
            [button2 setImage:[UIImage imageNamed:@"files_button_selected.png"] forState:UIControlStateSelected];

            [button2 addTarget:self action:@selector(saveToFolderOrFile:) forControlEvents:UIControlEventTouchUpInside];
            [button2 setTag:2];
            [label1 setText:@"To Folder"];
            [label2 setText:@"To File"];
            
            [actionsPopover presentPopoverFromRect:CGRectMake(20, 205, 50, 40)
                                        inView:self.view    
                      permittedArrowDirections:UIPopoverArrowDirectionDown
                                      animated:YES name:@"Save"];  
            [button1 release];
            [button2 release];
            [label1 release];
            [label2 release];
            [viewCon release];
            return;
        }
        else if ([sender tag] == 2) {
            NSLog(@"Planning");
            [button1 setImage:[UIImage imageNamed:@"task_button.png"] forState:UIControlStateNormal];
            [button1 setImage:[UIImage imageNamed:@"task_button_selected.png"] forState:UIControlStateSelected];
    
            [button1 addTarget:self action:@selector(addNewEvent:) forControlEvents:UIControlEventTouchUpInside];
            [button1 setTag:15];
            [button2 setImage:[UIImage imageNamed:@"appointment_button.png"] forState:UIControlStateNormal];
            [button2 setImage:[UIImage imageNamed:@"appointment_button_selected.png"] forState:UIControlStateSelected];
    
            [button2 addTarget:self action:@selector(addNewEvent:) forControlEvents:UIControlEventTouchUpInside];
            [button2 setTag:16];
            [label1 setText:@"Task"];
            [label2 setText:@"Appointment"];
            [actionsPopover presentPopoverFromRect:CGRectMake(90, 205, 50, 40)
                                        inView:self.view
                      permittedArrowDirections: UIPopoverArrowDirectionDown
                                      animated:YES name:@"Plan"];    
            [button1 release];
            [button2 release];
            [label1 release];
            [label2 release];
            [viewCon release];
            
            return;
        }
        else if ([sender tag] == 3) {
            NSLog(@"Changing View");
            [button1 release];
            [button2 release];
            [label1 release];
            [label2 release];
            [viewCon release];
            return;
        }
        else {
            NSLog(@"Sending");
            
            [button1 setImage:[UIImage imageNamed:@"email_button.png"] forState:UIControlStateNormal];
            [button1 setImage:[UIImage imageNamed:@"email_button_selected.png"] forState:UIControlStateSelected];
    
            [button1 addTarget:self action:@selector(sendItem:) forControlEvents:UIControlEventTouchUpInside];
            
            [button2 setImage:[UIImage imageNamed:@"message_button.png"] forState:UIControlStateNormal];
            [button2 setImage:[UIImage imageNamed:@"message_button_selected.png"] forState:UIControlStateSelected];
    
            [button2 addTarget:self action:@selector(sendItem:) forControlEvents:UIControlEventTouchUpInside];
            [label1 setText:@"Email"];
            [label2 setText:@"Message"];
            [actionsPopover presentPopoverFromRect:CGRectMake(205, 205, 50, 50) inView:self.view
                      permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES name:@"Send"]; 
            [button1 release];
            [button2 release];
            [label1 release];
            [label2 release];
            [viewCon release];
            
            return;
        }
    }    
    [button1 release];
    [button2 release];
    [label1 release];
    [label2 release];
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

- (void) saveMemo:(id) sender {
    return;
}

- (void)saveToFolderOrFile:(id)sender {
    [actionsPopover dismissPopoverAnimated:YES];
    
    return;
}


- (void) addNewEvent:(id)sender {
    [actionsPopover dismissPopoverAnimated:YES];
    return;
}

- (void) sendItem:(id)sender {
    [actionsPopover dismissPopoverAnimated:YES];
    return;
}



@end
