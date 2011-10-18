//
//  Tag.h
//  WriteNow
//
//  Created by Keith Fernandes on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, Folder, Memo;

@interface Tag : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* folders;
@property (nonatomic, retain) NSSet* files;
@property (nonatomic, retain) NSSet* memos;

@end
