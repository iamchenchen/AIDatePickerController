//
//  AITableViewController.m
//  AIDatePickerController
//
//  Created by Ali Karagoz on 28/10/2013.
//  Copyright (c) 2013 Ali Karagoz. All rights reserved.
//

#import "AITableViewController.h"
#import "AIDatePickerController.h"

#import "CCPickerController.h"

@interface AITableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;

//this is a temp idea, I want to make it better
@property (nonatomic) NSInteger selected;

@end

@implementation AITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  // temp idea
  self.selected = 0;
  
    // View Controller
    self.title = @"Date Picker";
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50.0;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  if (indexPath.row == 0) {
    cell.textLabel.text = @"Pick a date";
  } else
    cell.textLabel.text = @"Pick something";

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    __weak AITableViewController *weakSelf = self;
    
    // Creating a date
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:@"1955-02-24"];
    
    AIDatePickerController *datePickerViewController = [AIDatePickerController pickerWithDate:date selectedBlock:^(NSDate *selectedDate) {
      __strong AITableViewController *strongSelf = weakSelf;
      
      [strongSelf dismissViewControllerAnimated:YES completion:nil];
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
      
      NSLog(@"Selected Date : %@", selectedDate);
      
    } cancelBlock:^{
      __strong AITableViewController *strongSelf = weakSelf;
      
      [strongSelf dismissViewControllerAnimated:YES completion:nil];
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
    
    [self presentViewController:datePickerViewController animated:YES completion:nil];
  } else {
    NSArray *data = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
    CCPickerController *picker = [CCPickerController pickerWithData:data andRow:self.selected selectedBlock:^(NSUInteger selectedRow) {
      NSLog(@"selected data is %@", [data objectAtIndex:selectedRow]);
      self.selected = selectedRow;
      [self dismissViewControllerAnimated:YES completion:nil];
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } cancelBlock:^{
      [self dismissViewControllerAnimated:YES completion:nil];
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
    [self presentViewController:picker animated:YES completion:nil];
  }
}

@end
