//
// Created by Ian Dundas on 01/06/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import "IDArtistViewController.h"
#import "IDArtist.h"
#import "NSDate+DateTools.h"
#import "NSString+ObjectiveSugar.h"
#import "NSDateFormatter+factory.h"
#import "IDEventViewController.h"


@interface IDArtistViewController ()
@property (nonatomic, strong) IDArtist *artist;

- (void)pushEventsViewController;
@end

@implementation IDArtistViewController {

}

-(instancetype)initWithArtist:(IDArtist*)artist{
    if (self = [super init]) {
        _artist= artist;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle: self.artist.displayName];
}

- (void) pushEventsViewController{
    IDEventViewController *viewController= [[IDEventViewController alloc] initWithArtist:self.artist];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID= @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if (!cell){
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }

    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section > 0)
        return;

    if (indexPath.row == 0){
        if ([self.artist.onTourUntil isEarlierThan:[NSDate date]]){
            [cell.textLabel setText:@"Not currently on tour"];
        }
        else{
            NSString *untilString= [[NSDateFormatter ddMMyyyyFormatterInstance] stringFromDate:self.artist.onTourUntil];
            [cell.textLabel setText:NSStringWithFormat (@"On Tour Until: %@", untilString )];
            [cell.detailTextLabel setText:@"Tap to view events"];
        }
    }
    else if (indexPath.row == 1){
        [cell.textLabel setText:@"Visit Artist's page"];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0){
        if ([self.artist.onTourUntil isLaterThanOrEqualTo:[NSDate date]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.artist.uri]];
        }
    }
}
@end