//
//  File.h
//  WriteNow
//
//  Created by Keith Fernandes on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Folder, Memo, Tag;

@interface File : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* tags;
@property (nonatomic, retain) Folder * folder;
@property (nonatomic, retain) NSSet* memos;

@end
