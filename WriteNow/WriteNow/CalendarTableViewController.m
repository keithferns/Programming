//
//  CalendarTableViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalendarTableViewController.h"

#import "WriteNowAppDelegate.h"
#import "AppointmentsTableViewController.h"
#import "AppointmentCustomCell.h"
#import "TaskCustomCell.h"
#import "DetailViewController.h"
#import "MyDataObject.h"


@implementation CalendarTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext, tableLabel;
@synthesize selectedDate;
@synthesize myCell;

- (MyDataObject *) myDataObject; {
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	MyDataObject* myDataObject;
	myDataObject = (MyDataObject*) theDelegate.myDataObject;
	return myDataObject;
}

- (void)dealloc {
    [super dealloc];
    [_fetchedResultsController release];
    [tableLabel release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetDateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.fetchedResultsController = nil;
    self.selectedDate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"APPOINTMENTS TABLEVIEWCONTROLLER: MEMORY WARNING");
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    tableIsDown = YES;
    NSLog(@"IN CALENDAR TABLEVIEWCONTROLLER");
    [NSFetchedResultsController deleteCacheWithName:@"Root"];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    /*-- MOC: Initialize--*/
    if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    }    /*--MOC:Done --*/
    
    
    /*--Set the predicate to show only items that are 6 hours prior to NOW--*/
    //TODO: REFINE
    //NSDate *tempDate = [NSDate dateWithTimeIntervalSinceNow:-6*60*60];
    //NSPredicate *checkDate = [NSPredicate predicateWithFormat:@"doDate > %@", tempDate];
    //self.fetchedResultsController = [self fetchedResultsControllerWithPredicate:checkDate];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectedDate:) name:@"GetDateNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidSaveNotification:)name:NSManagedObjectContextDidSaveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureCellForTableUp) name:@"tableViewMovedUpNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureCellForTableDown) name:@"tableViewMovedDownNotification" object:nil];
    
    UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    myCell.accessoryView = accessoryButton;
    
}

- (void) configureCellForTableUp{
    NSLog(@"Table is UP");
    tableIsDown = NO;
}

- (void) configureCellForTableDown{
    NSLog(@"Table is Down");
    tableIsDown = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)handleDidSaveNotification:(NSNotification *)notification {
    NSLog(@"NSManagedObjectContextDidSaveNotification Received by AppointmentsTableViewController");
    
    [managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
	[self.tableView reloadData];
}

- (void)getSelectedDate:(NSNotification *)notification {
    
    NSLog(@"GET DATE NOTIFICATION RECEIVED by AppointmentsTableViewController");
    selectedDate = [notification object];
    
    
    MyDataObject *myData = [self myDataObject];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormatter stringFromDate:myData.myDate];
    NSDate *newDate = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    
    NSPredicate *checkDate = [NSPredicate predicateWithFormat:@"doDate == %@", newDate];    
    self.fetchedResultsController = [self fetchedResultsControllerWithPredicate:checkDate];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
    }
    
    [tableLabel setText:@""];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *) fetchedResultsControllerWithPredicate:(NSPredicate *)aPredicate {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Note" inManagedObjectContext:managedObjectContext]];
    [request setFetchBatchSize:10];
    
    
    [request setPredicate:aPredicate];
    
	NSSortDescriptor *dateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"doDate" ascending:YES] autorelease];
	NSSortDescriptor *typeDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"type" ascending:NO]autorelease];
    NSSortDescriptor *timeDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"doTime" ascending:NO]autorelease];
    [request setSortDescriptors:[NSArray arrayWithObjects:dateDescriptor,typeDescriptor,timeDescriptor, nil]];
    
    NSString *cacheName = @"Root";
    if (aPredicate) {
        cacheName = nil;
    }
    NSFetchedResultsController *newController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:@"doDate" cacheName:cacheName];
    
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
    //NSNumber *number1 = [NSNumber numberWithInt:1];
    //NSNumber *number2 = [NSNumber numberWithInt:2];
    //NSPredicate *firstPredicate = [NSPredicate predicateWithFormat:@"type == 1"];
    //NSPredicate *secondPredicate = [NSPredicate predicateWithFormat:@"type == 2"];
    NSPredicate *compPredicate = [NSPredicate predicateWithFormat:@"type == 1 OR type == 2"];
    self.fetchedResultsController = [self fetchedResultsControllerWithPredicate:compPredicate];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableIsDown){
        return 20.0;
    }else{
        return 15.0;
    }
}

