//
//  Note.h
//  WriteNow
//
//  Created by Keith Fernandes on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person, Place;

@interface Note : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * doTime;
@property (nonatomic, retain) NSDate * doDate;
@property (nonatomic, retain) NSNumber * isEditing;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Place * location;
@property (nonatomic, retain) Person * person;

@end
