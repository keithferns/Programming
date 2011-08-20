//
//  AppointmentsViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "AppointmentsViewController.h"
#import "WriteNowAppDelegate.h"
//#import "StartScreenCustomCell.h"
#import "AppointmentCustomCell.h"

@implementation AppointmentsViewController


@synthesize managedObjectContext, managedObjectContextTV;
@synthesize datePicker, timePicker;
@synthesize appointmentsToolbar;
@synthesize dateField, timeField, textView;
@synthesize tableView;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize tableLabel;
@synthesize newAppointment;
@synthesize dateFormatter, timeFormatter;
@synthesize containerView;

- (void)dealloc {
    [super dealloc];
	[datePicker release];
    //[appointmentsToolbar release];  //WHY CAN'T I RELEASE THIS??????  
    [dateField release];
    [timeField release];
    [textView release];
    [dateFormatter release];
    [_fetchedResultsController release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
  
    NSLog(@"Received Memory Warning!");
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    /*Setting Up the Views*/
    NSLog(@"In AppointmentsViewController");
    
    [NSFetchedResultsController deleteCacheWithName:@"Root"];

    self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    self.timeFormatter = [[NSDateFormatter alloc]init];
	[self.timeFormatter setTimeStyle:NSDateFormatterShortStyle];

    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1];    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [containerView.layer setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor].CGColor];
    [containerView.layer setOpacity:0.9];
    [self.view addSubview:containerView];
    
    /*--setup the textView for the input text--*/
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 35, 300, 40)];
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    [textView.layer setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor].CGColor];
    [textView.layer setBorderWidth:1.0];
    [textView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [textView.layer setCornerRadius:10.0];
    [textView setFont:[UIFont boldSystemFontOfSize:15]];
    [textView setDelegate:self];
    [textView setAlpha:1.0];
    
    textView.text = newAppointment.text;
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [label  setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor blackColor]];
    [label setTextAlignment:UITextAlignmentCenter];
    label.text = @"New Appointment";
    [label setFont:[UIFont fontWithName:@"Georgia-BoldItalic" size:18]];
    
    
    /*--Adding the Date and Time Fields--*/

    dateField = [[UITextField alloc] initWithFrame:CGRectMake(10, 80, 145, 25)];
    
    [dateField setBorderStyle:UITextBorderStyleRoundedRect];
    //[dateField setBackgroundColor:[UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1]];
    [dateField setPlaceholder:@"Set Date"];
    
    timeField = [[UITextField alloc] initWithFrame:CGRectMake(165, 80, 145, 25)];
    [timeField setBorderStyle:UITextBorderStyleRoundedRect];
    //[timeField setBackgroundColor:[UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1]];
    [timeField setPlaceholder:@"Set Time"];
    
    tableLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,300, 20)];
    [tableLabel setBackgroundColor:[UIColor lightGrayColor]];
    [tableLabel setTextColor:[UIColor whiteColor]];
    [tableLabel setTextAlignment:UITextAlignmentCenter];
    [tableLabel setText:@"All Appointments"];
    [self.view addSubview:tableLabel];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 110, 300, 85)];
    [tableView.layer setCornerRadius:5.0];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setTableHeaderView:tableLabel];
    
    [self.view addSubview:containerView];
    [containerView addSubview:label];
    [containerView addSubview:textView];
    [containerView addSubview:dateField];
    [containerView addSubview:timeField];    
    [containerView addSubview:tableView];

    [self makeToolbar];
    [self.view addSubview:appointmentsToolbar];
    
    [datePicker setFrame:CGRectMake(0, 245, 320, 216)];
    //[datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePicker setDate:[NSDate date]];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)]];
    datePicker.timeZone = [NSTimeZone systemTimeZone];
    [datePicker setTag:0];
    [self.view addSubview:datePicker];
    datePicker.hidden = NO;
    
    [timePicker setFrame:CGRectMake(0, 245, 320, 216)];
    [timePicker setDatePickerMode:UIDatePickerModeTime];
    //[timePicker setDate:[NSDate date]];
    //[timePicker setMinimumDate:[NSDate date]];
    //[timePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*365)]];
    timePicker.timeZone = [NSTimeZone systemTimeZone];
    [timePicker setTag:1];
    [self.view addSubview:timePicker];
    timePicker.hidden = YES;
    
    /*-- Initializing the managedObjectContext--*/
    if (managedObjectContextTV == nil) { 
		managedObjectContextTV = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContextTV);
    }
    /*--Done Initializing the managedObjectContext--*/
  
    swappingViews = NO;

    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
    }
    NSLog(@"Done Loading View"); 
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.fetchedResultsController = nil;
    self.dateFormatter = nil;
    self.datePicker = nil;
    self.timePicker = nil;
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
	swappingViews = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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
    newAppointment.doDate = [calendar dateFromComponents:dateComponents];
    NSLog(@"Selected Date: %@", newAppointment.doDate);
    dateField.text = [self.dateFormatter stringFromDate:newAppointment.doDate];

    /*--configure the search predicate to display all and only appointments for the selected date --*/

    NSPredicate *checkDate = [NSPredicate predicateWithFormat:@"doDate == %@", newAppointment.doDate];
    self.fetchedResultsController = [self fetchedResultsControllerWithPredicate:checkDate];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        }
    [self.tableView reloadData];
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
    
    newAppointment.doTime = [calendar dateFromComponents:timeComponents];
    NSLog(@"Selected Time: %@", newAppointment.doTime);
    timeField.text = [self.timeFormatter stringFromDate:newAppointment.doTime];
}


