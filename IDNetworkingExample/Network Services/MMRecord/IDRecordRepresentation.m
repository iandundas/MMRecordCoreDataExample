//
// Created by Ian Dundas on 03/03/2014.
//

#import "IDRecordRepresentation.h"
#import "IDBaseMarshaller.h"

@implementation IDRecordRepresentation {
}

- (Class)marshalerClass {

    Class marshallerClass = @{
        // Add here e.g.:
//        @"MMBundle" : [IDBundleRecordMarshaller class],

    }[self.entity.name];

    if (!marshallerClass) {
        NSLog (@"CANNOT FIND MARSHALLER FOR ENTITY: %@", self.entity.name);
        return [IDBaseMarshaller class];
    }
    return marshallerClass;
}

@end