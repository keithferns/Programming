//
//  FoldersTableViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "FoldersTableViewController.h"
#import "WriteNowAppDelegate.h"
#import "FolderCell.h"

@implementation FoldersTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext;
@synthesize searchBar;

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
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchFiles:) name:@"HasToggledToFilesViewNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchFolders:) name:@"HasToggledToFoldersViewNotification" object:nil];
    
    isFolderView = YES;
    
    _fetchedResultsController.delegate = self;
    [self.view setFrame:CGRectMake(0, 245, 320, 215)];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 245, 320, 215) style:UITableViewStylePlain];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    searchBar.delegate = self;
    
    [self.tableView addSubview:searchBar];
    
    [searchBar setTranslucent:YES];


    [searchBar setPlaceholder:@"Search for Folder"];
    self.tableView.tableHeaderView = searchBar;
    
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    if (managedObjectContext == nil) { 
		managedObjectContext = [(WriteNowAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
	}
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
	}
}

- (void)fetchFiles:(NSNotification *)notification{
    isFolderView = NO;
    _fetchedResultsController = nil;
    NSLog(@"HAS TOGGLED TO FILES VIEW NOTIFICATION RECIEVED");
    [searchBar setPlaceholder:@"Search for File"];
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
	}
    [self.tableView reloadData];
    return;
}

- (void)fetchFolders:(NSNotification *)notification{
    isFolderView = YES;
    _fetchedResultsController = nil;
    NSLog(@"HAS TOGGLED TO FOLDERS VIEW NOTIFICATION RECIEVED");

    [searchBar setPlaceholder:@"Search for Folder"];
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
	}
    [self.tableView reloadData];

    return;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.fetchedResultsController.delegate = nil;
	self.fetchedResultsController = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
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

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    CGRect topFrame = CGRectMake(0, 0, 320, 245);
    [self.tableView setFrame:topFrame];
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartedSearching_Notification" object:nil];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EndedSearching_Notification" object:nil];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {    
    NSString * searchString = self.searchBar.text;
    NSLog(@"Search String is %@", searchString);    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat: @"name CONTAINS[c] %@", searchString];
    self.fetchedResultsController = [self fetchedResultsControllerWithPredicate:searchPredicate];
    
 	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
	}
    [self.tableView reloadData];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    CGRect bottomFrame = CGRectMake(0, 205, 320, 204);
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    [self.tableView setFrame:bottomFrame];
    self.fetchedResultsController = [self fetchedResultsControllerWithPredicate:nil];
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
	}
    
    [self.tableView reloadData];
    [self.searchBar setShowsCancelButton:NO animated:YES];

}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *) fetchedResultsControllerWithPredicate: (NSPredicate *) aPredicate {
    
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    if (isFolderView) {
        NSLog(@"SETTING NSENTITYDESCRIPTION TO FOLDER");
        [request setEntity:[NSEntityDescription entityForName:@"Folder" inManagedObjectContext:managedObjectContext]];
    }
    else if(!isFolderView){
        NSLog(@"SETTING NSENTITYDESCRIPTION TO FILE");

        [request setEntity:[NSEntityDescription entityForName:@"File" inManagedObjectContext:managedObjectContext]];

    }
    [request setFetchBatchSize:10];
    [request setPredicate:aPredicate];
    
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [[_fetchedResultsController sections] count];
	if (count == 0) {
		count = 1;
	}
    return count;
}
/*
 - (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 //id<NSFetchedResultsSectionInfo>  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
 
 //return [sectionInfo name];
 return @"My Folders";
 }
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    if ([[_fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}

- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	FolderCell *mycell;
	if([cell isKindOfClass:[UITableViewCell class]]){
		mycell = (FolderCell *) cell;
	}
    if (isFolderView) {
        Folder *aFolder = [_fetchedResultsController objectAtIndexPath:indexPath];	
        
        [mycell.folderName setText:aFolder.name];
    }
    else if (!isFolderView){
        File *aFile = [_fetchedResultsController objectAtIndexPath:indexPath];	
        
        [mycell.folderName setText:aFile.name];
    }
    
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
    
    //KJF NOTE: POST A NOTIFICATION WITH THE SELECTED ROW AS THE OBJECT PASSED WITH THE NOTIFICATION TO THE VIEW CONTROLLER
    
    if ([[_fetchedResultsController objectAtIndexPath:indexPath] isKindOfClass:[Folder class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FolderSelectedInTableViewControllerNotification" object:[_fetchedResultsController objectAtIndexPath:indexPath]];
    }
    else if ([[_fetchedResultsController objectAtIndexPath:indexPath] isKindOfClass:[File class]]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FileSelectedInTableViewControllerNotification" object:[_fetchedResultsController objectAtIndexPath:indexPath]];
    }
    
    /*VIEWING
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
     */
    /* ADDING
    newMemo.folder = [_fetchedResultsController objectAtIndexPath:indexPath];	
    
    NSLog(@"%@",newMemo.folder);
    
    folderTextField.text = newMemo.folder.name;
    isSelected = YES;
    
    NSError *error;
	if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
	}
     */
}
@end
