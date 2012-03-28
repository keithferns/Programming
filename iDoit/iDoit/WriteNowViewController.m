//
//  WriteNowViewController.m
//  iDoit
//
//  Created by Keith Fernandes on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iDoitAppDelegate.h"
#import "WriteNowViewController.h"
#import "WriteNowTableViewController.h"
#import "ArchiveViewController.h"
#import "CalendarViewController.h"
#import "UINavigationController+NavControllerCategory.h"
#import "Contants.h"


@implementation WriteNowViewController

@synthesize managedObjectContext, tableViewController;

@synthesize topView, bottomView, textView, cover;
@synthesize toolbar;
@synthesize calendarView, actionsPopover;
@synthesize doubleTapOnTextView, singleTapOnTextView;
@synthesize theItem;

#pragma mark - Memory Management

- (void)dealloc {
    [super dealloc];
    [managedObjectContext release];
    [tableViewController release];
    [topView release];
    [bottomView release];
    [cover release];
    [textView release];
    [calendarView release];
    [toolbar release];
    [actionsPopover release];
    [theItem release];
}

- (void)viewDidUnload {
    [super viewDidUnload];

    topView = nil;
    bottomView = nil;
    textView = nil;
    calendarView = nil;
    cover = nil;
    toolbar = nil;
    tableViewController =nil;
    actionsPopover = nil;
    theItem = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];   
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"WriteNowViewController: Memory Warning Received");
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    isScrolling = NO;
    
    NSLog(@"The date is %@", [NSDate date]);

    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    // NSDateComponents *components = [calendar components:(NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit) fromDate:[self aDate]];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit |NSMonthCalendarUnit |NSDayCalendarUnit) fromDate:[NSDate date]];
    
    NSString *tmp = [NSString stringWithFormat:@"%d", (([components year] * 1000000) + ([components month] *1000) + [components day])];
    NSLog(@"%@", tmp);
          
    //Navigation Bar
    self.navigationController.navigationBar.topItem.title = @"Write Now";    
    
    //Init and add the top and bottom Views. These views will be used to animate the transitions of textView and the table and calendar Views. 
    if (bottomView.superview == nil && bottomView == nil) {
        bottomView = [[UIView alloc] initWithFrame:kBottomViewRect];
        bottomView.backgroundColor = [UIColor blackColor];
    }
    if (topView.superview == nil && topView == nil) {
        topView = [[UIView alloc] initWithFrame:kTopViewRect];
        topView.backgroundColor = [UIColor blackColor];
    }    
    //View Heirarchy: topView - bottomview
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];
    
    //Initialize the toolbar. disable 'save' and 'send' buttons.
    if (toolbar == nil) {

    toolbar = [[CustomToolBar alloc] init];
    [toolbar.firstButton setTarget:self];
    [toolbar.secondButton setTarget:self];
    [toolbar.thirdButton setTarget:self];
    [toolbar.fourthButton setTarget:self];
    [toolbar.fifthButton setTarget:self];
    }
    
    //Initialize and add the textView. the TV is a basic part of initial view.     
    if (textView.superview == nil) {
        if (textView == nil){
            textView = [[UITextView alloc] initWithFrame:kTextViewRect];
            
            textView.textColor = [UIColor whiteColor];
            textView.showsVerticalScrollIndicator = YES;
            UIImage *patternImage = [UIImage imageNamed:@"54700.png"];
            
            //UIImage *patternImage = [UIImage imageNamed:@"textview_background.png"];
            [textView.layer setBackgroundColor:[UIColor colorWithPatternImage:patternImage].CGColor];
            textView.layer.cornerRadius = 5.0;
            
            [textView setFont:[UIFont systemFontOfSize:18]];
            textView.layer.borderWidth = 2.0;
            textView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        }
        [self.topView addSubview:textView];
        textView.delegate = self;    
        textView.inputAccessoryView = toolbar;

    }
        
    /*-- Point current instance of the MOC to the main managedObjectContext --*/
	if (managedObjectContext == nil) { 
		managedObjectContext = [(iDoitAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"CURRENT VIEWCONTROLLER: After managedObjectContext: %@",  managedObjectContext);
	}    
    
    //Initialize the table view controller. the tableView added only in ViewWillAppear.
    
        if (self.tableViewController == nil) {
               self.tableViewController = [[[WriteNowTableViewController alloc]init] autorelease];
            //FIXME: Potential Memory Leak Warning for tableViewController. 
            }            
        [tableViewController.tableView setSeparatorColor:[UIColor whiteColor]];
        [tableViewController.tableView setSectionHeaderHeight:18];
        //tableViewController.tableView.rowHeight = kCellHeight;
    tableViewController.tableView.rowHeight = 65;
        //[tableViewController.tableView setTableHeaderView:tableLabel];

    //add the tableView to the bottomView.
    if (self.tableViewController.tableView.superview == nil){
        [self.bottomView addSubview:self.tableViewController.tableView];
    }
    doubleTapOnTextView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    
    [doubleTapOnTextView setNumberOfTapsRequired:2];
    
    [doubleTapOnTextView setDelegate:self];
    [doubleTapOnTextView setEnabled:YES];
    
    [self.cover addGestureRecognizer:doubleTapOnTextView];
    
    singleTapOnTextView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    [doubleTapOnTextView setNumberOfTapsRequired:1];
    [doubleTapOnTextView setNumberOfTouchesRequired:1];
    [singleTapOnTextView setDelegate:self];
    [singleTapOnTextView setEnabled:YES];
    
    [self.cover addGestureRecognizer:singleTapOnTextView];
}

