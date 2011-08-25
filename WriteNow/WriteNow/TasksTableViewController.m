//
//  TasksTableViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TasksTableViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "WriteNowAppDelegate.h"
#import "TaskCustomCell.h"


@implementation TasksTableViewController

@synthesize managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize tableLabel;
@synthesize selectedDate;


- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [super dealloc];
    [_fetchedResultsController release];
    [selectedDate release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];    


}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"IN TASKS TABLEVIEWCONTROLLER");
    
    [NSFetchedResultsController deleteCacheWithName:@"Root"];

    tableLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    [tableLabel setBackgroundColor:[UIColor lightGrayColor]];
    [tableLabel setTextColor:[UIColor whiteColor]];
    [tableLabel setTextAlignment:UITextAlignmentCenter];
    [tableLabel setText:@"All Tasks"];
    [self.view addSubview:tableLabel];

    //UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 110, 300, 85)];
    //[myTableView.layer setCornerRadius:5.0];
    //[myTableView setDelegate:self];
    //[myTableView setDataSource:self];
    //[myTableView setTableHeaderView:tableLabel];
    //self.tableView = myTableView;
    
    [self.tableView setFrame:CGRectMake(10, 110, 300, 85)];
    [self.tableView.layer setCornerRadius:10.0];
    [self.tableView setTableHeaderView:tableLabel];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    /*-- Initializing the managedObjectContext--*/
	if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    }
    
    /*--Done Initializing the managedObjectContext--*/
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
    }
    NSLog(@"Done Loading View");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectedDate:) name:@"GetDateNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidSaveNotification:)name:NSManagedObjectContextDidSaveNotification 
     object:nil];
    
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.fetchedResultsController = nil;
    self.selectedDate = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)handleDidSaveNotification:(NSNotification *)notification {
    
    NSLog(@"NSManagedObjectContextDidSaveNotification Received by TasksTableViewController");
    
    [managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
	
    [self.tableView reloadData];
}


- (void)getSelectedDate:(NSNotification *)notification {
    
    NSLog(@"GET DATE NOTIFICATION RECEIVED FROM TASKSVIEWCONTROLLER");
    selectedDate= [notification object];
    NSLog(@"my task = %@", selectedDate);
    NSPredicate *checkDate = [NSPredicate predicateWithFormat:@"doDate == %@", selectedDate];
    self.fetchedResultsController = [self fetchedResultsControllerWithPredicate:checkDate];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
    }
    [self.tableView.tableHeaderView setHidden:YES];
    [self.tableView reloadData];    
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *) fetchedResultsControllerWithPredicate:(NSPredicate *)aPredicate {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext]];
    [request setFetchBatchSize:10];
    [request setPredicate:aPredicate];    
	NSSortDescriptor *dateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"doDate" ascending:YES] autorelease];
    [request setSortDescriptors:[NSArray arrayWithObjects:dateDescriptor, nil]];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

/* // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }*/


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

@end
