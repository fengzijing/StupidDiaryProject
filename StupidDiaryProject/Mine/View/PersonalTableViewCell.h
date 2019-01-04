//
//  PersonalTableViewCell.h
//  JSNotepadProject
//
//  Created by 刘成 on 2018/11/14.
//  Copyright © 2018年 刘成. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UITextField *rightField;
@property (weak, nonatomic) IBOutlet UIImageView *rightIMageView;

+ (PersonalTableViewCell *)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
