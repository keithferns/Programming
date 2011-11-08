//
//  CurrentViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "ControlVariables.h"
#import "CurrentViewController.h"
#import "WriteNowAppDelegate.h"

#import "CustomToolBarMainView.h"
#import "CurrentTableViewController.h"
#import "MyDataObject.h"
#import "AppDelegateProtocol.h"

@implementation CurrentViewController

@synthesize managedObjectContext;
@synthesize tableViewController;
@synthesize textView, topView, bottomView;
@synthesize toolBar;
@synthesize navPopover, schedulerPopover, reminderPopover;
@synthesize datePicker, timePicker, pickerView;
@synthesize recurring;
@synthesize addField;
@synthesize calendarView;
@synthesize newAppointment, newItem;
@synthesize dateFormatter, timeFormatter;
@synthesize flipperImageForDateNavigationItem;
@synthesize flipIndicatorButton, cancelButton, addButton, editButton;
@synthesize frontViewIsVisible;





- (MyDataObject *) myDataObject {
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	MyDataObject* myDataObject;
	myDataObject = (MyDataObject*) theDelegate.myDataObject;
	return myDataObject;
}

#pragma mark - Memory Management

- (void)dealloc {
    [super dealloc];
    [self.textView release];
    [tableViewController release];
    [managedObjectContext release];
    [toolBar release];
    [topView release];
    [bottomView release];
    [cancelButton release];

    [[NSNotificationCenter defaultCenter] removeObserver:self];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"CURRENT VIEWCONTROLLER: MEMORY WARNING");
}

- (void)viewDidUnload{
    [super viewDidUnload];
    self.textView = nil;
    tableViewController =nil;
    toolBar = nil;
    topView = nil;
    bottomView = nil;
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self];   
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    self.title = @"Write Now";
    [super viewDidLoad];
    
    addField = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
       
    /*-- Point current instance of the MOC to the main managedObjectContext --*/
	if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"CURRENT VIEWCONTROLLER: After managedObjectContext: %@",  managedObjectContext);
	}    
    //[self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.5 alpha:1]];
    UIImage *background = [UIImage imageNamed:@"wallpaper.png"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:background]];
    
    //TOOLBAR: setup    
    toolBar = [[CustomToolBarMainView alloc] initWithFrame:toolBarRect];
    [toolBar.firstButton setTarget:self];
    [toolBar.secondButton setTarget:self];
    [toolBar.thirdButton setTarget:self];
    [toolBar.fourthButton setTarget:self];
    [toolBar.dismissKeyboard setTarget:self];
    
    //Init and add the top and bottom Views. These views will be used to animate the transitions of textView and the table and calendar Views. 
    if (bottomView.superview == nil && bottomView == nil) {
        bottomView = [[UIView alloc] initWithFrame:bottomViewRect];
        [self.view addSubview:bottomView];
        [bottomView setBackgroundColor:[UIColor lightGrayColor]];
    }
    if (topView.superview == nil && topView == nil) {
        topView = [[UIView alloc] initWithFrame:topViewRect];
        [self.view addSubview:topView]; 
    }
    
    //Init the textView and add it to topView
    if (textView.superview == nil) {
        NSLog(@"Adding the textView");
        if (textView == nil){
            NSLog(@"Initializing the textView");
            
        textView = [[CustomTextView alloc] initWithFrame:CGRectMake(0, 0, textViewRect.size.width, textViewRect.size.height)];

        //textView = [[CustomTextView alloc] initWithFrame:CGRectMake(textViewRect.origin.x, -(textViewRect.size.height+textViewRect.origin.y), textViewRect.size.width, textViewRect.size.height)];
        }
        NSLog(@"Adding the textView");
        [self.topView addSubview:textView];
        textView.delegate = self;    
        textView.inputAccessoryView = toolBar;
    }
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, MMM d, yyyy"];    
    timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"h:mm a"];
}

