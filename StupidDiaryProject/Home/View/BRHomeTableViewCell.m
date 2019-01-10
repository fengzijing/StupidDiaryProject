//
//  BRHomeTableViewCell.m
//  StupidDiaryProject
//
//  Created by 锋子 on 2019/1/7.
//  Copyright © 2019 锋子. All rights reserved.
//

#import "BRHomeTableViewCell.h"

@implementation BRHomeTableViewCell

+ (BRHomeTableViewCell *)cellWithTableView:(UITableView *)tableView{
    
    static NSString *identifier = @"BRHomeTableViewCell";
    BRHomeTableViewCell *cell=(BRHomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        UINib *nib = [UINib nibWithNibName:identifier bundle:[NSBundle bundleForClass:[NSClassFromString(@"BRHomeTableViewCell") class]]];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = (BRHomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
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
//    UIBezierPath *shadowPath = [UIBezierPath
//                                bezierPathWithRect:self.bgView.bounds];
//    self.bgView.layer.masksToBounds = NO;
//    self.bgView.layer.shadowColor = SMColorFromRGB(0x808080).CGColor;
//    self.bgView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
//    self.bgView.layer.shadowOpacity = 0.5f;
//    self.bgView.layer.shadowPath = shadowPath.CGPath;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
