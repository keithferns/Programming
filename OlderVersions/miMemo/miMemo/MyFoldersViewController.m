//
//  MyFoldersViewController.m
//  miMemo
//
//  Created by Keith Fernandes on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyFoldersViewController.h"
#import "miMemoAppDelegate.h"
#import "FolderFilesViewController.h"
#import "FolderCell.h"


#import "MyTasksViewController.h"
#import "MyAppointmentsViewController.h"

@implementation MyFoldersViewController

@synthesize toolbar;
@synthesize saveActionSheet, goActionSheet;
@synthesize searchBar;
@synthesize managedObjectContext, tableView;
@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - View lifecycle

//FIXME: Add ability to change/edit the name of a folder. 


- (void)viewDidLoad
{
    [super viewDidLoad];    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 245, 320, 215) style:UITableViewStylePlain];
    //tableView.tableHeaderView.frame.size.height 
    [self.view addSubview:tableView];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    searchBar.delegate = self;
    
    [self.tableView addSubview:searchBar];
    [searchBar setShowsCancelButton:YES];
    tableView.tableHeaderView = searchBar;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self makeToolbar];
    [self.view addSubview:toolbar];  
    if (managedObjectContext == nil) { 
		managedObjectContext = [(miMemoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
	}
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.fetchedResultsController.delegate = nil;
	self.fetchedResultsController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [super dealloc];
    [toolbar release];
    [saveActionSheet release];
    [goActionSheet release];
    [tableView release];
    [_fetchedResultsController release];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"Memory Warning at MyFoldersViewController");

    // Release any cached data, images, etc that aren't in use.
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    CGRect topFrame = CGRectMake(0, 0, 320, 205);
    [self.searchBar resignFirstResponder];
    [tableView setFrame:topFrame];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{    
    NSString * searchString = self.searchBar.text;
    NSLog(@"Search String is %@", searchString);
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat: @"folderName CONTAINS[c] %@", searchString];
    
    self.fetchedResultsController = [self fetchedResultsControllerWithPredicate:searchPredicate];
    
 	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
	}
    [self.tableView reloadData];
    
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    CGRect bottomFrame = CGRectMake(0, 245, 320, 215);
    [tableView setFrame:bottomFrame];
    
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *) fetchedResultsControllerWithPredicate: (NSPredicate *) aPredicate{
    
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"Folder" inManagedObjectContext:managedObjectContext]];
    [request setFetchBatchSize:10];
    [request setPredicate:aPredicate];
    
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"folderName" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObjects:nameDescriptor, nil]];
	[nameDescriptor release];
    
    NSString *cacheName = @"Root";
    if (aPredicate) {
        cacheName = nil;
    }
	NSFetchedResultsController *newController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:cacheName];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	//return [[_fetchedResultsController sections] count];
    return 1;
}
/*
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	//id<NSFetchedResultsSectionInfo>  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
	
	//return [sectionInfo name];
    return @"My Folders";
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section	
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
    //return 1;
}

- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
	
	FolderCell *mycell;
	if([cell isKindOfClass:[UITableViewCell class]]){
        
		mycell = (FolderCell *) cell;
	}
    Folder *aFolder = [_fetchedResultsController objectAtIndexPath:indexPath];	
        
    [mycell.folderName setText:aFolder.folderName];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"FolderCell";

	FolderCell *cell = (FolderCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle]
									loadNibNamed:@"FolderCell"
									owner:nil options:nil];
		
		for (id currentObject in topLevelObjects){
			if([currentObject isKindOfClass:[UITableViewCell class]]){
				cell = (FolderCell *) currentObject;
				break;
			}
		}
	}
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Folder *selectedFolder = [_fetchedResultsController objectAtIndexPath:indexPath];
    //  Create another view controller.
    
    FolderFilesViewController *detailViewController = [[FolderFilesViewController alloc] initWithNibName:@"FolderFilesViewController" bundle:[NSBundle mainBundle]];
    
    NSLog(@"the selectedFolderis %@", selectedFolder);
    // Pass the selected object to the new view controller.

    detailViewController.folder = selectedFolder;
    detailViewController.managedObjectContext = self.managedObjectContext;
    
    //Present the new viewController
    [self presentModalViewController:detailViewController animated:YES];
    [detailViewController release];

}

#pragma -
#pragma Navigation Controls and Actions

- (void) makeToolbar{
    /*Setting up the Toolbar */
    CGRect buttonBarFrame = CGRectMake(0, 210, 320, 40);
    toolbar = [[UIToolbar alloc] initWithFrame:buttonBarFrame];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar setTintColor:[UIColor blackColor]];
    UIBarButtonItem *saveAsButton = [[UIBarButtonItem alloc] initWithTitle:@"SAVE AS" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [saveAsButton setTag:0];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [doneButton setTag:1];
    UIBarButtonItem *gotoButton = [[UIBarButtonItem alloc] initWithTitle:@"GO TO.." style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [gotoButton setTag:2];
    [saveAsButton setWidth:90];
    [doneButton setWidth:90];
    [gotoButton setWidth:90];
    //UIButton *customView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //Possible to use this with the initWithCustomView method of  UIBarButtonItems
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
    
    NSArray *items = [NSArray arrayWithObjects:flexSpace, saveAsButton, flexSpace, doneButton, flexSpace, gotoButton, flexSpace,nil];
    [toolbar setItems:items];
    [doneButton release];
    [saveAsButton release];
    [gotoButton release];
    [flexSpace release];
    
    /*--End Setting up the Toolbar */
}

-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
		case 2:
			self.goActionSheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Go To" delegate:self cancelButtonTitle:@"Later"
								  destructiveButtonTitle:nil otherButtonTitles:@"Memos", @"Appointments", @"Tasks", nil];
			
			[goActionSheet showInView:self.view];
			
			
			NSLog(@"The Go To Action was Shown");
			break;
		case 1:
            [self dismissModalViewControllerAnimated:YES];
            
			break;
			
		case 0:
			saveActionSheet = [[UIActionSheet alloc] 
                               initWithTitle:@"What do you want to do with this Memo?" delegate:self
                               cancelButtonTitle:@"Later" destructiveButtonTitle:nil otherButtonTitles:@"Name, Tag and Save", @"Append to Existing File", @"Appointment or Task Reminder", nil];
			[saveActionSheet showInView:self.view];			
			break;
		default:
			break;
	}
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (actionSheet	== saveActionSheet){
		switch (buttonIndex) {
				
			case 3:
				NSLog(@"Cancel Button Clicked on saveAlert");
				break;
			case 2:
				NSLog(@"3nd Button Clicked on saveAlert");
				break;
			case 1:
				NSLog(@"2nd Button Clicked on saveAlert");
				break;
			case 0:
				NSLog(@"1st Button Clicked on saveAlert");
				break;
			default:
				break;
		}
	}
	else if (actionSheet == goActionSheet){
		switch (buttonIndex){
			case 3:
				NSLog(@"Cancel Button Clicked on wallAlert");
			default:
				break;
			case 2:
				NSLog(@"Task Button Clicked on WallAlert");
				break;
			case 1:
				NSLog(@"Appointments Button Clicked on WallAlert");
			{MyAppointmentsViewController *viewController = [[[MyAppointmentsViewController alloc] initWithNibName:@"MyAppointmentsViewController" bundle:nil] autorelease];			
				[self presentModalViewController:viewController animated:YES];}
				break;
			case 0:
				NSLog(@" Folder and Files Button Clicked on WallAlert");
				break;				
		}
	}
}
#pragma -

@end