- (void) viewWillAppear:(BOOL)animated{
    
    MyDataObject *myData = [self myDataObject];
    myData.isEditing = [NSNumber numberWithInt:0];
    
    if (self.navigationController.navigationBarHidden == YES){
        self.navigationController.navigationBarHidden = NO;
        }
   
    if (tableViewController.tableView.superview == nil) {
        if (tableViewController == nil) {
            tableViewController = [[CurrentTableViewController alloc]init];
            }
        [self.bottomView addSubview:tableViewController.tableView];
        [tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
        [tableViewController.tableView setSectionHeaderHeight:18];
        tableViewController.tableView.rowHeight = kCellHeight;
        //[tableViewController.tableView setTableHeaderView:tableLabel];
    }
        CGRect startFrame = CGRectMake(0, bottomViewRect.size.height, bottomViewRect.size.width, bottomViewRect.size.height);
        tableViewController.tableView.frame = startFrame;   

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];    
    [UIView setAnimationDelegate:self];
    //textView.frame = CGRectMake(0, 0, textViewRect.size.width, textViewRect.size.height);
    tableViewController.tableView.frame = CGRectMake(0, 0, bottomViewRect.size.width, bottomViewRect.size.height);
   
    [UIView commitAnimations]; 
    
    NSIndexPath *tableSelection = [tableViewController.tableView indexPathForSelectedRow];
	[tableViewController.tableView deselectRowAtIndexPath:tableSelection animated:NO];
    NSLog(@"Current View Controller Subviews: %@", [self.view subviews]);
}

- (void) viewWillDisappear:(BOOL)animated{
    NSLog(@"Current View Controller Subviews: %@", [self.view subviews]);

    NSLog(@"View Will Disappear: removing views");
    [[NSNotificationCenter defaultCenter] removeObserver:nil name: UITableViewSelectionDidChangeNotification object:nil];

    [tableViewController.tableView removeFromSuperview];
    [tableViewController release];
    tableViewController = nil;
    
    [navPopover setDelegate:nil];
    [navPopover release];
    navPopover = nil;
    if (![textView hasText]) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - TextView Management

- (void) textViewDidBeginEditing:(UITextView *)textView{
    UIImage *image = [UIImage imageNamed:@"cancel_white_on_blue_button.png"];

    if (cancelButton == nil) {
        cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [cancelButton setBackgroundImage:image forState:UIControlStateNormal];
        UIBarButtonItem *barbutton = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
        [self.navigationItem setLeftBarButtonItem:barbutton animated:YES];
        [barbutton release];
        [cancelButton addTarget:self action:@selector(cancelAddEvent) forControlEvents:(UIControlEventTouchDown)];
    }
    if (flipIndicatorButton == nil){
        frontViewIsVisible = YES;
        flipIndicatorButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [flipIndicatorButton setBackgroundImage:self.flipperImageForDateNavigationItem forState:UIControlStateNormal];	
        UIBarButtonItem *calendarBarButton;
        calendarBarButton=[[UIBarButtonItem alloc] initWithCustomView:flipIndicatorButton];	
        [self.navigationItem setRightBarButtonItem:calendarBarButton animated:YES];
        [calendarBarButton release];
        [flipIndicatorButton addTarget:self action:@selector(toggleCalendar) forControlEvents:(UIControlEventTouchDown)];
    }
    
}
- (void) textViewDidEndEditing:(UITextView *)textView{
    if (cancelButton != nil) {
        self.navigationItem.leftBarButtonItem = nil;
        cancelButton = nil;
    }
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
    textView.frame = textViewRect;
    tableViewController.tableView.frame = bottomViewRect;
    
    [UIView commitAnimations];
}
- (void) clearAll{
    textView.text = @"";
    [textView becomeFirstResponder];
}

#pragma mark Responding to keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]; // Get the origin of the keyboard when it's displayed.
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
    //Put endframes for views that are to be resized here.
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    //
    [UIView commitAnimations];
}

