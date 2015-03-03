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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Album *album = self.albums[indexPath.row];
    cell.textLabel.text = album.title;
    if ([album.photos count] > 0) {
        
        NSSet *unorderedPhotos = album.photos;
        
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
        NSArray *sortedPhotos = [unorderedPhotos sortedArrayUsingDescriptors:@[dateDescriptor]];
        Photo *photo = sortedPhotos[0];
        cell.imageView.image = photo.image;
    } else {
        cell.imageView.image = nil; 
    }
    
    return cell;
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
    if ([segue.identifier isEqualToString:@"toAlbumDetail"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        AlbumDetailCollectionViewController *nextController = segue.destinationViewController;
        nextController.album = self.albums[path.row];
    }
}



@end
