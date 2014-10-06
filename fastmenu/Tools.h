//
//  Tools.h
//  fastmenu
//
//  Created by HeartNest on 03/10/14.
//  Copyright (c) 2014 labt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+(UIButton *)createMenuBtnComponentWithName:(NSString *)name price:(double)price color:(NSString *)cl;
+ (UIButton *)createPlusBtnComponentWithQnt:(NSString *)quantity andColor:(NSString *)cl;
+(UIButton *)createCopertoBtnWithNumPeople:(float) copertoCost;
+(UIColor *)colorFromHexString:(NSString *)cl;
+(UIButton *)createNoteBtnWithString:(NSString *) str;
//+(UIButton *)createCategoryBtnComponentWithName:(NSString *)name;
@end
