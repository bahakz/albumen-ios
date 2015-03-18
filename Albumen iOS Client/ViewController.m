//
//  ViewController.m
//  Albumen iOS Client
//
//  Created by Bakytzhan Baizhikenov on 2/16/15.
//  Copyright (c) 2015 intellection. All rights reserved.
//

#import "ViewController.h"
#import "Album.h"
#import "Photo.h"
#import "AlbumDetailCollectionViewController.h"
#import "Konsts.h"
#import "AlbumTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *albums;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.albums = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSError *error = nil;
    
    NSArray* fetchedAlbums = [context executeFetchRequest:fetchRequest error:&error];
    self.albums = [fetchedAlbums mutableCopy];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.albums count];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        cell.preservesSuperviewLayoutMargins = NO;
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"AlbumTableCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    }
    
    Album *album = self.albums[indexPath.row];
    cell.titleLabel.text = album.title;
    if ([album.photos count] > 0) {
        NSSet *unorderedPhotos = album.photos;
        
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
        NSArray *sortedPhotos = [unorderedPhotos sortedArrayUsingDescriptors:@[dateDescriptor]];
        Photo *photo = sortedPhotos[0];
        cell.coverImageView.image = photo.image;
    } else {
        cell.coverImageView.image = [UIImage imageNamed:@"no photo.png"];
    }
    
    cell.coverImageView.layer.cornerRadius = 25;
    cell.coverImageView.clipsToBounds = YES;
    
    cell.coverImageView.layer.borderWidth = 0.5f;
    cell.coverImageView.layer.borderColor = [UIColor grayColor].CGColor; 
    
    cell.detailLabel.text = [NSString stringWithFormat:@"%lu фото", (unsigned long)[album.photos count], nil];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toAlbumDetailVC" sender:indexPath];
}

- (IBAction)addAlbumBarButtonPressed:(UIBarButtonItem *)sender {
    UIAlertView *newAlbumAlertView = [[UIAlertView alloc] initWithTitle:@"Введите название для нового альбома" message:nil delegate:self cancelButtonTitle:@"Отменить" otherButtonTitles:@"Добавить", nil];
    [newAlbumAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [newAlbumAlertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *alertText = [alertView textFieldAtIndex:0].text;
        Album *newAlbum = [self albumWithName:alertText];
        [self.albums addObject:newAlbum];
        [self.tableView reloadData];
    }
}

- (Album *) albumWithName: (NSString *) name
{
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    album.title = name;
    album.date = [NSDate date];
    album.capacity = ALBUM_MAX_CAPACITY;
    NSError *error = nil;
    
    if (![context save:&error]) {
        NSLog(@"We have error. failed to save");
    }
    
    return album;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toAlbumDetailVC"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        AlbumDetailCollectionViewController *nextController = segue.destinationViewController;
        nextController.album = self.albums[path.row];
    }
}



@end
