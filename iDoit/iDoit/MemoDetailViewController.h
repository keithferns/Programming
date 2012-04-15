//
//  MemoDetailViewController.h
//  iDoit
//
//  Created by Keith Fernandes on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewItemOrEvent.h"

@interface MemoDetailViewController : UITableViewController{
    
    NewItemOrEvent *theItem;
    
}

@property (nonatomic,retain) NewItemOrEvent *theItem;


@end