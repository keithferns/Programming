//
//  FilesTableViewController.m
//  WriteNow
//
//  Created by Keith Fernandes on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "FilesTableViewController.h"
#import "FileCustomCell.h"
#import "WriteNowAppDelegate.h"

@implementation FilesTableViewController

@synthesize managedObjectContext;
@synthesize searchBar;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
    [searchBar release];
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
    [super viewDidLoad];

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    CGRect mytestFrame = CGRectMake(15, 55, 290, 140);
    [self.tableView setFrame:mytestFrame];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{    
    NSString * searchString = self.searchBar.text;
    NSLog(@"Search String is %@", searchString);
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat: @"name CONTAINS[c] %@", searchString];
    self.fetchedResultsController = [self fetchedResultsControllerWithPredicate:searchPredicate];
 	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
	}
    [self.tableView reloadData];    
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *) fetchedResultsControllerWithPredicate: (NSPredicate *) aPredicate{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"File" inManagedObjectContext:managedObjectContext]];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    if ([[_fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}

- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
	
	FileCustomCell *mycell;
	if([cell isKindOfClass:[UITableViewCell class]]){
		mycell = (FileCustomCell *) cell;
	}
    File *aFile = [_fetchedResultsController objectAtIndexPath:indexPath];	
    [mycell.fileName setText:aFile.name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"FileCustomCell";
	FileCustomCell *cell = (FileCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle]
									loadNibNamed:@"FileCustomCell"
									owner:nil options:nil];
		
		for (id currentObject in topLevelObjects){
			if([currentObject isKindOfClass:[UITableViewCell class]]){
				cell = (FileCustomCell *) currentObject;
				break;
			}
		}
	}
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //File *myFile = [_fetchedResultsController objectAtIndexPath:indexPath];

    //[myFile setMemos:<#(NSSet *)#>
    
    //NSString *tempString = [NSString stringWithFormat:@"%@%@%@", myFile.content, @"\n", selectedMemo.text];

    
    //NSLog(@"The file text is %@", tempString);
    
   // myFile.content = tempString;
    //[tempString release];
    
    //textView.text = myFile.content;
    
    //fileTextField.text = myFile.name;
    
    NSError *error;
	if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
	}
}

@end
