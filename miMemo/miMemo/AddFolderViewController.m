//
//  AddFolderViewController.m
//  Memo
//
//  Created by Keith Fernandes on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddFolderViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "miMemoAppDelegate.h"
#import "NSManagedObjectContext-insert.h"
#import "Memo.h"
#import "FolderCell.h"

@implementation AddFolderViewController

@synthesize managedObjectContext, managedObjectContextTV;
@synthesize newMemoText, newFolder;
@synthesize goActionSheet;
@synthesize toolbar;
@synthesize folderTextField, fileTextField, tagTextField, textView, newTextInput;
@synthesize tableView, searchBar;
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"In AddFolderViewController");
    /*-- Setting Up the main view 
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [myView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    myView.hidden = NO;
    self.view = myView;         --*/
    
    [self makeToolbar];
    [self.view addSubview:toolbar];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    
    /*--The Text View --*/
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 45, 300, 160)];
    [self.view addSubview:textView];
    [textView setFont:[UIFont systemFontOfSize:18]];
    textView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    textView.layer.cornerRadius = 7.0;
    textView.layer.frame = CGRectInset(textView.layer.frame, 5, 10);
    textView.layer.contents = (id) [UIImage imageNamed:@"lined_paper_320x200.png"].CGImage;    
    [textView setText:[NSString stringWithFormat:@"%@", newTextInput]];
    [self.view addSubview:textView];
    [textView setDelegate:self];
    /*--Adding the Date and Time Fields--*/
    
    folderTextField = [[UITextField alloc] init];
    [folderTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [folderTextField setFont:[UIFont systemFontOfSize:15]];
    [folderTextField setFrame:CGRectMake(12, 20, 295, 31)];
    [folderTextField setPlaceholder:@"Folder"];
    [self.view addSubview:folderTextField];
        
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 245, 320, 215) style:UITableViewStylePlain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.delegate = self;
    [searchBar setShowsCancelButton:YES];
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.tableView addSubview:searchBar];
    tableView.tableHeaderView = searchBar;
    
//TODO: add textField for Tags    
    
    /*--Done Setting Up the Views--*/
    
    /*-- Initializing the managedObjectContext--*/
    
	if (managedObjectContextTV == nil) { 
		managedObjectContextTV = [(miMemoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContextTV);
    }
    /*--Done Initializing the managedObjectContext--*/
    
    newMemoText = [managedObjectContext insertNewObjectForEntityForName:@"MemoText"];
    [newMemoText setMemoText:newTextInput];
    [newMemoText setCreationDate:[NSDate date]]; 
   
    Memo *newMemo = [managedObjectContext insertNewObjectForEntityForName:@"Memo"];
    newMemo.memoText = newMemoText; 
    newMemo.doDate = newMemoText.creationDate ;

    /*
    //Insert a new File Object into the MOC
    newFile = [managedObjectContext insertNewObjectForEntityForName:@"File"]; 
    int temp = arc4random();
    NSString *tempString = [NSString stringWithFormat:@"%d", temp];

    [newFile setFileName:tempString];
     newMemo.appendToFile = newFile;
     newFile.savedIn = newFolder;
     */
    
    NSError *error;
	if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
	}
    swappingViews = NO;     
    isSelected = NO;
    NSError *fetcherror;
	if (![[self fetchedResultsController] performFetch:&fetcherror]) {
	}
}

- (void) makeFolder{
    if (folderTextField.text == nil) {
        return;
    }
    //else if (!isSelected){ 
//FIXME: check to see if a folder with the specified name exists, if yes, put up an alert view 
        
    newFolder = [managedObjectContext insertNewObjectForEntityForName:@"Folder"]; 
    newFolder.folderName = folderTextField.text;
    newMemoText.savedMemo.savedIn = newFolder;
    
    if (folderTextField.text == @"") {
    int tempF = abs(arc4random());
    NSString *tempStringF = [NSString stringWithFormat:@"Folder%d", tempF];
    [newFolder setFolderName:tempStringF];
        }
        
        /*--Save the MOC--*/	
    NSError *error;
    if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
        }

    if (!swappingViews) {
        [self swapViews];
    }
    /*-- Change the OK Button to the DONE button --*/
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [doneButton setTag:3];
    [doneButton setWidth:90];
    NSUInteger newButton = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:toolbar.items] retain];
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 1) {
            newButton = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButton withObject:doneButton];
    toolbar.items = toolbarItems;
}


