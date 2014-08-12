//
//  FavoritesViewController.m
//  FavoritePhotos
//
//  Created by ETC ComputerLand on 8/11/14.
//  Copyright (c) 2014 cmeats. All rights reserved.
//

#import "FavoritesViewController.h"
#import "ViewController.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.favoritePhotos.count > 0) {
        NSLog(@"save");
        [self save];
    } else {
        NSLog(@"in else?");
        [self load];
    }
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.favoritePhotos.count;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"favoriteCellId" forIndexPath:indexPath];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:self.favoritePhotos[indexPath.row]]];
//    cell.backgroundView = [[UIImageView alloc] initWithImage:self.favoritePhotos[indexPath.row]];
    return cell;
}

-(NSURL *)documentsDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directories = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return directories[0];
}

-(void) save
{
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"favoritePhotos.plist"];
    [self.favoritePhotos writeToURL:plist atomically:YES];
}

-(void) load
{
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"favoritePhotos.plist"];
    self.favoritePhotos = [NSMutableArray arrayWithContentsOfURL:plist];
    [self.collectionView reloadData];
}

-(IBAction)unWindFromSearch:(UIStoryboardSegue *)segue
{
    ViewController *svc = segue.sourceViewController;
    //self.favoritePhotos = svc.favoritePhotos;
    for (NSData *favoritePhoto in svc.favoritePhotos) {
        [self.favoritePhotos addObject:favoritePhoto];
    }
    [self save];
    [self.collectionView reloadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
