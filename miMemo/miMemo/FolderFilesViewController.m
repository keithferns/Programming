//
//  FolderFilesViewController.m
//  miMemo
//
//  Created by Keith Fernandes on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Folder.h"
#import "Memo.h"
#import "File.h"
#import "MemoText.h"

#import "FolderFilesViewController.h"


@implementation FolderFilesViewController


@synthesize folder, memos;
@synthesize tableView;
@synthesize toolbar;

#define FOLDERS_SECTION 0
#define MEMOS_SECTION 1
#define FILES_SECTION 2

- (void)dealloc
{
    [super dealloc];

    
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
    [self makeToolbar];
    [self.view addSubview:toolbar];
    
    
    NSLog(@"%@", folder.containsMemo);
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 40, 300, 150) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    //tableView.delegate = self;
    [self.view addSubview:tableView];
    
    memos = [[NSMutableArray alloc] initWithArray:[self.folder.containsMemo allObjects]];
   // [memos addObjectsFromArray:[folder.containsFile allObjects]];
    
    [self.tableView reloadData]; 
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UITableView Delegate/Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
//the 3 sections here assumes that any given folder can have (1) (sub)Folders, (2) Memos and (3) Files.

}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    // Return a title or nil as appropriate for the section.
    switch (section) {
        case FOLDERS_SECTION:
            title = @"Folders";
            break;
        case MEMOS_SECTION:
            title = @"Memos";
            break;
        case FILES_SECTION:
            title = @"Files";
        default:
            break;
    }
    return title;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    switch (section) {
        case FOLDERS_SECTION:
            
        case MEMOS_SECTION:
            rows = [folder.containsMemo count];
            break;
        case FILES_SECTION:
            rows = [folder.containsFile count];
            break;
		default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;

    //if (indexPath.section == MEMOS_SECTION) {
		NSUInteger memoCount = [folder.containsMemo count];
        NSLog(@"memoCount is %d", memoCount);
        
        NSInteger row = indexPath.row;
		
        if (indexPath.row < memoCount) {
            // If the row is within the range of the number of ingredients for the current recipe, then configure the cell to show the ingredient name and amount.
			static NSString *MemosCellIdentifier = @"MemosCell";
			
			cell = [self.tableView dequeueReusableCellWithIdentifier:MemosCellIdentifier];
			
			if (cell == nil) {
                // Create a cell to display an ingredient.
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MemosCellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
            Memo *memo = [memos objectAtIndex:row];
            cell.textLabel.text = memo.memoRE;
			cell.detailTextLabel.text = memo.memoText.memoText;
        }
   /*     
        else {
            // If the row is outside the range, it's the row that was added to allow insertion (see tableView:numberOfRowsInSection:) so give it an appropriate label.
			static NSString *AddIngredientCellIdentifier = @"AddIngredientCell";
			
			cell = [tableView dequeueReusableCellWithIdentifier:AddIngredientCellIdentifier];
			if (cell == nil) {
                // Create a cell to display "Add Ingredient".
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddIngredientCellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
            cell.textLabel.text = @"Add Ingredient";
        }
    } 
    else {
        // If necessary create a new cell and configure it appropriately for the section.  Give the cell a different identifier from that used for cells in the Ingredients section so that it can be dequeued separately.
        static NSString *MyIdentifier = @"GenericCell";
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSString *text = nil;
        
        switch (indexPath.section) {
            case TYPE_SECTION: // type -- should be selectable -> checkbox
                text = [recipe.type valueForKey:@"name"];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case INSTRUCTIONS_SECTION: // instructions
                text = @"Instructions";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.editingAccessoryType = UITableViewCellAccessoryNone;
                break;
            default:
                break;
        }
       
        cell.textLabel.text = text;
    }
    */
   // }
    return cell;
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
    
    /*--End Setting up the Toolbar */
}

-(IBAction) navigationAction:(id)sender{
	switch ([sender tag]) {
		case 2:

			break;
		case 1:
            [self dismissModalViewControllerAnimated:YES];
            
			break;
			
		case 0:
				
			break;
		default:
			break;
	}
}


@end
