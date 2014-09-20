//
// Created by Ian Dundas on 01/06/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import <ObjectiveRecord/CoreDataManager.h>
#import "IDEventViewController.h"
#import "IDArtist.h"
#import "NSString+ObjectiveSugar.h"
#import "_IDEvent.h"
#import "IDEvent.h"


@interface IDEventViewController ()
@property (nonatomic, strong) IDArtist *artist;
@property (nonatomic, strong) NSArray *events;
@end

@implementation IDEventViewController {}

-(instancetype)initWithArtist:(IDArtist*)artist{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _artist= artist;
        _events= @[];
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"Path: %@", NSStringWithFormat(@"artists/%@/calendar.json", self.artist.id));

    /* Why won't this return anything?!? argh */

    __weak __typeof(self)weakSelf = self;
    [IDEvent startRequestWithURN: NSStringWithFormat(@"artists/%@/calendar.json", self.artist.id)
                             data:nil
                          context:[[CoreDataManager sharedManager] managedObjectContext]
                           domain:self
                      resultBlock:^(NSArray *records) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        self.events= records.copy;

        NSLog(@"Events: %@", self.events);
        [self.tableView reloadData];
    }
                     failureBlock:^(NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.events.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID= @"eventsCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if (!cell){
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    IDEvent *event= self.events[(NSUInteger) indexPath.row];

    [cell.textLabel setText:event.displayName];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end