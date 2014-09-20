// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to IDArtist.h instead.

#import <CoreData/CoreData.h>
#import "MMRecord.h"

extern const struct IDArtistAttributes {
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *onTourUntil;
	__unsafe_unretained NSString *uri;
} IDArtistAttributes;

extern const struct IDArtistRelationships {
	__unsafe_unretained NSString *events;
} IDArtistRelationships;

extern const struct IDArtistFetchedProperties {
} IDArtistFetchedProperties;

@class IDEvent;






@interface IDArtistID : NSManagedObjectID {}
@end

@interface _IDArtist : MMRecord {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (IDArtistID*)objectID;





@property (nonatomic, strong) NSString* displayName;



//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* onTourUntil;



//- (BOOL)validateOnTourUntil:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* uri;



//- (BOOL)validateUri:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *events;

- (NSMutableSet*)eventsSet;





@end

@interface _IDArtist (CoreDataGeneratedAccessors)

- (void)addEvents:(NSSet*)value_;
- (void)removeEvents:(NSSet*)value_;
- (void)addEventsObject:(IDEvent*)value_;
- (void)removeEventsObject:(IDEvent*)value_;

@end

@interface _IDArtist (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;




- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSDate*)primitiveOnTourUntil;
- (void)setPrimitiveOnTourUntil:(NSDate*)value;




- (NSString*)primitiveUri;
- (void)setPrimitiveUri:(NSString*)value;





- (NSMutableSet*)primitiveEvents;
- (void)setPrimitiveEvents:(NSMutableSet*)value;


@end
