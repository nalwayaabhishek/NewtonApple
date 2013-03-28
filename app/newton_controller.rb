class NewtonController < UIViewController


  # how many pixels/sec an accel of 1.0 represents
  MAX_ACCEL_PER_SEC = 200;
  def viewDidLoad
    create_scene
    @lastAccelTimestamp = 0  
    resetApple
    
    @motionManager = CMMotionManager.alloc.init

    if (@motionManager.isDeviceMotionAvailable)
      queue = NSOperationQueue.alloc.init

      @motionManager.startDeviceMotionUpdatesToQueue(queue, withHandler:lambda do |motion, error|
        start_playing(motion, error)

      end)
    else
      p "Device Motion is not available: You're likely running this in a simulator"
      @label0.text = "Device Motion is not available: You're likely running this in a simulator"
    end

  end
  def start_playing(motion, error)
    #As Device Motion work in diffrent thread 
    Dispatch::Queue.main.sync do

      elapsedTime = motion.timestamp - @lastAccelTimestamp
      #v = u + at
      @appleVelocityX = @appleVelocityX  + (motion.gravity.x * MAX_ACCEL_PER_SEC * elapsedTime)
      @appleVelocityY = @appleVelocityY - (motion.gravity.y * MAX_ACCEL_PER_SEC * elapsedTime)

      if (@lastAccelTimestamp > 0)
        # distance = velocity * time
        @appleX += (@appleVelocityX * elapsedTime)
        @appleY += (@appleVelocityY * elapsedTime)
        checkApple
      end


      # update view
      @apple.position = CGPointMake( @appleX , @appleY)


      @lastAccelTimestamp = motion.timestamp

    end

  end
  def resetApple
    @appleVelocityX = 0.0
    @appleVelocityY = 0.0
    @appleX = self.view.frame.size.width / 2
    @appleY = self.view.frame.size.height / 5
  end
  def checkApple
    if	@appleX  < 0 || @appleY  < 0 ||
      @appleX > self.view.frame.size.width ||
      @appleY > self.view.frame.size.height
      resetApple
    end
  end


  def create_scene
    self.view.backgroundColor = UIColor.colorWithRed(0.255, green: 0.686, blue: 0.988, alpha: 1.0)
    @apple = CALayer.layer
    @apple_image = UIImage.imageNamed("apple.png")
    @apple.contents = @apple_image.CGImage
    @apple.frame = CGRectMake(0, 0, 153, 82)
    @apple.position = CGPointMake(100, 100)
    self.view.layer.addSublayer(@apple)

    @grass = CALayer.layer
    @grass_image = UIImage.imageNamed("Tree.gif")
    @grass.contents = @grass_image.CGImage
    @grass.frame = CGRectMake(0, 0, 553, 682)
    @grass.position = CGPointMake(200, 250)
    self.view.layer.addSublayer(@grass)


    @label0 =  UILabel.alloc.initWithFrame( [[25, 10], [250, 40]] )
    @label0.backgroundColor = UIColor.clearColor
    view.addSubview(@label0)
  end
end