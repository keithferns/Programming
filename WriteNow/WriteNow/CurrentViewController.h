//
//  CurrentViewController.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CurrentViewController : UIViewController < NSFetchedResultsControllerDelegate, UITextViewDelegate,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
    
        NSManagedObjectContext *managedObjectContext;
        NSFetchedResultsController *_fetchedResultsController;
        UITableView *tableView;	
    }
    @property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
    @property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
    @property (nonatomic, retain) UITableView *tableView;
    
    
    @end