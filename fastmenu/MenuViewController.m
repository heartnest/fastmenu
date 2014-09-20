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


@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@property (nonatomic) int pageindex;

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
    
    
    self.categories = @[@"te",@"analcolico",@"alcolico",@"succo",@"dolce",@"altri"];
    
    
    _pageTitles = @[@"Over 200 Tips and Tricks", @"Discover Hidden Features", @"Bookmark Favorite Tip", @"Free Regular Update"];
    _pageImages = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
    
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    // Create page content view controller
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 300);
    
    //add view
    [self.pageview addSubview:_pageViewController.view];
    
    //create buttons
    [self createCategoryButtonsFromArray:self.menuArray];
    
    self.pageIndex = 0;
    //button events
//    [button addTarget:self
//               action:@selector(didPressButton:)
//     forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view.
}

-(void) createCategoryButtonsFromArray:(NSArray *) arr{
    
    double xcoord = 1;
    double yheight = 1;
    for (NSDictionary *categ in arr) {
        
        NSString *btn = [categ objectForKey:@"category"];
        
//        sizeWithFont:[UIFont systemFontOfSize:14]
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.backgroundColor = [UIColor greenColor];
        [button setTitle:btn forState:UIControlStateNormal];
        
        CGSize stringsize = [btn sizeWithAttributes: @{NSFontAttributeName:
                                                           [UIFont systemFontOfSize:17.0f]}];

    
        [button setFrame:CGRectMake(xcoord,1,stringsize.width+10, stringsize.height)];
        
        yheight = stringsize.height;
        xcoord += stringsize.width+20;
        [self.scrollView addSubview:button];
        
    }
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(xcoord, yheight)];
}


- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    PageContentViewController *pageContentViewController;
    if (([self.menuArray count] == 0) || (index >= [self.menuArray count])) {
        return nil;
    }
    if (index == 0) {
         pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageOrderViewController"];
    }
    else{
    pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.category = [self.menuArray[index] objectForKey:@"category"];
    pageContentViewController.list = [self.menuArray[index] objectForKey:@"list"];
    pageContentViewController.pageIndex = index;
    }
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    self.pageindex--;
    
    if (self.pageindex < 0) {
            return nil;
    }
    
    return [self viewControllerAtIndex:self.pageindex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    self.pageindex++;
    if (self.pageindex == [self.menuArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:self.pageindex];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
