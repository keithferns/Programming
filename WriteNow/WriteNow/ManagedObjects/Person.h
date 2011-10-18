//
//  Person.h
//  WriteNow
//
//  Created by Keith Fernandes on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note, Place;

@interface Person : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * phone;
@property (nonatomic, retain) Note * note;
@property (nonatomic, retain) Place * location;

@end
