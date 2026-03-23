import { SAFE_TOP, SAFE_BOTTOM } from '../constants';

@Entry
@Component
struct Start {
  @StorageProp(SAFE_TOP) safeTop: number = 0;
  router = this.getUIContext().getRouter();
  // 定时器 id
  timerId: number = 0;

  aboutToAppear(): void {
    console.info('Start Page: aboutToAppear - 即将创建定时器');
    // 5秒后自动跳转到首页
    this.timerId = setTimeout(() => {
      console.info('Start Page: 定时器触发，正在跳转至 Index 页面');
      this.router.replaceUrl({ url: 'pages/Index' });
    }, 5000);
    console.info(`Start Page: 定时器已创建，ID = ${this.timerId}`);
  }

  aboutToDisappear(): void {
    console.info('Start Page: aboutToDisappear - 即将清除定时器');
    if (this.timerId !== 0) {
      clearTimeout(this.timerId);
      console.info(`Start Page: 定时器 ${this.timerId} 已被清除`);
      this.timerId = 0;
    } else {
      console.info('Start Page: 无需清除定时器（ID 为 0）');
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image($r('app.media.ad'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Button('跳过')
        .margin({ top: this.safeTop + 10, right: 10 })
        .backgroundColor('#4d000000')
        .fontColor('#ffffff')
        .onClick(() => {
          console.info('Start Page: 用户点击“跳过”，手动清除定时器并跳转');
          if (this.timerId !== 0) {
            clearTimeout(this.timerId);
            this.timerId = 0;
          }
          this.router.replaceUrl({ url: 'pages/Index' });
        })
    }
    .width('100%')
    .height('100%')
  }
}