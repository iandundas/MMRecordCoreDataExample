//
// Created by Ian Dundas on 03/02/2014.
//

@import Foundation;

@interface NSDateFormatter (factory)
+ (NSDateFormatter *)yyyyMMddFormatterInstance;

+ (NSDateFormatter *)timeFormatterInstance;

+ (NSDateFormatter *)ddMMyyFormatterInstance;

+ (NSDateFormatter *)ddMMyyyyFormatterInstance;

+ (NSDateFormatter *)dutchDateTimeFormatterInstance;

+ (NSDateFormatter *)ISO8601DateTimeFormatterInstance;


+ (NSDateFormatter *)ISO8601WithMillisecondsDateTimeFormatterInstance;
@end