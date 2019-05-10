//
//  ViewController.m
//  DouyinDemo
//
//  Created by iMac03 on 2019/5/10.
//  Copyright © 2019 Zhangbk. All rights reserved.
//

#import "ViewController.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define sectionNum 6

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) int currentIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = 0;
    [self.view addSubview:self.tableView];
    
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew  context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchStatusBar) name:@"StatusBarTouchBeginNotification" object:nil];
}

- (void)touchStatusBar{
    self.currentIndex = 0;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"currentIndex"]) {

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.currentIndex];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatePoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        scrollView.panGestureRecognizer.enabled = NO;
        if (translatePoint.y < -50 && self.currentIndex + 1 < sectionNum ) {
            self.currentIndex++;
        }
        
        if (translatePoint.y > 50 && self.currentIndex > 0) {
            self.currentIndex--;
        }
        
        [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentIndex] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        } completion:^(BOOL finished) {
            scrollView.panGestureRecognizer.enabled = YES;
        }];
    });
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionNum;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%d个cell",self.currentIndex];
    cell.backgroundColor = [UIColor colorWithRed:self.currentIndex * 99/255.0 green:self.currentIndex * 6/255.0 blue:self.currentIndex * 68/255.0 alpha:1.0];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenHeight;
}

-(UITableView *)tableView{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight * sectionNum) style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, ScreenHeight * sectionNum - 1, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
