// Created by Ian Dundas

#import "IDBaseMarshaller.h"


@implementation IDBaseMarshaller {

}

// @subclass me. Return nil to make no change to the value. (default action)
+ (id)mutatedValueForKey:(NSString *)key withInitialValue:(id)initialValue {
    NSLog (@"Warning: blank parent implementation of 'mutatedValueForKey:withInitialValue:' called for key %@", key);
    return nil;
}

// @subclass me
+ (NSNumber *)enumNumberForEnumType:(NSString *)enumType andInitialValue:(NSString *)initialValue {
    NSLog (@"Warning: blank parent implementation of 'enumNumberForEnumType:andInitialValue:' called for type %@", enumType);
    return nil;
}

+ (void)populateProtoRecord:(MMRecordProtoRecord *)protoRecord
       attributeDescription:(NSAttributeDescription *)attributeDescription
             fromDictionary:(NSDictionary *)dictionary {

    NSString *coreDataFieldName = [attributeDescription name];

    // sometimes JSON uses different key to Core Data:
    NSString *alternativeJSONName = (attributeDescription.userInfo)[@"MMRecordAttributeAlternateNameKey"]; // e.g. 'unit'
    NSObject *initialValue = [dictionary valueForKeyPath:alternativeJSONName ? alternativeJSONName : coreDataFieldName];

    // If this is a number and will shoehorned into an ENUM type, calculate the equivalent NSNumber value and set it:
    if ((attributeDescription.userInfo)[@"IDRecordAttributeTypeEnum"]) {
        NSAssert(attributeDescription.attributeType == NSInteger16AttributeType, @"Attribute was not an integer type");
        NSString *enumType = (attributeDescription.userInfo)[@"IDRecordAttributeTypeEnum"]; // e.g. 'TTBundleUnit'

        // NSNumber with equivelant numeric value of the relevant enum. This is how we store it in Core Data.
        NSNumber *enumValueResult = [self enumNumberForEnumType:enumType andInitialValue:initialValue];

        [self setValue:enumValueResult
              onRecord:protoRecord.record
             attribute:attributeDescription
         dateFormatter:protoRecord.representation.dateFormatter];

        return;
    }
    else {
        NSObject *newValue = [self mutatedValueForKey:coreDataFieldName withInitialValue:initialValue];

        if (newValue) {
            [self setValue:newValue
                  onRecord:protoRecord.record
                 attribute:attributeDescription
             dateFormatter:protoRecord.representation.dateFormatter];
            return;
        }

        // otherwise just let MMRecord handle it (as it's not got any strange shit going on)
        [super populateProtoRecord:protoRecord
              attributeDescription:attributeDescription
                    fromDictionary:dictionary];

    }
}


@end
