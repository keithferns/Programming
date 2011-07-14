//
//  AppointmentsTableViewController.m
//  Memo
//
//  Created by Keith Fernandes on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppointmentsTableViewController.h"
#import "AppDelegate_Shared.h"
#import "StartScreenCustomCell.h"
#import "MemoDetailViewController.h"


#pragma mark -
#pragma mark Private Interface

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Private interface definitions
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface AppointmentsTableViewController (private)


@end

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

@implementation AppointmentsTableViewController

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
	[self.tableView reloadData];
}

	//NOTE: If there are two different managedObjectContexts for two different ViewControllers, then send a NSManagedObjectContextDidSaveNotification to -(void)mergeChangesFromContextDidSaveNotification. The latter will emit change notifications that the fetch results controller will observe.



#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view addSubview:tableView];
		//Point the current instance of the managedObjectContext to the main managedObjectContext
	if (managedObjectContext == nil) { 
		managedObjectContext = [(AppDelegate_Shared *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
	}
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
	}
		
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
		//[self.tableView reloadData];  See managedObjectContextSaved method above.
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}



#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *) fetchedResultsController {
	if (_fetchedResultsController!=nil) {
		return _fetchedResultsController;
	}
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	[request setEntity:[NSEntityDescription entityForName:@"Appointments" inManagedObjectContext:managedObjectContext]];
	
	NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"appointmentTime" ascending:NO];
	
	[request setSortDescriptors:[NSArray arrayWithObject:dateDescriptor]];
	[dateDescriptor release];
	
	[request setFetchBatchSize:10];
	
	
	NSFetchedResultsController *newController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
	
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
	return [sectionInfo name];
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		// Return the number of rows in the section	
	
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
	}
	MemoText *aNote = [_fetchedResultsController objectAtIndexPath:indexPath];	
	if ([aNote.noteType intValue] == 0) {
		[mycell.creationDate setText: [dateFormatter stringFromDate:[aNote.savedMemo creationDate]]];
		[mycell.memoRE setText:[NSString stringWithFormat:@"%@", aNote.savedMemo.memoRE]];
	} 
	else if ([aNote.noteType intValue] == 1){
		
		[mycell.creationDate setText: [dateFormatter stringFromDate:[aNote.savedAppointment creationDate]]];
			//[mycell.memoRE setText:[NSString stringWithFormat:@"%@", aNote.savedAppointment.appointmentRE]];		 
	}
	[mycell.memoText setText:[NSString stringWithFormat:@"%@", aNote.memoText]];
	
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"StartScreenCustomCell";
	
	static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"dd MMMM yyyy h:mm a"];
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
    MemoDetailViewController *detailViewController = [[MemoDetailViewController alloc] initWithNibName:@"MemoDetailView" bundle:[NSBundle mainBundle]];
		// ...
		// Pass the selected object to the new view controller.
	
	
	detailViewController.selectedMemoText = [_fetchedResultsController objectAtIndexPath:indexPath];	
	
	[self presentModalViewController:detailViewController animated:YES];	
	
	
	
    [detailViewController release];
}


#pragma mark -
#pragma mark Fetched Results Notifications
	//Copied from http://www.raywenderlich.com/999/core-data-tutorial-how-to-use-nsfetchedresultscontroller

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
	self.managedObjectContext = nil;
	self.fetchedResultsController.delegate = nil;
	self.fetchedResultsController = nil;}

- (void)dealloc {
    [super dealloc];
	[_fetchedResultsController release];
	[tableView release];
}


@end
