//
// Created by Ian Dundas on 07/03/2014.
//

#import <ObjectiveSugar/ObjectiveSugar.h>
#import "IDRecordResponseSerializer.h"
#import "IDBaseWebService.h"
#import "MMRecordResponse.h"
#import "IDCoreDataWebService.h"
#import "IDConfiguration.h"

@interface IDRecordResponseSerializer ()
@property(nonatomic, strong) id <AFMMRecordResponseSerializationEntityMapping> entityMapper;
@end

@implementation IDRecordResponseSerializer {

}

#pragma mark - AFURLResponseSerialization


// This is the entry point to the class: AFNetworking calls this.
- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {

    unless ([IDConfiguration isProduction]){
        // this is the correct place to grab the *untouched* received JSON
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog (@"Raw JSON: %@", responseString);
    }

    NSError *localError = nil;
    // Send raw network response back to our Network layer to be cleaned up / mutated as needed.
    id cleanedResponseObject = [self.webserviceDelegate responseObjectFromNetworkResponse:response
                                                                                 withData:data
                                                                    andResponseSerializer:self.HTTPResponseSerializer
                                                                                    error:&localError];

    if (localError != nil) {
        *error = localError; //  :(
        return nil;
    }

    NSEntityDescription *initialEntity = [self.entityMapper recordResponseSerializer:self
                                                                   entityForResponse:response
                                                                      responseObject:cleanedResponseObject
                                                                             context:self.context];
    if (!initialEntity) {
        *error = [NSError errorWithDomain:IDServiceErrorDomain
                                     code:500
                                 userInfo:@{NSLocalizedDescriptionKey : @"Could not determine appropriate action for received server response"}
        ];
        return nil;
    }


    // Drill down into response and pull out data from keyPath, if relevant.
    // Also, wrap dictionary in an Array, if relevant.
    NSArray *responseArray = [self responseArrayFromResponseObject:cleanedResponseObject initialEntity:initialEntity];

    // MMRecordResponse is merely a wrapper for context + initialEntity + responseObjectArray, which will be used..
    MMRecordResponse *recordResponse = [MMRecordResponse responseFromResponseObjectArray:responseArray
                                                                           initialEntity:initialEntity
                                                                                 context:self.context];
    // ... here, to produce hydrate Core Data records.
    NSArray *records = [self recordsFromMMRecordResponse:recordResponse
                                       backgroundContext:[self backgroundContext]];
    return records;
}

@end