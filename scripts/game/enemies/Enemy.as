package game.enemies
{
   import flash.geom.Rectangle;
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Ease;
   import flashpunk2.global.Rand;
   import game.PlatformObject;
   import game.fx.Explosion;
   import game.player.Player;
   import game.world.PlatformLevel;
   import sound.SoundManager;
   import starling.display.Image;
   
   public class Enemy extends PlatformObject
   {
      
      protected var _damage:int = 2;
      
      protected var hp:int = 3;
      
      protected var alive:Boolean = true;
      
      protected var image:AnimationRenderer = new AnimationRenderer();
      
      protected var player:Player;
      
      protected var takingHit:Boolean = false;
      
      protected var invulnerable:int = 0;
      
      protected var spot:Image;
      
      public function Enemy(param1:int, param2:int, param3:int, param4:int, param5:Boolean = true)
      {
         super(param1 + param3 / 2,param2 + param4,param3,param4,false,param5);
         ON_START.add(this.onStart);
         ON_UPDATE.add(this.onUpdate);
         groups = Groups.ENEMY;
      }
      
      private function onUpdate() : void
      {
         if(this.alive)
         {
            if(this.hp <= 0)
            {
               this.alive = false;
               _body = new Rectangle();
               gravity = 0;
               _ySpeed = 0;
               _xSpeed = 0;
               cancelAllTweens();
               if(this.spot)
               {
                  tween(this.spot,0.4).scaleTo(0,0).ease(Ease.cubeOut).onComplete(function():void
                  {
                     level.illumination.removeSpot(spot);
                  });
               }
               tween(this,0.45).scaleFrom(1.25,0.9).scaleTo(0,0).ease(Ease.backIn).onComplete(this.kill);
            }
         }
      }
      
      public function kill() : void
      {
         this.dropLoot();
         world.add(new Explosion(x,y));
         removeSelf();
      }
      
      protected function dropLoot() : void
      {
         level.randomLoot(x,y);
      }
      
      public function takeHit(param1:int, param2:int) : void
      {
         if(!this.takingHit && this.alive)
         {
            SoundManager.playSound("coelhadaHit" + Rand.getInt(2).toString());
            this.hp -= param1;
            tween(this.image,0.5,null,false).scaleFrom(0.8 * param2,1.2).scaleTo(1 * param2,1).ease(Ease.backInOut);
            this.takingHit = true;
            _ySpeed = -200;
            world.add(new Explosion(x,y - this.image.width / 3,"puff",0.3));
         }
      }
      
      public function onBounced(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         if(this.alive)
         {
            _loc2_ = Calc.sign(this.image.scaleX);
            this.hp -= param1;
            tween(this.image,0.5,null,false).scaleFrom(1.3 * _loc2_,0.8).scaleTo(1 * _loc2_,1).ease(Ease.backInOut);
            this.takingHit = true;
            _ySpeed = -100;
            world.add(new Explosion(x,y - this.image.width / 3,"puff",0.3));
            return true;
         }
         return false;
      }
      
      override protected function onHitGround() : void
      {
         super.onHitGround();
         this.takingHit = false;
      }
      
      private function onStart() : void
      {
         this.player = (world as PlatformLevel).player;
      }
      
      public function get canAttack() : Boolean
      {
         return !this.takingHit && this.invulnerable <= 0;
      }
      
      public function get damage() : int
      {
         return this._damage;
      }
   }
}

