package game.enemies
{
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Ease;
   import flashpunk2.global.Rand;
   import game.fx.Explosion;
   import sound.SoundManager;
   
   public class Merman extends Enemy
   {
      
      private var side:int = -1;
      
      private var type:String;
      
      private var canShot:Boolean = false;
      
      private var startY:int;
      
      private var shouldJump:Boolean = false;
      
      public function Merman(param1:int, param2:int)
      {
         super(param1,param2,48,48);
         image = new AnimationRenderer();
         image.addPrefix("stand","enemies/mermanIdle",8,false);
         image.addPrefix("blink","enemies/mermanIdleBlink",8,false);
         image.addPrefix("shot","enemies/mermanShoot",10,false);
         image.addPrefix("jump","enemies/mermanJump",10,true);
         image.addPrefix("fall","enemies/mermanFall",10,true);
         image.centerOrigin();
         image.originY = image.height;
         image.y = body.height / 2;
         add(image);
         this.backToIdle();
         ON_UPDATE.add(this.onUpdate);
         tween(this,3,null,false).onComplete(this.onStartJump);
         gravity = 0;
         this.startY = param2 + 32;
      }
      
      private function onStartJump() : void
      {
         var jHeight:int;
         var entity:Entity = null;
         image.ON_COMPLETE.clear();
         this.shouldJump = true;
         image.play("jump",true);
         entity = this;
         jHeight = 128;
         if(Boolean(level.solidAt(x / 32,(y - 128) / 32)) || Boolean(level.solidAt(x / 32,(y - 128 - 32) / 32)))
         {
            jHeight = 64;
         }
         tween(this,1).moveTo(x,this.startY - jHeight).ease(Ease.cubeOut).onComplete(function():void
         {
            onStartShot();
            tween(entity,1).delay(0.1).moveTo(x,startY).ease(Ease.cubeInOut).onComplete(backToIdle);
         });
      }
      
      override public function takeHit(param1:int, param2:int) : void
      {
         if(!takingHit && alive)
         {
            SoundManager.playSound("coelhadaHit" + Rand.getInt(2).toString());
            hp -= param1;
            tween(image,0.5,null,false).scaleFrom(0.8 * param2,1.2).scaleTo(1 * param2,1).ease(Ease.backInOut);
            world.add(new Explosion(x,y - image.width / 3,"puff",0.3));
         }
      }
      
      override public function onBounced(param1:int) : Boolean
      {
         var side:int = 0;
         var jumpDamage:int = param1;
         if(alive)
         {
            side = Calc.sign(image.scaleX);
            hp -= jumpDamage;
            takingHit = true;
            tween(image,0.5,null,false).scaleFrom(1.3 * side,0.8).scaleTo(1 * side,1).ease(Ease.backInOut).onComplete(function():void
            {
               takingHit = false;
            });
            return true;
         }
         return false;
      }
      
      private function onStartShot() : void
      {
         image.play("shot",true);
         image.ON_COMPLETE.add(function():void
         {
            image.play("fall",true);
            image.ON_COMPLETE.clear();
         });
         this.canShot = true;
      }
      
      private function onShot() : void
      {
         if(this.canShot)
         {
            world.add(new Projectile(x,y - 16,"fx/waterShot",this.side * 4));
            this.canShot = false;
         }
      }
      
      private function backToIdle() : void
      {
         image.ON_COMPLETE.clear();
         image.ON_COMPLETE.add(this.backToIdle);
         image.play(Rand.chance(0.2) ? "blink" : "stand",true);
         if(this.shouldJump)
         {
            tween(this,2,null,false).onComplete(this.onStartJump);
            this.shouldJump = true;
         }
      }
      
      private function onUpdate() : void
      {
         if(player.x != x)
         {
            this.side = Calc.sign(player.x - x);
         }
         if(Calc.sign(image.scaleX) != this.side)
         {
            tween(image,0.4,null,false).scaleFrom(0.7 * this.side,1).scaleTo(1 * this.side,1).ease(Ease.backOut);
         }
         if(image.index == 1 && image.animationName == "shot")
         {
            this.onShot();
         }
      }
   }
}

