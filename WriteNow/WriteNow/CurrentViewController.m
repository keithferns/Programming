//  CurrentViewController.m
//  WriteNow
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "ControlVariables.h"
#import "CurrentViewController.h"
#import "WriteNowAppDelegate.h"
#import "CurrentTableViewController.h"
#import "CalendarTableViewController.h"
#import "MyDataObject.h"
#import "AppDelegateProtocol.h"
#import "NSDate+TKCategory.h"

@implementation CurrentViewController

@synthesize managedObjectContext, tableViewController, textView, topView, bottomView, toolBar;
@synthesize navPopover, schedulerPopover, reminderPopover, datePicker, timePicker, pickerView;
@synthesize recurring, addField, calendarView, newItem,dateFormatter, timeFormatter;
@synthesize flipperImageForDateNavigationItem, flipIndicatorButton, cancelButton, addButton, editButton, saveButton;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displaySelectedRow:) name:UITableViewSelectionDidChangeNotification object:nil];
    
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
    
    NSLog(@"TextView did begin editing");
    [self toggleLeftBarButtonItem:nil]; 
    [self toggleRightBarButtonItem:nil];
   
}

-(void) textViewDidChange:(UITextView *)textView{
    if (self.navigationItem.leftBarButtonItem == nil) { 
    //Check if the leftNavigationItem is visible. If YES, then call toggleLeftBarButton to set CANCEL
    [self toggleLeftBarButtonItem:nil]; 
    // call toggleRightButton to set Done
        [self toggleRightBarButtonItem:nil];
    }

}
- (void) textViewDidEndEditing:(UITextView *)textView{    
    // textView is no longer firstResponder. Call toggleLeftBarButton to set ADDNNEW
    [self toggleLeftBarButtonItem:nil];
    //call toggleRightBarButton to set DONE or EDIT
    [self toggleRightBarButtonItem:nil];
}

- (void) setEditingView {//Called only when on calendar/tv view
    MyDataObject *myData = [self myDataObject];
    if (textView !=nil) {
        [textView removeFromSuperview];
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
    
    [self toggleLeftBarButtonItem:nil];
    [self toggleRightBarButtonItem:nil];
   
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    textView.frame = textViewRect;
    tableViewController.tableView.frame = bottomViewRect;
    
    [UIView commitAnimations];
}
- (void) clearAll{
    if ([schedulerPopover isPopoverVisible]) {
        [self cancelPopover:nil];
    }
    textView.text = @"";
    [textView resignFirstResponder];
    [newItem deleteItem:nil];
    [toolBar toggleDateButton:nil];
    self.navigationItem.leftBarButtonItem = nil;
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
    if ([textView isFirstResponder]){//if textView is firstResponder, textview resigns first responder;
        [textView resignFirstResponder];
    }
    if ([tableViewController.tableView superview] != nil){//If the tableView is in view, remove it from the superView.
        [tableViewController.tableView removeFromSuperview];
    }
    if (tableViewController.tableView == nil){
        //re-initialize
    }
    [self.bottomView addSubview:tableViewController.tableView];
    tableViewController.tableView.frame = CGRectMake(0, screenRect.origin.y, bottomViewRect.size.width, bottomViewRect.size.height);
    [tableViewController.tableView reloadData];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];    
    [UIView setAnimationDelegate:self];                

    tableViewController.tableView.frame = CGRectMake(0, 0, bottomViewRect.size.width, bottomViewRect.size.height);
    [UIView commitAnimations];
    if([navPopover isPopoverVisible]) {
        [navPopover dismissPopoverAnimated:YES];
        [navPopover setDelegate:nil];
        [navPopover autorelease];
        navPopover = nil;
    }
}

#pragma mark - Display and Edit

