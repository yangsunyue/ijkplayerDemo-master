//
//  YsyLiveModel.h
//  ijkplayerDemo
//
//  Created by Yang on 16/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "JSONModel.h"


@protocol YsyCreatorModel
@end

@interface YsyCreatorModel : JSONModel
@property (nonatomic,strong)NSString <Optional> *gender;
@property (nonatomic,strong)NSString <Optional> *level;
@property (nonatomic,strong)NSString <Optional> *nick;
@property (nonatomic,strong)NSString <Optional> *portrait;
@end


@interface YsyLiveModel : JSONModel
@property (nonatomic ,copy)NSString<Optional> *stream_addr;
@property (nonatomic ,copy)NSString<Optional> *share_addr;
@property (nonatomic ,copy)NSString<Optional> *online_users;
@property (nonatomic ,copy)NSString<Optional> *city;
@property (nonatomic ,copy)YsyCreatorModel <Optional, YsyCreatorModel> *creator;
@end
