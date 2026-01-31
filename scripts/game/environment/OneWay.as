package game.environment
{
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.global.Debug;
   
   public class OneWay extends Wall
   {
      
      public function OneWay(param1:int, param2:int)
      {
         super(param1,param2,32,32);
         image = new ImageRenderer("environment/oneWay",true);
         add(image);
         ON_START.add(this.onStart);
         depth = 1;
      }
      
      private function onStart() : void
      {
         level.setSolid(x / 32,y / 32,this);
      }
      
      override protected function onDebug() : void
      {
         Debug.drawRect(x + body.x,y + body.y,body.width,body.height / 2,16742144,0.5);
      }
      
      override public function isObstacle(param1:int, param2:int) : Boolean
      {
         return level.player.body.bottom <= body.top + y + 1 && param2 > 0 && param1 == 1;
      }
   }
}

