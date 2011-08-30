//
//  FoldersViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoldersViewController : UIViewController <UITextViewDelegate> {
    
    NSManagedObjectContext *managedObjectContext;
    UITableViewController *tableViewController;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITableViewController *tableViewController;

@end