- (void) displaySelectedRow:(NSNotification *) notification {
        NSLog(@"In displaySelectedRow Method");
    if ([notification object] != nil){
        NSLog(@"Notification Object is NOT NIL");
    }
    if ([[notification object] isKindOfClass:[Appointment class]]) {
         NSLog(@"THE SELECTED NOTIFICATION OBJECT IS AN APPOINTMENT");
         self.navigationItem.title = @"Appointment";//FIXME: show the title of the appointment
         Appointment *temp = [notification object];
         NSString *selectedDate = [dateFormatter stringFromDate:temp.doDate];
         NSString *selectedStart = [timeFormatter stringFromDate:temp.doTime];
         NSString *selectedEnd = [timeFormatter stringFromDate:temp.endTime];
         NSMutableString *text = [NSMutableString stringWithFormat:@"Scheduled Date: %@\nStarts At: %@. Ends At: %@\n\n%@",selectedDate, selectedStart, selectedEnd, temp.text];
         textView.text = text;      
     } 
     else if ([[notification object] isKindOfClass:[Task class]]){
         NSLog(@"THE SELECTED NOTIFICATION OBJECT IS A TASK");
         self.navigationItem.title = @"To Do";//FIXME: show the title of the todo
         Task *temp = [notification object];
         NSString *selectedDate = [dateFormatter stringFromDate:temp.doDate];
         NSMutableString *text = [NSMutableString stringWithFormat:@"Scheduled Date: %@\n\n%@",selectedDate, temp.text];
         textView.text = text;  
     }
     else if ([[notification object] isKindOfClass:[Memo class]]){
         NSLog(@"THE SELECTED NOTIFICATION OBJECT IS A MEMO");
         self.navigationItem.title = @"Memo";
         Memo *temp = [notification object];
         NSString *creationDate = [dateFormatter stringFromDate:temp.creationDate];
         NSMutableString *text = [NSMutableString stringWithFormat:@"%@\n%@", creationDate, temp.text];
         textView.text = text;
     }
    if (textView == nil){//TEXTVIEW: setup and add to self.view
        textView = [[CustomTextView alloc] initWithFrame:textViewRect];
        [self.topView addSubview:textView];
    }
    [textView setUserInteractionEnabled:NO];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    textView.frame = CGRectMake(0, 0, textViewRect.size.width, textViewRect.size.height);
    [self toggleRightBarButtonItem:nil];  //
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

#pragma mark - Data Management

- (void) addNewEvent:(id)sender {
    [navPopover dismissPopoverAnimated:YES];//Remove the presentActions Popover from view
    [self addPickerControls:nil]; //add the datePicker, timePicker and recurring pickerView to the mix
    [toolBar toggleDateButton:sender]; // Change the first and second button from save and plan to setDate and setReminder buttons
    [self presentSchedulerPopover:nil]; //Bring up the schedulePopover
    NSNumber *num = [NSNumber numberWithInt:1];
    NSArray *objects = [NSArray arrayWithObjects: datePicker, toolBar, num, nil];
    NSArray *keys = [NSArray arrayWithObjects: @"picker", @"toolbar",@"num", nil];
    NSDictionary *inputObjects = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopOverShouldUpdateNotification" object:nil userInfo:inputObjects];
    NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
    [addingContext setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
    newItem = [[NewItemOrEvent alloc] init];//Create new instance of delegate class.
    newItem.addingContext = addingContext; // pass adding MOC to the delegate instance.
    if ([sender tag]==1) {
        [newItem createNewItem:textView.text ofType:[NSNumber numberWithInt:1]];//Method in NewItemOrEvent inserts a new Note object into adding MOC and sets the text attribute to textView.text and sets the type to Appointment
        return;
    }
    else {
        [newItem createNewItem:textView.text ofType:[NSNumber numberWithInt:2]];//Method in NewItemOrEvent inserts a new Note object into adding MOC and sets the text attribute to textView.text and sets the type to Task
        return;
    }
}

- (void) saveMemo:(id)sender {    
    NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
    [addingContext setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
    
    newItem = [[NewItemOrEvent alloc] init];
    newItem.addingContext = addingContext;
    [newItem createNewItem:textView.text ofType:[NSNumber numberWithInt:0]];    
    [newItem saveNewItem];
    
    /*--TODO:   SAVE(MEMO/NOTE) option. When the user has added and saved text, then returns to editing but does not add any text. 
     // if (![newTextInput isEqualToString:previousTextInput]){
     --*/
    [navPopover dismissPopoverAnimated:YES];
    [self toggleLeftBarButtonItem:nil]; //Adds the Cancel button to NavBar
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
    [self toggleLeftBarButtonItem:nil];
    
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
    [self toggleLeftBarButtonItem:nil];
    [self toggleRightBarButtonItem:nil];
    newItem.newNote.text = textView.text; // set the text for the new note to current value of the textView
    NSString *selectedDate = [dateFormatter stringFromDate:newItem.newNote.doDate]; 
    NSString *selectedStart = [timeFormatter stringFromDate:newItem.newNote.doTime];
    NSString *selectedEnd = [timeFormatter stringFromDate:newItem.newNote.endTime];
    [newItem saveNewItem]; //save the newNote as Appointment, task or memo. delete newNote.
    if (newItem.newAppointment != nil) {
        if (newItem.newAppointment.doDate == nil || newItem.newAppointment.text == @""){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Appointment Date or Text" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            //return user to the missing input view. if text is missing, make textView first responder etc.
            return;
            }
        NSMutableString *text = [NSMutableString stringWithFormat:@"Scheduled Date: %@\nStarts At: %@. Ends At: %@\n\n%@",selectedDate, selectedStart, selectedEnd, textView.text];
        textView.text = text;         
        }
     else if (newItem.newTask != nil) {
        if (newItem.newTask.doDate == nil || newItem.newTask.text == @""){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Appointment Date or Text" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            //return user to the missing input view. if text is missing, make textView first responder etc.
            return;
        }
         NSMutableString *text = [NSMutableString stringWithFormat:@"Due Date: %@\n\n%@",selectedDate, textView.text];
         textView.text = text;  
     }  
    else if (newItem.newMemo != nil){
        if (newItem.newTask.doDate == nil || newItem.newTask.text == @""){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Appointment Date or Text" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            //return user to the missing input view. if text is missing, make textView first responder etc.
            return;   
        }
        NSMutableString *text = [NSMutableString stringWithFormat:@"Created: %@\n\n%@",selectedDate, textView.text];
        textView.text = text;  
    }
    [bottomView addSubview:tableViewController.tableView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    tableViewController.tableView.frame = CGRectMake(0, 0, bottomViewRect.size.width, bottomViewRect.size.height);
    [textView setFrame:CGRectMake(0, 0, textViewRect.size.width, textViewRect.size.height)];
    [UIView commitAnimations];
    [textView setUserInteractionEnabled:NO];
}

#pragma mark - ToolBar and NavigationBar Management...

- (void) toggleLeftBarButtonItem:(id) sender {//Left Nav Button is CANCEL if [textView isEditing] <-> is ADDNEW if[textView setUserInteractionEnabled:NO] and [textView hasText]
    if ([textView isFirstResponder] && [textView hasText]){
    UIImage *image = [UIImage imageNamed:@"cancel_white_on_blue_button.png"];
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [cancelButton setBackgroundImage:image forState:UIControlStateNormal];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    //UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(clearAll)];
    [self.navigationItem setLeftBarButtonItem:leftButton animated:YES];
	[leftButton release];
	[cancelButton addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    }
    else if ([textView hasText] && textView.userInteractionEnabled == NO) {
    UIImage *image = [UIImage imageNamed:@"add_item_white_on_blue_button.png"];
    addButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [addButton setBackgroundImage:image forState:UIControlStateNormal];	
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:addButton];
	[self.navigationItem setLeftBarButtonItem:leftButton animated:YES];
    [leftButton release];
	[addButton addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void) toggleRightBarButtonItem:(id) sender{//is DONE if [textView isEditing] <-> is EDIT if [textView setUserInteractionEnabled:NO] and [textView hasText]
    if ([textView isFirstResponder] && [textView hasText]) {
        //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
        UIImage *image = [UIImage imageNamed:@"save_white_on_blue_button.png"];
        saveButton= [UIButton buttonWithType:UIButtonTypeCustom];
        [saveButton setImage:image forState:UIControlStateNormal];
        [saveButton setImage:image forState:UIControlStateHighlighted];
        saveButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
        self.navigationItem.rightBarButtonItem  = rightButton;
        [rightButton release];
        self.navigationItem.rightBarButtonItem.tag = 1;
        [saveButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([textView hasText] && textView.userInteractionEnabled == NO) {
        UIImage *image = [UIImage imageNamed:@"edit_white_on_blue_button.png"];
        editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [editButton setImage:image forState:UIControlStateNormal];
        [editButton setImage:image forState:UIControlStateHighlighted];
        editButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:editButton];
        [editButton addTarget:self action:@selector(editSelectedRow) forControlEvents:UIControlEventTouchUpInside];
        //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editSelectedRow)];
        [rightButton setStyle:UIBarButtonItemStyleBordered];
        self.navigationItem.rightBarButtonItem = rightButton;
        [rightButton release];

    }
    else if (calendarView.frame.origin.y == 0) {//toggleCalendar
        UIImage *image = [UIImage imageNamed:@"edit_white_on_blue_button.png"];
        editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [editButton setImage:image forState:UIControlStateNormal];
        [editButton setImage:image forState:UIControlStateHighlighted];
        editButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:editButton];
        [editButton addTarget:self action:@selector(toggleCalendar:) forControlEvents:UIControlEventTouchUpInside];
        [editButton setTag:23];
        //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editSelectedRow)];
        [rightButton setStyle:UIBarButtonItemStyleBordered];
        self.navigationItem.rightBarButtonItem = rightButton;
        [rightButton release];
    }
}

- (void) toggleCalendar: (id) sender {//Right Nav button if [textView setUserInteractionEnabled:YES] and NOT[textView isEditing]
    NSLog(@"Display Calendar");
    if (calendarView == nil) {
        calendarView = 	[[TKCalendarMonthView alloc] init];        
        calendarView.delegate = self;
        calendarView.dataSource = self;
        [self.topView addSubview:calendarView];
        [calendarView reload];
        calendarView.frame = CGRectMake(0, screenRect.size.height, calendarView.frame.size.width, calendarView.frame.size.height);
    }
    [tableViewController.tableView removeFromSuperview];
    tableViewController = nil;
    tableViewController = [[CalendarTableViewController alloc]init];
    tableViewController.tableView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-calendarView.frame.size.height);
    [topView addSubview:tableViewController.tableView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.45];
    [UIView setAnimationDelegate:self];
    
    if ([sender tag] == 3){
    CGRect frame = topViewRect;
    frame.size.height = kScreenHeight;
    topView.frame = frame;
    [textView resignFirstResponder];
    calendarView.frame = CGRectMake(0, 0 , calendarView.frame.size.width, calendarView.frame.size.height);
    tableViewController.tableView.frame = CGRectMake(0, calendarView.frame.size.height,kScreenWidth, kScreenHeight-calendarView.frame.size.height);

    }
    else if ([sender tag] == 23){
        [textView becomeFirstResponder];
        topView.frame = topViewRect;
        calendarView.frame = CGRectMake(0, kScreenRect.size.height , calendarView.frame.size.width, calendarView.frame.size.height);
        self.navigationItem.rightBarButtonItem = nil;
    }
    [UIView commitAnimations];         
}

#pragma mark - Picker Methods and PickerView Delegate Methods

- (void) addPickerControls:(id)sender {
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

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component{
    NSNumber *num = [NSNumber numberWithInt:7];
    NSArray *objects = [NSArray arrayWithObjects:num, nil];
    NSArray *keys   = [NSArray arrayWithObjects:@"num", nil];
    NSDictionary *inputObjects = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    newItem.recurring = [recurring objectAtIndex:row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PopOverShouldUpdateNotification" object:newItem.recurring userInfo:inputObjects];
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

#pragma mark - Popover Management
- (void) presentActionsPopover:(id)sender{
    if (![textView hasText]){
        if ([sender tag] == 1 || [sender tag] == 4) {
            return;
        }
    }
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
            [button1 setTag:15];
            [button2 setImage:[UIImage imageNamed:@"appointment_button.png"] forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(addNewEvent:) forControlEvents:UIControlEventTouchUpInside];
            [button2 setTag:16];
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

    [tableViewController.tableView removeFromSuperview];
	//[textView removeFromSuperview];
    //[self.view addSubview:textView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];    
    textView.frame = CGRectMake(5, 0, textViewRect.size.width-10, textViewRect.size.height);
    [UIView commitAnimations];
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
- (void)presentReminderPopover:(id)sender { //Create Popover to set Alarms
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

#pragma mark - TKCalendarMonthViewDelegate methods


- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)d {
	NSLog(@"calendarMonthView didSelectDate: %@", d);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetDateNotification" object:d userInfo:nil]; 

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

- (void) look: (id) sender {
    return;
}


#pragma mark - Scheduling Appointments and Tasks
- (void) addDateField{
    return;
}

- (void)datePickerChanged:(id)sender{
    NSLog(@"DatePicker Changed");
    //TKDateInformation info = [[datePicker date] dateInformation];
    //[dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm"];
    NSLog(@"DatePicker Changed");
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit) fromDate:[datePicker date]];
    // [dateComponents setYear:[dateComponents year]];
    // [dateComponents setMonth:[dateComponents month]];
    // [dateComponents setDay:[dateComponents day]];
    
    NSDate *selectedDate = [calendar dateFromComponents:dateComponents];
    
    [calendar release];
    NSLog(@"SELECTED DATE: %@", selectedDate);

    if (newItem.newNote != nil){
        NSLog(@"method:datePickerChanged. newItem.newNote is not nil");
        [newItem updateSelectedDate:selectedDate];
    }
    NSNumber *num = [NSNumber numberWithInt:2];
    NSArray *objects = [NSArray arrayWithObjects:num, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"num", nil];
    NSDictionary *inputObjects = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetDateNotification" object:selectedDate userInfo:inputObjects]; 
    
}
- (void) setAppointmentDate:(id)sender{
    if (!schedulerPopover || ![schedulerPopover isPopoverVisible]) {//CASE:the popOver has not been created or is not visible.
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
        [toolBar toggleStartButton:nil];
        
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
    NSLog(@"In setStartTime method");
    if (!schedulerPopover || ![[schedulerPopover returnName] isEqualToString:@"Scheduler"]){
        [self cancelPopover:nil];
        [self presentSchedulerPopover:nil];
        addField = 2;
    }
    
    //CASE: the popOver in view, TIMEPICKER time selected and  STARTTIME button tapped -> 
    else if ([schedulerPopover isPopoverVisible]) {
        NSLog(@"Calling method:addEndTimeField");
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
            newItem.newNote.doTime = selectedTime;
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
        [toolBar toggleEndButton:nil];
        //PostNotification to schedulepopover  
        NSNumber *num = [NSNumber numberWithInt:5];
        NSArray *objects = [NSArray arrayWithObjects:self.timePicker, self.toolBar, num, nil];
        NSArray *keys = [NSArray arrayWithObjects:@"picker", @"toolbar", @"num",nil];
        NSDictionary *inputObjects = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PopOverShouldUpdateNotification"object:newItem.newNote userInfo:inputObjects];
    }
}
- (void) setEndTime:(id)sender{
    //Put end time in popOver view
    if (!schedulerPopover || ![schedulerPopover isPopoverVisible]) {
        [self presentSchedulerPopover:nil];
        addField = 3;
    }
    //CASE: popOver in view, TIMEPICKER time selected and the ENDTIME button is tapped --> 
    else if ([schedulerPopover isPopoverVisible]) {
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
            newItem.newNote.endTime = selectedTime;
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
        [toolBar toggleRecurButton:nil];
        [self toggleRightBarButtonItem:nil];
        //Post Notification to schedulepopover  
        NSNumber *num = [NSNumber numberWithInt:6];
        NSArray *objects = [NSArray arrayWithObjects:self.pickerView, self.toolBar, num, nil];
        NSArray *keys = [NSArray arrayWithObjects:@"picker", @"toolbar", @"num",nil];
        NSDictionary *inputObjects = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PopOverShouldUpdateNotification"object:newItem userInfo:inputObjects];
    }
}
- (void) setRecurrance:(id)sender{
    NSLog(@"calling method:setRecurrance");
    [self cancelPopover:nil];
    [self toggleRightBarButtonItem:self];

    [textView becomeFirstResponder];
    
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


@end

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

