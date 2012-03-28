//
//  FoldersDetailTableViewController.h
//  iDoit
//
//  Created by Keith Fernandes on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoldersDetailTableViewController : UITableViewController{

Folder *folder;
NSMutableArray *memos;
NSManagedObjectContext *managedObjectContext;


}


@property (nonatomic, retain) Folder *folder;
@property (nonatomic, retain) NSMutableArray *memos;

@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIButton *changeName;
@property (nonatomic, retain) IBOutlet UITextField *folderName;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


//- (IBAction) changeFolderName;
//- (void) makeToolbar;
//- (IBAction) navigationAction:(id)sender;

@end
