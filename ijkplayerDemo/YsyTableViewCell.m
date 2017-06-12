//
//  YsyTableViewCell.m
//  ijkplayerDemo
//
//  Created by Yang on 16/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "YsyTableViewCell.h"

@implementation YsyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bigImage.layer.cornerRadius = 7;
    _bigImage.layer.masksToBounds = YES;
    _headImg.layer.cornerRadius = 20;
    _headImg.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(YsyLiveModel *)model{
    _model = model;
    [_bigImage sd_setImageWithURL:[NSURL URLWithString:model.creator.portrait]];
    [_headImg sd_setImageWithURL:[NSURL URLWithString:model.creator.portrait]];
    _name.text = model.creator.nick;
    _city.text = model.city;
    _numberLbael.text = [NSString stringWithFormat:@"%@人在线", model.online_users];

}

@end
