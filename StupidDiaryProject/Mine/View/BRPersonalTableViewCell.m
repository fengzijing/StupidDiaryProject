//
//  PersonalTableViewCell.m
//  JSNotepadProject
//
//  Created by 刘成 on 2018/11/14.
//  Copyright © 2018年 刘成. All rights reserved.
//

#import "BRPersonalTableViewCell.h"

@implementation BRPersonalTableViewCell

+ (BRPersonalTableViewCell *)cellWithTableView:(UITableView *)tableView{
    
    static NSString *identifier = @"BRPersonalTableViewCell";
    BRPersonalTableViewCell *cell=(BRPersonalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        UINib *nib = [UINib nibWithNibName:identifier bundle:[NSBundle bundleForClass:[NSClassFromString(@"BRPersonalTableViewCell") class]]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = (BRPersonalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
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
