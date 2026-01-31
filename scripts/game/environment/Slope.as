package game.environment
{
   import flash.geom.Rectangle;
   import flashpunk2.Entity;
   import flashpunk2.global.Debug;
   import game.Constants;
   import game.PlatformObject;
   
   public class Slope extends Entity implements Solid
   {
      
      public static const RIGHT:uint = 0;
      
      public static const LEFT:uint = 1;
      
      private var _floorRight:Number;
      
      private var _floorLeft:Number;
      
      private var _body:Rectangle = new Rectangle(32,32);
      
      public function Slope(param1:int, param2:int, param3:uint)
      {
         super(int(param1 + Constants.TILE_WIDTH / 2),int(param2 + Constants.TILE_HEIGHT / 2));
         if(param3 == RIGHT)
         {
            this._floorLeft = 0;
            this._floorRight = Constants.TILE_HEIGHT - 1;
         }
         else
         {
            this._floorRight = 0;
            this._floorLeft = Constants.TILE_HEIGHT - 1;
         }
         groups = Groups.SOLID | Groups.BLOCK | Groups.THICK;
         ON_DEBUG.add(this.onDebug);
      }
      
      public function get body() : Rectangle
      {
         return this._body;
      }
      
      private function onDebug() : void
      {
         var _loc1_:int = x - Constants.TILE_WIDTH / 2;
         Debug.drawLine(_loc1_,this.bottom - this._floorLeft,_loc1_ + Constants.TILE_WIDTH,this.bottom - this._floorRight,16776960,0.5,3);
         Debug.drawLine(_loc1_,this.bottom - this._floorLeft,_loc1_,this.bottom,16776960,0.5,3);
         Debug.drawLine(_loc1_ + Constants.TILE_WIDTH,this.bottom,_loc1_ + Constants.TILE_WIDTH,this.bottom - this._floorRight,16776960,0.5,3);
      }
      
      public function get floorLeft() : Number
      {
         return this._floorLeft;
      }
      
      public function get floorRight() : Number
      {
         return this._floorRight;
      }
      
      public function isObstacle(param1:int, param2:int) : Boolean
      {
         return param1 == 1;
      }
      
      public function onStepped(param1:PlatformObject) : void
      {
      }
      
      public function get bottom() : Number
      {
         return y + Constants.TILE_HEIGHT / 2;
      }
      
      public function get top() : Number
      {
         return y - Constants.TILE_HEIGHT / 2;
      }
      
      public function onHit(param1:PlatformObject) : void
      {
      }
      
      public function reset() : void
      {
      }
   }
}

