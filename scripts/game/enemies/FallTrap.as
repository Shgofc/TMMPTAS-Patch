package game.enemies
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.global.Ease;
   import game.environment.Wall;
   import sound.SoundManager;
   
   public class FallTrap extends Wall
   {
      
      private static const SPEED:Number = 6;
      
      private var destroyed:Boolean = false;
      
      private var solid:Boolean = false;
      
      private var original:Point;
      
      public function FallTrap(param1:int, param2:int, param3:Boolean = true)
      {
         var x:int = param1;
         var y:int = param2;
         var startTween:Boolean = param3;
         super(x,y,32,64);
         this.original = new Point(x,y);
         image = new ImageRenderer("environment/estalactite",true);
         image.y = 10;
         add(image);
         if(startTween)
         {
            image.originY = 0;
            image.y = -image.height / 2;
            image.scaleY = 0;
            tween(image,1).scaleTo(1,1).ease(Ease.backOut).onComplete(function():void
            {
               image.centerOrigin();
               image.x = image.y = 0;
               ON_UPDATE.add(onUpdate);
            });
         }
         else
         {
            ON_UPDATE.add(this.onUpdate);
         }
      }
      
      private function onUpdate() : void
      {
         if(x < level.player.x + level.player.body.width && x + body.width > level.player.x && level.player.y > y)
         {
            ON_UPDATE.remove(this.onUpdate);
            tween(this,0.5).scaleTo(1,0.8).onComplete(function():void
            {
               ON_UPDATE.add(onFalling);
               setScale(1,1);
            });
         }
      }
      
      private function onFalling() : void
      {
         var _loc3_:Wall = null;
         var _loc4_:Rectangle = null;
         var _loc1_:Rectangle = new Rectangle(x,y + 16 + SPEED,body.width / 2,body.height);
         var _loc2_:Boolean = false;
         for each(_loc3_ in level.getEntitiesByType(Wall))
         {
            if(level.solidAt(_loc1_.x / 32,_loc1_.y / 32) != null)
            {
               SoundManager.playSound("bossHit");
               _loc2_ = true;
               break;
            }
         }
         _loc4_ = new Rectangle(x,y,body.width,body.height);
         if(level.player.body.intersects(_loc4_))
         {
            level.player.onTakeHit(1,x - level.player.x > 0 ? 1 : -1);
            this.destroy();
         }
         if(!_loc2_)
         {
            y += SPEED;
         }
         else if(!this.destroyed)
         {
            setPosition(int(x / 32) * 32 + 16,int(y / 32) * 32 + 16);
            level.setSolid(x / 32,y / 32,this);
            tween(image,0.4).moveTo(image.x,image.y + 16).ease(Ease.elasticOut);
            ON_UPDATE.remove(this.onFalling);
            this.solid = true;
         }
      }
      
      public function destroy() : void
      {
         if(!this.destroyed)
         {
            this.destroyed = true;
            tween(this,0.25).scaleTo(0,0).onComplete(function():void
            {
               world.add(new FallTrap(original.x,original.y,true));
               removeSelf();
            });
         }
      }
   }
}

