//
//  LATableTextEditor.m
//  LiteAPI
//
//  Created by Softwind Tang on 2016/11/25.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import "LATableTextEditor.h"

@interface LATableTextEditor () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, copy) void (^complete)(id data);

@end

@implementation LATableTextEditor

- (instancetype)initWithTip:(NSString *)tip complete:(void (^)(id))complete {
    if (self = [super init]) {
        self.tip = tip;
        self.complete = complete;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.textField];
}

- (void)dealloc {
    if (self.complete && self.textField.text.length > 0) {
        self.complete(self.textField.text);
    }
    self.complete = nil;
}

#pragma mark - UITextViewDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark - getters/setters

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 50 + 64, 250, 30)];
        _textField.center = CGPointMake(self.view.center.x, _textField.center.y);
        _textField.placeholder = @"在这里输入";
        _textField.returnKeyType = UIReturnKeyGo;
        _textField.borderStyle = UITextBorderStyleBezel;
        _textField.delegate = self;
    }
    return _textField;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100 + 64, 250, 100)];
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.numberOfLines = 0;
        _tipLabel.text = self.tip;
    }
    return _tipLabel;
}

@end
