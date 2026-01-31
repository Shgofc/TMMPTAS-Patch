package game.enemies
{
   import flash.geom.Rectangle;
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Rand;
   import game.world.PlatformLevel;
   import sound.SoundManager;
   
   public class Projectile extends Entity
   {
      
      protected var xSpeed:Number = 0;
      
      protected var ySpeed:Number = 0;
      
      private var _body:Rectangle;
      
      protected var image:AnimationRenderer;
      
      private var gone:Boolean = false;
      
      public var side:int = 0;
      
      public function Projectile(param1:int, param2:int, param3:String, param4:Number, param5:Number = 0)
      {
         super(param1,param2);
         this.ySpeed = param5;
         this.xSpeed = param4;
         this._body = new Rectangle(param1 - 4,param2 - 4,8,8);
         this.image = new AnimationRenderer();
         this.image.addPrefix("proj",param3,10,true);
         this.image.addPrefix("fade",param3 + "Fade",10,false);
         this.image.play("proj");
         add(this.image);
         this.image.centerOrigin();
         ON_UPDATE.add(this.onUpdate);
         this.image.scaleX = param4 > 0 ? 1 : -1;
         groups = Groups.PROJECTILE;
      }
      
      public function onHit() : void
      {
         if(!this.gone)
         {
            this._body = new Rectangle();
            this.gone = true;
            ON_UPDATE.remove(this.onUpdate);
            this.image.play("fade");
            this.image.ON_COMPLETE.add(removeSelf);
            this.xSpeed = 0;
            this.ySpeed = 0;
            SoundManager.playSound("goo" + Rand.getInt(2).toString());
         }
      }
      
      public function takeHit() : void
      {
         this.onHit();
      }
      
      private function onUpdate() : void
      {
         x += this.xSpeed;
         y += this.ySpeed;
         this._body.x = x - 4;
         this._body.y = y - 4;
         if(x < 0 || x > this.level.width)
         {
            removeSelf();
         }
         else
         {
            this.side = Calc.sign(this.xSpeed);
            if(this.level.solidAt((x + this.xSpeed + this.side * 8) / 32,(y + this.ySpeed) / 32))
            {
               this.onHit();
            }
         }
      }
      
      public function get level() : PlatformLevel
      {
         return world as PlatformLevel;
      }
      
      public function get body() : Rectangle
      {
         return this._body;
      }
      
      public function get damage() : int
      {
         return 1;
      }
   }
}

