package game.environment
{
   import game.PlatformObject;
   
   public interface Solid
   {
      
      function get floorRight() : Number;
      
      function get floorLeft() : Number;
      
      function isObstacle(param1:int, param2:int) : Boolean;
      
      function onStepped(param1:PlatformObject) : void;
      
      function onHit(param1:PlatformObject) : void;
      
      function get bottom() : Number;
      
      function get top() : Number;
      
      function reset() : void;
   }
}

