//
// Created by Ian Dundas on 04/07/2014.
//

#import "CoreDataManager+extensions.h"


@implementation CoreDataManager (extensions)
- (BOOL)resetDatastore // http://stackoverflow.com/a/6322866/349364
{
    [[self managedObjectContext] lock];
    [[self managedObjectContext] reset];
    NSPersistentStore *store = [[[self persistentStoreCoordinator] persistentStores] lastObject];
    BOOL resetOk = NO;

    if (store)
    {
        NSURL *storeUrl = store.URL;
        NSError *error;

        if ([[self persistentStoreCoordinator] removePersistentStore:store error:&error])
        {
            [self setValue:nil forKey:@"persistentStoreCoordinator"];
            [self setValue:nil forKey:@"managedObjectContext"];

            if (![[NSFileManager defaultManager] removeItemAtPath:storeUrl.path error:&error])
            {
                NSLog(@"\nresetDatastore. Error removing file of persistent store: %@",
                        [error localizedDescription]);
                resetOk = NO;
            }
            else
            {
                //now recreate persistent store
                [self persistentStoreCoordinator];
                [[self managedObjectContext] unlock];
                resetOk = YES;
            }
        }
        else
        {
            NSLog(@"\nresetDatastore. Error removing persistent store: %@",
                    [error localizedDescription]);
            resetOk = NO;
        }
        return resetOk;
    }
    else
    {
        NSLog(@"\nresetDatastore. Could not find the persistent store");
        return resetOk;
    }
}
@end