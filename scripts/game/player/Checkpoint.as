package game.player
{
   import flash.geom.Rectangle;
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.AnimationRenderer;
   import game.UserData;
   import game.world.PlatformLevel;
   import sound.SoundManager;
   
   public class Checkpoint extends Entity
   {
      
      private var body:Rectangle;
      
      private var image:AnimationRenderer;
      
      public function Checkpoint(param1:int, param2:int)
      {
         super(param1,param2,this.onUpdate);
         add(this.image = new AnimationRenderer());
         this.image.addPrefix("off","environment/checkpointOff",10,true);
         this.image.addPrefix("on","environment/checkpointOn",10,true);
         this.body = new Rectangle(param1,param2,32,64);
         ON_START.add(this.onStart);
         depth = 5;
      }
      
      private function onStart() : void
      {
         if(UserData.isCheckpoint(world as PlatformLevel))
         {
            this.image.play("on");
         }
         else
         {
            this.image.play("off");
         }
      }
      
      private function onUpdate() : void
      {
         if((world as PlatformLevel).player.body.intersects(this.body))
         {
            ON_UPDATE.remove(this.onUpdate);
            UserData.setCheckpoint((world as PlatformLevel).x,(world as PlatformLevel).y);
            this.image.play("on");
            SoundManager.playSound("checkpoint");
         }
      }
   }
}