- (void) viewWillAppear:(BOOL)animated{
    [self.navigationController hidesBottomBarWhenPushed];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTableRowSelection:) name:UITableViewSelectionDidChangeNotification object:nil];


    NSIndexPath *tableSelection = [tableViewController.tableView indexPathForSelectedRow];
	[tableViewController.tableView deselectRowAtIndexPath:tableSelection animated:NO];
    
    /* NOTE: Took this out - because too fussy - REVIEW AGAIN LATER
    // flip the textview 
    //Initial Frame
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:topView cache:YES];    
    //Final Frame.
     //textView.frame = CGRectMake(0, 0, textViewRect.size.width, textViewRect.size.height);

    [UIView commitAnimations];
     
    // raise tableView into place 
    CGRect startFrame = CGRectMake(0, bottomViewRect.size.height, bottomViewRect.size.width, bottomViewRect.size.height);
    tableViewController.tableView.frame = startFrame;   
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];    
    [UIView setAnimationDelegate:self];
    tableViewController.tableView.frame = CGRectMake(0, 0, bottomViewRect.size.width, bottomViewRect.size.height);
    [UIView commitAnimations]; 
     */
    /*
    if ([textView hasText] && calendarView.superview == nil){
        [textView becomeFirstResponder];
        self.navigationItem.rightBarButtonItem = [self.navigationController addDoneButton];
        self.navigationItem.rightBarButtonItem.action = @selector(saveItem);
        self.navigationItem.rightBarButtonItem.target =self;        
    }
     */
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

   // [[NSNotificationCenter defaultCenter] removeObserver:nil name: UITableViewSelectionDidChangeNotification object:nil];
    
    [actionsPopover setDelegate:nil];//CHECK WHERE SET TO SELF
    [actionsPopover release];
    actionsPopover = nil;
    
    if (calendarView.superview != nil) {
        return;
    }else if (![textView hasText]) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }

    //NOTE: view will disappear if one of the other tab buttons is selected -> key board is down already.  
    if (![textView isFirstResponder]){
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TextView Management - Delegate Methods

- (void) textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"TextView Did Begin Editing");
    if ([self.textView hasText]){
        self.navigationItem.rightBarButtonItem = [self.navigationController addDoneButton];
        self.navigationItem.rightBarButtonItem.action = @selector(saveItem);
        self.navigationItem.rightBarButtonItem.target =self;
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"TextView Did End Editing");
    self.cover = [[[UIView alloc] initWithFrame:kTopViewRect] autorelease];
    //FIXME: Potential Memory Leak for cover.
    self.cover.backgroundColor = [UIColor clearColor];
    if (calendarView.superview != nil){
    [self.view addSubview:cover];
        
    }
    //Check if TV has text, if yes, change right nav button to EDIT.
    
    if ([self.textView hasText] && self.textView.superview !=nil){
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem =  [self.navigationController addEditButton];
        self.navigationItem.rightBarButtonItem.target = self;
        self.navigationItem.leftBarButtonItem.target =self;
    }
}

