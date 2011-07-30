//
//  MyMemosTableViewController.h
//  miMemo
//
//  Created by Keith Fernandes on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyMemosTableViewController : UITableViewController  <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
        
        
        NSManagedObjectContext *managedObjectContext;
        NSFetchedResultsController *_fetchedResultsController;
        UITableView *tableView;
    }
    
    @property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
    @property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
    @property (nonatomic, retain) IBOutlet UITableView *tableView;
    
    @end
