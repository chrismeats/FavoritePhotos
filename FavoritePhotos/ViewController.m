//
//  ViewController.m
//  FavoritePhotos
//
//  Created by ETC ComputerLand on 8/11/14.
//  Copyright (c) 2014 cmeats. All rights reserved.
//

#import "ViewController.h"
#import "FavoritesViewController.h"

@interface ViewController () <UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>


@property (strong, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (strong, nonatomic) IBOutlet UISearchBar *photoSearchBar;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photos = [NSMutableArray new];
    self.favoritePhotos = [NSMutableArray new];
    
}

-(void)getPhotosByTag: (NSString *)tag
{
    NSString *urlString = [NSString stringWithFormat:@"https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&api_key=f7bd790aa038fe1a346ea130bda91f90&tags=%@&per_page=10&nojsoncallback=1", tag];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSArray *photoDics = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"photos"][@"photo"];

        // get all photos
        for (NSDictionary *photo in photoDics) {
            NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",
                                                    photo[@"farm"],
                                                    photo[@"server"],
                                                    photo[@"id"],
                                                    photo[@"secret"]]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
//            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
            [self.photos addObject:imageData];
        }
        [self.photoCollectionView reloadData];
    }];
}
- (IBAction)onFavoriteTap:(UIButton *)button {
    NSArray *indexPaths = [self.photoCollectionView indexPathsForVisibleItems];
    NSIndexPath *indexPath = [indexPaths firstObject];
    [self.favoritePhotos addObject:self.photos[indexPath.row]];

    //button.hidden = YES;
}

#pragma mark - Text Box delegates

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self getPhotosByTag:searchBar.text];
    [searchBar resignFirstResponder];
}

#pragma mark - Collection Delegate

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
//    NSDictionary *photo = self.photos[indexPath.row];
//    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",
//                                            photo[@"farm"],
//                                            photo[@"server"],
//                                            photo[@"id"],
//                                            photo[@"secret"]]];
//    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:self.photos[indexPath.row]]];

    return cell;
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    FavoritesViewController *fvc = segue.destinationViewController;
//    fvc.favoritePhotos = self.favoritePhotos;
//}



@end