- (void) textViewDidChange:(UITextView *)textView {
    
    //textView has text so enable the Save and Send buttons
    //FIXME: this method is called and the loop condition is checked each time a character is changed.  
    if (self.navigationItem.rightBarButtonItem == nil && [self.textView hasText]) {
        self.navigationItem.rightBarButtonItem = [self.navigationController addDoneButton];
        self.navigationItem.rightBarButtonItem.action = @selector(saveItem);
        self.navigationItem.rightBarButtonItem.target =self;
        self.navigationItem.leftBarButtonItem = [self.navigationController addAddButton]; 
        
        self.navigationItem.leftBarButtonItem.action = @selector(startNewItem:);
        self.navigationItem.leftBarButtonItem.target = self;    
        if (toolbar.firstButton.enabled == NO && toolbar.fourthButton.enabled == NO && [self.textView hasText]) {
            toolbar.firstButton.enabled = YES;
            toolbar.fourthButton.enabled = YES;
        }    
    }
}

#pragma mark - methods to deal with zooming scroll view
//FIXME:  Looks like double tapping on the textView when editing is disabled causes it to zoom but also to call up the keyboard. Seems no easy way to disable zooming. BUT the better option anyway is to get the double tap gesture to turn on the tv to enable editing. 
//all the methods below are intended to fix the zooming on double tap problem. Unfortunatelly they don't work. 


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Touches Began");

    UITouch *theTouch = [touches anyObject];    
    if (calendarView.superview !=nil){
        NSLog(@"calendar up - removing cover");
        [cover removeFromSuperview]; 
        return;
    } else if ([theTouch view] == self.cover){
        if ([theTouch tapCount]  == 2){
            NSLog(@"Cover off 2 ");

            [cover removeFromSuperview];
            [self.textView setEditable:YES];
            [self.textView becomeFirstResponder];
            return;
          }
        else if([theTouch tapCount] ==1 && isScrolling){
            NSLog(@"Cover off 1 ");
            [cover removeFromSuperview];
        }
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Touches Ended");
    //allow for delay
    if (calendarView.superview !=nil){
        return;
    }
    
    UITouch *theTouch = [touches anyObject];
    if (self.textView.editable == NO && [theTouch view]  == self.textView){

    [self performSelector:@selector(coverUp) withObject:nil afterDelay:2.0];
        NSLog(@"Inside conditional in Touches Ended");
    }
}


