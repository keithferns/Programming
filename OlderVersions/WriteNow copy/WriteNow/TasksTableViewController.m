//  TasksTableViewController.m
//  WriteNow
//  Created by Keith Fernandes on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "WriteNowAppDelegate.h"
#import "TasksTableViewController.h"
#import "TaskCustomCell.h"
#import "DetailViewController.h"

@implementation TasksTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext, tableLabel;
@synthesize selectedDate;

- (MyDataObject *) myDataObject {
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	MyDataObject* myDataObject;
	myDataObject = (MyDataObject*) theDelegate.myDataObject;
	return myDataObject;
}


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
    [tableLabel release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetDateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil]; 
}
- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.fetchedResultsController = nil;
    self.selectedDate = nil;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    NSLog(@"TASKS TABLEVIEWCONTROLLER: MEMORY WARNING RECEIVED");
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
    //[self.view addSubview:tableLabel];
    //[self.tableView setTableHeaderView:tableLabel];
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    /*-- MOC: Initialize--*/
	if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    }    /*--MOC:Done --*/

    /*--Set the predicate to show only items that are 6 hours prior to NOW--*/
    //TODO: REFINE THIS PREDICATE
    NSDate *tempDate = [NSDate dateWithTimeIntervalSinceNow:-6*60*60];
    NSPredicate *checkDate = [NSPredicate predicateWithFormat:@"doDate > %@", tempDate];
    self.fetchedResultsController = [self fetchedResultsControllerWithPredicate:checkDate];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectedDate:) name:@"GetDateNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidSaveNotification:)name:NSManagedObjectContextDidSaveNotification 
     object:nil];
    
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section       
{
    
    id<NSFetchedResultsSectionInfo>  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    int mySection;
    mySection = [[sectionInfo name] intValue];
    UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 20.00)] autorelease];
    
   
    customView.backgroundColor = [UIColor colorWithRed:0.9 green:0.5 blue:0.2 alpha:1.0];
    
    UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    headerLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    headerLabel.frame = CGRectMake(11,-11, 320.0, 44.0);
    headerLabel.textAlignment = UITextAlignmentLeft;
    headerLabel.text = [self.tableView.dataSource tableView:self.tableView titleForHeaderInSection:section]; 
    [customView addSubview:headerLabel];
    
    return customView;
}
*/

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	id<NSFetchedResultsSectionInfo>  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    NSDateFormatter *tempDateFormatter = [[NSDateFormatter alloc] init];
    [tempDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    NSDate *aDate = [tempDateFormatter dateFromString:[sectionInfo name]];    
    [tempDateFormatter setDateFormat:@"EEEE, MMM d"];
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
