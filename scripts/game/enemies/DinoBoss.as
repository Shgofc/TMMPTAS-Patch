package game.enemies
{
   import flash.geom.Rectangle;
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.global.Debug;
   import flashpunk2.global.Rand;
   import game.environment.FallBlock;
   import game.fx.CameraShake;
   import game.fx.Explosion;
   import game.fx.ScreenFlash;
   import game.world.Cutscene;
   import game.world.PlatformLevel;
   import sound.MusicPlayer;
   import sound.SoundManager;
   
   public class DinoBoss extends Enemy
   {
      
      public static const IDLE:String = "idle";
      
      public static const WALK:String = "walk";
      
      public static const JUMP:String = "jump";
      
      private var currentMove:String;
      
      private var thinking:Number;
      
      private var side:int;
      
      private var jumping:Boolean = false;
      
      private var willJump:Boolean = false;
      
      private var fallBody:Rectangle;
      
      public function DinoBoss(param1:int, param2:int)
      {
         super(param1,param2,64,128);
         image = new AnimationRenderer();
         image.addPrefix("idle","enemies/bossDinoIdle",10,true);
         image.addPrefix("jumpBefore","enemies/bossDinoJumpA",10,false);
         image.addPrefix("jumpAfter","enemies/bossDinoJumpB",10,true);
         image.addPrefix("jumpTurn","enemies/bossDinoFallA",10,false);
         image.addPrefix("jumpFall","enemies/bossDinoFallB",10,true);
         image.addPrefix("hitGround","enemies/bossDinoFallC",10,false);
         image.addPrefix("walk","enemies/bossDinoWalk",10,true);
         image.addPrefix("hit","enemies/bossDinoHit",10,false);
         image.play("idle");
         image.centerOrigin();
         add(image);
         image.y -= 31;
         this.currentMove = IDLE;
         this.thinking = 10;
         ON_UPDATE.add(this.onUpdate);
         this.side = 1;
         _damage = 1;
         hp = 5;
         this.fallBody = new Rectangle(body.x - 24,body.y - 32,body.width + 48,body.height + 32);
         gravity *= 0.8;
      }
      
      override protected function onDebug() : void
      {
         super.onDebug();
         Debug.drawRect(this.fallBody.x,this.fallBody.y,this.fallBody.width,this.fallBody.height,16711680,0.5);
      }
      
      private function onUpdate() : void
      {
         var nextX:int = 0;
         var fb:FallBlock = null;
         this.fallBody.x = body.x - 24;
         this.fallBody.y = body.y;
         switch(this.currentMove)
         {
            case IDLE:
               if(this.thinking <= 0)
               {
                  this.currentMove = Rand.choose(WALK,JUMP);
                  this.thinking = 60;
                  break;
               }
               _xSpeed *= 0.9;
               --this.thinking;
               this.side = x > player.x ? -1 : 1;
               image.scaleX = this.side;
               break;
            case WALK:
               if(this.thinking <= 0)
               {
                  this.currentMove = IDLE;
                  image.play("idle");
                  this.thinking = 30;
                  image.scaleX = this.side;
                  break;
               }
               this.breakAround();
               image.scaleX = this.side;
               _xSpeed = 80 * this.side;
               this.thinking -= 0.6;
               image.play("walk");
               if(x <= 256 && xSpeed < 0 || x >= level.width - 256 && xSpeed > 0)
               {
                  this.side *= -1;
               }
               nextX = x + (body.width * 0.5 + 3) * this.side;
               for each(fb in level.getEntitiesByType(FallBlock))
               {
                  if(nextX > fb.x && fb.x + fb.body.width > nextX)
                  {
                     fb.destroy();
                  }
               }
               break;
            case JUMP:
               if(onGround)
               {
                  image.play("jumpBefore");
                  image.ON_COMPLETE.add(function():void
                  {
                     if(!jumping)
                     {
                        _ySpeed = -450;
                        side = x > player.x / 2 ? -1 : 1;
                        _xSpeed = 180 * side;
                        jumping = true;
                        image.play("jumpAfter");
                        image.ON_COMPLETE.clear();
                     }
                  });
               }
               if(image.animationName != "jumpFall" && image.animationName != "jumpTurn" && ySpeed > 0)
               {
                  image.play("jumpTurn");
                  image.ON_COMPLETE.add(function():void
                  {
                     image.ON_COMPLETE.clear();
                     image.play("jumpFall");
                  });
               }
               image.scaleX = this.side;
         }
         --invulnerable;
         if(invulnerable > 0)
         {
            if(invulnerable % 6 < 3)
            {
               image.alpha = 0.5;
            }
            else
            {
               image.alpha = 1;
            }
         }
         else
         {
            image.alpha = 1;
         }
      }
      
      private function onImpact() : void
      {
         var _loc1_:int = level.player.x / 32;
         level.add(new FallBlock(_loc1_,2));
         level.add(new FallBlock(this.getDifferentNumber(3,11,_loc1_),2));
         level.add(new FallBlock(this.getDifferentNumber(11,16,_loc1_),2));
         SoundManager.playSound("bossHit");
      }
      
      override public function onBounced(param1:int) : Boolean
      {
         if(invulnerable <= 0)
         {
            image.play("hit");
            image.ON_COMPLETE.add(this.backToIdle);
            super.onBounced(param1);
            invulnerable = 120;
            return true;
         }
         return false;
      }
      
      private function backToIdle() : void
      {
         image.play("idle");
         image.ON_COMPLETE.clear();
      }
      
      override public function kill() : void
      {
         var sFlash:ScreenFlash;
         var block:FallBlock = null;
         world.add(new Explosion(x,y));
         sFlash = new ScreenFlash(0,1,0,function():void
         {
            engine.setWorld(new Cutscene("saveMagali",new PlatformLevel(1,92),false));
         });
         world.add(sFlash);
         for each(block in level.getEntitiesByType(FallBlock))
         {
            block.wipeout();
         }
         MusicPlayer.playMusic("vitoria",1,true);
         removeSelf();
      }
      
      override protected function onHitGround() : void
      {
         super.onHitGround();
         if(this.jumping)
         {
            world.add(new CameraShake(5,0.25));
            this.onImpact();
            world.add(new CameraShake(10,0.25));
            image.play("hitGround");
            this.jumping = false;
            image.ON_COMPLETE.add(function():void
            {
               currentMove = IDLE;
               willJump = false;
               thinking = 40;
               backToIdle();
            });
            this.breakAround();
         }
         else
         {
            world.add(new CameraShake(5,0.25));
         }
      }
      
      private function breakAround() : void
      {
         var _loc1_:FallBlock = null;
         for each(_loc1_ in level.getEntitiesByType(FallBlock))
         {
            if(this.fallBody.intersects(new Rectangle(_loc1_.x - 16,_loc1_.y - 16,_loc1_.body.width,_loc1_.body.height)))
            {
               _loc1_.wipeout();
            }
         }
      }
      
      private function getDifferentNumber(param1:int, param2:int, param3:int) : int
      {
         var _loc4_:int = 0;
         while(true)
         {
            _loc4_ = Rand.getIntRange(param1,param2);
            if(_loc4_ != param3)
            {
               break;
            }
         }
         return _loc4_;
      }
   }
}

