//
//  FolderFilesViewController.h
//  miMemo
//
//  Created by Keith Fernandes on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Folder;

@interface FolderFilesViewController : UIViewController <UITableViewDataSource>{
    
    Folder *folder;
    NSMutableArray *memos;
    NSManagedObjectContext *managedObjectContext;

    
}


@property (nonatomic, retain) Folder *folder;
@property (nonatomic, retain) NSMutableArray *memos;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIButton *changeName;
@property (nonatomic, retain) IBOutlet UITextField *folderName;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


- (IBAction) changeFolderName;
- (void) makeToolbar;
- (IBAction) navigationAction:(id)sender;

@end
