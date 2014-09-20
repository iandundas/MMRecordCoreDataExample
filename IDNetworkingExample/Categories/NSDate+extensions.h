//
// Created by Ian Dundas on 04/02/2014.
//

@import Foundation;

@interface NSDate (extensions)
+ (NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime;

-(BOOL)isDateOnSameDayAsDate:(NSDate *)otherDate;
@end