- (void) backAction{
	[self dismissModalViewControllerAnimated:YES];		
}

- (void) setAppointmentDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:[datePicker date]];
    [dateComponents setYear:[dateComponents year]];
    [dateComponents setMonth:[dateComponents month]];
    [dateComponents setDay:[dateComponents day]];
    [dateComponents setHour:12];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    newAppointment.doDate = [calendar dateFromComponents:dateComponents];
    /*--Save the MOC--*/	
	NSError *error;
	if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
	}  

    if (!swappingViews) {
        [self swapViews];
    }
    UIBarButtonItem *timeButton = [[UIBarButtonItem alloc] initWithTitle:@"Set Time" style:UIBarButtonItemStyleBordered target:self action:@selector(setAppointmentTime)];
    [timeButton setTag:3];
    [timeButton setWidth:90];
    NSUInteger newButton = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:appointmentsToolbar.items] retain];
    
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 1) {
            newButton = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButton withObject:timeButton];
    appointmentsToolbar.items = toolbarItems;
    [timeButton release];
    [toolbarItems release];
    
    datePicker.hidden = YES;
    timePicker.hidden = NO;
}

- (void) setAppointmentTime{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[timePicker date]];    
    [timeComponents setHour:[timeComponents hour]];
    [timeComponents setMinute:[timeComponents minute]];
    [timeComponents setSecond:[timeComponents second]];
    [timeComponents setYear:0];
    [timeComponents setMonth:0];
    [timeComponents setDay:0];
    
    newAppointment.doTime = [calendar dateFromComponents:timeComponents];
    
    /*--Save the MOC--*/	
	NSError *error;
	if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
	}  
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];
    [doneButton setTag:4];
    [doneButton setWidth:90];
    NSUInteger newButton = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:appointmentsToolbar.items] retain];
    
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 3) {
            newButton = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButton withObject:doneButton];
    appointmentsToolbar.items = toolbarItems;
    [doneButton release];
    [toolbarItems release];
}

#pragma mark -
#pragma mark Navigation

- (void) doneAction{
    [self dismissModalViewControllerAnimated:YES];
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
    NSFetchedResultsController *newController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContextTV sectionNameKeyPath:@"doDate" cacheName:cacheName];
    
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
    NSDateFormatter *tempDateFormatter = [[NSDateFormatter alloc] init];
    
    [tempDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    NSDate *aDate = [tempDateFormatter dateFromString:[sectionInfo name]];
    
    [tempDateFormatter setDateFormat:@"EEEE, MM d"];
    
    NSString *myDate = [tempDateFormatter stringFromDate:aDate];
    [tempDateFormatter release];
	return myDate;
	//return [sectionInfo name];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
	AppointmentCustomCell *mycell;
	if([cell isKindOfClass:[UITableViewCell class]]){
		mycell = (AppointmentCustomCell *) cell;
        [mycell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];   
        }
//if ([_fetchedResultsController objectAtIndexPath:0] != nil) {
    Appointment *anAppointment = [_fetchedResultsController objectAtIndexPath:indexPath];	
    [mycell.textLabel setText:[NSString stringWithFormat:@"%@", anAppointment.text]];
    [mycell.timeLabel setText: [timeFormatter stringFromDate:anAppointment.doTime]];
//}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AppointmentCustomCell";
    
    AppointmentCustomCell *cell = (AppointmentCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle]
									loadNibNamed:@"AppointmentCustomCell"
									owner:nil options:nil];
		for (id currentObject in topLevelObjects){
			if([currentObject isKindOfClass:[UITableViewCell class]]){
				cell = (AppointmentCustomCell *) currentObject;
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

#pragma mark -
#pragma mark Navigation

- (void) makeToolbar {
    /*Setting up the Toolbar */
    CGRect buttonBarFrame = CGRectMake(0, 200, 320, 45);
    appointmentsToolbar = [[[UIToolbar alloc] initWithFrame:buttonBarFrame] autorelease];
    [appointmentsToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [appointmentsToolbar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"BACK" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];
    [backButton setTag:0];
    UIBarButtonItem *dateButton = [[UIBarButtonItem alloc] initWithTitle:@"Set Date" style:UIBarButtonItemStyleBordered target:self action:@selector(setAppointmentDate)];
    
    
    [dateButton setTag:1];
    UIBarButtonItem *gotoButton = [[UIBarButtonItem alloc] initWithTitle:@"GO TO.." style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction)];
    [gotoButton setTag:2];
    
    [backButton setWidth:90];
    [dateButton setWidth:90];
    [gotoButton setWidth:90];
    
    //UIButton *customView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //Possible to use this with the initWithCustomView method of  UIBarButtonItems
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
    
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithObjects:flexSpace, backButton, flexSpace, dateButton, flexSpace, gotoButton, flexSpace,nil];
    [appointmentsToolbar setItems:toolbarItems];
    [backButton release];
    [dateButton release];
    [gotoButton release];
    [flexSpace release];
    /*--End Setting up the Toolbar */
}

@end
