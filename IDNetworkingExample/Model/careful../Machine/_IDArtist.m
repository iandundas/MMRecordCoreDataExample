// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to IDArtist.m instead.

#import "_IDArtist.h"

const struct IDArtistAttributes IDArtistAttributes = {
	.displayName = @"displayName",
	.id = @"id",
	.onTourUntil = @"onTourUntil",
	.uri = @"uri",
};

const struct IDArtistRelationships IDArtistRelationships = {
	.events = @"events",
};

const struct IDArtistFetchedProperties IDArtistFetchedProperties = {
};

@implementation IDArtistID
@end

@implementation _IDArtist

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"IDArtist" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"IDArtist";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"IDArtist" inManagedObjectContext:moc_];
}

- (IDArtistID*)objectID {
	return (IDArtistID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic displayName;






@dynamic id;






@dynamic onTourUntil;






@dynamic uri;






@dynamic events;

	
- (NSMutableSet*)eventsSet {
	[self willAccessValueForKey:@"events"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"events"];
  
	[self didAccessValueForKey:@"events"];
	return result;
}
	






@end