- (void) dismissKeyboard{
    //Check if textView is firstResponder. If yes, dismiss the keyboard by calling resignFirstResponder;
    if ([textView isFirstResponder]){
        [textView resignFirstResponder];
    }
    if (self.navigationController.navigationBarHidden == YES) {
        [self.navigationController.navigationBar setHidden:NO];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];    
    [UIView setAnimationDelegate:self];                
    //
    [UIView commitAnimations];
    if([navPopover isPopoverVisible]) {
        [navPopover dismissPopoverAnimated:YES];
        [navPopover setDelegate:nil];
        [navPopover autorelease];
        navPopover = nil;
    }
}

#pragma mark - Data Management

- (void) addNewEvent:(id)sender {
    [navPopover dismissPopoverAnimated:YES];
    [self addPickerControls];
    [toolBar toggleSaveAndSetDate];
    [self presentSchedulerPopover:nil];
    
    NSNumber *num = [NSNumber numberWithInt:1];
    NSArray *objects = [NSArray arrayWithObjects: datePicker, toolBar, num, nil];
    NSArray *keys = [NSArray arrayWithObjects: @"picker", @"toolbar",@"num", nil];
    NSDictionary *inputObjects = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopOverShouldUpdateNotification" object:nil userInfo:inputObjects];
    
    
    NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
    [addingContext setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
    
    
    if ([sender tag]==1) {
        newAppointment = [[NewAppointment alloc] init];//Create new instance of delegate class.
        newAppointment.addingContext = addingContext; // pass adding MOC to the delegate instance.
        [newAppointment createNewAppointment:textView.text];//Inserts a new Appointment object and set the text attribute.
        return;
    }
    else {
        newItem = [[NewItemOrEvent alloc] init];
        newItem.addingContext = addingContext;
        [newItem createNewItem:textView.text ofType:[NSNumber numberWithInt:2]];
        
    }
    return;
}

- (void) cancelAddEvent{
    NSLog(@"Cancelling Appointment");
    //release NewAppointment object.
    //return toolBar to base state.
    //???clear text
    return;
}

- (void) saveMemo:(id)sender {    
    if (![textView hasText]){
        return;
    }
    NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
    [addingContext setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
    newItem = [[NewItemOrEvent alloc] init];
    newItem.addingContext = addingContext;
    [newItem createNewItem:textView.text ofType:[NSNumber numberWithInt:0]];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:NSManagedObjectContextDidSaveNotification object:nil];
    [newItem saveNewItem];
    
    [textView setText:@""];
    
    /*--TODO:   SAVE(MEMO/NOTE) option. When the user has added and saved text, then returns to editing but does not add any text. 
     // if (![newTextInput isEqualToString:previousTextInput]){
     --*/
    
    [navPopover dismissPopoverAnimated:YES];
    
    UIImage *image = [UIImage imageNamed:@"cancel_white_on_blue_button.png"];
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [cancelButton setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    [self.navigationItem setLeftBarButtonItem:barbutton animated:YES];
	[barbutton release];
	[cancelButton addTarget:self action:@selector(cancelAddEvent) forControlEvents:(UIControlEventTouchDown)];
    
    
    if ([sender tag]==1) {
        //ADD CODE TO SAVE TO FOLDER
        return;
        }
    else {
        //ADD CODE TO SAVE TO FILE    
        }
    return;
}

- (void) sendItem:(id)sender {
    [navPopover dismissPopoverAnimated:YES];
    UIImage *image = [UIImage imageNamed:@"cancel_white_on_blue_button.png"];
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [cancelButton setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    [self.navigationItem setLeftBarButtonItem:barbutton animated:YES];
	[barbutton release];
	[cancelButton addTarget:self action:@selector(cancelAddEvent) forControlEvents:(UIControlEventTouchDown)];
    
    if ([sender tag]==1) {
        
        //ADD CODE TO SEND EMAIL
        return;
    }
    else {
        //ADD CODE TO SEND MESSAGE   
    }
    return;
}

- (void) doneAction{
    
    MyDataObject *myData = [self myDataObject];
    
    UIImage *addButtonImage = [UIImage imageNamed:@"add_item_white_on_blue_button.png"];
    addButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, addButtonImage.size.width, addButtonImage.size.height)];
    [addButton setBackgroundImage:addButtonImage forState:UIControlStateNormal];	
    UIBarButtonItem *leftButton;
    leftButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
	[self.navigationItem setLeftBarButtonItem:leftButton animated:YES];
    [leftButton release];
	[addButton addTarget:self action:@selector(clearAll) forControlEvents:(UIControlEventTouchDown)];
    
    UIImage *menuButtonImage = [UIImage imageNamed:@"edit_white_on_blue_button.png"];
    UIImage *menuButtonImageHighlighted = [UIImage imageNamed:@"edit.png"];
    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:menuButtonImage forState:UIControlStateNormal];
    [editButton setImage:menuButtonImageHighlighted forState:UIControlStateHighlighted];	
    editButton.frame = CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height);
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    [editButton addTarget:self action:@selector(editSelectedRow) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = menuBarButton;
    [menuBarButton release];
    
    if (!([newItem.newNote.type intValue]==2)) {
        [newAppointment saveNewAppointment];
        
        newAppointment.newAppointment.text = textView.text;
        NSString *selectedDate = [dateFormatter stringFromDate:newAppointment.newAppointment.doDate];
        NSString *selectedStart = [timeFormatter stringFromDate:newAppointment.newAppointment.doTime];
        NSString *selectedEnd = [timeFormatter stringFromDate:newAppointment.newAppointment.endTime];
        NSMutableString *text = [NSMutableString stringWithFormat:@"Scheduled Date: %@\nStarts At: %@. Ends At: %@\n\n%@",selectedDate, selectedStart, selectedEnd, newAppointment.newAppointment.text];
        textView.text = text;        
        if (newAppointment.newAppointment.doDate == nil || newAppointment.newAppointment.text == @""){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Appointment Date or Text" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
    } else {
        
        [newItem saveNewItem];  
        if (newItem.newNote.doDate == nil || newItem.newNote.text == @""){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Appointment Date or Text" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            
            return;
        }
    }
    [bottomView addSubview:tableViewController.tableView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    tableViewController.tableView.frame = CGRectMake(0, 0, bottomViewRect.size.width, bottomViewRect.size.height);
    [textView setFrame:textViewRect];
    [UIView commitAnimations];
    
    [textView setUserInteractionEnabled:NO];
    
    myData.selectedAppointment = nil;
    myData.selectedTask = nil;
    myData.isEditing = [NSNumber numberWithInt:0];
    
}


#pragma mark - ToolBar and NavigationBar Management...


- (UIImage *)flipperImageForDateNavigationItem {
	// returns a 30 x 30 image to display the flipper button in the navigation bar
	CGSize itemSize=CGSizeMake(30.0,30.0);
	UIGraphicsBeginImageContext(itemSize);
	UIImage *backgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"calendar_white_on_blue_button.png"]];
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

- (void) toggleCalendar{
    if (calendarView == nil) {
        calendarView = 	[[TKCalendarMonthView alloc] init];        
        calendarView.delegate = self;
        calendarView.dataSource = self;
       
        [self.topView addSubview:calendarView];
        [calendarView reload];
        calendarView.frame = CGRectMake(0, screenRect.size.height, calendarView.frame.size.width, calendarView.frame.size.height);
        }
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationDelegate:self];
    
        if (frontViewIsVisible == YES){
            CGRect frame = topViewRect;
            frame.size.height = calendarView.frame.size.height;
            topView.frame = frame;
            [textView resignFirstResponder];
            calendarView.frame = CGRectMake(0, 0 , calendarView.frame.size.width, calendarView.frame.size.height);
                       }
        else{
            topView.frame = topViewRect;
            [textView becomeFirstResponder];
            calendarView.frame = CGRectMake(0, screenRect.size.height, calendarView.frame.size.width, calendarView.frame.size.height);
            }
            
        [UIView commitAnimations];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(myTransitionDidStop:finished:context:)];
    
        if (frontViewIsVisible==YES) {
            UIImage *image = [UIImage imageNamed:@"edit_white_on_blue_button.png"];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:flipIndicatorButton cache:YES];
            [flipIndicatorButton setBackgroundImage:image forState:UIControlStateNormal];
        } 
        else {
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:flipIndicatorButton cache:YES];
            [flipIndicatorButton setBackgroundImage:self.flipperImageForDateNavigationItem forState:UIControlStateNormal];
        }
        [UIView commitAnimations];
        frontViewIsVisible=!frontViewIsVisible;        
}

