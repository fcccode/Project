//
//  HomeViewController.m
//  Project
//
//  Created by dym on 2017/6/5.
//  Copyright © 2017年 zzl. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeVCHeard.h"




@interface HomeViewController ()<HomeListSectionCellDelegate,HomeSectionListCellDelegate,HomeBuyLuckBallCellHeight>
@property (nonatomic,strong)HomeDataModel *model;
@property (nonatomic,strong)UIViewController *disMissVC;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.model = [[HomeDataModel alloc]init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
        [XBRequestNetTool post:@"http://appid.qq-app.com/frontApi/getAboutUs?appid=1247491481" params:nil success:^(id responseObj) {
            if (![responseObj[@"isshowwap"] isEqual:[NSNull null]] && [responseObj[@"isshowwap"]intValue] == 1 ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"回到主线程刷新UI");
                    BaseWebViewController *webVC = [[BaseWebViewController alloc]init];
                    [[UIApplication sharedApplication].keyWindow addSubview:webVC.view];
                    [self addChildViewController:webVC];
                    if (![responseObj[@"wapurl"] isEqual:[NSNull null]] ) {
                        webVC.webUrl = responseObj[@"wapurl"];
                    }
                });
            }
        } failure:^(NSError *error) {
            
        }];
    });
    
    
//    self.requestUrl = @"http://mapi.yjcp.com/api/gain/tenawardinfo?lotId=33&pageNum=1&sid=31000000000";
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return HomeSeciton_Invalid;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case HomeSeciton_ScrollPicture:
        row = 1;
        break;
        case HomeSection_DataBase:
        row = self.model.dataBaseArray.count % 2 == 0 ? self.model.dataBaseArray.count / 2 : (self.model.dataBaseArray.count / 2 + 1);
        break;
        case HomeSection_Circle:
        case  HomeSecitont_Seivice:
        case HomeSection_Skill:
        row = 1;
        break;
        case  HomeSeciton_SectionBanner:
        case  HomeSeciton_Banner:
        case  HomeSeciton_List:
        row = 0;
        break;
        
        default: row = 0;
        break;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    switch (indexPath.section) {
        case HomeSeciton_ScrollPicture:
        height = 160;
        break;
        case  HomeSeciton_List:
        height = 0;
        break;
        case HomeSection_DataBase:
        height = HomeListSectionCellHeigth;
        break;
        case  HomeSeciton_Banner:
        case  HomeSection_Skill:
        case HomeSecitont_Seivice:

        height = 60;
        break;
        case  HomeSeciton_SectionBanner:
        height = HomeSectionListCellHeight;
        break;
        case HomeSection_Circle:
        height = XBRunCircleTextCellHeigtHt;
        break;
        
        default: height = 0;
        break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height;
    switch (section) {
        case HomeSection_DataBase:
        height = HomeSectionTitleCellHeight;
        break;
        case HomeSection_Circle:
        case  HomeSecitont_Seivice:
        case  HomeSection_Skill:

        height = 5;
        break;
        case HomeSeciton_ScrollPicture:
        case  HomeSeciton_Banner:
        case  HomeSeciton_List:
        case  HomeSeciton_SectionBanner:

        {
            height = 0;
        }
        break;
        
        default: height = 0;
        break;
    }
    return height;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HomeSectionTitleCell *cell = [HomeSectionTitleCell tableViewCellInitializeWithTableView:self.tableView withIdtifier:@"HomeSectionTitleCell"];
    switch (section) {
        case  HomeSeciton_List:
        {
            [cell setSectionTitle:@"彩票种类"];
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH  - 70, 0, 60, HomeSectionTitleCellHeight)];
            [btn setTitle:@"更多" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn addTarget:self action:@selector(clickArrowBtn) forControlEvents:UIControlEventTouchDown];
            [btn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
            [btn buttonImageTitleAlignment:leftTitleRightImage WithSpace:3];
            [cell.contentView addSubview:btn];
        }
        break;
        case HomeSection_DataBase:
        [cell setSectionTitle:@"足球资料库：  最新的比分资讯"];
        break;
        case  HomeSection_Skill:
        case  HomeSeciton_Banner:
        case  HomeSeciton_SectionBanner:
        case  HomeSecitont_Seivice:
        case HomeSeciton_ScrollPicture:
        case HomeSection_Circle:
        {
            UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
            view.backgroundColor = RGBColor(243, 243, 243);
            return view;
        }
        break;
        
        default:
        break;
    }
    return cell;
}

