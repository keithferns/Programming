//
//  MyAppointmentsTableViewController.m
//  Memo
//
//  Created by Keith Fernandes on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyAppointmentsTableViewController.h"
#import "miMemoAppDelegate.h"
#import "StartScreenCustomCell.h"
#import "MemoDetailViewController.h"

@implementation MyAppointmentsTableViewController

@synthesize managedObjectContext, tableView;
@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view addSubview:tableView];
    
    //Point the current instance of the MOC to the main MOC
	if (managedObjectContext == nil) { 
		managedObjectContext = [(miMemoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
	}
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
	}
 }

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self.tableView reloadData];  //See managedObjectContextSaved method above.
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
		
	[request setEntity:[NSEntityDescription entityForName:@"Appointment" inManagedObjectContext:managedObjectContext]];
		
	NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"doDate" ascending:YES];
	NSSortDescriptor *timeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"doTime" ascending:NO];
	
	[request setSortDescriptors:[NSArray arrayWithObjects:dateDescriptor,timeDescriptor, nil]];
	[dateDescriptor release];
	[timeDescriptor release];
		
	[request setFetchBatchSize:10];
	
	NSFetchedResultsController *newController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:@"doDate" cacheName:@"Root"];
		
	newController.delegate = self;
	self.fetchedResultsController = newController;
	[newController release];
	[request release];
	
	return _fetchedResultsController;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
		// Return the number of sections -- if there are any. For now it should return 1. 
	return [[_fetchedResultsController sections] count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	id<NSFetchedResultsSectionInfo>  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *aDate = [dateFormatter dateFromString:[sectionInfo name]];
        
    
    [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy"];
    NSString *mydate = [dateFormatter stringFromDate:aDate];
    
    [dateFormatter release];
	return mydate;
    //return [sectionInfo name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section	

		id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
		return [sectionInfo numberOfObjects];
		//return 1;
}

- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
	StartScreenCustomCell *mycell;
	if([cell isKindOfClass:[UITableViewCell class]]){
	
		mycell = (StartScreenCustomCell *) cell;
	}
	 Appointment *aNote = [_fetchedResultsController objectAtIndexPath:indexPath];	
        [mycell.dateLabel setText:@"Scheduled at:"];
        [mycell.date setText: [aNote doTime]];
        [mycell.memoText setText:[NSString stringWithFormat:@"%@", aNote.memoText.memoText]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    static NSString *CellIdentifier = @"StartScreenCustomCell";
	
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EEEE dd MMMM"];
	}
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
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MemoDetailViewController *detailViewController = [[MemoDetailViewController alloc] initWithNibName:@"MemoDetailView" bundle:[NSBundle mainBundle]];
     // ...
     // Pass the selected object to the new view controller.
	
	detailViewController.selectedMemoText = [_fetchedResultsController objectAtIndexPath:indexPath];	
		
	[self presentModalViewController:detailViewController animated:YES];	
	
    [detailViewController release];
}
*/
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
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;	
    //self.managedObjectContext = nil;
	self.fetchedResultsController.delegate = nil;
	self.fetchedResultsController = nil;
}

- (void)dealloc {
    [super dealloc];
	[_fetchedResultsController release];
	[tableView release];
}


@end

