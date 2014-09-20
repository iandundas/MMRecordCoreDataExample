//
// Created by Ian Dundas on 01/06/2014.
// Copyright (c) 2014 Ian Dundas. All rights reserved.
//

#import "IDSearchViewController.h"
#import "IDArtist.h"
#import "CoreDataManager.h"
#import "IDEventViewController.h"
#import "CRToast.h"
#import "UIColor+KKL.h"
#import "IDArtistViewController.h"


@interface IDSearchViewController () <UISearchDisplayDelegate>
@property (nonatomic, strong) NSArray *artists;

@property (nonatomic, retain) UISearchDisplayController *searchController;
@property (nonatomic, retain) UISearchBar *searchBar;

- (void)performSearchFor:(NSString *)searchTerm;
- (void)displayErrorWithText:(NSString *)errorText;
@end

@implementation IDSearchViewController {
}

-(instancetype)init{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _artists= @[];

        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,170,320,44)];
        _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    }
    return self;
}
#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"SK Search"];

    self.tableView.tableHeaderView = self.searchBar;
    self.searchBar.delegate = self;

    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    [self.searchController setActive:NO animated:YES];

    [self.searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.artists.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID= @"artistCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if (!cell){
        cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    IDArtist *artist= self.artists[(NSUInteger) indexPath.row];
    [cell.textLabel setText:artist.displayName];

//    UIImageView *imageView= [[UIImageView alloc]init];
//    [imageView setImageWithURL:[NSURL urlWith]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IDArtist *artist= self.artists[(NSUInteger) indexPath.row];

    IDArtistViewController *viewController= [[IDArtistViewController alloc] initWithArtist:artist];
    [self.navigationController pushViewController:viewController animated:YES];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - search stuff

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
        [self.searchDisplayController.searchBar scopeButtonTitles][(NSUInteger) [self.searchDisplayController.searchBar selectedScopeButtonIndex]]];

    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
        [self.searchDisplayController.searchBar scopeButtonTitles][(NSUInteger) searchOption]];

    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performSearchFor:searchBar.text];
}

#pragma mark - Networking:

- (void) performSearchFor:(NSString *)searchTerm{

    __weak __typeof(self)weakSelf = self;
    [IDArtist startRequestWithURN:@"search/artists.json"
                             data:@{@"query":searchTerm}
                          context:[[CoreDataManager sharedManager] managedObjectContext]
                           domain:self
                      resultBlock:^(NSArray *records) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        self.artists= records.copy;

        if (self.artists.count) {
            [self.tableView reloadData];
            [self.searchController.searchResultsTableView reloadData];
        }
        else{
            [strongSelf displayErrorWithText: @"No results found :("];
            [strongSelf.searchBar resignFirstResponder];
        }

    }
                     failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        [strongSelf displayErrorWithText: error.localizedDescription];

    }];
}

#pragma mark - Other
-(void) displayErrorWithText:(NSString *)errorText{
    NSDictionary *options = @{
            kCRToastTextKey : errorText,
            kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
            kCRToastBackgroundColorKey : [UIColor keeklaRed],
            kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
            kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
            kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
            kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
    };

    [CRToastManager showNotificationWithOptions:options
                                completionBlock:^{}];
}
@end