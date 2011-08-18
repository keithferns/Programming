//
//  CurrentViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrentViewController.h"
#import "WriteNowAppDelegate.h"

#import "StartScreenCustomCell.h"
#import "TaskCustomCell.h"

#import "Memo.h"
#import "Appointment.h"
#import "Task.h"


// Name of notification
NSString * const managedObjectContextSavedNotification= @"ManagedObjectContextSaved";

#pragma mark -
#pragma mark Private Interface
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface CurrentViewController (private)
- (void) managedObjectContextSaved:(NSNotification *)notification;
@end
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/


@implementation CurrentViewController


@synthesize managedObjectContext, tableView;
@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark -
#pragma mark Private Methods
/*---------------------------------------------------------------------------
 * Notifications of ManagedObjectContext Saved 
 *--------------------------------------------------------------------------*/
- (void) managedObjectContextSaved:(NSNotification *)notification{
    // Redisplay the data.
    //NOTE: This can also be done using the viewWillAppearMethod.
    NSLog(@"ManagedObjectContextSavedNotificationReceived");

	[self.tableView reloadData];
}
- (void)handleDidSaveNotification:(NSNotification *)notification {
    NSLog(@"NSManagedObjectContextDidSaveNotification received");

    [managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    [self.tableView reloadData];
}
///////

- (void)dealloc
{
    [super dealloc];
    [_fetchedResultsController release];
	[tableView release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [NSFetchedResultsController deleteCacheWithName:@"Root"];

    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(handleDidSaveNotification:)
     name:NSManagedObjectContextDidSaveNotification 
     object:nil];
    /*configure tableView, set its properties and add it to the main view.*/
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 220) style:UITableViewStylePlain];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 320, 26)];
    [headerLabel setBackgroundColor:[UIColor lightGrayColor]];
    [headerLabel setText:@"MY STUFF"];
    [headerLabel setTextAlignment:UITextAlignmentCenter];
    [headerView setBackgroundColor:[UIColor blackColor]];
    [headerView addSubview:headerLabel];
    //[tableView setTableHeaderView:headerView];
    //[tableView setSectionFooterHeight:0.0];
    //[tableView setSectionHeaderHeight:15.0];
    [tableView setRowHeight:55.0];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    
    
    
    /*-- Point current instance of the MOC to the main managedObjectContext --*/
	if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
	}
    
    /* call method to perform the fetch */
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
	}
    
    /* NOTICATION */
    
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(managedObjectContextSaved:) name:managedObjectContextSavedNotification object:nil];
    

    
}

    

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.managedObjectContext = nil;
	self.fetchedResultsController.delegate = nil;
	self.fetchedResultsController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *) fetchedResultsController {
	if (_fetchedResultsController!=nil) {
		return _fetchedResultsController;
	}
    
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Note" inManagedObjectContext:managedObjectContext]];
    
	NSSortDescriptor *typeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES];
	NSSortDescriptor *textDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];// just here to test the sections and row calls
    
    
    /*-- set Predicate to filter all tasks and appointments for a time after NOW --*/
    //NSArray *checkDateArray = [NSArray arrayWithObjects:@"memotext.savedAppointment.doDate",@"memotext.saveMemo.doDate", @"memotext.saveTask.doDate", nil];
    
    //NSPredicate *checkDate = [NSPredicate predicateWithFormat:@"'[NSDate date]' < %@" argumentArray:checkDateArray];
    
    //[request setPredicate:checkDate];
    
    /* -- --*/
    
	[request setSortDescriptors:[NSArray arrayWithObjects:typeDescriptor,textDescriptor, nil]];
    [typeDescriptor release];
    [textDescriptor release];
    
	[request setFetchBatchSize:10];
    
	NSFetchedResultsController *newController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:@"type" cacheName:@"Root"];
    
	newController.delegate = self;
	self.fetchedResultsController = newController;
	[newController release];
	[request release];
	
	return _fetchedResultsController;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[_fetchedResultsController sections] count];
}
/*
 - (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 id<NSFetchedResultsSectionInfo>  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
 int mySection;
 mySection = [[sectionInfo name] intValue];
 if (mySection == 0){
 return	@"Notes";
 }
 else if (mySection == 1){
 return @"Appointments";
 }
 else if (mySection == 2) {
 return @"Tasks";
 }
 else{
 return @"No Saved Memo's";
 }
 }
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    //return [sectionInfo numberOfObjects];
    return 1;
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
        [mycell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];   
    }
    Note *currentItem = [_fetchedResultsController objectAtIndexPath:indexPath];	
    
	if ([currentItem.type intValue] == 0) {
        Memo *memo = [_fetchedResultsController objectAtIndexPath:indexPath];
        [mycell.memoText setText:[NSString stringWithFormat:@"%@", memo.text]];	
		[mycell.date setText:[dateFormatter stringFromDate:memo.creationDate]];
        [mycell.dateLabel setText:@"CREATED:"];
        mycell.imageView.image = [UIImage imageNamed:@"MEMO.png"];
    } 
	else if ([currentItem.type intValue] == 1){
        Appointment *appointment = [_fetchedResultsController objectAtIndexPath:indexPath];
        [mycell.memoText setText:[NSString stringWithFormat:@"%@", appointment.text]];
		[mycell.date setText:[dateFormatter stringFromDate:appointment.creationDate]];
        [mycell.dateLabel setText:@"SCHEDULED:"];
        mycell.imageView.image = [UIImage imageNamed:@"Tasks Icon.png"];
	}
    else if ([currentItem.type intValue] == 2){
    //else if ([[_fetchedResultsController objectAtIndexPath:indexPath] isKindOfClass:[Task class]]){  
        Task *task  = [_fetchedResultsController objectAtIndexPath:indexPath];
        [mycell.memoText setText:[NSString stringWithFormat:@"%@", task.text]];
		[mycell.date setText: [dateFormatter stringFromDate:task.creationDate]];
        [mycell.dateLabel setText:@"DUE:"];
        mycell.imageView.image = [UIImage imageNamed:@"ToDo.png"];
	}
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // MemoText *aNote = [_fetchedResultsController objectAtIndexPath:indexPath];	
    //if ([aNote.noteType intValue] == 0){
    
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
    /*}
     else if ([aNote.noteType intValue] == 1){
     
     static NSString *CellIdentifier = @"TaskCustomCell";
     
     TaskCustomCell *cell = (TaskCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     NSArray *topLevelObjects = [[NSBundle mainBundle]
     loadNibNamed:@"TaskCustomCell"
     owner:nil options:nil];
     for (id currentObject in topLevelObjects){
     if([currentObject isKindOfClass:[UITableViewCell class]]){
     cell = (TaskCustomCell *) currentObject;
     break;
     }
     }
     }
     [self configureCell:cell atIndexPath:indexPath];
     return cell;
     }
     else if ([aNote.noteType intValue] == 2){
     
     static NSString *CellIdentifier = @"TaskCustomCell";
     
     TaskCustomCell *cell = (TaskCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     NSArray *topLevelObjects = [[NSBundle mainBundle]
     loadNibNamed:@"TaskCustomCell"
     owner:nil options:nil];
     for (id currentObject in topLevelObjects){
     if([currentObject isKindOfClass:[UITableViewCell class]]){
     cell = (TaskCustomCell *) currentObject;
     break;
     }
     }
     }
     
     [self configureCell:cell atIndexPath:indexPath];
     return cell;
     }*/
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
        //NSManagedObjectContext *context = [_fetchedResultsController managedObjectContext];
		[managedObjectContext deleteObject:[_fetchedResultsController objectAtIndexPath:indexPath]];
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
    
    /*
    MemoText *selectedMemoText = [_fetchedResultsController objectAtIndexPath:indexPath];	
    if ([selectedMemoText.noteType intValue] == 0){
        MyMemosViewController *detailViewController = [[MyMemosViewController alloc] initWithNibName:nil bundle:nil];  
        detailViewController.selectedMemoText = selectedMemoText;
        [self presentModalViewController:detailViewController animated:YES];	
        [detailViewController release];
    }
    else if ([selectedMemoText.noteType intValue] == 1) {
        MyAppointmentsViewController *detailViewController = [[MyAppointmentsViewController alloc] initWithNibName:@"MyAppointmentsViewController" bundle:[NSBundle mainBundle]];  
        detailViewController.selectedMemoText = selectedMemoText;
        [self presentModalViewController:detailViewController animated:YES];	
        [detailViewController release];
    }
    else if ([selectedMemoText.noteType intValue] == 2){
        MyTasksViewController *detailViewController = [[MyTasksViewController alloc] initWithNibName:nil bundle:nil]; 
        detailViewController.selectedMemoText = selectedMemoText;
        [self presentModalViewController:detailViewController animated:YES];	
        [detailViewController release];
        
    }
    */
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
            break;
			
        case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
			[self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
			
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
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