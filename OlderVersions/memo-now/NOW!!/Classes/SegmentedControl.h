//
//  SegmentedControl.h
//  NOW!!
//
//  Created by Keith Fernandes on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SegmentedControl : UISegmentedControl {

	BOOL momentary;
	UISegmentedControlStyle segmentedControlStyle;
	UIColor *tintColor;
	
}

@property(nonatomic, getter=isMomentary) BOOL momentary;
@property(nonatomic) UISegmentedControlStyle segmentedControlStyle;
@property(nonatomic, retain) UIColor *tintColor;

	
	

@end
