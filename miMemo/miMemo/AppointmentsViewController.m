//
//  AppointmentsViewController.m
//  Memo
//
//  Created by Keith Fernandes on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppointmentsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "miMemoAppDelegate.h"
#import "NSManagedObjectContext-insert.h"
#import "StartScreenCustomCell.h"

@implementation AppointmentsViewController

@synthesize managedObjectContext, managedObjectContextTV;
@synthesize datePicker;
@synthesize goActionSheet;
@synthesize appointmentsToolbar;
@synthesize dateTextField, timeTextField, textView, newTextInput;
@synthesize selectedDate;
@synthesize tableView;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize tableLabel;
//@synthesize newAppointment;

- (void)viewDidLoad {
    [super viewDidLoad];
    /*Setting Up the Views*/
    NSLog(@"In AppointmentsViewController");
    
    /*Setting Up the main view */
    //UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    //[myView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    //myView.hidden = NO;
    //self.view = myView;
    
    [self makeToolbar];
    [self.view addSubview:appointmentsToolbar];
    
    if (managedObjectContextTV == nil) { 
		managedObjectContextTV = [(miMemoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContextTV);
    }

    /*--Adding the Text View */
    self.view.layer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
        /*--The Text View --*/
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 45, 300, 50)];
    [self.view addSubview:textView];
    [textView setFont:[UIFont systemFontOfSize:18]];
    textView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    textView.layer.cornerRadius = 7.0;
    textView.layer.frame = CGRectInset(textView.layer.frame, 5, 10);
    textView.layer.contents = (id) [UIImage imageNamed:@"lined_paper_320x200.png"].CGImage;    
    [textView setText:[NSString stringWithFormat:@"%@", newTextInput]];
    [self.view addSubview:textView];
    [textView setDelegate:self];
        /*--Adding the Date and Time Fields--*/

    dateTextField = [[UITextField alloc] init];
    [dateTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [dateTextField setFont:[UIFont systemFontOfSize:15]];
    [dateTextField setFrame:CGRectMake(12, 20, 145, 31)];
    [dateTextField setPlaceholder:@"Set Appointment Date"];
    [self.view addSubview:dateTextField];

    
    timeTextField = [[UITextField alloc] init];
    [timeTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [timeTextField setFont:[UIFont systemFontOfSize:15]];
    [timeTextField setFrame:CGRectMake(160, 20, 145, 31)];
    [timeTextField setPlaceholder:@"Set Appointment Time"];
    [self.view addSubview:timeTextField];
    
    tableLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 20)];
    [tableLabel setBackgroundColor:[UIColor blackColor]];
    [tableLabel setTextColor:[UIColor whiteColor]];
    [tableLabel setTextAlignment:UITextAlignmentCenter];
    [tableLabel setText:@"All Appointments"];
    [self.view addSubview:tableLabel];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 90, 290, 100)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setTableHeaderView:tableLabel];
    [self.view addSubview:tableView];
    /*--Done Setting Up the Views--*/
    
    swappingViews = NO;
    /*-- Add and Initialize date and time pickers --*/
    //datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 245, 320, 215)];
    //[datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.view addSubview:datePicker];
    datePicker.minimumDate = [NSDate date];		//Now
	datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)];
	datePicker.date = [NSDate date];
    datePicker.timeZone = [NSTimeZone systemTimeZone];
    datePicker.hidden = NO;
    /*
    timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 245, 320, 215)];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    [self.view addSubview:timePicker];
    //TODO: Initialize timePicker to 12:00 PM
    timePicker.hidden = YES;
    */
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
    }
    NSLog(@"Done Loading View"); 
}

- (IBAction)datePickerChanged:(id)sender{
    NSDate *tempDate = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:tempDate];
    NSPredicate *checkDate = [NSPredicate predicateWithFormat:@"doDate == %@", dateString];
    self.fetchedResultsController = [self fetchedResultsControllerWithPredicate:checkDate];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
    }
    [tableLabel setText:dateString];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Navigation

-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
		case 0:
            [self backAction];
            break;            
		case 1:
            [self setAppointmentDate];
			break;
		case 2:
			self.goActionSheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Go To" delegate:self cancelButtonTitle:@"Later"
								  destructiveButtonTitle:nil otherButtonTitles:@"Memos, Files and Folders", @"Appointments", @"Tasks", nil];
			[goActionSheet showInView:self.view];            
			break;
        case 3:
            [self dismissModalViewControllerAnimated:YES];
            break;     
		default:
			break;
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
		switch (buttonIndex){
			case 3:
			default:
				break;
			case 2:			
				break;
			case 1:			
				break;
			case 0:
				break;				
    }
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	swappingViews = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	datePicker = nil;
}

- (void)dealloc {
    [super dealloc];
	[datePicker release];
    [goActionSheet release];
    [appointmentsToolbar release];
    [dateTextField release];
    [timeTextField release];
    [textView release];

    
		//[monthView release];
		//[datetimeView release];
}

#pragma mark -
#pragma mark Class Methods

- (void) backAction{
	[self dismissModalViewControllerAnimated:YES];		
}

- (void) setAppointmentDate{
    
    MemoText *newMemoText = [managedObjectContext insertNewObjectForEntityForName:@"MemoText"];
    [newMemoText setMemoText:textView.text];
    [newMemoText setNoteType:[NSNumber numberWithInt:1]];
    [newMemoText setCreationDate:[NSDate date]];
    
    Appointment *newAppointment = [managedObjectContext insertNewObjectForEntityForName:@"Appointment"];
    newAppointment.memoText = newMemoText;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    newAppointment.selectedDate = [datePicker date];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    newAppointment.doDate = [dateFormatter stringFromDate:newAppointment.selectedDate];
    dateTextField.text = newAppointment.doDate;
    [dateFormatter setDateFormat:@"hh:mm a"];
	newAppointment.doTime = [dateFormatter stringFromDate:newAppointment.selectedDate];
    timeTextField.text = newAppointment.doTime;
    [dateFormatter release];

    /*--Save the MOC--*/	
	NSError *error;
	if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
	}    
    if (!swappingViews) {
        [self swapViews];
    }
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [doneButton setTag:3];
    [doneButton setWidth:90];
    NSUInteger newButton = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:appointmentsToolbar.items] retain];
    
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 1) {
            newButton = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButton withObject:doneButton];
    appointmentsToolbar.items = toolbarItems;
}

