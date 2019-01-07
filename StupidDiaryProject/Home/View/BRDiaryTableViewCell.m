//
//  BRDiaryTableViewCell.m
//  StupidDiaryProject
//
//  Created by 锋子 on 2019/1/7.
//  Copyright © 2019 锋子. All rights reserved.
//

#import "BRDiaryTableViewCell.h"

@implementation BRDiaryTableViewCell

+ (BRDiaryTableViewCell *)cellWithTableView:(UITableView *)tableView{
    
    static NSString *identifier = @"BRDiaryTableViewCell";
    BRDiaryTableViewCell *cell=(BRDiaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        UINib *nib = [UINib nibWithNibName:identifier bundle:[NSBundle bundleForClass:[NSClassFromString(@"BRDiaryTableViewCell") class]]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = (BRDiaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, ScreenWidth)];
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