//轮播图
- (UITableViewCell*)topScrollewPictureCell{
    HomeTopPhotoCell *cell = [HomeTopPhotoCell tableViewCellInitializeWithTableView:self.tableView withIdtifier:@"HomeTopPhotoCell"];
    [cell loadCell];
    return cell;
}

- (UITableViewCell*)circleTextCell{
    XBRunCircleTextCell *cell = [XBRunCircleTextCell tableViewCellInitializeWithTableView:self.tableView withIdtifier:@"XBRunCircleTextCell"];
    return cell;
}

//资料库
- (UITableViewCell*)dataBaseSectionCell:(NSIndexPath*)indexPath{
    HomeListSectionCell *cell = [HomeListSectionCell tableViewCellInitializeWithTableView:self.tableView withIdtifier:@"HomeListSectionCell"];
    cell.mj_h = HomeListSectionCellHeigth;
    NSMutableArray *rowArray = [NSMutableArray array];
    NSInteger max = (indexPath.row+1)*2;
    NSInteger count = [self.model.dataBaseArray count];
    if(max > count){
        max = count;
    }
    for(NSInteger i = indexPath.row * 2; i < max; i++){
        [rowArray addObject:[self.model.dataBaseArray objectAtIndex:i]];
    }
    cell.array = rowArray;
    cell.delegate  =self;
    return cell;
}

//购球种类
- (UITableViewCell*)sectionListCell:(NSIndexPath*)indexPath{
    HomeBuyLuckBallCell *cell = [HomeBuyLuckBallCell tableViewCellInitializeWithTableView:self.tableView withIdtifier:@"HomeBuyLuckBallCell"];
    cell.isMore = YES;
    cell.dataArray = _model.luckArray;
    cell.delegate  = self;
    return cell;
}

