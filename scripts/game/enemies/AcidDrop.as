package game.enemies
{
   import flash.geom.Rectangle;
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.AnimationRenderer;
   import game.environment.Wall;
   import game.world.PlatformLevel;
   
   public class AcidDrop extends Entity
   {
      
      public static const SPEED:int = 5;
      
      private var image:AnimationRenderer;
      
      private var body:Rectangle;
      
      private var destroyed:Boolean = false;
      
      public function AcidDrop(param1:int, param2:int)
      {
         super(param1,param2);
         this.image = new AnimationRenderer();
         this.image.addPrefix("fall","environment/acidDropFall",10,false);
         this.image.addPrefix("hit","environment/acidDropHit",10,false);
         this.image.play("fall");
         add(this.image);
         ON_UPDATE.add(this.onUpdate);
         this.body = new Rectangle(param1,param2,32,32);
      }
      
      public function get level() : PlatformLevel
      {
         return world as PlatformLevel;
      }
      
      private function onUpdate() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Boolean = false;
         var _loc3_:Wall = null;
         var _loc4_:Rectangle = null;
         if(!this.destroyed)
         {
            _loc1_ = new Rectangle(x,y + 16 + SPEED,this.body.width / 2,this.body.height);
            _loc2_ = false;
            for each(_loc3_ in this.level.getEntitiesByType(Wall))
            {
               if(this.level.solidAt(_loc1_.x / 32,_loc1_.y / 32) != null)
               {
                  _loc2_ = true;
                  y = y - 1;
                  y = int(_loc1_.y / 32) * 32 - 32;
                  this.destroy();
               }
            }
            _loc4_ = new Rectangle(x,y,this.body.width,this.body.height);
            if(this.level.player.body.intersects(_loc4_))
            {
               _loc2_ = true;
               this.level.player.onTakeHit(1,x + 8 - this.level.player.x > 0 ? -1 : 1);
               this.destroy();
            }
            if(!_loc2_)
            {
               y += SPEED;
            }
         }
      }
      
      private function destroy() : void
      {
         this.image.play("hit");
         this.destroyed = true;
         this.image.ON_COMPLETE.add(removeSelf);
      }
   }
}

