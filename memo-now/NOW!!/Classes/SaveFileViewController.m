    //
//  SaveFileViewController.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//TO DO. Add TextField To Put File Name.
//TO DO. ADD TextField To Put Folder Name.
//TO DO. Add TextField To Add Tag.
//TO Do. Add Search Box to Search For Folders. Resuse Code from MyMemos
//TO 


#import "SaveFileViewController.h"
#import "NOW__AppDelegate.h"

@implementation SaveFileViewController
@synthesize topView, bottomView, getFileName, getFolderName, getTag, searchBar, tableViewController;
@synthesize folderArray, managedObjectContext;



#pragma mark -
#pragma mark Navigation

-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
		case 1:
			[self dismissModalViewControllerAnimated:YES];	
			break;
		case 2:
			[self dismissModalViewControllerAnimated:YES];	
			break;
		case 3:
			[self dismissModalViewControllerAnimated:YES];	
			break;
		default:
			break;
	}
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	isSearching = NO;
	NSLog(@"added an instance of topView and bottomView to view");
	[self.bottomView addSubview:tableViewController.tableView];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	NSLog(@"isSearching is set to %d", isSearching);
	isSearching = YES;
	NSLog(@"isSearching is now set to %d", isSearching);
	/*
		//create new subview and initialize with the frame for the topView
	CGRect mytestFrame = CGRectMake(0, 0, 320, 192);
	UIView *myNewView = [[[UIView	alloc] initWithFrame:mytestFrame] autorelease];
		
		//When the user taps inside the search bar, the new subview is set to blue background and the tableView is added to it. 
	if (isSearching) {
		
		[myNewView setBackgroundColor:[UIColor blueColor]];
		[self.view addSubview:myNewView];
		[myNewView addSubview:tableViewController.tableView];
	}
	*/
}

- (IBAction) nameFile{
	
}
- (IBAction) makeFolder{
	NSLog(@"firing myFolder");
	NSString *mytext = [NSString stringWithFormat: @"%@", getFolderName.text];
	NSLog(@"%@", mytext);
	Folder *newFolder = (Folder *)[NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext: managedObjectContext];	
	[newFolder setTimeStamp:[NSDate	date]];
	[newFolder setFolderName:mytext];
	NSError *error;
	if(![managedObjectContext save:&error]){  //???
	}
	[folderArray insertObject:newFolder atIndex:0];
}

- (IBAction) addTag{
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
	[topView release];
	[bottomView release];
	[getFileName release];
	[getFolderName release];
	[getTag release];
	[searchBar release];
	[tableViewController release];
}


@end
