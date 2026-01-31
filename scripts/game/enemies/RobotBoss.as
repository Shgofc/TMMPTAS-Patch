package game.enemies
{
   import flash.geom.Point;
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Ease;
   import flashpunk2.global.Rand;
   import game.fx.CameraShake;
   import game.fx.ScreenFlash;
   import sound.MusicPlayer;
   import sound.SoundManager;
   
   public class RobotBoss extends Enemy
   {
      
      private var side:int = 1;
      
      private var wheelB:ImageRenderer;
      
      private var wheelA:ImageRenderer;
      
      public function RobotBoss(param1:int, param2:int)
      {
         super(param1 + 80,param2 - 48,124,238,true);
         image = new AnimationRenderer();
         image.addPrefix("idle","enemies/bossRobotIdle",10,true);
         image.centerOrigin();
         image.play("idle");
         add(image);
         var _loc3_:AnimationRenderer = new AnimationRenderer();
         _loc3_.addPrefix("idle","enemies/cebolinha",10,true);
         _loc3_.centerOrigin();
         _loc3_.play("idle");
         _loc3_.setPosition(5,-130);
         add(_loc3_);
         this.wheelA = new ImageRenderer("enemies/bossRoboWheel",true);
         this.wheelA.setPosition(-35,100);
         add(this.wheelA);
         this.wheelB = new ImageRenderer("enemies/bossRoboWheel",true);
         this.wheelB.setPosition(40,100);
         add(this.wheelB);
         tween(this.wheelA,1).from("angle",0).to("angle",360).repeat(-1);
         tween(this.wheelB,1).from("angle",0).to("angle",360).repeat(-1);
         _xSpeed = 35;
         ON_UPDATE.add(this.onUpdate);
         tween(this,4).onComplete(this.nextAction).repeat(-1);
         hp = 15;
      }
      
      private function nextAction() : void
      {
         this.shotAtPlayer();
      }
      
      private function shotAtPlayer() : void
      {
         var thisThing:Enemy = null;
         switch(Rand.getInt(5))
         {
            case 0:
               tween(this,0.2,null,false).repeat(2).onComplete(function():void
               {
                  var _loc1_:Point = null;
                  _loc1_ = new Point(player.x,player.y).subtract(new Point(x,y));
                  _loc1_.normalize(9);
                  SoundManager.playSound("plasma");
                  world.add(new Projectile(x,y,"fx/plasmaShot",_loc1_.x,_loc1_.y));
               });
               break;
            case 1:
               _ySpeed -= 350;
               break;
            case 2:
            case 3:
               thisThing = this;
               tween(this,0.2,null,false).onComplete(function():void
               {
                  var _loc1_:Point = null;
                  _loc1_ = new Point(player.x,player.y).subtract(new Point(x,y));
                  _loc1_.normalize(5);
                  SoundManager.playSound("plasma3");
                  world.add(new ChargedBall(x,y,_loc1_.x,_loc1_.y,thisThing));
               });
               break;
            case 4:
               _xSpeed *= -1;
         }
      }
      
      override protected function onHitGround() : void
      {
         super.onHitGround();
         SoundManager.playSound("bossHit");
         SoundManager.playSound("plasma2");
         world.add(new CameraShake(10,0.25));
         world.add(new Projectile(x,y + body.y / 2,"fx/plasmaShot",10,0));
         world.add(new Projectile(x,y + body.y / 2,"fx/plasmaShot",-10,0));
         world.add(new Projectile(x,y + body.y / 2,"fx/plasmaShot",8,0));
         world.add(new Projectile(x,y + body.y / 2,"fx/plasmaShot",-8,0));
         world.add(new Projectile(x,y + body.y / 2,"fx/plasmaShot",5,0));
         world.add(new Projectile(x,y + body.y / 2,"fx/plasmaShot",-5,0));
      }
      
      override public function onBounced(param1:int) : Boolean
      {
         if(invulnerable <= 0)
         {
            super.onBounced(param1);
            tween(image,0.5).scaleFrom(1.3 * this.side,0.8).scaleTo(1 * this.side,1).ease(Ease.backInOut);
            invulnerable = 120;
            return true;
         }
         return false;
      }
      
      override public function kill() : void
      {
         world.add(new ScreenFlash(0,2,0,level.endGame,1));
         super.kill();
         MusicPlayer.playMusic("vitoria",1,true);
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
      
      override public function onHorizontalCollide() : void
      {
         _xSpeed *= -1;
      }
      
      private function onUpdate() : void
      {
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
         if(Calc.sign(_xSpeed) != this.side)
         {
            this.side = Calc.sign(_xSpeed);
            if(this.side == 1)
            {
               tween(this.wheelA,1).from("angle",0).to("angle",360).repeat(-1);
               tween(this.wheelB,1).from("angle",0).to("angle",360).repeat(-1);
            }
            else
            {
               tween(this.wheelA,1).from("angle",360).to("angle",0).repeat(-1);
               tween(this.wheelB,1).from("angle",360).to("angle",0).repeat(-1);
            }
         }
      }
   }
}

