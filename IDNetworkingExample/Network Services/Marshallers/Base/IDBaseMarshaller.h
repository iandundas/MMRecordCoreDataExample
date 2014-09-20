// Created by Ian Dundas

@import Foundation;
#import <MMRecord/MMRecordMarshaler.h>
#import <MMRecord/MMRecordProtoRecord.h>
#import <MMRecord/MMRecordRepresentation.h>

@interface IDBaseMarshaller : MMRecordMarshaler

+ (id)mutatedValueForKey:(NSString *)key withInitialValue:(id)initialValue;

+ (NSNumber *)enumNumberForEnumType:(NSString *)enumType andInitialValue:(id)initialValue;
@end
