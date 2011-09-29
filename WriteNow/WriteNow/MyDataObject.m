//
//  MyDataObject.m
//  WriteNow
//
//  Created by Keith Fernandes on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyDataObject.h"


@implementation MyDataObject

@synthesize myDate;
@synthesize myNote, noteType, myText;

- (void)dealloc {//Release any properties declared as retain or copy.
	self.myDate = nil;
	self.myNote = nil;
    self.noteType = nil;
    self.myText = nil;
	[super dealloc];
}

@end
