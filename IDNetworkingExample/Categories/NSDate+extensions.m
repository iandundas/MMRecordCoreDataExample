//
// Created by Ian Dundas on 04/02/2014.
//

#import "NSDate+extensions.h"


@implementation NSDate (extensions)
-(BOOL)isDateOnSameDayAsDate:(NSDate *)otherDate
{
    NSDateComponents *firstDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    NSDateComponents *secondDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:otherDate];
    return [firstDay day] == [secondDay day] &&
        [firstDay month] == [secondDay month] &&
        [firstDay year] == [secondDay year] &&
        [firstDay era] == [secondDay era];
}

+ (NSInteger)daysBetweenDate:(NSDate *)fromDateTime andDate:(NSDate *)toDateTime {
    NSDate *fromDate;
    NSDate *toDate;

    NSCalendar *calendar = [NSCalendar currentCalendar];

    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];

    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];

    return [difference day];
}
@end