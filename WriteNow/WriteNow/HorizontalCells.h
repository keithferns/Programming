//
//  HorizontalCells.h
//  WriteNow
//
//  Created by Keith Fernandes on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HorizontalCells : UITableViewCell <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView *_hTableView;
    NSArray *myObjects;

}

@property (nonatomic, retain) UITableView *hTableView;
@property (nonatomic, retain) NSArray *myObjects;



@end
