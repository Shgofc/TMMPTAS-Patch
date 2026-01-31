package game.enemies
{
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Ease;
   import flashpunk2.global.Rand;
   import sound.SoundManager;
   
   public class Shooter extends Enemy
   {
      
      private var side:int = -1;
      
      private var type:String;
      
      private var canShot:Boolean = false;
      
      public function Shooter(param1:int, param2:int, param3:String)
      {
         super(param1,param2,48,48);
         this.type = param3;
         image = new AnimationRenderer();
         image.addPrefix("stand","enemies/" + param3 + "Idle",8,false);
         image.addPrefix("blink","enemies/" + param3 + "IdleBlink",8,false);
         image.addPrefix("shot","enemies/" + param3 + "Shoot",10,false);
         image.centerOrigin();
         image.originY = image.height;
         image.y = body.height / 2;
         add(image);
         image.play("stand");
         ON_UPDATE.add(this.onUpdate);
         tween(this,3,null,false).onComplete(this.onStartShot).repeat(-1);
      }
      
      private function onStartShot() : void
      {
         image.play("shot",true);
         image.ON_COMPLETE.add(this.backToIdle);
         this.canShot = true;
      }
      
      private function onShot() : void
      {
         if(this.canShot)
         {
            world.add(new Projectile(x + this.side * 4,y - 18,"fx/muckShot",this.side * 4));
            level.shouldSortEntities = true;
            this.canShot = false;
            SoundManager.playSound("spit",0.6);
         }
      }
      
      private function backToIdle() : void
      {
         (image as AnimationRenderer).play(Rand.chance(0.1) ? "blink" : "stand");
      }
      
      private function onUpdate() : void
      {
         if(player.x != x)
         {
            this.side = Calc.sign(player.x - x);
         }
         if(Calc.sign(image.scaleX) != this.side)
         {
            tween(image,0.4).scaleFrom(0.7 * this.side,1).scaleTo(1 * this.side,1).ease(Ease.backOut);
         }
         if(image.index == 4 && image.animationName == "shot")
         {
            this.onShot();
         }
      }
   }
}

