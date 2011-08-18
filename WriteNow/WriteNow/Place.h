//
//  Place.h
//  WriteNow
//
//  Created by Keith Fernandes on 8/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note, Person;

@interface Place : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Address;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* notes;
@property (nonatomic, retain) NSSet* persons;

@end
