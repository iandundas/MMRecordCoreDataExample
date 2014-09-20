// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to IDEvent.h instead.

#import <CoreData/CoreData.h>
#import "MMRecord.h"

extern const struct IDEventAttributes {
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *type;
} IDEventAttributes;

extern const struct IDEventRelationships {
	__unsafe_unretained NSString *artist;
} IDEventRelationships;

extern const struct IDEventFetchedProperties {
} IDEventFetchedProperties;

@class IDArtist;





@interface IDEventID : NSManagedObjectID {}
@end

@interface _IDEvent : MMRecord {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (IDEventID*)objectID;





@property (nonatomic, strong) NSString* displayName;



//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* type;



//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) IDArtist *artist;

//- (BOOL)validateArtist:(id*)value_ error:(NSError**)error_;





@end

@interface _IDEvent (CoreDataGeneratedAccessors)

@end

@interface _IDEvent (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;




- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;





- (IDArtist*)primitiveArtist;
- (void)setPrimitiveArtist:(IDArtist*)value;


@end
