//
//  LATableSelector.m
//  LiteAPI
//
//  Created by Softwind Tang on 2016/11/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LATableSelector.h"

@interface LATableSelector () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) void (^complete)(id);
@property (nonatomic, strong) NSArray<NSString *> *selections;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation LATableSelector

- (instancetype)initWithSelections:(NSArray<NSString *> *)selections complete:(void (^)(id))complete {
    if (self = [super init]) {
        self.selections = selections;
        self.complete = complete;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex = NSNotFound;
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.view addSubview:self.tableView];
}

- (void)dealloc {
    if (self.complete && self.selectedIndex != NSNotFound) {
        self.complete(@(self.selectedIndex));
    }
    self.complete = nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LAUISELECTOR"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"LAUISELECTOR"];
    }
    cell.textLabel.text = self.selections[indexPath.row];
    return cell;
}

#pragma mark - getters/setters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
