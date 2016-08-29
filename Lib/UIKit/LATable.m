//
//  LATable.m
//  LiteAPI
//
//  Created by Softwind Tang on 2016/11/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LATable.h"
#import "LADefine.h"
#import "LATemplate.h"
#import "LARequestMaker.h"
#import "LARequestMaker+Persistant.h"
#import "LATableSelector.h"
#import "LATableTextEditor.h"
#import "LADefine.h"

@interface LATable () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<LAIdentifier> *ids;

@end

@implementation LATable

#pragma mark - business

- (NSString *)nameOfPostStyle:(LAPostStyle)style {
    if (style == LAPostStyleForm) {
        return @"FORM";
    } else if (style == LAPostStyleJSON){
        return @"JSON";
    } else {
        return @"CUSTOM";
    }
}

- (NSString *)nameOfResponseStyle:(LAResponseStyle)style {
    if (style == LAResponseStyleJSON) {
        return @"JSON";
    } else if (style == LAResponseStyleStream) {
        return @"STREAM";
    } else {
        return @"CUSTOM";
    }
}

- (NSString *)nameofStatus:(LAStatus)status {
    if (status == LAStatusProduction) {
        return @"Production";
    } else if (status == LAStatusBeta) {
        return @"Beta";
    } else {
        return @"Develop";
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.ids.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LAUI"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"LAUI"];
    }
    LARequestMaker *maker = [[LATemplate shared] templateWithIdentifier:self.ids[indexPath.section]];
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"Method";
            cell.detailTextLabel.text = [maker valueForKey:@"v_method"];
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"Host";
            cell.detailTextLabel.text = [maker valueForKey:@"v_host"];
            break;
        }
        case 2:
        {
            cell.textLabel.text = @"Version";
            cell.detailTextLabel.text = [maker valueForKey:@"v_version"];
            break;
        }
        case 3:
        {
            cell.textLabel.text = @"ResponseStyle";
            cell.detailTextLabel.text = [self nameOfResponseStyle:[[maker valueForKey:@"v_responseStyle"] integerValue]];
            break;
        }
        case 4:
        {
            cell.textLabel.text = @"PostStyle";
            cell.detailTextLabel.text = [self nameOfPostStyle:[[maker valueForKey:@"v_postStyle"] integerValue]];
            break;
        }
        case 5:
        {
            cell.textLabel.text = @"Sync";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", [[maker valueForKey:@"v_sync"] integerValue]];
            break;
        }
        case 6:
        {
            cell.textLabel.text = @"Status";
            cell.detailTextLabel.text = [self nameofStatus:[[LATemplate shared] statusForTemplate:self.ids[indexPath.section]]];
            break;
        }
        case 7:
        {
            cell.textLabel.text = @"Brief";
            cell.detailTextLabel.text = maker.description;
            break;
        }
        default:
            break;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    LARequestMaker *maker = [[LATemplate shared] templateWithIdentifier:self.ids[section]];
    NSMutableString *str = [NSMutableString new];
    [str appendString:self.ids[section]];
    [str appendFormat:@"[%@]", [self nameofStatus:[[LATemplate shared] statusForTemplate:self.ids[section]]]];
    if (!maker) {
        [str appendFormat:@"[并没有定义]"];
    }
    return str;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __block LARequestMaker *maker = [[LATemplate shared] templateWithIdentifier:self.ids[indexPath.section]];
    if (!maker) {
        return;
    }
    __weak __typeof__(self) bself = self;
    UIViewController *vc = nil;
    switch (indexPath.row) {
        case 0:
        {
            vc = [[LATableSelector alloc] initWithSelections:@[@"GET", @"POST", @"PUT", @"DELETE"]
                                                    complete:^(id data) {
                                                        maker.method([data integerValue]);
                                                        [bself.tableView reloadData];
                                                    }];

            break;
        }
        case 1:
        {
            vc = [[LATableTextEditor alloc] initWithTip:[NSString stringWithFormat:@"输入你要的 HOST\n当前为 [%@]", [maker valueForKey:@"v_host"]]
                                               complete:^(id data) {
                                                   maker.host(data);
                                                   [bself.tableView reloadData];
                                               }];
            break;
        }
        case 2:
        {
            vc = [[LATableTextEditor alloc] initWithTip:[NSString stringWithFormat:@"输入你要的 VERSION\n当前为 [%@]", [maker valueForKey:@"v_version"]]
                                               complete:^(id data) {
                                                   maker.version(data);
                                                   [bself.tableView reloadData];
                                               }];
            break;
        }
        case 3:
        {
            vc = [[LATableSelector alloc] initWithSelections:@[@"STREAM", @"JSON", @"CUSTOM"]
                                                    complete:^(id data) {
                                                        maker.response([data integerValue]);
                                                        [bself.tableView reloadData];
                                                    }];
            break;
        }
        case 4:
        {
            vc = [[LATableSelector alloc] initWithSelections:@[@"FORM", @"JSON", @"CUSTOM"]
                                                    complete:^(id data) {
                                                        maker.post([data integerValue]);
                                                        [bself.tableView reloadData];
                                                    }];
            break;
        }
        case 5:
        {
            vc = [[LATableSelector alloc] initWithSelections:@[@"NO", @"YES"]
                                                    complete:^(id data) {
                                                        maker.sync([data boolValue]);
                                                        [bself.tableView reloadData];
                                                    }];
            break;
        }
        case 6:
        {
            vc = [[LATableSelector alloc] initWithSelections:@[@"PRODUCTION", @"BETA", @"DEVELOP"]
                                                    complete:^(id data) {
                                                        [[LATemplate shared] setStatus:[data integerValue] forTemplate:self.ids[indexPath.section]];
                                                        [bself.tableView reloadData];
                                                    }];
            break;
        }
        default:
            break;
    }
    
    if (vc) {
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ids = [[LATemplate shared] allIdentifiers];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.navigationItem.title = @"LiteAPI Running Modify";
    self.edgesForExtendedLayout = UIRectEdgeTop;
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)dealloc {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [self.ids enumerateObjectsUsingBlock:^(LAIdentifier obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        LARequestMaker *maker = [[LATemplate shared] templateWithIdentifier:obj onStatus:LAStatusProduction];
        if (maker) {
            dic[LAntoa(LAStatusProduction)] = [maker dictionaryRepresentation];
        }
        
        maker = [[LATemplate shared] templateWithIdentifier:obj onStatus:LAStatusBeta];
        if (maker) {
            dic[LAntoa(LAStatusBeta)] = [maker dictionaryRepresentation];
        }
        
        maker = [[LATemplate shared] templateWithIdentifier:obj onStatus:LAStatusDevelop];
        if (maker) {
            dic[LAntoa(LAStatusDevelop)] = [maker dictionaryRepresentation];
        }
        dic[@"status"] = @([[LATemplate shared] statusForTemplate:obj]);
        data[obj] = dic;
    }];
    
    NSData *temp = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    if (temp) {
        [[NSUserDefaults standardUserDefaults] setObject:temp forKey:LAPersistantKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
