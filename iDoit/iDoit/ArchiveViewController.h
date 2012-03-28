//
//  ArchiveViewController.h
//  iDoit
//
//  Created by Keith Fernandes on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WEPopoverController.h"
#import "NewItemOrEvent.h"
#import "FoldersTableViewController.h"
#import "FilesTableViewController.h"

@interface ArchiveViewController : UIViewController <PopoverControllerDelegate, UIAlertViewDelegate>{
    NewItemOrEvent *theItem;
    BOOL saving;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) WEPopoverController *actionsPopover;
@property (nonatomic, retain) NewItemOrEvent *theItem;
@property (nonatomic, readwrite) BOOL saving;
@property (nonatomic, retain) FoldersTableViewController *foldersTableViewController;
@property (nonatomic, retain) FilesTableViewController *filesTableViewController;

- (UIView *) addItemsView: (CGRect) frame;

- (UIView *)organizerView: (CGRect)frame;
- (void) presentActionsPopover:(id) sender;

@end


