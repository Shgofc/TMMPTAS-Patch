package game.environment
{
   import flash.geom.Rectangle;
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.Renderer;
   import flashpunk2.global.Debug;
   import game.Constants;
   import game.PlatformObject;
   import game.world.PlatformLevel;
   
   public class Wall extends Entity implements Solid
   {
      
      protected var image:Renderer;
      
      private var _body:Rectangle;
      
      public var glow:Boolean = false;
      
      public function Wall(param1:int, param2:int, param3:int, param4:int)
      {
         super(int(param1 + param3 / 2),int(param2 + param4 / 2));
         this._body = new Rectangle(-param3 / 2,-param4 / 2,param3,param4);
         groups = Groups.SOLID | Groups.BLOCK | Groups.THICK;
         ON_DEBUG.add(this.onDebug);
         depth = -2;
      }
      
      public function get body() : Rectangle
      {
         return this._body;
      }
      
      public function get level() : PlatformLevel
      {
         return world as PlatformLevel;
      }
      
      protected function onDebug() : void
      {
         Debug.drawRect(x + this.body.x,y + this.body.y,this.body.width,this.body.height,16776960,0.5);
      }
      
      public function get floorRight() : Number
      {
         return Constants.TILE_HEIGHT - 1;
      }
      
      public function get floorLeft() : Number
      {
         return Constants.TILE_HEIGHT - 1;
      }
      
      public function isObstacle(param1:int, param2:int) : Boolean
      {
         return true;
      }
      
      public function onStepped(param1:PlatformObject) : void
      {
      }
      
      public function onHit(param1:PlatformObject) : void
      {
      }
      
      public function get bottom() : Number
      {
         return y + this._body.y + this._body.height;
      }
      
      public function get top() : Number
      {
         return y + this._body.y;
      }
      
      public function reset() : void
      {
      }
   }
}