- (void) addPickerControls {
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
}

- (void) look: (id) sender {
    return;
}


#pragma mark - Popover Management

- (void) presentActionsPopover:(id)sender{
    
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

    if(!navPopover) {
        navPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        [navPopover setDelegate:self];
        } 
    
    if([navPopover isPopoverVisible]) {
        [navPopover dismissPopoverAnimated:YES];
        [navPopover setDelegate:nil];
        [navPopover autorelease];
        navPopover = nil;
            } else {
        
            if ([sender tag] == 1) {
            NSLog(@"Saving");
            [self saveMemo:nil];
            [button1 setImage:[UIImage imageNamed:@"folder_button.png"] forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(saveToFolder) forControlEvents:UIControlEventTouchUpInside];
            [button1 setTag:1];
            [button2 setImage:[UIImage imageNamed:@"files_button.png.png"] forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(saveToFile) forControlEvents:UIControlEventTouchUpInside];
            [button2 setTag:2];
            [label1 setText:@"To Folder"];
            [label2 setText:@"To File"];
            
                            [navPopover presentPopoverFromRect:CGRectMake(20, 205, 50, 40)
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
            [button1 addTarget:self action:@selector(addNewEvent:) forControlEvents:UIControlEventTouchUpInside];
            [button1 setTag:2];
            [button2 setImage:[UIImage imageNamed:@"appointment_button.png"] forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(addNewEvent:) forControlEvents:UIControlEventTouchUpInside];
            [button2 setTag:1];
            [label1 setText:@"Task"];
            [label2 setText:@"Appointment"];
            [navPopover presentPopoverFromRect:CGRectMake(90, 205, 50, 40)
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
            [button1 addTarget:self action:@selector(sendItem:) forControlEvents:UIControlEventTouchUpInside];
            
            [button2 setImage:[UIImage imageNamed:@"message_button.png"] forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(sendItem:) forControlEvents:UIControlEventTouchUpInside];
            [label1 setText:@"Email"];
            [label2 setText:@"Message"];
            [navPopover presentPopoverFromRect:CGRectMake(205, 205, 50, 50) inView:self.view
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

- (void)presentSchedulerPopover:(id)sender {//CREATE THE POPOVER AND ADD TO THE VIEW
    //if (self.navigationController.navigationBarHidden == NO) {
    //    self.navigationController.navigationBarHidden = YES;
    //}
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
    if(!schedulerPopover) {
        
       // if (![[schedulerPopover returnName] isEqualToString:@"Scheduler"]) {
       //     NSLog(@"schedulerPopover is not Scheduler");
       //     [self cancelPopover:nil];
       // }

        [schedulerPopover addName:@"Scheduler"];
        SchedulePopoverViewController *viewCon = [[SchedulePopoverViewController alloc]init];
       // [viewCon.button1 addTarget:self action:@selector(cancelPopover:) forControlEvents:UIControlEventTouchUpInside];
        
        viewCon.tableViewController = self.tableViewController;
        viewCon.contentSizeForViewInPopover = CGSizeMake(300, 140);
        schedulerPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
        [schedulerPopover setDelegate:self];
        [viewCon release];
    }
    [schedulerPopover presentPopoverFromRect:CGRectMake(15, 205, 0, 57) inView:self.view 
        permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES name:@"Scheduler"];
    
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

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Did dismiss");
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Should dismiss");
    return YES;
}

- (void)myTransitionDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	// re-enable user interaction when the flip is completed.
	//flipIndicatorButton.userInteractionEnabled = YES;
    //flipperView.userInteractionEnabled = YES;
}


#pragma mark - PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component{
    NSNumber *num = [NSNumber numberWithInt:7];
    NSArray *objects = [NSArray arrayWithObjects:num, nil];
    NSArray *keys   = [NSArray arrayWithObjects:@"num", nil];
    NSDictionary *inputObjects = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    MyDataObject *myData = [self myDataObject];
    if ([myData.noteType intValue] == 1) {
        newAppointment.newAppointment.recurring = [recurring objectAtIndex:row];
        }
    else {
        newItem.recurring = [recurring objectAtIndex:row];
        newAppointment.newAppointment.recurring = [recurring objectAtIndex:row];
        }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopOverShouldUpdateNotification"object:newAppointment.newAppointment userInfo:inputObjects];
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


- (void) setAlarm {
    return;
}

#pragma mark - Scheduling Appointments and Tasks
- (void) addDateField{
    
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
    if (newAppointment.newAppointment != nil){
        newAppointment.newAppointment.doDate = selectedDate;
    }
    else if (newItem.newNote != nil){
        newItem.newNote.doDate = selectedDate;
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
        [toolBar toggleSetDateAndSetStart];
        
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
            newAppointment.newAppointment.doTime = selectedTime;
        }
        else {
            [timeComponents setHour:0];
            [timeComponents setMinute:0];
            [timeComponents setSecond:0];
            selectedTime = [calendar dateFromComponents:timeComponents];
            newItem.newNote.doTime = selectedTime;
        }
    }
}
- (void) addEndTimeField{
    if ([schedulerPopover isPopoverVisible]) {
        [toolBar toggleSetStartAndSetEnd];
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
            newAppointment.newAppointment.endTime = selectedTime;
        }
        else {
            [timeComponents setHour:0];
            [timeComponents setMinute:0];
            [timeComponents setSecond:0];
            selectedTime = [calendar dateFromComponents:timeComponents];
            newItem.newNote.endTime = selectedTime;
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PopOverShouldUpdateNotification"object:newAppointment.newAppointment userInfo:inputObjects];
    }
}
- (void) setRecurrance:(id)sender{
    [self cancelPopover:nil];
    [textView becomeFirstResponder];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem  = rightButton;
    [rightButton release];
    self.navigationItem.rightBarButtonItem.tag = 1;
    [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain]; 
    return;
}

#pragma mark - TableView Management


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


#pragma mark -


@end
/*
- (void) saveToFile{
    //FIXME: Save the memo/note and pass it to the folder view
    
    [self.tabBarController setSelectedIndex:2];
    [textView setText:@""];
    [textView resignFirstResponder];
    [navPopover dismissPopoverAnimated:YES];
    
    return;
}

- (void) saveToFolder{
    //FIXME: Save the memo/note. Pass it to the FolderView
    [self.tabBarController setSelectedIndex:2];
    [textView setText:@""];
    [textView resignFirstResponder];
    [navPopover dismissPopoverAnimated:YES];
    return;
}

*/
/*
 - (void) addNewAppointment {
 MyDataObject *myData = [self myDataObject];
 [myData setMyText:textView.text];
 [myData setNoteType:[NSNumber numberWithInt:1]];
 [myData setIsEditing:[NSNumber numberWithInt:1]];
 [self.tabBarController setSelectedIndex:1];    
 [textView setText:@""];
 [textView resignFirstResponder];
 [navPopover dismissPopoverAnimated:YES];
 return;
 }
 
 - (void) addNewTask {
 MyDataObject *myData = [self myDataObject];    
 [myData setMyText:textView.text];
 [myData setNoteType:[NSNumber numberWithInt:2]];
 [myData setIsEditing:[NSNumber numberWithInt:1]];
 [self.tabBarController setSelectedIndex:1];
 [textView setText:@""];
 [textView resignFirstResponder];
 [navPopover dismissPopoverAnimated:YES];
 return;
 }
 
 */

/*
 // Create a new managed object context for the new task -- set its persistent store coordinator to the same as that for the fetched results controller's context.
 NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
 addViewController.managedObjectContext = addingContext;
 [addingContext release];	
 [addViewController.managedObjectContext setPersistentStoreCoordinator:[[tableViewController.fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
 NSLog(@"After managedObjectContext: %@",  addViewController.managedObjectContext);
 [addViewController release];
 */
/*

 - (void) animateViews:(UIView *)view startFrom:(CGRect)fromFrame endAt:(CGRect)toFrame{
 view.frame = fromFrame;
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationDuration:0.4];    
 [UIView setAnimationDelegate:self];
 view.frame = toFrame;
 [UIView commitAnimations];    
 }
 - (void) swapViews {
 
 CATransition *transition = [CATransition animation];
 transition.duration = 1.0;
 transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 [transition setType:@"kCATransitionPush"];	
 [transition setSubtype:@"kCATransitionFromLeft"];
 
 swappingViews = YES;
 transition.delegate = self;
 [self.view.layer addAnimation:transition forKey:nil];
 
 }

- (void) makeActionSheet:(id) sender{
    // UIBarButtonItem *actionButton = sender;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"DO" delegate:self cancelButtonTitle:@"Later" destructiveButtonTitle:nil otherButtonTitles:@"Save to Folder", @"Append to File", @"Send as Email", @"Send as Message", nil];
    //[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    actionSheet.layer.backgroundColor = [UIColor blueColor].CGColor;
    //[actionSheet showFromBarButtonItem:actionButton animated:YES];
    //[actionSheet showInView:self.view];
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(50, 340, 220, 65)];
    CGRect myframe = CGRectMake(myView.frame.origin.x, myView.frame.origin.y, myView.frame.size.width, myView.frame.size.height);
    CALayer *mylayer = [[CALayer alloc] init];
    [mylayer setFrame:myframe];
    [mylayer setCornerRadius:10.0];
    [myView.layer addSublayer:mylayer];
    [myView.layer setMask:mylayer];
    [actionSheet showInView:myView];
    [actionSheet setAlpha:0.6];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
    [myView release];
    [mylayer release];
    [textView becomeFirstResponder];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 4:
            NSLog(@"Cancel Button Clicked on Main View action sheet");
            break;
        case 3:   
            NSLog(@"4nd Button Clicked on action sheet");
            break;
        case 2:
            NSLog(@"3nd Button Clicked on action sheet");
            break;
        case 1:
            //  if ([textView hasText] || rightLabel.superview == nil) {
            //  [self.view addSubview:rightLabel];
            //[rightLabel setPlaceholder:@"New File"];
            //  CGRect startFrame = CGRectMake(320, textView.frame.origin.y+textView.frame.size.height+15, 154,30);
            //CGRect endFrame = CGRectMake(165, textView.frame.origin.y+textView.frame.size.height+15, 154,30);
            //[self animateViews:rightLabel startFrom:startFrame endAt:endFrame]; 
            //}
            break;
        case 0:
            //if ([textView hasText]) {
            //    [self.view addSubview:rightLabel];
            //    //[rightLabel setPlaceholder:@"New Folder:"];
            //    CGRect startFrame = CGRectMake(320, textView.frame.origin.y+textView.frame.size.height+15, 154,30);
            //  CGRect endFrame = CGRectMake(165, textView.frame.origin.y+textView.frame.size.height+15, 154,30);
            //   [self animateViews:rightLabel startFrom:startFrame endAt:endFrame];
            // }
            break;
        default:
            break;
    }
}
*/

