//
//  PageContentViewController.h
//  Demo
//
//  Created by HeartNest on 20/09/14.
//  Copyright (c) 2014 labt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;
@property (nonatomic) int tableid;
@property NSString *category;
@property (nonatomic,strong) NSArray *list;
@end
