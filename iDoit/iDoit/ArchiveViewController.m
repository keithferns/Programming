//
//  ArchiveViewController.m
//  iDoit
//
//  Created by Keith Fernandes on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArchiveViewController.h"
#import "FoldersTableViewController.h"
#import "FoldersDetailViewController.h"//testing
#import "Contants.h"


@implementation ArchiveViewController

@synthesize actionsPopover;
@synthesize isSaving;

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    isSaving = NO;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Navigation Bar SetUP
    NSArray *items = [NSArray arrayWithObjects:@"Folders", @"Files", nil];
    UISegmentedControl *archivingControl = [[UISegmentedControl alloc] initWithItems:items];
    [archivingControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [archivingControl setWidth:60 forSegmentAtIndex:0];
    [archivingControl setWidth:60 forSegmentAtIndex:1];
    [archivingControl setSelectedSegmentIndex:0];
    
     self.navigationItem.titleView = archivingControl;
    [archivingControl release];
    if (!isSaving){
        
        UIBarButtonItem *rightNavButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(presentActionsPopover:)];
        rightNavButton.tag = 2;
        self.navigationItem.rightBarButtonItem = rightNavButton;    
        [rightNavButton release];
        UIBarButtonItem *leftNavButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentActionsPopover:)];
        leftNavButton.tag = 1;
        self.navigationItem.leftBarButtonItem = leftNavButton;
        [leftNavButton release];
    }
    
    //Table View
    FoldersTableViewController *tableViewController = [[FoldersTableViewController alloc] initWithStyle:UITableViewStyleGrouped];

    tableViewController.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0,kNavBarHeight,kScreenWidth, kScreenHeight-kNavBarHeight-kTabBarHeight)];
    tableViewController.tableView.backgroundColor = [UIColor blackColor];

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    searchBar.tintColor = [UIColor blackColor];

    tableViewController.tableView.tableHeaderView = searchBar;
    [searchBar release];
    
    [self.view addSubview:tableViewController.tableView];

}

- (void) viewWillAppear:(BOOL)animated{
    
    
    UIBarButtonItem *firstItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentActionsPopover:)];
    //firstItem.title = @"Do Something";
    [firstItem setTag:1];
    
    
    UIBarButtonItem *secondItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(presentActionsPopover:)];
    
    [secondItem setTag:2];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight-kTabBarHeight, kScreenWidth, kTabBarHeight)];
    [toolbar setItems:[NSArray arrayWithObjects:flexSpace, firstItem,flexSpace,secondItem,flexSpace, nil]];
    toolbar.tintColor = [UIColor clearColor];
    [firstItem release];
    [secondItem release];
    [flexSpace release];
    [self.view addSubview:toolbar];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) editFoldersFiles{

//    
}


#pragma mark - Popover Management

- (void) presentActionsPopover:(id) sender{
    //Check for visisble instance of actionsPopover. if yes dismiss.
    if([actionsPopover isPopoverVisible]) {
        [actionsPopover dismissPopoverAnimated:YES];
        [actionsPopover setDelegate:nil];
        [actionsPopover autorelease];
        actionsPopover = nil;
        return;
    }
        
    if(!actionsPopover ) {
        
        UIViewController *viewCon = [[UIViewController alloc] init];
        
            switch ([sender tag]) {
            case 1://ADDING NEW FOLDERS OR FILES
                {
                NSLog(@"Saving");        
                
                    
                CGSize size = CGSizeMake(140, 100);
                viewCon.contentSizeForViewInPopover = size;
                    
               viewCon.view =  [self addItemsView:CGRectMake(0, 0, size.width, size.height)];
                actionsPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
                    [actionsPopover setDelegate:self];
                    
                if (isSaving){
                
                    [actionsPopover presentPopoverFromRect:CGRectMake(80, kScreenHeight-kTabBarHeight, 50, 40)
                                                inView:self.view    
                              permittedArrowDirections:UIPopoverArrowDirectionDown
                                              animated:YES name:@"Save"];  
                }
                    else if (!isSaving) {
                        [actionsPopover presentPopoverFromRect:CGRectMake(10, 0, 50, 40)
                                                        inView:self.view    
                                      permittedArrowDirections:UIPopoverArrowDirectionUp
                                                      animated:YES name:@"Save"];     
                    }
                    
                [viewCon release];
                }
                break;
                
            case 2:
                {
                NSLog(@"Organizing");
                
                CGSize size = CGSizeMake(140, 210);
                viewCon.contentSizeForViewInPopover = size;
                viewCon.view = [self organizerView: CGRectMake(0, 0, size.width, size.height)];
                
                actionsPopover = [[WEPopoverController alloc] initWithContentViewController:viewCon];
                    [actionsPopover setDelegate:self];
                
            if (isSaving) {
                                
            [actionsPopover presentPopoverFromRect:CGRectMake(190, kScreenHeight-kTabBarHeight, 50, 40)
                                                inView:self.view
                              permittedArrowDirections: UIPopoverArrowDirectionDown
                                              animated:YES name:@"Plan"];
                }
            else if (!isSaving) {
                [actionsPopover presentPopoverFromRect:CGRectMake(280,0, 50, 40) inView:self.view
                    permittedArrowDirections: UIPopoverArrowDirectionUp
                    animated:YES name:@"Organize"];
                        }
             
                [viewCon release];
                }
                break;
                
                
            default:
                break;
        }    

    }

}
- (void) cancelPopover:(id)sender {
    NSLog(@"CANCELLING POPOVER");
    return;
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Did dismiss");
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController {
    NSLog(@"Should dismiss");
    return YES;
}


- (void) makeNewFolderFile:(id)sender{
    //
}


- (UIView *) addItemsView: (CGRect) frame{
    UIView *oView = [[UIView alloc] initWithFrame:frame];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 54, 54)];
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(button1.frame.size.width+30, 5, 54, 54)];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(button1.frame.origin.x-10, button1.frame.size.height+5, button1.frame.size.width+20, 30)];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setTextAlignment:UITextAlignmentCenter];
    [label1 setTextColor:[UIColor whiteColor]];
    [label1 setFont:[UIFont boldSystemFontOfSize:12]];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(button2.frame.origin.x, button2.frame.size.height+5, button2.frame.size.width, 30)];    
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setTextAlignment:UITextAlignmentCenter];
    [label2 setFont:[UIFont boldSystemFontOfSize:12]];
    [label2 setTextColor:[UIColor whiteColor]];
    

    
    [button1 setImage:[UIImage imageNamed:@"folder_button.png"] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"folder_button_selected.png"] forState:UIControlStateHighlighted];
    [button1 addTarget:self action:@selector(makeNewFolderFile:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTag:1];
    [button2 setImage:[UIImage imageNamed:@"files_button.png"] forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"files_button_selected.png"] forState:UIControlStateSelected];
    
    [button2 addTarget:self action:@selector(makeNewFolderFile:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTag:2];
    [label1 setText:@"Folder"];
    [label2 setText:@"File"];
    
    [oView addSubview:button1];
    [oView addSubview:button2];
    [oView addSubview:label1];
    [oView addSubview:label2];
    
    [button1 release];
    [button2 release];
    [label1 release];
    [label2 release];
    
    return oView;

}

