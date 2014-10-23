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
@property (weak, nonatomic) IBOutlet UIView *pageview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *totalLabel;

@property NSString *titleText;
@property NSString *imageFile;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong,nonatomic) NSArray *menuArray;
@property (strong,nonatomic) NSArray *categories;
@property (strong,nonatomic) UIAlertView *tmpalert;
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
    
    //load table data
    
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"tables" ofType:@"json"];
    NSData *data2 = [[NSFileManager defaultManager] contentsAtPath:filePath2];
    NSArray *tables = [NSJSONSerialization JSONObjectWithData:data2 options:0 error:nil];
    NSDictionary *table = [tables objectAtIndex:self.tableid - 2001];
    NSArray *orders = [table objectForKey:@"orders"];
    
    [[NSUserDefaults standardUserDefaults]setObject:orders forKey:[[NSString alloc] initWithFormat:@"ordersOfTable%i",self.tableid]];
    [[NSUserDefaults standardUserDefaults]synchronize];
  
    
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
    
    
    //create category buttons
    
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    [marr addObject:@"Selected"];
    for (NSDictionary *d in self.menuArray) {
        NSString *categ = [d objectForKey:@"category"];
        [marr addObject:categ];
    }
    [self createCategoryButtonsFromArray:marr];
    [self markCategoryButton:0];
    
    
    //top left bar button
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"〈 Tables" style:UIBarButtonItemStyleBordered target:self action:@selector(toTables:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    
    //top center button
    
    NSString *tablenum = [[NSString alloc]initWithFormat:@"table %i",self.tableid-2000];
    UIButton *titleLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleLabel setTitle:tablenum forState:UIControlStateNormal];
    titleLabel.frame = CGRectMake(0, 0, 70, 44);
    [titleLabel setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [titleLabel addTarget:self action:@selector(alertChangeTable:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleLabel;
    
     //top right button
    
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(0.0, 0.0, 25.0, 25.0)];
    [button1 addTarget:self action:@selector(alertNotifications) forControlEvents:UIControlEventTouchUpInside];
    [button1 setImage:[UIImage imageNamed:@"bell36red.png"] forState:UIControlStateNormal];
    UIBarButtonItem *buttonbell = [[UIBarButtonItem alloc]initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = buttonbell;
    
    //bottom left bar button
    
    self.totalLabel.tintColor = [UIColor blackColor];
    self.totalLabel.title=[[NSString alloc]initWithFormat:@"%0.2f euro",[self howMuchNow] ];
    
    
    if (self.tablestate == 0) {
        [self alertNumPeople];
    }

}


#pragma mark - UIButton Actions -

-(void)toTables:(id)sender{
    [self alertItemsNotSubmited];
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
    }
    else if([title isEqualToString:@"SEND"]){
        [self alerOrderSent];
        [sender setTitle:@"PAY"];
    }
    else if([title isEqualToString:@"PAY"]){
        [self alerPayBill];
    }
    
}


#pragma mark - subview content & exchanges -

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    PageContentViewController *pageContentViewController;
    if (([self.menuArray count] == 0) || (index > [self.menuArray count])) {
        return nil;
    }
    if (index == 0) {
        pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Tmpodrvc"];
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



#pragma mark - creating buttons -

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


#pragma mark - alerts -

-(void)alertNumPeople{
    UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:@""
                           message: [[NSString alloc ] initWithFormat:@"Number of people for table %i?",self.tableid-2000]
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           otherButtonTitles:@"OK",nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];

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
    
    alert.tag = 20;
    [alert show];
}

-(void)alerOrderSent{
    UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:@"Orders sent successfully"
                           message:@""
                           delegate:self
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
    alert.tag = 30;
    [alert show];
}



-(void)alertItemsNotSubmited{
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey: [[NSString alloc] initWithFormat:@"ordersOfTable%i",self.tableid]];
    
    if ([self doesMenuContainNewPlate:arr]) {
        UIAlertView * alert = [[UIAlertView alloc]
                               initWithTitle:@"Orders have not been sent!"
                               message:@"If you leave, temporal orders will be deleted"
                               delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:@"Send",@"Leave",nil];
        alert.tag = 40;
        [alert show];
    }else{
        [self backToTablesList];
    }
    
    

}


- (void)alertChangeTable:(id) sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Free tables to go" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
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
    
    
    [alert setValue:v forKey:@"accessoryView"];
    alert.tag = 50;
    
    self.tmpalert = alert;
    [alert show];
    
}

-(void)alerPayBill{
    UIAlertView * alert = [[UIAlertView alloc]
                           initWithTitle:@"Order paid successfullyaa"
                           message:@""
                           delegate:self
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
    alert.tag= 60;
    [alert show];
}


#pragma mark - alert handler -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10) {
        if (buttonIndex == 0) {
            [self backToTablesList];
        }else if(buttonIndex == 1) {
             NSLog(@"Entered: kk %@",[[alertView textFieldAtIndex:0] text]);
        }
       
    }
    else if (alertView.tag == 40) {
    
        if (buttonIndex == 2) {
            [self backToTablesList];
        }else if(buttonIndex == 1) {
            //NSLog(@"11");
        }
    }
    else if(alertView.tag == 60){
        [self backToTablesList];
    }
    
}

#pragma mark - utilities -

-(BOOL)doesMenuContainNewPlate:(NSArray *)arr{
    BOOL res = NO;
    for (NSDictionary *d in arr) {
        NSString *tmp = [d objectForKey:@"state"];
        if ([tmp isEqualToString:@"new"]) {
            res = YES;
            break;
        }
    }
    return res;
}

-(double)howMuchNow{
    double sum = 0;
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey: [[NSString alloc] initWithFormat:@"ordersOfTable%i",self.tableid]];
    for (NSDictionary *d in arr) {
        double a = [[d objectForKey:@"price"] doubleValue];
        double b = [[d objectForKey:@"quantity"] doubleValue];
        sum += (a*b);
    }
    return sum;
}

-(void)backToTablesList{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
