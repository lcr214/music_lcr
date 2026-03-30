import { getSongList } from '../apis';
import { SongItemType, SongItem } from '../models/Index';
@Component
export default struct Mine {
  @State showList: [SongItemType[]] = [[]];     //状态变量：用于存储展示的歌曲列表（二维数组）
  columnList: number[] = [0, 1, 2, 3];        //定义网格布局的列索引

  //生命周期回调
  async aboutToAppear() {
    const songList: SongItemType[] = await getSongList() as SongItemType[];  //异步获取歌曲列表数据

    //为每列生成随机排序的歌曲列表
    this.columnList.forEach(item => {
      this.showList[item] = songList
        .map(item => new SongItem(item))
        .sort(() => Math.random() - 0.5);   //随机排序算法，将图片打乱随机排列
    });
    console.log('the length of showList',this.showList.length)   //调试输出列表长度4列
    console.log('the length of showList',this.showList[0].length)  //调式输出每列的长度
    console.log('the length of songList',songList.length)  //歌曲列表长度
  }
  build() {
    Column() {
      // 背景
      Column() {
        GridRow({
          breakpoints: { value: ['100vp'] },//仅一个断点，保证所有屏幕都是四列
          columns: 4,
          gutter: {x:9, y:9}  //项之间的横向 /纵向间距

        }) {

          ForEach(this.columnList, (item: number) => {
            GridCol({ span: 1 }) {
              SongCard({ songs: this.showList[item] })
            }
          })
        }
      }
      .scale({ x: 1.15, y: 1.15, centerX: '50%', centerY: '0' }) //背景缩放效果
      .height('75%')
      .width('100%')
      .backgroundColor('#000')
      // 个人信息
      Column() {
        Column() {
          Image($r('app.media.logo'))
            .width('90%')
        }
        .backgroundColor(Color.Black)
        .width(80)
        .aspectRatio(1)
        .borderRadius(80)
        .offset({ y: -40 })
        Column({ space: 12 }) {
          Row({ space: 8 }) {
            Text('黑马云音乐')
              .fontColor(Color.White)
              .fontSize(20)
            Image($r('app.media.ic_vip'))
              .width(40)
          }
          .offset({ y: -15 })
          Row() {
            Image($r('app.media.ic_boy'))
              .width(14)
              .fillColor('#ff23496b')
              .margin({ right: 4 })
            Text('00后')
              .fontColor('#555')
              .margin({ right: 12 })
              .fontSize(14)
            Text('双子座')
              .fontColor('#555')
              .margin({ right: 12 })
              .fontSize(14)
            Text('北京')
              .fontColor('#555')
              .margin({ right: 12 })
              .fontSize(14)
            Text('歌龄·2年')
              .fontColor('#555')
              .margin({ right: 12 })
              .fontSize(14)
          }
          Row() {
            Text('1 关注')
              .fontColor('#555')
              .margin({ right: 12 })
              .fontSize(14)
            Text('10万 粉丝')
              .fontColor('#555')
              .margin({ right: 12 })
              .fontSize(14)
            Text('167万 赞')
              .fontColor('#555')
              .margin({ right: 12 })
              .fontSize(14)
          }
        }
      }
      .width('100%')
      .height('25%')
      .backgroundColor('#121215')
    }
    .width('100%')
  }
}

@Component
struct SongCard {
  @Prop songs: SongItemType[] = [];   //接收父组件传递的歌曲列表
  build() {

    List({ space: 12 }) {   //垂直列表，项间距12
      ForEach(this.songs, (item: SongItemType) => {
        ListItem() {
          Stack() {
            Image(item.img)
              .width('100%')
          }
          .width('100%')
          .aspectRatio(1)
          .borderRadius(8)
          .clip(true)
        }
      })
    }
    .width('100%')
    .height('100%')
  }
}