- (UIView *)organizerView: (CGRect)frame {
    UIView *oView = [[UIView alloc] initWithFrame:frame];
    UILabel *sortLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 29)];
    [sortLabel setText:@"Sort By"];
    [sortLabel setBackgroundColor:[UIColor clearColor]];
    sortLabel.textColor = [UIColor lightTextColor];
    sortLabel.font = [UIFont boldSystemFontOfSize:18];
    sortLabel.layer.borderWidth = 2;
    sortLabel.layer.borderColor = [UIColor clearColor].CGColor;
    UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 120, 29)];
    [b1 setTitle:@"Name" forState:UIControlStateNormal];
    b1.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    b1.backgroundColor = [UIColor darkGrayColor];
    b1.alpha = 0.4;
    [b1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    //b1.layer.borderWidth = 2;
    //b1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [b1 addTarget:self action:@selector(pushingDetail) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *b2 = [[UIButton alloc] initWithFrame:CGRectMake(5, 60, 120, 29)];
    b2.backgroundColor = [UIColor darkGrayColor];
    b2.alpha = 0.4;
    [b2 setTitle:@"Date Created" forState:UIControlStateNormal];
    b2.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    [b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    //b2.layer.borderWidth = 2;
    //b2.layer.borderColor = [UIColor darkGrayColor].CGColor;
    UIButton *b3 = [[UIButton alloc] initWithFrame:CGRectMake(5, 90, 120, 29)];
    [b3 setTitle:@"Date Modified" forState:UIControlStateNormal];
    b3.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    [b3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b3 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    b3.backgroundColor = [UIColor darkGrayColor];
    b3.alpha = 0.4;

    //b3.layer.borderWidth = 2;
    //b3.layer.borderColor = [UIColor darkGrayColor].CGColor;
    UIButton *b4 = [[UIButton alloc] initWithFrame:CGRectMake(5, 120, 120, 29)];
    [b4 setTitle:@"Other" forState:UIControlStateNormal];
    b4.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    b4.backgroundColor = [UIColor darkGrayColor];
    //b4.layer.borderWidth = 2;
    //b4.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [b4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b4 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    b4.alpha = 0.4;

    UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 140, 29)];
    deleteLabel.backgroundColor = [UIColor clearColor];
    deleteLabel.textColor = [UIColor lightTextColor];
    [deleteLabel setText:@"Delete"];
    deleteLabel.font = [UIFont boldSystemFontOfSize:18];

    UIButton *b5 = [[UIButton alloc] initWithFrame:CGRectMake(5, 180, 120, 29)];
    [b5 setTitle:@"Delete" forState:UIControlStateNormal];
    //b5.layer.borderWidth = 2;
    //b5.layer.borderColor = [UIColor darkGrayColor].CGColor;
    b5.titleLabel.font = [UIFont italicSystemFontOfSize:15];
    b5.alpha = 0.4;
    b5.backgroundColor = [UIColor darkGrayColor];
    [b5 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [b5 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    [oView addSubview:sortLabel];
    [oView addSubview:b1];
    [oView addSubview:b2];
    [oView addSubview:b3];
    [oView addSubview:b4];
    [oView addSubview:deleteLabel];
    [oView addSubview:b5];
    
    
    [b1 release];
    [b2 release];
    [b3 release];
    [b4 release];
    [b5 release];
    [sortLabel release];
    [deleteLabel release];
    
    return oView;
}

- (void) pushingDetail {
    FoldersDetailViewController *detailViewController = [[FoldersDetailViewController alloc] init];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

@end
