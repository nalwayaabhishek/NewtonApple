class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
      @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
      @window.makeKeyAndVisible
      @window.rootViewController = NewtonController.new
    true
  end
end
