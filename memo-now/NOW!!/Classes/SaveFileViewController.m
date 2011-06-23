//  SaveFileViewController.m
//  NOW!!
//  Created by Keith Fernandes on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.



#import "SaveFileViewController.h"
#import "NOW__AppDelegate.h"

@implementation SaveFileViewController
@synthesize topView, bottomView, getFileName, getFolderName, getTag, searchBar, tableViewController;
@synthesize folderArray, memoArray, fileArray, managedObjectContext;

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
	[self fetchMemoRecords];

}

-(void) fetchFolderRecords{NSLog(@"Going to fetch Folder records now");
	NSEntityDescription *aFolder = [NSEntityDescription entityForName:@"Folder" inManagedObjectContext:managedObjectContext];
	NSFetchRequest *request	= [[NSFetchRequest alloc] init];
	[request setEntity:aFolder];
	NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortByDate];
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


- (void)fetchMemoRecords{
	NSEntityDescription *aMemo = [NSEntityDescription entityForName:@"Memo" inManagedObjectContext:managedObjectContext];
	NSFetchRequest *request =[[NSFetchRequest alloc] init];
	[request setEntity:aMemo];
	NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
	NSArray *sortDescriptors =[NSArray arrayWithObject:sortByDate];
	[request setSortDescriptors:sortDescriptors];
	[sortByDate release];
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest: request error:&error] mutableCopy];
	if (!mutableFetchResults) {
			//
	}
	[self setMemoArray:mutableFetchResults];
	[mutableFetchResults release];
	[request release];
}
- (void)fetchFileRecords{
	NSEntityDescription *aFile = [NSEntityDescription entityForName:@"File"  inManagedObjectContext:managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:aFile];
	NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"fileName" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
	[request setSortDescriptors:sortDescriptors];
	[sortByName release];
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
	if (!mutableFetchResults) {
			//
	}
	[self setFileArray:mutableFetchResults];
	[mutableFetchResults release];
	[request release];
} 

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
	NSString *aString = [NSString stringWithFormat:@"%@", textField.text];
	if ([textField tag] == 3){
/*TODO: Before Setting a new Folder Name, Search whether there is a Folder which Matches the value for aString. If yes, then put alert window asking the user to enter a new Name */		
			Folder *newFolder = (Folder *)[NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext: managedObjectContext];				
			[newFolder setTimeStamp:[NSDate	date]];
			[newFolder setFolderName:aString];
			NSError *error;
			if(![managedObjectContext save:&error]){  //???
			}
			[folderArray insertObject:newFolder atIndex:0];
		}

	else if ([textField tag]==2){
			//Memo *currentMemo = [memoArray objectAtIndex:0];
			//[currentMemo setMemoTags:aString];
		NSError *error;
		if(![managedObjectContext save:&error]){
			}
		}
	else if ([textField tag] ==1){
		File *newFile = (File *)[NSEntityDescription insertNewObjectForEntityForName:@"File" inManagedObjectContext: managedObjectContext];
		[newFile setFileName:aString];
		[newFile addAppendedObject:[memoArray objectAtIndex:0]];
		NSError *error;
		if(![managedObjectContext save:&error]){
			}
		[fileArray insertObject:newFile atIndex:0];
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