- (void) coverUp {
    NSLog(@"Covering Up");
    if (self.textView.editable == NO && self.textView.isFirstResponder == NO) {
        if (calendarView.superview != nil){
        [self.view addSubview:cover];
        }
    }
}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"Did Scroll");
    //allow for delay
    
    isScrolling = YES;
    
    if ([scrollView isKindOfClass:[CustomTextView class]] && self.textView.editable == NO){
            
        [self performSelector:@selector(coverUp) withObject:nil afterDelay:1.0];
        NSLog(@"Inside conditional in Touches Ended");
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    
    NSLog(@"Method: handleDoubleTap called");
    if (self.textView.editable == NO) {
        [self.textView setEditable:YES];
        [self.textView becomeFirstResponder];
    }
    [cover removeFromSuperview];
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {    
    NSLog(@"Method: handleSingleTap called");
    [cover removeFromSuperview];
}


#pragma mark - Data Management

- (void) newItemOrEvent: (id)sender {
    NSLog(@"WriteNowViewController: newItemOrEvent");
    //this method is called by the buttons on the toolbar popups and by the ADD item button. It just inserts the relevant objects in the adding MOC but does not save it. 
    
    NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
    
    [addingContext setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];

        if (theItem == nil) {
            theItem = [[[NewItemOrEvent alloc] init]retain];//Create new instance of delegate class.
            theItem.addingContext = addingContext; // pass adding MOC to the delegate instance.
        
            [theItem createNewItem:textView.text ofType:[NSNumber numberWithInt:[sender tag]]];
            
            if (![sender tag]){
                NSNumber *num = [NSNumber numberWithInt:1];
                [theItem createNewItem:textView.text ofType:num];
            }
        }
    [addingContext release];
    
    [actionsPopover dismissPopoverAnimated:YES];
    
    if ([self.textView hasText] && self.textView.superview !=nil){
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem =  [self.navigationController addEditButton];
        self.navigationItem.rightBarButtonItem.target = self;
        self.navigationItem.leftBarButtonItem.target =self;
    }
    
    if ([sender tag] == 2 || [sender tag] == 3) {
        NSLog(@"WriteNowViewController:newItemOrEvent -> pushing CalendarViewController");
        [actionsPopover dismissPopoverAnimated:YES];
        CalendarViewController *calendarViewController = [[[CalendarViewController alloc] init] autorelease];
        calendarViewController.hidesBottomBarWhenPushed = YES;
        calendarViewController.isScheduling = YES;
        calendarViewController.theItem = self.theItem;
        [self.navigationController pushViewController:calendarViewController animated:YES];
        
        
    } else if ([sender tag] == 5 || [sender tag] == 5){
        NSLog(@"WriteNowViewController:newItemOrEvent -> pushing ArchiveViewController");

        [actionsPopover dismissPopoverAnimated:YES];
        
        NSError *error;
        if(![addingContext save:&error]){ 
            NSLog(@"DID NOT SAVE");
        }
        
        ArchiveViewController *archiveViewController = [[[ArchiveViewController alloc] init] autorelease];
        archiveViewController.hidesBottomBarWhenPushed = YES;
        archiveViewController.saving = YES;
        archiveViewController.theItem = self.theItem;
        [self.navigationController pushViewController:archiveViewController animated:YES];
    }

}

- (void) saveItem {
    
    NSLog(@"WriteNowViewController: Save Item");
    //this method call the saveNewItem method in NewItemOrEvent.
    //called by the Done button or the ADD button.
    if (theItem == nil) {
        [self newItemOrEvent:nil];
    }
    else if(theItem != nil && theItem.theNote != nil){
        //maybe check to see if strings are same??
        theItem.theNote.text = self.textView.text;
    }
    [theItem saveNewItem];
    
    //Change state of view
    self.textView.userInteractionEnabled = YES; 
    [self.textView setScrollsToTop:YES];
    [self.textView resignFirstResponder];
    return;
}



- (void) startNewItem:(id) sender{//Called by Left Nav ADD_ITEM Button.
    NSLog(@"Start New Item");

    //call NewItemOrEvent method to save the MOC state.
    [self saveItem];
    //If the TV has text
    if ([textView hasText]){
        
        //if text Yes, then check if a Note object exists.
        if (theItem.theNote == nil){//No NOTE 
            //creat a new Item
            [self newItemOrEvent:nil];
            
        } else if (theItem != nil && theItem.theNote != nil) {//NOTE exists
            //if (![textView.text isEqualToString:theItem.theNote.text]){
                //Check if the text has changed, if yes then save the text to current note.
                //NOTE: this string comparison may be costly. Find better way or dispense if possible                
                theItem.theNote.text = self.textView.text;
           // }
        }        
        //Clear the TV
        self.textView.text = nil;
    }
    
    //Make  TV editable 
    if (![self.textView isEditable]){
        [self.textView setEditable:YES];
    }
    
    //Make TV the first responder
    if (![self.textView isFirstResponder]){
        [self.textView becomeFirstResponder];
    }
        
    //remove the nav Buttons
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    //disable save and send buttons
    toolbar.firstButton.enabled = NO;
    toolbar.fourthButton.enabled = NO;
    
    //release current instance of theItem
    self.theItem = nil;
    return;
}

- (void) editTextView:(id) sender {
    //Returns User to Editing the TextView
    //enable editing the TV
    [self.textView setEditable:YES];
    
    //make the tv first responder - raise kb
    if (![self.textView isFirstResponder]){
        [self.textView becomeFirstResponder];
    }
    //reset the right nav button.
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [self.navigationController addDoneButton];
    self.navigationItem.rightBarButtonItem.action = @selector(saveItem);
    self.navigationItem.rightBarButtonItem.target = self;    
}

- (void) sendItem:(id)sender {
    [actionsPopover dismissPopoverAnimated:YES];
    return;
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
        frame.size.height = topView.frame.size.height;
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


- (void) textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Method: textfieldDidEndEditing -> currently commands");
    //
}

#pragma mark - ToolBar Actions

- (void) dismissKeyboard {    
    NSLog(@"Method: dismissKeyboard -> 1.dismisses actionsPopover if visible, 2. if TV is FR, resign FR. 3. set left nav = addButton & right nav =  doneButton 4.");
    if([actionsPopover isPopoverVisible]) {
        [actionsPopover dismissPopoverAnimated:YES];
    }
    if ([textView isFirstResponder]){
        [textView resignFirstResponder];       
    }
    //Check if TV has text. Y then add reset navButtons to  addbutton(left) and  doneButton(right)
    if ([textView hasText]){//2/29 - 0:29
    self.navigationItem.leftBarButtonItem = [self.navigationController addAddButton];
    self.navigationItem.leftBarButtonItem.action = @selector(startNewItem:);
    self.navigationItem.leftBarButtonItem.target = self;
    
    self.navigationItem.rightBarButtonItem = [self.navigationController addDoneButton];
    self.navigationItem.rightBarButtonItem.action = @selector(newItemOrEvent:);
    self.navigationItem.rightBarButtonItem.target = self;    
    }
    //If TV no text, then enable TV and clear the navButtons
    else {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    }
    [self.textView setUserInteractionEnabled:YES];

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
    
    if (calendarView == nil) {
        //Check if the calendar obect exists. If it is not in view, it should not exist. Initialize and slide into view from bottom.
        calendarView = 	[[TKCalendarMonthView alloc] init];        
        calendarView.delegate = self;
        calendarView.dataSource = self;
        [self.topView addSubview:calendarView];
        [calendarView reload];
        calendarView.frame = CGRectMake(0, -calendarView.frame.size.height, calendarView.frame.size.width, calendarView.frame.size.height);
        //calendarView.frame = CGRectMake(0, kScreenHeight, calendarView.frame.size.width, calendarView.frame.size.height);
        
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
        self.textView.frame = CGRectMake(0, -kTopViewRect.size.height, self.textView.frame.size.width, self.textView.frame.size.height);
        [UIView commitAnimations];
        NSDate *d = [NSDate date];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetDateNotification" object:d userInfo:nil]; 
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
        frame.origin.y  = 0;
        textView.frame = frame;
        frame = bottomView.frame;
        frame.origin.y = kBottomViewRect.origin.y+85;    
        self.bottomView.frame = frame;
        }
        /*
        else if (scheduleView.superview != nil){
            //check to see if the ScheduleView is below the calendar view
            CGRect frame = topView.frame;
            frame.size.height = kTopViewRect.size.height+35;
            self.topView.frame = frame;
            frame = bottomView.frame;
            frame.origin.y = kBottomViewRect.origin.y+85;
            self.bottomView.frame = frame;
        }
         */
        calendarView.frame = CGRectMake(0, -calendarView.frame.size.height, calendarView.frame.size.width, calendarView.frame.size.height);

        //calendarView.frame = CGRectMake(0, kScreenHeight, calendarView.frame.size.width, calendarView.frame.size.height);
        
        [UIView commitAnimations];
    }
}
- (void) finishedCalendarTransition{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetDateNotification" object:nil userInfo:nil]; 

    [calendarView removeFromSuperview];
    calendarView = nil;
    if (textView.superview !=nil) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        [textView becomeFirstResponder];
        [textView setUserInteractionEnabled:YES];
        }/*
          
    
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
    }*/
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
- (NSArray *)fetchDatesForTimedEvents{ 
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
	//[cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

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
- (void) addDateToCurrentEvent{
    /* the navigation bar needs to be changed for the schedule view 
     Left button = Cancel. Returns the user to the editing page.
     
     Right Button = ADD item - when the calendar is pulled up.
     If the textview has text then, check if there is an appointment or task event linked. 
     If not, selecting a date and hitting the ADD button, creates an event  if it doesn't already exist 
     and adds the date.
     If there is no text in TV, then create note and event. 
     
     Alternately, have two different looking buttons which show depending on whether there is text or not. 
     
     */
    
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
    button1.alpha = 0.8;
    [button1 setTitle:@"Event" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    button1.layer.cornerRadius = 6.0;
    button1.layer.borderWidth = 1.0;
    
    UIButton *button2 = [[UIButton alloc] init];
    button2.frame = CGRectMake(0, 81, 100, 39);
    button2.backgroundColor = [UIColor darkGrayColor];
    button2.alpha = 0.8;
    [button2 setTitle:@"To Do" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    button2.layer.cornerRadius = 6.0;
    button2.layer.borderWidth = 1.0;
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
            [button1 addTarget:self action:@selector(newItemOrEvent:) forControlEvents:UIControlEventTouchUpInside];
                [button1 setTag:5];
                
            [button2 setTitle:@"Document" forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(newItemOrEvent:) forControlEvents:UIControlEventTouchUpInside];
                [button2 setTag:6];
            [actionsPopover presentPopoverFromRect:CGRectMake(20, 192, 50, 40) inView:self.view
                          permittedArrowDirections: UIPopoverArrowDirectionDown animated:YES name:@"Plan"];  
            break;
        case 2:
            label1.text = @"Create";
            button1.titleLabel.text = @"Appointment";
            button2.titleLabel.text = @"To Do";
            [button1 setTitle:@"Appointment" forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(newItemOrEvent:) forControlEvents:UIControlEventTouchUpInside];
                [button1 setTag:2];
            [button2 setTitle:@"To Do" forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(newItemOrEvent:) forControlEvents:UIControlEventTouchUpInside];
                [button2 setTag:3];
              
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
                [button1 setTag:41];
            button2.titleLabel.text = @"Message";
            [button2 setTitle:@"Message" forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(sendItem:) forControlEvents:UIControlEventTouchUpInside];
                [button2 setTag:42];
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



@end



#pragma mark - Internal View Management
/*
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
        [self.navigationItem.leftBarButtonItem setTarget:self];
        //self.navigationItem.leftBarButtonItem setAction:@selector(clearEvent:)
        //FIXME: add the clearEvent: method to delete any to do or appointment
        
        //Add Done Button to the Nav Bar. Set it to call method to save input and to return to editing
        self.navigationItem.rightBarButtonItem =[self.navigationController addDoneButton];
        [self.navigationItem.rightBarButtonItem setTarget:self];
        [self.navigationItem.rightBarButtonItem setAction:@selector(saveSchedule:)];
        
        [toolbar changeToSchedulingButtons];
        toolbar.fourthButton.enabled = YES;
        
    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:topView cache:YES];        
        [scheduleView removeFromSuperview];
        [self.topView addSubview:textView];
        [toolbar changeToEditingButtons];
        
        if ([self.textView hasText]){
            self.navigationItem.leftBarButtonItem = [self.navigationController addAddButton];
            self.navigationItem.leftBarButtonItem.target = self;
            self.navigationItem.rightBarButtonItem = [self.navigationController addDoneButton];
            self.navigationItem.rightBarButtonItem.action = @selector(newItemOrEvent:);
            self.navigationItem.rightBarButtonItem.target = self;
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
     
}



- (void) finishedScheduleTextViewTransition{
    NSLog(@"Method: finishedScheduleTextViewTransition -> enabling topView, making TV FR");
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
 
 
 
 - (void) saveSchedule:(id)sender {
 
 NSLog(@"Saving Schedule");
 
 NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];    
 [gregorian setLocale:[NSLocale currentLocale]];
 //[gregorian setTimeZone:[NSTimeZone localTimeZone]];
 [gregorian setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
 
 NSDateComponents *timeComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[scheduleView.datePicker date]];    
 [timeComponents setYear:[timeComponents year]];
 [timeComponents setMonth:[timeComponents month]];
 [timeComponents setDay:[timeComponents day]];
 NSDate *selectedDate= [gregorian dateFromComponents:timeComponents];
 
 NSLog(@"the selectedDate is %@", selectedDate);
 
 if (theToDo == nil) {
 //set the Appointment date
 NSLog(@"the selectedDate is %@", selectedDate);
 
 [theAppoinment setADate:selectedDate];
 
 NSLog(@"this appointment date is %@", theAppoinment.aDate);
 }
 
 else {
 
 // set the To Do due date
 NSLog(@"the selectedDate is %@", selectedDate);
 
 theToDo.aDate = selectedDate; 
 NSLog(@"this todo date is %@", theToDo.aDate);
 
 }
 
 
NSError *error;
if(![managedObjectContext save:&error]){ 
} 
return;
}

*/
