//
//  YsyTableViewCell.h
//  ijkplayerDemo
//
//  Created by Yang on 16/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YsyLiveModel.h"

@interface YsyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UIImageView *bigImage;
@property (weak, nonatomic) IBOutlet UILabel *numberLbael;
//YsyLiveModel;
@property (nonatomic, strong) YsyLiveModel *model;

@end
