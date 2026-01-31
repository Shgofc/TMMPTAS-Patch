package game.fx
{
   import flashpunk2.Entity;
   import flashpunk2.components.timing.Tween;
   import game.world.PlatformLevel;
   
   public class CameraShake extends Entity
   {
      
      public function CameraShake(param1:int, param2:Number)
      {
         var timer:Tween = null;
         var amplitude:int = param1;
         var duration:Number = param2;
         super();
         timer = tween(this,duration).onComplete(this.destroy);
         ON_UPDATE.add(function():void
         {
            (world as PlatformLevel).cameraShake = amplitude * (1 - timer.percent);
         });
      }
      
      private function destroy() : void
      {
         (world as PlatformLevel).cameraShake = 0;
         removeSelf();
      }
   }
}