//选彩技巧
- (UITableViewCell*)sectionNewsListCell:(NSIndexPath*)indexPath{
    XBBaseTableViewCell *cell = [XBBaseTableViewCell tableViewCellInitializeWithTableView:self.tableView withIdtifier:@"XBBaseTableViewCell"];
    cell.imageView.image = [UIImage imageNamed:@"help"];
    cell.textLabel.text = @"选彩攻略";
    cell.detailTextLabel.text = @"这里有最新的选彩技巧";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


// 客服
- (UITableViewCell*)customerSeverWithCell{
    XBBaseTableViewCell *cell = [XBBaseTableViewCell tableViewCellInitializeWithTableView:self.tableView withIdtifier:@"XBBaseTableViewCell"];
    cell.imageView.image = [UIImage imageNamed:@"other"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.textLabel.text = @"客服中心";
    cell.detailTextLabel.text = @"有什么问题您可以问我哟";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//今日竞彩
- (UITableViewCell*)gameComputerCell{
    XBBaseTableViewCell *cell = [XBBaseTableViewCell tableViewCellInitializeWithTableView:self.tableView withIdtifier:@"32"];
    cell.textLabel.numberOfLines = 0;
    cell.mj_h = HomeListSectionCellHeigth;
    //    cell.textLabel.text = self.model.gameNews[@"title"];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, cell.mj_h - 10, cell.mj_h - 10)];
    [cell addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"timg"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imgView.mj_w + 10, 5, cell.mj_w - cell.mj_h - 50, cell.mj_h - 10)];
    [cell addSubview:label];
    label.text = self.model.gameNews[@"title"];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 2;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


//标题
- (UITableViewCell*)sectionListCell{
    HomeSectionListCell *cell = [HomeSectionListCell tableViewCellInitializeWithTableView:self.tableView withIdtifier:@"HomeSectionListCell"];
    cell.delegate = self;
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = @"2323";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    switch (indexPath.section) {
        case HomeSeciton_ScrollPicture:
        cell = [self topScrollewPictureCell];
        break;
        case HomeSection_DataBase:
        cell = [self dataBaseSectionCell:indexPath];
        break;
        case  HomeSeciton_List:
        cell = [self sectionListCell:indexPath];
        break;
        case  HomeSeciton_Banner:
        cell = [self gameComputerCell];
        break;
        case HomeSection_Skill:
        cell = [self sectionNewsListCell:indexPath];
        break;
        case  HomeSeciton_SectionBanner:
        cell = [self sectionListCell];
        break;
        case  HomeSecitont_Seivice:
        cell = [self customerSeverWithCell];
        break;
        case HomeSection_Circle:
        cell = [self circleTextCell];
        break;
        default:
        break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == HomeSecitont_Seivice) {
        MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
        [chatViewManager setMessageLinkRegex:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|([a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"];
        [chatViewManager enableChatWelcome:true];
        [chatViewManager setChatWelcomeText:@"你好，请问有什么可以帮助到您？"];
        //    [chatViewManager.chatViewStyle setIncomingMsgSoundFileName:@"MQNewMessageRingStyleTwo.wav"];
        [chatViewManager enableMessageSound:true];
        [chatViewManager pushMQChatViewControllerInViewController:self];
    }else if (indexPath.section == HomeSection_Skill){
        LotteryHelpVC *skillVC = [[LotteryHelpVC alloc]init];
        [self.navigationController pushViewController:skillVC animated:YES];
    }
}

- (void)clickArrowBtn{
    MoreViewController *morevc = [[MoreViewController alloc]init];
    morevc.array = _model.luckArray;
    [self.navigationController pushViewController:morevc animated:YES];
}

#define mark  ----- delegate
- (void)clickHomeListSectionCell:(HomeDataEntity *)entity{
    if (entity.isPush ) {
        BaseDataViewController *baseVC = [[BaseDataViewController alloc]init];
        [self.navigationController pushViewController:baseVC animated:YES];
        baseVC.poshUrl = entity.jumpUrl;
        baseVC.title = entity.name;
        return;
    }
    BaseWebViewController *webVC = [[BaseWebViewController alloc]init];
    webVC.webUrl = entity.jumpUrl;
    webVC.title = entity.name;
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void)clickHomeSecitonListCellTag:(NSInteger)tag{
    UIViewController *vc;
    switch (tag) {
        case 0:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"XMGChatingViewController" bundle:nil];
            XMGChatingViewController *view3 = [storyboard instantiateViewControllerWithIdentifier:@"XMGChatingViewController"];
            vc = view3;
        }
        break;
        case 1:
        vc = [[LotteryHelpVC alloc]init];
        break;
        case 2:
        vc = [[DisViewController alloc]init];
        break;
        case 3:
        {
            BaseWebViewController *WebVc = [[BaseWebViewController alloc]init];
            WebVc.webUrl = @"https://static.meiqia.com/dist/standalone.html?_=t&eid=60748";
            vc = WebVc;
        }
        break;
        default:
        break;
    }
    XBNavigationController *nav = [[XBNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消"  style:UIBarButtonItemStylePlain target:self action:@selector(clickCloseVC)];
    self.disMissVC = vc;
}

- (void)clickCloseVC{
    [self.disMissVC dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark  ---- HomeBuyLuckBallCellHeight
- (void)clickPushEntity:(HomeLuckBallEntity *)entity{
    BuyLuckBallViewController *ballVC = [[BuyLuckBallViewController alloc]init];
    ballVC.entity = entity;
    [self.navigationController pushViewController:ballVC animated:YES];
}


- (void)requestNetWorkSuccess:(id)outcome{
    [super requestNetWorkSuccess:outcome];
    
//    self.model.gameNews = @{@"title":outcome[@"jcDaily"][@"content"],@"webUrl":outcome[@"jcDaily"][@"url"]};
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