- (void) swapViews {
	
	CATransition *transition = [CATransition animation];
	transition.duration = 1.0;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[transition setType:@"kCATransitionPush"];	
	[transition setSubtype:@"kCATransitionFromRight"];
	
	swappingViews = YES;
	transition.delegate = self;
	
	[self.view.layer addAnimation:transition forKey:nil];
	//datePicker.hidden = YES;
	//monthView.hidden = YES;
	//datetimeView.hidden = NO;	
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *) fetchedResultsControllerWithPredicate:(NSPredicate *)aPredicate {

	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Appointment" inManagedObjectContext:managedObjectContextTV]];
    [request setFetchBatchSize:10];
    
    [request setPredicate:aPredicate];
    
	NSSortDescriptor *dateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"doDate" ascending:YES] autorelease];
	NSSortDescriptor *timeDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"doTime" ascending:NO]autorelease];    
    [request setSortDescriptors:[NSArray arrayWithObjects:dateDescriptor,timeDescriptor, nil]];
    
    NSString *cacheName = @"Root";
    if (aPredicate) {
        cacheName = nil;
    }
    NSFetchedResultsController *newController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContextTV sectionNameKeyPath:nil cacheName:cacheName];
    
    newController.delegate = self;
    NSError *anyError = nil;
    if (![newController performFetch:&anyError]){
        NSLog(@"Error Fetching:%@", anyError);
    }
	self.fetchedResultsController = newController;
	[newController release];
	[request release];
	
	return _fetchedResultsController;
}

- (NSFetchedResultsController *) fetchedResultsController {
    if(_fetchedResultsController != nil){
        return _fetchedResultsController;
        }
    self.fetchedResultsController = [self fetchedResultsControllerWithPredicate:nil];
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]){
        NSLog(@"Error Fetching:%@", error);
    }
	return _fetchedResultsController;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[_fetchedResultsController sections] count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	id<NSFetchedResultsSectionInfo>  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *aDate = [dateFormatter dateFromString:[sectionInfo name]];
    
    [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy"];
    
	return [dateFormatter stringFromDate:aDate];
	//return [sectionInfo name];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"dd MMMM yyyy h:mm a"];
        //[dateFormatter setDateFormat:@"EEEE, dd MMMM yyyy h:mm a"]; //This format gives the Day of Week, followed by date and time
	}
	StartScreenCustomCell *mycell;
	if([cell isKindOfClass:[UITableViewCell class]]){
		mycell = (StartScreenCustomCell *) cell;
        [mycell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];   
    }
    //if ([_fetchedResultsController objectAtIndexPath:0] != nil) {
    Appointment *anAppointment = [_fetchedResultsController objectAtIndexPath:indexPath];	
    [mycell.memoText setText:[NSString stringWithFormat:@"%@", anAppointment.memoText.memoText]];
    [mycell.date setText: anAppointment.doTime];
    //}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"StartScreenCustomCell";
    StartScreenCustomCell *cell = (StartScreenCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle]
									loadNibNamed:@"StartScreenCustomCell"
									owner:nil options:nil];
		for (id currentObject in topLevelObjects){
			if([currentObject isKindOfClass:[UITableViewCell class]]){
				cell = (StartScreenCustomCell *) currentObject;
				break;
			}
		}
	}
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   // MemoDetailViewController *detailViewController = [[MemoDetailViewController alloc] initWithNibName:@"MemoDetailView" bundle:[NSBundle mainBundle]];
    // ...
    // Pass the selected object to the new view controller.
	
	//detailViewController.selectedMemoText = [_fetchedResultsController objectAtIndexPath:indexPath];	
    
	//[self presentModalViewController:detailViewController animated:YES];	
    //[detailViewController release];
}

#pragma mark -
#pragma mark Fetched Results Notifications

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
    UITableView *aTableView = self.tableView;
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [aTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
			[self configureCell:[aTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
			
        case NSFetchedResultsChangeMove:
            [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [aTableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}


- (void) makeToolbar {
    /*Setting up the Toolbar */
    CGRect buttonBarFrame = CGRectMake(0, 208, 320, 37);
    appointmentsToolbar = [[[UIToolbar alloc] initWithFrame:buttonBarFrame] autorelease];
    [appointmentsToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [appointmentsToolbar setTintColor:[UIColor blackColor]];
    UIBarButtonItem *saveAsButton = [[UIBarButtonItem alloc] initWithTitle:@"BACK" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [saveAsButton setTag:0];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"Time" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [newButton setTag:1];
    UIBarButtonItem *gotoButton = [[UIBarButtonItem alloc] initWithTitle:@"GO TO.." style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [gotoButton setTag:2];
    
    [saveAsButton setWidth:90];
    [newButton setWidth:90];
    [gotoButton setWidth:90];
    
    //UIButton *customView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //Possible to use this with the initWithCustomView method of  UIBarButtonItems
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
    
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithObjects:flexSpace, saveAsButton, flexSpace, newButton, flexSpace, gotoButton, flexSpace,nil];
    [appointmentsToolbar setItems:toolbarItems];
    /*--End Setting up the Toolbar */
}


@end
