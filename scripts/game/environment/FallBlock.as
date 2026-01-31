package game.environment
{
   import flash.geom.Rectangle;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.global.Rand;
   import game.Constants;
   import game.enemies.DinoBoss;
   
   public class FallBlock extends Wall
   {
      
      private static const SPEED:Number = 4;
      
      private var destroyed:Boolean = false;
      
      private var solid:Boolean = false;
      
      public function FallBlock(param1:int, param2:int)
      {
         super(param1 * Constants.TILE_WIDTH + 10,param2 * Constants.TILE_HEIGHT + Constants.TILE_HEIGHT / 2 + 10,12,12);
         image = new ImageRenderer("environment/fallBlock" + Rand.getInt(2).toString(),true);
         add(image);
         ON_UPDATE.add(this.onUpdate);
      }
      
      public function destroy() : void
      {
         if(!this.destroyed)
         {
            tween(this,0.5).scaleTo(0,0).onComplete(this.removeSelf);
            if(!this.solid)
            {
               ON_UPDATE.remove(this.onUpdate);
            }
            else
            {
               level.setSolid(x / 32,y / 32,null);
            }
            this.destroyed = true;
         }
      }
      
      public function wipeout() : void
      {
         tween(this,0.5).scaleTo(0,0).onComplete(this.removeSelf);
         level.setSolid(x / 32,y / 32,null);
      }
      
      override public function removeSelf() : void
      {
         level.setSolid(x / 32,y / 32,null);
         super.removeSelf();
      }
      
      private function onUpdate() : void
      {
         var _loc3_:Wall = null;
         var _loc4_:DinoBoss = null;
         var _loc5_:Rectangle = null;
         var _loc1_:Rectangle = new Rectangle(x,y + 16 + SPEED,body.width,body.height);
         var _loc2_:Boolean = false;
         for each(_loc3_ in level.getEntitiesByType(Wall))
         {
            if(level.solidAt(_loc1_.x / 32,_loc1_.y / 32) != null)
            {
               _loc2_ = true;
               break;
            }
         }
         for each(_loc4_ in level.getEntitiesByType(DinoBoss))
         {
            if(_loc4_.body.intersects(_loc1_))
            {
               this.destroy();
            }
         }
         _loc5_ = new Rectangle(x,y,body.width,body.height);
         if(level.player.body.intersects(_loc5_))
         {
            level.player.onTakeHit(1,0);
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
            ON_UPDATE.remove(this.onUpdate);
            this.solid = true;
         }
      }
   }
}

