//
//  AddEntityTableViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "AddEntityTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppointmentCustomCell.h"
#import "WriteNowAppDelegate.h"
#import "DetailViewController.h"

@implementation AddEntityTableViewController

//@synthesize myTableView;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext;
@synthesize tableLabel;
@synthesize selectedDate;

- (MyDataObject *) myDataObject;
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	MyDataObject* myDataObject;
	myDataObject = (MyDataObject*) theDelegate.myDataObject;
	return myDataObject;
}



- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
    
    [_fetchedResultsController release];
    [tableLabel release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetDateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"IN ADDENTITY TABLEVIEWCONTROLLER");
    [NSFetchedResultsController deleteCacheWithName:@"Root"];
    
    [self.view setFrame:CGRectMake(0, 245, 320, 215)];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 245, 320, 215) style:UITableViewStylePlain];
    
    /*-- MOC: Initialize--*/
    if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
    }
    /*--MOC:Done --*/
   // NSTimeInterval *timeInterval    = 5*60*60;
    
    NSDate *tempDate = [NSDate dateWithTimeIntervalSinceNow:-6*60*60];
    
    NSPredicate *checkDate = [NSPredicate predicateWithFormat:@"doDate > %@", tempDate];
    
    self.fetchedResultsController = [self fetchedResultsControllerWithPredicate:checkDate];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
    }
    NSLog(@"Done Loading View"); 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectedDate:) name:@"GetDateNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidSaveNotification:)name:NSManagedObjectContextDidSaveNotification object:nil];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.fetchedResultsController = nil;
    self.selectedDate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
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
    NSLog(@"NSManagedObjectContextDidSaveNotification Received by AddEntityTableViewController");
    
    [managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    
	[self.tableView reloadData];
}


- (void)getSelectedDate:(NSNotification *)notification {
    
    NSLog(@"GET DATE NOTIFICATION RECEIVED FROM AddEntityTableViewController");
    selectedDate = [notification object];
    
    NSLog(@"selected date = %@", selectedDate);
    
    NSPredicate *checkDate = [NSPredicate predicateWithFormat:@"doDate == %@", selectedDate];
    
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
    [request setEntity:[NSEntityDescription entityForName:@"Appointment" inManagedObjectContext:managedObjectContext]];
    [request setFetchBatchSize:10];
    
    [request setPredicate:aPredicate];
    
	NSSortDescriptor *dateDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"doDate" ascending:YES] autorelease];
	NSSortDescriptor *timeDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"doTime" ascending:NO]autorelease];    
    [request setSortDescriptors:[NSArray arrayWithObjects:dateDescriptor,timeDescriptor, nil]];
    
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

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo>  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    NSDateFormatter *tempDateFormatter = [[NSDateFormatter alloc] init];
    
    [tempDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    NSDate *aDate = [tempDateFormatter dateFromString:[sectionInfo name]];
    
    [tempDateFormatter setDateFormat:@"EEEE, d MMMM"];
    
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
    NSDateFormatter * timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
	if([cell isKindOfClass:[UITableViewCell class]]){
		mycell = (AppointmentCustomCell *) cell;
        //[mycell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];   
    }
    //if ([_fetchedResultsController objectAtIndexPath:0] != nil) {
    Appointment *anAppointment = [_fetchedResultsController objectAtIndexPath:indexPath];	
    [mycell.textLabel setText:[NSString stringWithFormat:@"%@", anAppointment.text]];
    [mycell.timeLabel setText: [timeFormatter stringFromDate:anAppointment.doTime]];
    //}
    [timeFormatter release];
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
    
    //DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:[NSBundle mainBundle]];
    // Pass the selected object to the new view controller.
	
	//detailViewController.selectedFolder = [_fetchedResultsController objectAtIndexPath:indexPath];	
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

@end