/*
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 
 UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 20.0)] autorelease];
 customView.backgroundColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:0.8];
 
 UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
 headerLabel.backgroundColor = [UIColor clearColor];
 headerLabel.opaque = NO;
 headerLabel.textColor = [UIColor whiteColor];
 headerLabel.font = [UIFont boldSystemFontOfSize:18];
 headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
 headerLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
 headerLabel.frame = CGRectMake(11,-11, 320.0, 44.0);
 headerLabel.textAlignment = UITextAlignmentLeft;
 headerLabel.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section]; 
 [customView addSubview:headerLabel];
 
 return customView;
 }
 */

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableIsDown) {
        return 40.0;
    }else {
        return 30.0;
    }
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo>  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    NSDateFormatter *tempDateFormatter = [[NSDateFormatter alloc] init];
    
    [tempDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    NSDate *aDate = [tempDateFormatter dateFromString:[sectionInfo name]];
    if (tableIsDown){
        [tempDateFormatter setDateFormat:@"EEEE, d MMMM"];
    }
    else {
        [tempDateFormatter setDateFormat:@"EEE, MMM d"];
    }
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
    
    NSDateFormatter * timeFormatter = [[NSDateFormatter alloc] init];
    //[timeFormatter setTimeStyle:NSDateFormatterShortStyle];
        
    [timeFormatter setDateFormat:@"hh:mm a"];
    if ([[_fetchedResultsController objectAtIndexPath:indexPath] isKindOfClass:[Appointment class]]){
    
        if([cell isKindOfClass:[UITableViewCell class]]){
            myCell = (AppointmentCustomCell *) cell;
            //[mycell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];   
        }   
    //if ([_fetchedResultsController objectAtIndexPath:0] != nil) {
        Appointment *anAppointment = [_fetchedResultsController objectAtIndexPath:indexPath];	
        [myCell.textLabel setText:[NSString stringWithFormat:@"%@", anAppointment.text]];
        [myCell.startTimeLabel setText: [timeFormatter stringFromDate:anAppointment.doTime]];
        [myCell.endTimeLabel setText:[timeFormatter stringFromDate:anAppointment.endTime]];
    //}
        [timeFormatter release];
    }
    else {
        TaskCustomCell *mycell;
        if([cell isKindOfClass:[UITableViewCell class]]){
            mycell = (TaskCustomCell *) cell;
            //[mycell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];   
        }
        //if ([_fetchedResultsController objectAtIndexPath:0] != nil) {
        Task *aTask = [_fetchedResultsController objectAtIndexPath:indexPath];	
        [mycell.memoTextLabel setText:[NSString stringWithFormat:@"%@", aTask.text]];
        //}
    }
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //alternates the bgcolor of the rows
    if (indexPath.row == 0 || indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.1];
        cell.backgroundColor = altCellColor;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AppointmentCustomCell";
    
    AppointmentCustomCell *cell = (AppointmentCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		//NSArray *topLevelObjects = [[NSBundle mainBundle]
        //loadNibNamed:@"AppointmentCustomCell"
        //owner:nil options:nil];
		//for (id currentObject in topLevelObjects){
		//	if([currentObject isKindOfClass:[UITableViewCell class]]){
		//		cell = (AppointmentCustomCell *) currentObject;
		//		break;
		//	}
		//}
        //TODO: check if the following code is safe and efficient
        cell = [[[AppointmentCustomCell alloc] init]autorelease];
        if (tableIsDown) {
            UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            cell.accessoryView = accessoryButton;
        }else {
            CGRect frame = cell.contentView.frame;
            frame.size.width = 155.0;
            frame.size.height = 30;
            cell.startTimeLabel.frame = CGRectMake(0, 0, 45, 15);
            cell.endTimeLabel.frame = CGRectMake(0, 15, 45, 15);
            cell.textLabel.frame = CGRectMake(46, 0, 109, 30);
            cell.endTimeLabel.textColor = [UIColor lightTextColor];
            cell.startTimeLabel.textColor = [UIColor lightTextColor];
            cell.textLabel.textColor = [UIColor lightTextColor];
            cell.textLabel.numberOfLines = 3;
            cell.textLabel.minimumFontSize = 8.0;
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            UIImage *image = [UIImage imageNamed:@"wallpaper.png"];
            cell.contentView.backgroundColor = [UIColor colorWithPatternImage:image];
            cell.userInteractionEnabled = NO;
            [cell.textLabel.text sizeWithFont:[UIFont systemFontOfSize:10.0]];
            cell.textLabel.lineBreakMode = UILineBreakModeCharacterWrap;
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
        NSManagedObjectContext *context = [_fetchedResultsController managedObjectContext];
        [context deleteObject:[_fetchedResultsController objectAtIndexPath:indexPath]];
        // Save the context.
        NSError *error;
        if (![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
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
    
    MyDataObject *myData = [self myDataObject];
    myData.selectedAppointment = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:UITableViewSelectionDidChangeNotification object:[_fetchedResultsController objectAtIndexPath:indexPath ]];   
    
}

#pragma mark -
#pragma mark Fetched Results Notifications

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
   	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            NSLog(@"FetchedResultsController ChangeInsert");
            break;
        case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            NSLog(@"FetchedResultsController ChangeDelete");            
            break;
        case NSFetchedResultsChangeUpdate:
			[self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            NSLog(@"FetchedResultsController ChangeUpdate");
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            NSLog(@"FetchedResultsController ChangeMove");
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

@end
