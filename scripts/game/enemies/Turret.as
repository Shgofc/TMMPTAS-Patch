package game.enemies
{
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Ease;
   import flashpunk2.global.Rand;
   import sound.SoundManager;
   
   public class Turret extends Enemy
   {
      
      private var cannon:ImageRenderer;
      
      private var lockOn:Boolean = false;
      
      public function Turret(param1:int, param2:int)
      {
         super(param1 - 4,param2,48,48);
         this.cannon = new ImageRenderer("enemies/turretCannon",true);
         this.cannon.originX = 10;
         add(this.cannon);
         image = new AnimationRenderer();
         image.addPrefix("","enemies/turretTop",10,true);
         image.play("");
         image.centerOrigin();
         image.y = -10;
         add(image);
         ON_UPDATE.add(this.onUpdate);
         hp = 4;
         tween(this,3.5).delay(Rand.getNumber(4)).onComplete(this.onShot).repeat(-1);
         depth = -5;
         ON_START.add(this.onStart);
      }
      
      private function onStart() : void
      {
         if(level.dark)
         {
            spot = level.illumination.addSpot(x - camera.x,y - camera.y,0);
            tween(spot,0.5).scaleFrom(0,0).scaleTo(2.5,2.5).ease(Ease.bounceOut);
            ON_UPDATE.add(function():void
            {
               spot.x = x - camera.x;
               spot.y = y - camera.y;
            });
         }
      }
      
      private function onShot() : void
      {
         var _loc1_:Number = 3;
         SoundManager.playSound("plasma");
         world.add(new Projectile(x + Calc.moveAngleX(this.cannon.angle,image.width - 10),y + Calc.moveAngleY(this.cannon.angle,image.height - 10),"fx/plasmaShot",Calc.moveAngleX(this.cannon.angle,_loc1_),Calc.moveAngleY(this.cannon.angle,_loc1_)));
         tween(this.cannon,1).scaleTo(1,1).scaleFrom(0.6,0.8).ease(Ease.elasticOut);
      }
      
      private function onUpdate() : void
      {
         var _loc1_:Number = Calc.atan2(player.y - (y + this.cannon.y),player.x - (x + this.cannon.x));
         this.lockOn = false;
         if(!(_loc1_ < -180 || _loc1_ > 15))
         {
            this.cannon.angle = Calc.lerp(this.cannon.angle,_loc1_,0.05);
            this.lockOn = true;
         }
      }
   }
}

