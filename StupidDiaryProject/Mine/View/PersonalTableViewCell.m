//
//  PersonalTableViewCell.m
//  JSNotepadProject
//
//  Created by 刘成 on 2018/11/14.
//  Copyright © 2018年 刘成. All rights reserved.
//

#import "PersonalTableViewCell.h"

@implementation PersonalTableViewCell

+ (PersonalTableViewCell *)cellWithTableView:(UITableView *)tableView{
    
    static NSString *identifier = @"PersonalTableViewCell";
    PersonalTableViewCell *cell=(PersonalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        UINib *nib = [UINib nibWithNibName:identifier bundle:[NSBundle bundleForClass:[NSClassFromString(@"PersonalTableViewCell") class]]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = (PersonalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImageView.layer.cornerRadius = 20;
    self.headerImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
