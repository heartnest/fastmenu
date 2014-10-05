//
//  MenuViewController.m
//  fastmenu
//
//  Created by HeartNest on 19/09/14.
//  Copyright (c) 2014 labt. All rights reserved.
//

#import "MenuViewController.h"
#import "PageContentViewController.h"
#import "Tools.h"

@interface MenuViewController () <UIPageViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) NSArray *categories;
@property (weak, nonatomic) IBOutlet UIView *pageview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *totalLabel;

@property NSString *titleText;
@property NSString *imageFile;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@property (strong,nonatomic) NSArray *menuArray;

@property (nonatomic) int currentPageID;

@end

@implementation MenuViewController


#pragma mark - view controller life cycle -

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
    
    //navigational bar content
    
    NSString *tablenum = [[NSString alloc]initWithFormat:@"table %i",self.tableid-2000];
    //self.title = [[NSString alloc]initWithFormat:@"table %i",self.tableid-2000];
    
    UIButton *titleLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleLabel setTitle:tablenum forState:UIControlStateNormal];
    titleLabel.frame = CGRectMake(0, 0, 70, 44);
    [titleLabel setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [titleLabel addTarget:self action:@selector(titleTap:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"🔔" style:UIBarButtonItemStylePlain  target:self action:@selector(alertNotifications)];
    
   // [self alertNotifications];
    
    //trival things
    self.totalLabel.tintColor = [UIColor blackColor];
    
    
    if (self.tablestate == 0) {
        [self alertNumPeople];
    }
    
}


- (IBAction)summary:(UIBarButtonItem *)sender {
    NSString *title = sender.title;
    if ([title isEqualToString:@"Summary"]) {
        [sender setTitle:@"SEND"];
        UIViewController *selectedViewController = [self viewControllerAtIndex:0];
        [self markCategoryButton:0];
        
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
    }else{
        [self alerOrderSent];
    }
    
    
}

//-(void)viewWillDisappear:(BOOL)animated{
//    //[super viewWillDisappear:animated];
//    
//    [self alertItemsNotSubmited];
//    //NSLog(@"a");
//}
//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//   // if ([identifier isEqualToString:@"Identifier Of Segue Under Scrutiny"]) {
//        // perform your computation to determine whether segue should occur
//        
//        //BOOL segueShouldOccur = YES|NO; // you determine this
//        BOOL segueShouldOccur = NO;
//        if (!segueShouldOccur) {
//            UIAlertView *notPermitted = [[UIAlertView alloc]
//                                         initWithTitle:@"Alert"
//                                         message:@"Segue not permitted (better message here)"
//                                         delegate:nil
//                                         cancelButtonTitle:@"OK"
//                                         otherButtonTitles:nil];
//            
//            // shows alert to user
//            [notPermitted show];
//            
//            // prevent segue from occurring
//            return NO;
//        }
//   // }
//    
//    // by default perform the segue transition
//    return YES;
//}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    PageContentViewController *pageContentViewController;
    if (([self.menuArray count] == 0) || (index > [self.menuArray count])) {
        return nil;
    }
    if (index == 0) {
        pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Tmpodrvc"];
        
        
        //can be deleted
//        pageContentViewController.category = [self.menuArray[index] objectForKey:@"category"];
//        pageContentViewController.list = [self.menuArray[index] objectForKey:@"list"];
        pageContentViewController.pageIndex = index;
    }
    else{
        pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
        pageContentViewController.category = [self.menuArray[index-1] objectForKey:@"category"];
        pageContentViewController.list = [self.menuArray[index-1] objectForKey:@"list"];
        pageContentViewController.pageIndex = index;
        
    }
    
    pageContentViewController.tableid = self.tableid;
    
    self.currentPageID = (int) index;
   
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
        button.backgroundColor = [UIColor whiteColor];
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
    
    int idx = (int)index;
    if ((idx < 0) || (index == NSNotFound)) {
        return nil;
    }
    
    [self markCategoryButton:(int)index];

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
    
    [self markCategoryButton:(int)index];
    
    index++;
    if (index == [self.menuArray count]+1) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}



#pragma mark - buttons -
/*
 menu category
*/

-(void) createCategoryButtonsFromArray:(NSArray *) arr{
    
    int count = 0;
    double xcoord = 1;
    double yheight = 1;
    
    
    for (NSString *btn in arr) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //button.backgroundColor = [UIColor greenColor];
        [button setTitle:btn forState:UIControlStateNormal];
        
        CGSize stringsize = [btn sizeWithAttributes: @{NSFontAttributeName:
                                                           [UIFont systemFontOfSize:17.0f]}];
        
        
        [button setFrame:CGRectMake(xcoord,1,stringsize.width+10, stringsize.height)];
        
        [[button layer] setBorderWidth:1.0f];
        [[button layer] setBorderColor: [Tools colorFromHexString:@"#EEC591"].CGColor];
        
        
        button.tintColor = [UIColor blackColor];
        
        //yheight = stringsize.height;
        xcoord += stringsize.width+20;
        
        button.tag = 1000+count;
        [button addTarget:self action:@selector(onCategoryButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:button];
        
        count++;
        
    }

    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setContentSize:CGSizeMake(xcoord, yheight)];
}

/**
 * view a category
 */

- (void)onCategoryButtonPressed:(UIButton *)button {
    int pageid = (int) button.tag - 1000;
    
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

#pragma mark - alert dialogs -

-(void)alertNumPeople{
    UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:@"Number of People"
                           message:@"Please insert the number of people"
                           delegate:self
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    //[[alert textFieldAtIndex:0] setDelegate:self];
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    //[[alert textFieldAtIndex:0] becomeFirstResponder];
    
    alert.tag = 10;
    [alert show];
}



-(void)alertNotifications{
    UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:@"Notifications"
                           message:@""
                           delegate:self
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:@"Call from table 2",@"Call from table 3",@"Meal ready for table 5",nil];
    
    [alert show];
}

-(void)alerOrderSent{
    UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:@"Orders sent successfully"
                           message:@""
                           delegate:self
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
    
    [alert show];
}



-(void)alertItemsNotSubmited{
    UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:@"Number of People"
                           message:@"Please insert the number of people"
                           delegate:self
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:@"+1",@"add note",@"-1",nil];
    [alert show];
}

- (IBAction) titleTap:(id) sender
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Free tables to go" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 150)];
    
    int x=0,y=0;
    //buttons on view
    for (int i=1; i<6; i++) {
        
        NSString *t = [[NSString alloc] initWithFormat:@"%i",i ];
        UIButton *titleLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleLabel setTitle:t forState:UIControlStateNormal];
        titleLabel.frame = CGRectMake(x, y, 50, 50);
        [titleLabel setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        
        [[titleLabel layer] setBorderWidth:1.0f];
        [[titleLabel layer] setBorderColor:[UIColor grayColor].CGColor];
        x += 55;
        if (i%4 == 0 && i !=0) {
            y += 55;
            x = 0;
        }
        [v addSubview:titleLabel];
    }
    
    
    [av setValue:v forKey:@"accessoryView"];
    //v.backgroundColor = [UIColor yellowColor];
    [av show];
}


#pragma mark - alert handler -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10) {
        NSLog(@"Entered: kk %@",[[alertView textFieldAtIndex:0] text]);
    }
    
}

@end
