package game.enemies
{
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.global.Ease;
   import game.fx.ScreenFlash;
   import game.world.Cutscene;
   import game.world.PlatformLevel;
   import sound.MusicPlayer;
   
   public class MermanBoss extends Enemy
   {
      
      public static const IDLE:String = "idle";
      
      public static const WALK:String = "walk";
      
      public static const JUMP:String = "jump";
      
      private var currentMove:String;
      
      private var thinking:int;
      
      private var side:int;
      
      private var jumping:Boolean = false;
      
      private var startY:Number;
      
      private var levelSide:int = -1;
      
      private var canShot:Boolean = false;
      
      public function MermanBoss(param1:int, param2:int)
      {
         super(param1,param2,64,64);
         image = new AnimationRenderer();
         image.addPrefix("idle","enemies/bossMermanIdle",10,true);
         image.addPrefix("jump","enemies/bossMermanJumpB",10,true);
         image.addPrefix("rotate","enemies/bossMermanFlip",10,true);
         image.addPrefix("shot","enemies/bossMermanShoot",12,false);
         image.play("idle");
         image.centerOrigin();
         image.originY -= 48;
         add(image);
         image.y -= 31;
         this.currentMove = IDLE;
         this.thinking = 10;
         ON_START.add(this.onStart);
         this.side = 1;
         _damage = 1;
         hp = 6;
         gravity = 0;
         ON_UPDATE.add(this.onUpdate);
         tween(this,3,null,false).onComplete(this.onStartJump);
         this.startY = param2 + 64;
      }
      
      private function onStart() : void
      {
         x += image.width / 2;
         y += image.height / 2;
      }
      
      private function onStartJump() : void
      {
         var entity:Entity = null;
         image.play("jump",true);
         entity = this;
         tween(this,1.5).to("y",this.startY - 300).ease(Ease.circOut).onComplete(function():void
         {
            onStartShot();
            tween(entity,1.7).delay(0.1).to("y",startY).ease(Ease.cubeInOut).onComplete(backToIdle);
            tween(entity,1.7,null,false).delay(0.1).to("angle",levelSide == -1 ? 180 : -180).ease(Ease.cubeOut);
            tween(entity,1.7,null,false).delay(0.1).to("x",levelSide == 1 ? 128 : level.width - 128).ease(Ease.cubeOut);
         });
         tween(this,1.8,null,false).delay(0.2).to("x",level.width / 2).ease(null);
         tween(entity,1.7,null,false).delay(0.1).to("angle",this.levelSide == -1 ? 90 : -90).ease(Ease.cubeOut);
      }
      
      private function onStartShot() : void
      {
         image.play("shot");
         image.ON_COMPLETE.add(function():void
         {
            image.play("idle");
            image.ON_COMPLETE.clear();
         });
         this.canShot = true;
      }
      
      private function backToIdle() : void
      {
         cancelAllTweens();
         this.levelSide *= -1;
         image.scaleX = -this.levelSide;
         this.side = this.levelSide;
         image.play("rotate");
         angle = 0;
         image.ON_COMPLETE.add(function():void
         {
            image.play("idle");
            image.ON_COMPLETE.clear();
         });
         tween(this,2,null,false).onComplete(this.onStartJump);
      }
      
      override public function onBounced(param1:int) : Boolean
      {
         return false;
      }
      
      override public function kill() : void
      {
         var merm:Merman = null;
         MusicPlayer.playMusic("vitoria",1,true);
         world.add(new ScreenFlash(0,1,0,function():void
         {
            engine.setWorld(new Cutscene("saveCascao",new PlatformLevel(2,92,player),false));
         }));
         for each(merm in level.getEntitiesByType(Merman))
         {
            merm.kill();
         }
         super.kill();
      }
      
      override public function takeHit(param1:int, param2:int) : void
      {
         if(invulnerable <= 0 && alive)
         {
            hp -= param1;
            tween(image,0.5,null,false).scaleFrom(0.8 * param2,1.2).scaleTo(1 * param2,1).ease(Ease.backInOut);
            invulnerable = 30;
         }
      }
      
      private function onUpdate() : void
      {
         if(image.index == 3 && image.animationName == "shot")
         {
            this.onShot();
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
      
      private function onShot() : void
      {
         if(this.canShot)
         {
            this.canShot = false;
            world.add(new Projectile(x,y + 32,"fx/waterShot",1 * (player.x - x < 0 ? -1 : 1),1.5));
            world.add(new Projectile(x,y + 32,"fx/waterShot",1 * (player.x - x > 0 ? -1 : 1),1.5));
         }
      }
   }
}

