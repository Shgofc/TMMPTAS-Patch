package game.environment
{
   import flashpunk2.components.rendering.RectRenderer;
   import flashpunk2.global.Debug;
   
   public class MovingPlatform extends Wall
   {
      
      private var xSpeed:Number = 10;
      
      private var ySpeed:Number = 0;
      
      private var debugColor:uint = 16777215;
      
      public function MovingPlatform(param1:Number, param2:Number, param3:int)
      {
         super(param1,param2,param3 * 32,32);
         image = new RectRenderer(param3 * 32,32,0,true);
         add(image);
         ON_UPDATE.add(this.onUpdate);
      }
      
      public function willCollide() : void
      {
         this.debugColor = 16711680;
      }
      
      override protected function onDebug() : void
      {
         Debug.drawRect(x + body.x,y + body.y,body.width,body.height,this.debugColor,0.5);
      }
      
      private function onUpdate() : void
      {
         this.debugColor = 16777215;
      }
   }
}

