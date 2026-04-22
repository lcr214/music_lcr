import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { SAFE_TOP, SAFE_BOTTOM } from '../constants';
import AVPlayerManager from '../utils/AVPlayerManager';
import AVSessionManager from '../utils/AVSessionManager';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Start', (err) => {
      // 【修正2】先检查加载是否成功，虽然获取窗口通常在加载后，但为了逻辑清晰
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }

      const mainWindow = windowStage.getMainWindowSync();

      // 1. 设置沉浸式效果
      mainWindow.setWindowLayoutFullScreen(true);

      // 2. 修改状态栏内容的颜色
      mainWindow.setWindowSystemBarProperties({
        statusBarContentColor: '#ffffff'
        // 可选：同时也设置导航栏图标颜色，防止底部黑条看不清
        // navigationBarContentColor: '#ffffff'
      });

      // 【修正3】先定义 avoidArea，再使用它
      // 获取顶部避让区高度（状态栏）
      const avoidArea = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      const safeTop = mainWindow.getUIContext().px2vp(avoidArea.topRect.height);

      // 存储顶部避让区高度
      AppStorage.setOrCreate(SAFE_TOP, safeTop);

      // 获取底部避让区高度（导航指示条）
      const navigationArea = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      const safeBottom = mainWindow.getUIContext().px2vp(navigationArea.bottomRect.height);

      // 存储底部避让区高度
      AppStorage.setOrCreate(SAFE_BOTTOM, safeBottom);
      AVPlayerManager.init();//新增
      AVSessionManager.init(this.context);


      hilog.info(DOMAIN, 'testTag', `SafeArea Set: Top=${safeTop}vp, Bottom=${safeBottom}vp`);
    });

  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}