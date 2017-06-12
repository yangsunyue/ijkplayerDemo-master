//
//  DEFINE.h
//  SNSPost
//
//  Created by  江志磊 on 14-9-4.
//  Copyright (c) 2014年  江 志磊. All rights reserved.
//

#ifndef SNSPost_DEFINE_h
#define SNSPost_DEFINE_h

//注册接口(get)
#define kRegisterString @"http://10.0.8.8/sns/my/register.php?username=%@&password=%@&email=%@"
//登录接口(post)
#define kLoginString @"http://10.0.8.8/sns/my/login.php"
//@"http://10.0.8.8/sns/my/login.php"
////@"http://192.168.88.8/sns/my/login.php"
//上传头像(post)
#define kUploadImage @"http://10.0.8.8/sns/my/upload_headimage.php"
//获取相册列表(post)
#define kPhotoList @"http://10.0.8.8/sns/my/album_list.php"

//作为保存在NSUserDefaults中的key
#define kAuth @"mauth"
#define kUserName @"username"
#define kPassword @"password"

#endif
