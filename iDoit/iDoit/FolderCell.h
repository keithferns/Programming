//
//  FolderCell.h
//  WriteNow
//
//  Created by Keith Fernandes on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FolderCell : UITableViewCell {
    
	UILabel *folderName;
	
}

@property (nonatomic, retain) IBOutlet UILabel *folderName;


@end