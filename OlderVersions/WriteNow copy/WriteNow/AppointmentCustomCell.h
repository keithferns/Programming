//
//  AppointmentCustomCell.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppointmentCustomCell : UITableViewCell {
    
    UILabel *textLabel, *startTimeLabel, *endTimeLabel;
}
    
@property (nonatomic, retain) UILabel *textLabel, *startTimeLabel, *endTimeLabel;


@end
