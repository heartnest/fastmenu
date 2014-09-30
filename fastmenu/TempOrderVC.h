//
//  PageContentViewController.h
//  Demo
//
//  Created by HeartNest on 20/09/14.
//  Copyright (c) 2014 labt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempOrderVC : UIViewController
@property NSUInteger pageIndex;
@property (nonatomic) int tableid;
@property NSString *category;
@property (nonatomic,strong) NSArray *list;
@end
