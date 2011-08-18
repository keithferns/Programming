//
//  Note.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place;

@interface Note : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * isEditing;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Place * location;

@end
