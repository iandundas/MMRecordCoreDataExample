//
// Created by Ian Dundas on 07/03/2014.
//

@import Foundation;
#import "AFMMRecordResponseSerializer.h"

@class IDBaseWebService;
@class IDCoreDataWebService;


@interface IDRecordResponseSerializer : AFMMRecordResponseSerializer
@property(nonatomic, strong) IDCoreDataWebService *webserviceDelegate;
@end