-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	swappingViews = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc {
    [super dealloc];
    [goActionSheet release];
    [toolbar release];
    [folderTextField release];
    [tagTextField release];
    [textView release];
    [searchBar release];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    CGRect mytestFrame = CGRectMake(15, 55, 290, 140);
    [tableView setFrame:mytestFrame];
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    newMemoText.savedMemo.savedIn = [_fetchedResultsController objectAtIndexPath:indexPath];	

    NSLog(@"%@",newMemoText.savedMemo.savedIn);
    
    folderTextField.text = newMemoText.savedMemo.savedIn.folderName;
    isSelected = YES;
    
    NSError *error;
	if(![managedObjectContext save:&error]){ 
        NSLog(@"DID NOT SAVE");
	}
}

#pragma mark -
#pragma mark Class Methods

- (void) backAction{
	[self dismissModalViewControllerAnimated:YES];		
}


/*
- (void) makeFile{
    if (folderTextField.text == nil) {
        return;
    }
    newFile.fileName = fileTextField.text;
    //--Save the MOC--
	NSError *error;
	if(![managedObjectContext save:&error]){ 
        NSLog(@"makeFile DID NOT SAVE");
	}
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [newButton setTag:4];
    [newButton setWidth:90];
    NSUInteger newButtonIndex = 0;
    NSMutableArray *toolbarItems = [[NSMutableArray arrayWithArray:appointmentsToolbar.items] retain];
    
    for (NSUInteger i = 0; i < [toolbarItems count]; i++) {
        UIBarButtonItem *barButtonItem = [toolbarItems objectAtIndex:i];
        if (barButtonItem.tag == 3) {
            newButtonIndex = i;
            break;
        }
    }
    [toolbarItems replaceObjectAtIndex:newButtonIndex withObject:newButton];
    appointmentsToolbar.items = toolbarItems;
}
*/

- (void) swapViews {
	CATransition *transition = [CATransition animation];
	transition.duration = 1.0;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[transition setType:@"kCATransitionPush"];	
	[transition setSubtype:@"kCATransitionFromRight"];
	swappingViews = YES;
	transition.delegate = self;
	[self.view.layer addAnimation:transition forKey:nil];
    //set views hidden and not hidden in sequence.
}

#pragma mark -
#pragma mark Navigation
- (void) makeToolbar {
    /*Setting up the Toolbar */
    CGRect buttonBarFrame = CGRectMake(0, 208, 320, 37);
    toolbar = [[[UIToolbar alloc] initWithFrame:buttonBarFrame] autorelease];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar setTintColor:[UIColor blackColor]];
    UIBarButtonItem *saveAsButton = [[UIBarButtonItem alloc] initWithTitle:@"BACK" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [saveAsButton setTag:0];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [newButton setTag:1];
    UIBarButtonItem *gotoButton = [[UIBarButtonItem alloc] initWithTitle:@"GO TO.." style:UIBarButtonItemStyleBordered target:self action:@selector(navigationAction:)];
    [gotoButton setTag:2];
    [saveAsButton setWidth:90];
    [newButton setWidth:90];
    [gotoButton setWidth:90];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil	action:nil];
    
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithObjects:flexSpace, saveAsButton, flexSpace, newButton, flexSpace, gotoButton, flexSpace,nil];
    [toolbar setItems:toolbarItems];
    /*--End Setting up the Toolbar */
}

-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
		case 0:
            [self backAction];
            break;            
		case 1:
            [self makeFolder];
			break;
		case 2:
			self.goActionSheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Go To" delegate:self cancelButtonTitle:@"Later"
								  destructiveButtonTitle:nil otherButtonTitles:@"Memos, Files and Folders", @"Appointments", @"Tasks", nil];
			[goActionSheet showInView:self.view];            
			break;
        case 3:
            [NSFetchedResultsController deleteCacheWithName:@"Root"];
            [self dismissModalViewControllerAnimated:YES];
            break;
        case 4:
            break;     
		default:
			break;
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex){
        case 3:
        default:
            break;
        case 2:			
            break;
        case 1:			
            break;
        case 0:
            break;				
    }
}

@end