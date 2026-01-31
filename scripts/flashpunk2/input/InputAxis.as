package flashpunk2.input
{
   import flash.geom.Point;
   
   public class InputAxis
   {
      
      private var _point:Point = new Point();
      
      private var _right:InputButton = new InputButton();
      
      private var _left:InputButton = new InputButton();
      
      private var _down:InputButton = new InputButton();
      
      private var _up:InputButton = new InputButton();
      
      private var _circle:Boolean = false;
      
      public function InputAxis()
      {
         super();
      }
      
      public static function create(param1:Boolean = true, param2:uint = 39, param3:uint = 37, param4:uint = 40, param5:uint = 38) : InputAxis
      {
         var _loc6_:InputAxis = new InputAxis();
         return _loc6_.setCircle(param1).addKeys(param2,param3,param4,param5);
      }
      
      public function addKeys(param1:uint = 39, param2:uint = 37, param3:uint = 40, param4:uint = 38) : InputAxis
      {
         this._right.addKey(param1);
         this._left.addKey(param2);
         this._down.addKey(param3);
         this._up.addKey(param4);
         return this;
      }
      
      public function setKeys(param1:uint = 39, param2:uint = 37, param3:uint = 40, param4:uint = 38) : InputAxis
      {
         this._right.clearKeys();
         this._left.clearKeys();
         this._down.clearKeys();
         this._up.clearKeys();
         this._right.addKey(param1);
         this._left.addKey(param2);
         this._down.addKey(param3);
         this._up.addKey(param4);
         return this;
      }
      
      public function addRightKey(param1:uint) : InputAxis
      {
         this._right.addKey(param1);
         return this;
      }
      
      public function addRightKeys(... rest) : InputAxis
      {
         this._right.addKeys.apply(null,rest);
         return this;
      }
      
      public function setRightKeys(... rest) : InputAxis
      {
         this._right.setKeys.apply(null,rest);
         return this;
      }
      
      public function addLeftKey(param1:uint) : InputAxis
      {
         this._left.addKey(param1);
         return this;
      }
      
      public function addLeftKeys(... rest) : InputAxis
      {
         this._left.addKeys.apply(null,rest);
         return this;
      }
      
      public function setLeftKeys(... rest) : InputAxis
      {
         this._left.setKeys.apply(null,rest);
         return this;
      }
      
      public function addDownKey(param1:uint) : InputAxis
      {
         this._down.addKey(param1);
         return this;
      }
      
      public function addDownKeys(... rest) : InputAxis
      {
         this._down.addKeys.apply(null,rest);
         return this;
      }
      
      public function setDownKeys(... rest) : InputAxis
      {
         this._down.setKeys.apply(null,rest);
         return this;
      }
      
      public function addUpKey(param1:uint) : InputAxis
      {
         this._up.addKey(param1);
         return this;
      }
      
      public function addUpKeys(... rest) : InputAxis
      {
         this._up.addKeys.apply(null,rest);
         return this;
      }
      
      public function setUpKeys(... rest) : InputAxis
      {
         this._up.setKeys.apply(null,rest);
         return this;
      }
      
      public function setCircle(param1:Boolean = true) : InputAxis
      {
         this._circle = param1;
         return this;
      }
      
      public function setSquare(param1:Boolean = true) : InputAxis
      {
         this._circle = !param1;
         return this;
      }
      
      public function get x() : Number
      {
         this._point.x = 0;
         if(this.rightButton.down)
         {
            ++this._point.x;
         }
         if(this.leftButton.down)
         {
            --this._point.x;
         }
         if(this._circle)
         {
            if(this.downButton.down)
            {
               ++this._point.y;
            }
            if(this.upButton.down)
            {
               --this._point.y;
            }
            if(this._point.x != 0 && this._point.y != 0)
            {
               this._point.normalize(1);
            }
         }
         return this._point.x;
      }
      
      public function get y() : Number
      {
         this._point.y = 0;
         if(this.downButton.down)
         {
            ++this._point.y;
         }
         if(this.upButton.down)
         {
            --this._point.y;
         }
         if(this._circle)
         {
            if(this.rightButton.down)
            {
               ++this._point.x;
            }
            if(this.leftButton.down)
            {
               --this._point.x;
            }
            if(this._point.x != 0 && this._point.y != 0)
            {
               this._point.normalize(1);
            }
         }
         return this._point.y;
      }
      
      public function get rightButton() : InputButton
      {
         return this._right;
      }
      
      public function get leftButton() : InputButton
      {
         return this._left;
      }
      
      public function get downButton() : InputButton
      {
         return this._down;
      }
      
      public function get upButton() : InputButton
      {
         return this._up;
      }
      
      public function get isCircle() : Boolean
      {
         return this._circle;
      }
      
      public function set isCircle(param1:Boolean) : void
      {
         this._circle = param1;
      }
      
      public function get isSquare() : Boolean
      {
         return !this._circle;
      }
      
      public function set isSquare(param1:Boolean) : void
      {
         this._circle = !param1;
      }
      
      public function get down() : Boolean
      {
         return this._right.down || this._left.down || this._down.down || this._up.down;
      }
      
      public function get pressed() : Boolean
      {
         return this._right.pressed || this._left.pressed || this._down.pressed || this._up.pressed;
      }
      
      public function get released() : Boolean
      {
         return this._right.released || this._left.released || this._down.released || this._up.released;
      }
      
      public function get up() : Boolean
      {
         return !this.down;
      }
   }
}

