//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Александр Брин on 20/06/15.
//  Copyright (c) 2015 Александр Брин. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "DetailViewController.h"
#import "BNRImageStore.h"
#import "ItemsViewController.h"
#import "HomepwnerItemCell.h"
#import "ImageViewController.h"
@implementation ItemsViewController

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        self.navigationItem.title = [NSString localizedStringWithFormat:NSLocalizedString(@"Homepwner", nil), 34];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        self.navigationItem.rightBarButtonItem = bbi;
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }
    return self;
}

- (void)viewDidLoad {
    UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HomepwnerItemCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)addNewItem:(id)sender {
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    DetailViewController* dvc = [[DetailViewController alloc] initForNewItem:YES];
    dvc.item = newItem;
    
    dvc.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:dvc];
    nvc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *dvc = [[DetailViewController alloc] initForNewItem:NO];
    dvc.item = [[BNRItemStore sharedStore].allItems objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [BNRItemStore sharedStore].allItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BNRItem *b = [[BNRItemStore sharedStore].allItems objectAtIndex:indexPath.row];
    HomepwnerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    cell.controller = self;
    cell.tableView = self.tableView;
    cell.name.text = b.itemName;
    cell.serial.text = b.serialNumber;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    cell.value.text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:b.valueInDollars]];
    cell.thumbnail.image = b.thumbnail;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BNRItemStore *store = [BNRItemStore sharedStore];
        BNRItem *item  = store.allItems[indexPath.row];
        [[BNRImageStore sharedStore] deleteImageForKey:item.imageKey];
        [store removeItemAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row to:destinationIndexPath.row];
}

- (void)showImage:(id)sender atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"adasasd %@", indexPath);
    
    ImageViewController *ivc = [[ImageViewController alloc] init];
    BNRItem *item = [[BNRItemStore sharedStore].allItems objectAtIndex:indexPath.row];
    if (item.imageKey) {
        UIImage *image = [[BNRImageStore sharedStore] imageForKey:item.imageKey];
        ivc.image = image;
        [self.navigationController pushViewController:ivc animated:YES];
    }
}


@end
