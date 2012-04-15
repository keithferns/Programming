//
//  FolderDetailViewController.h
//  iDoit
//
//  Created by Keith Fernandes on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderDetailViewController : UITableViewController{

    Folder *theFolder;

}

@property (nonatomic, retain) Folder *theFolder;


@end
