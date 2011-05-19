    //
//  SaveFileViewController.m
//  NOW!!
//
//  Created by Keith Fernandes on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



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

- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"added an instance of topView and bottomView to view");
	[self.bottomView addSubview:tableViewController.tableView];
	[self.view addSubview:topView];
	[self.view addSubview:bottomView];
	[self.topView addSubview:getFolderName];
	getFolderName.delegate = self;
	if (managedObjectContext == nil) 
	{ 
        managedObjectContext = [(NOW__AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
	}
	[self fetchFolderRecords];	
}


-(void) fetchFolderRecords{NSLog(@"Going to fetch Folder records now");
		//defining table to use
	NSEntityDescription *aFolder = [NSEntityDescription entityForName:@"Folder" inManagedObjectContext:managedObjectContext];
		//setting up the fetch request
	NSFetchRequest *request	= [[NSFetchRequest alloc] init];
	[request setEntity:aFolder];
		//defines how to sort the records
	NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortByDate];//note: if adding other sortdescriptors, then use method -arraywithObjects. If the fetch request must meet some conditions, then use the NSPredicate class 
	[request setSortDescriptors:sortDescriptors];
	[sortByDate release];
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	if (!mutableFetchResults) {
			//
		}
	[self setFolderArray:mutableFetchResults];//save fetched data to an array
	[mutableFetchResults release];
	[request release];	
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField{
	
	NSString *aString = [NSString stringWithFormat:@"%@", textField.text];
	NSLog(@"aString is set to %@", aString);
	if ([textField tag] == 3){
			NSLog(@"aString is set to %@", aString);
			Folder *newFolder = (Folder *)[NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext: managedObjectContext];	//Initialize a new Memo Object and Insert it into Memo table in the ManagedObjectContext
			[newFolder setTimeStamp:[NSDate	date]];//sets the timeStamp of the new Memo
			[newFolder setFolderName:aString];//copies the input text to the new Memo. 
			NSError *error;
			if(![managedObjectContext save:&error]){  //???
			}
			[folderArray insertObject:newFolder atIndex:0];
			Folder *lastFolder = [folderArray objectAtIndex:0] ;
			NSLog(@"The new folder is %@", [lastFolder valueForKey:@"folderName"]);
	}

	else if ([textField tag]==1){
	Memo *newMemo = (Memo *)[NSEntityDescription insertNewObjectForEntityForName:@"Memo" inManagedObjectContext: managedObjectContext];	//Initialize a new Memo Object and Insert it into Memo table in the ManagedObjectContext
			[newMemo setTimeStamp:[NSDate	date]];//sets the timeStamp of the new Memo
			[newMemo setMemoText:aString];//copies the input text to the new Memo. 
			NSError *error;
			if(![managedObjectContext save:&error]){  //???
			}

	}
	else if ([textField tag] ==2){
		File *newFile = (File *)[NSEntityDescription insertNewObjectForEntityForName:@"File" inManagedObjectContext: managedObjectContext];	//Initialize a new Memo Object and Insert it into Memo table in the ManagedObjectContext
		[newFile setTimeStamp:[NSDate	date]];//sets the timeStamp of the new Memo
		[newFile setMemoText:aString];//copies the input text to the new Memo. 
		NSError *error;
		if(![managedObjectContext save:&error]){  //???
		}
	}

	[textField resignFirstResponder];
	return YES;
}


- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
		//create new subview and initialize with the frame for the topView
	CGRect mytestFrame = CGRectMake(0, 0, 320, 192);
	UIView *myNewView = [[[UIView	alloc] initWithFrame:mytestFrame] autorelease];
		//When the user taps inside the search bar, the new subview is set to blue background and the tableView is added to it. 
	[myNewView setBackgroundColor:[UIColor blueColor]];
	[self.view addSubview:myNewView];
	[myNewView addSubview:tableViewController.tableView];
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

/*
	// this method is used to resign the keyboard 

-(void) touchesBegan :(NSSet *) touches withEvent:(UIEvent *)event

{
	
    [textField resignFirstResponder];
	
    [textField1 resignFirstResponder];
	
    [super touchesBegan:touches withEvent:event ];
	
}

*/
