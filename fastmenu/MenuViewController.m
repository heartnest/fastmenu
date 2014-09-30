//
//  MenuViewController.m
//  fastmenu
//
//  Created by HeartNest on 19/09/14.
//  Copyright (c) 2014 labt. All rights reserved.
//

#import "MenuViewController.h"
#import "PageContentViewController.h"

@interface MenuViewController () <UIPageViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) NSArray *categories;
@property (weak, nonatomic) IBOutlet UIView *pageview;


@property NSString *titleText;
@property NSString *imageFile;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@property (nonatomic) int currentPageID;

@property (strong,nonatomic) NSArray *menuArray;

@end

@implementation MenuViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    //load menu data
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    self.menuArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    
    
    // Create page view controller
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    
    // Create page content view controller
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    // Change the size of page view controller
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width*95/100, self.view.frame.size.height *75/100);
    
    //add view
    
    [self.pageview addSubview:_pageViewController.view];
    
    
    //create menu buttons
    
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    [marr addObject:@"Selected"];
    for (NSDictionary *d in self.menuArray) {
        NSString *categ = [d objectForKey:@"category"];
        [marr addObject:categ];
    }
    [self createCategoryButtonsFromArray:marr];
    
    [self markCategoryButton:0];
}



- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    PageContentViewController *pageContentViewController;
    if (([self.menuArray count] == 0) || (index > [self.menuArray count])) {
        return nil;
    }
    if (index == 0) {
//         pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageOrderViewController"];
//         pageContentViewController.tableid = self.tableid;
        pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController2"];
        pageContentViewController.tableid = self.tableid;
        
        //can be deleted
        pageContentViewController.category = [self.menuArray[index] objectForKey:@"category"];
        pageContentViewController.list = [self.menuArray[index] objectForKey:@"list"];
        pageContentViewController.pageIndex = index;
    }
    else{
        pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
        pageContentViewController.category = [self.menuArray[index-1] objectForKey:@"category"];
        pageContentViewController.list = [self.menuArray[index-1] objectForKey:@"list"];
        pageContentViewController.pageIndex = index;
        
    }
    
    self.currentPageID = index;
   
    return pageContentViewController;
}
-(void)markCategoryButton:(int) index{
    [self buttonsBackToColor];
    UIButton *button = (UIButton *)[self.view viewWithTag:index+1000];
    button.backgroundColor = [UIColor yellowColor];
}
-(void)buttonsBackToColor{
    for (int i = 0; i<= [self.menuArray count]; i++) {
        int bid = 1000 + i;
        UIButton *button = (UIButton *)[self.view viewWithTag:bid];
        button.backgroundColor = [UIColor greenColor];
    }
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index;
    if ([viewController isKindOfClass:[PageContentViewController class]]) {
        index = ((PageContentViewController*) viewController).pageIndex;
    }else
        index = 0;
    
    int idx = index;
    if ((idx < 0) || (index == NSNotFound)) {
        return nil;
    }
    
    [self markCategoryButton:index];

    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index;
    if ([viewController isKindOfClass:[PageContentViewController class]]) {
        index = ((PageContentViewController*) viewController).pageIndex;
    }else
        index = 0;
    
    
    if (index == NSNotFound) {
        return nil;
    }
    
    [self markCategoryButton:index];
    
    index++;
    if (index == [self.menuArray count]+1) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}


/*
 menu category
*/

-(void) createCategoryButtonsFromArray:(NSArray *) arr{
    
    int count = 0;
    double xcoord = 1;
    double yheight = 1;
    
    
    for (NSString *btn in arr) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.backgroundColor = [UIColor greenColor];
        [button setTitle:btn forState:UIControlStateNormal];
        
        CGSize stringsize = [btn sizeWithAttributes: @{NSFontAttributeName:
                                                           [UIFont systemFontOfSize:17.0f]}];
        
        
        [button setFrame:CGRectMake(xcoord,1,stringsize.width+10, stringsize.height)];
        
        //yheight = stringsize.height;
        xcoord += stringsize.width+20;
        
        button.tag = 1000+count;
        [button addTarget:self action:@selector(onButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:button];
        
        count++;
        
    }
//
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(xcoord, yheight)];
}

/**
 * view a category
 */

- (void)onButtonPressed:(UIButton *)button {
    int pageid = button.tag - 1000;
    
    if (self.currentPageID > pageid) {
        PageContentViewController *selectedViewController = [self viewControllerAtIndex:pageid];

        __weak UIPageViewController* pvcw = self.pageViewController;
        [self.pageViewController setViewControllers:@[selectedViewController]
                      direction:UIPageViewControllerNavigationDirectionReverse
                       animated:YES completion:^(BOOL finished) {
                           UIPageViewController* pvcs = pvcw;
                           if (!pvcs) return;
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [pvcs setViewControllers:@[selectedViewController]
                                              direction:UIPageViewControllerNavigationDirectionReverse
                                               animated:NO completion:nil];
                           });
                       }];
        
    }else if(self.currentPageID < pageid){
        PageContentViewController *selectedViewController = [self viewControllerAtIndex:pageid];
        
        __weak UIPageViewController* pvcw = self.pageViewController;
        [self.pageViewController setViewControllers:@[selectedViewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES completion:^(BOOL finished) {
                                               UIPageViewController* pvcs = pvcw;
                                               if (!pvcs) return;
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [pvcs setViewControllers:@[selectedViewController]
                                                                  direction:UIPageViewControllerNavigationDirectionForward
                                                                   animated:NO completion:nil];
                                               });
                                           }];
        
    }
        
    [self markCategoryButton:pageid];
}
@end
