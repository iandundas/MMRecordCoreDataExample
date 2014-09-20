// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to IDEvent.m instead.

#import "_IDEvent.h"

const struct IDEventAttributes IDEventAttributes = {
	.displayName = @"displayName",
	.id = @"id",
	.type = @"type",
};

const struct IDEventRelationships IDEventRelationships = {
	.artist = @"artist",
};

const struct IDEventFetchedProperties IDEventFetchedProperties = {
};

@implementation IDEventID
@end

@implementation _IDEvent

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"IDEvent" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"IDEvent";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"IDEvent" inManagedObjectContext:moc_];
}

- (IDEventID*)objectID {
	return (IDEventID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic displayName;






@dynamic id;






@dynamic type;






@dynamic artist;

	






@end
