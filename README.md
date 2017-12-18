# Restoration


iOSApp 进入后台后，由于系统资源紧张，后台的App 的很容易被干掉。时间或长或短，与手机的配置相关，这就是用户的使用体验很差。不过幸亏有Restoration，能让被系统干掉的App再次点击启动时，回到最初的页面。


#### UIStoration 简介

> View controllers play an important role in the state preservation and restoration process. State preservation records the configuration of your app before it is suspended so that the configuration can be restored on a subsequent app launch. Returning an app to its previous configuration saves time for the user and offers a better user experience.
 

上面的是[Apple官方说明](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/PreservingandRestoringState.html)的开头一段，基本说明了UIStoration的原理和实现效果。强烈建议细读官方说明。当App进入后台的时候，系统会将App需要保存的界面和数据信息保存在本地，如果App被干掉之后，下次启动的时候，根据存在本地的数据来配置App界面

#### UIStoration 实现

给需要restore的ViewController 设置 `restorationClass`和 `restorationIdentifier`值,一般设置为控制器类名即可，另外ViewController 需要遵循 `UIViewControllerRestoration` 并实现下面几个方法:

```
- (void) encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeObject:_messageInput.text forKey:kMessageRestorationKey];
}

- (void) decodeRestorableStateWithCoder:(NSCoder *)coder{
    [super decodeRestorableStateWithCoder:coder];
    self.messageInput.text = [coder decodeObjectForKey:kMessageRestorationKey];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    ViewController* vc = nil;
    UIStoryboard* sb = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
    if (sb) {
        vc = (ViewController*)[sb instantiateViewControllerWithIdentifier:@"ViewController"];
        vc.restorationIdentifier = [identifierComponents lastObject];
        vc.restorationClass = [ViewController class];
    }
    return vc;
}

```

如果自定的View需要restore，也需要设置 `restorationClass`和 `restorationIdentifier`值,并实现前面两个方法即可。
如果一个控制器拥有多个控制器，对于子控制器的restore的时候，我们添加如下代码。相同的子View也类似

```
- (void) decodeRestorableStateWithCoder:(NSCoder *)coder{
    [super decodeRestorableStateWithCoder:coder];
    [_childVC decodeRestorableStateWithCoder:coder];
    self.messageInput.text = [coder decodeObjectForKey:kMessageRestorationKey];
}

- (void) decodeRestorableStateWithCoder:(NSCoder *)coder{
    [super decodeRestorableStateWithCoder:coder];
    [_childVC decodeRestorableStateWithCoder:coder];
    self.messageInput.text = [coder decodeObjectForKey:kMessageRestorationKey];
}

```
  在Appledegate里面我们也需要实现相应的方法,来告知系统是否需要save数据和restore数据
当App在restore的时候默认会使用当时App切掉时的屏幕快照作为App的启动图片。如果不需要，可以在 `willEncodeRestorableStateWithCoder`的时候实现这个方法 `[application ignoreSnapshotOnNextApplicationLaunch];`
### Restoration 复现操作

手机运行在Xcode运行App之后，点击home键，使App进入后台，停止运行Xcode，或者再次运行Xcode
，等App再次启动，就会触发Restoration
#### 详细见[代码](https://github.com/LevenWin/Restoration);
