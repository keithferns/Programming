//
//  MyDataObject.h
//  WriteNow
//
//  Created by Keith Fernandes on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDataObject.h"

@interface MyDataObject : AppDataObject {
 
    Note *myNote;
    NSNumber *noteType;
    NSDate *myDate;
}

@property (nonatomic, retain) Note *myNote;

@property (nonatomic, retain) NSDate *myDate;

@property (nonatomic, retain) NSNumber *noteType;

@end
