//
//  MedicalImageAlbumViewController.m
//  Sunrise
//
//  Created by zhangnan on 7/15/14.
//  Copyright (c) 2014 zinc. All rights reserved.
//

#import "MedicalImageAlbumViewController.h"
#import "MedicalPictureModelController.h"
#import "MedicalPictureInfoViewController.h"

@interface MedicalImageAlbumViewController ()
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (strong, nonatomic) MedicalPictureModelController *modelController;
@property (nonatomic, assign) NSInteger targetIndex;
@end

@implementation MedicalImageAlbumViewController

- (id)initWithArray:(NSArray *)array andStartIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        _imgArray = array;
        // Custom initialization
        self.view.backgroundColor = UIColorFromRGB(0xf6f6f6);
        self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        self.pageViewController.delegate = self;
        
        MedicalPictureInfoViewController *startingViewController = [self.modelController viewControllerAtIndex:index];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        self.title = [NSString stringWithFormat:@"%d/%lu",index+1,(unsigned long)_imgArray.count];
        self.pageViewController.dataSource = self.modelController;
        
        [self addChildViewController:self.pageViewController];
        [self.view addSubview:self.pageViewController.view];
        
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        CGRect pageViewRect = self.view.bounds;
        //    pageViewRect = CGRectInset(pageViewRect, 0, 40.0);
        self.pageViewController.view.frame = pageViewRect;
        
        [self.pageViewController didMoveToParentViewController:self];
        
        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MedicalPictureModelController *)modelController
{
    if (!_modelController) {
        _modelController = [[MedicalPictureModelController alloc] initWithInfoArray:_imgArray];
    }
    return _modelController;
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

//- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
//{
    //    if (UIInterfaceOrientationIsPortrait(orientation)) {
    // In portrait orientation: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
//    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
//    NSArray *viewControllers = @[currentViewController];
//    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
//    
//    self.pageViewController.doubleSided = NO;
//    return UIPageViewControllerSpineLocationMin;
//}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    self.title = [NSString stringWithFormat:@"%lu/%lu",_targetIndex+1,(unsigned long)_imgArray.count];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    _targetIndex = [self.modelController indexOfViewController:pendingViewControllers.firstObject];
}
@end
