package flashpunk2
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Rand;
   import flashpunk2.global.Time;
   import flashpunk2.namespaces.fp_internal;
   import nape.geom.Vec2;
   import starling.display.Sprite;
   
   use namespace fp_internal;
   
   public class Camera
   {
      
      public const ON_CHANGE:Signal = new Signal();
      
      private var _sprite:Sprite = new Sprite();
      
      private var _matrix:Matrix = new Matrix();
      
      private var _x:Number = 0;
      
      private var _y:Number = 0;
      
      private var _originX:Number = 0;
      
      private var _originY:Number = 0;
      
      private var _angle:Number = 0;
      
      private var _zoom:Number = 1;
      
      private var _dirty:Boolean = true;
      
      private var _shakeX:Number = 0;
      
      private var _shakeY:Number = 0;
      
      private var _shakeDuration:Number = 0;
      
      private var _shakeTime:Number = 0;
      
      private var _shakeMagnitude:Number;
      
      private var _min:Point = new Point();
      
      private var _max:Point = new Point();
      
      public function Camera()
      {
         super();
      }
      
      fp_internal function update() : void
      {
         var _loc1_:Number = NaN;
         if(this._shakeTime > 0)
         {
            this._shakeTime -= Time.dt;
            if(this._shakeTime > 0)
            {
               _loc1_ = this._shakeMagnitude * (this._shakeTime / this._shakeDuration);
               this._shakeX = Rand.getNumberRange(-_loc1_,_loc1_);
               this._shakeY = Rand.getNumberRange(-_loc1_,_loc1_);
            }
            else
            {
               this._shakeX = this._shakeY = 0;
            }
            this._dirty = true;
         }
         if(this._dirty)
         {
            this._matrix.identity();
            this._matrix.translate(-(this._x + this._shakeX),-(this._y + this._shakeY));
            if(this._angle != 0)
            {
               this._matrix.rotate(this._angle * Calc.RAD);
            }
            this._matrix.scale(this._zoom,this._zoom);
            this._matrix.translate(this._originX,this._originY);
            this._sprite.transformationMatrix = this._matrix;
            this._dirty = false;
            this._min.setTo(0,0);
            this._max.setTo(this.width,this.height);
            this._min = this._sprite.localToGlobal(this._min,this._min);
            this._max = this._sprite.localToGlobal(this._max,this._max);
            this._min.setTo(-this._min.x,-this._min.y);
            this._max.setTo(-this._max.x,-this._max.y);
            this.ON_CHANGE.dispatch();
         }
      }
      
      fp_internal function getMatrix() : Matrix
      {
         return this._matrix;
      }
      
      public function shake(param1:Number, param2:Number) : void
      {
         this._shakeTime = this._shakeDuration = param1;
         this._shakeMagnitude = param2;
      }
      
      public function setPosition(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function centerOn(param1:Number, param2:Number) : void
      {
         this.x = param1 - this.width / 2 + this._originX;
         this.y = param2 - this.height / 2 + this._originY;
      }
      
      public function setOrigin(param1:Number, param2:Number) : void
      {
         this.originX = param1;
         this.originY = param2;
      }
      
      public function centerOrigin() : void
      {
         this.setOrigin(Engine.instance.width / 2,Engine.instance.height / 2);
      }
      
      public function moveTowards(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Vec2 = null;
         if(Calc.distance(this._x,this._y,param1,param2) < param3)
         {
            this._x = param1;
            this._y = param2;
         }
         else
         {
            _loc4_ = Vec2.get(param1 - this._x,param2 - this._y);
            _loc4_.normalise();
            _loc4_.mul(param3);
            this._x += _loc4_.x;
            this._y += _loc4_.y;
            _loc4_.dispose();
         }
         this._dirty = true;
      }
      
      public function lerp(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Vec2 = null;
         if(param3 >= 1)
         {
            this._x = param1;
            this._y = param2;
         }
         else
         {
            _loc4_ = Vec2.get(param1 - this._x,param2 - this._y);
            _loc4_.mul(param3);
            this._x += _loc4_.x;
            this._y += _loc4_.y;
            _loc4_.dispose();
         }
         this._dirty = true;
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function set x(param1:Number) : void
      {
         if(this._x != param1)
         {
            this._x = param1;
            this._dirty = true;
         }
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function set y(param1:Number) : void
      {
         if(this._y != param1)
         {
            this._y = param1;
            this._dirty = true;
         }
      }
      
      public function get originX() : Number
      {
         return this._originX;
      }
      
      public function set originX(param1:Number) : void
      {
         if(this._originX != param1)
         {
            this._originX = param1;
            this._dirty = true;
         }
      }
      
      public function get originY() : Number
      {
         return this._originY;
      }
      
      public function set originY(param1:Number) : void
      {
         if(this._originY != param1)
         {
            this._originY = param1;
            this._dirty = true;
         }
      }
      
      public function get zoom() : Number
      {
         return this._zoom;
      }
      
      public function set zoom(param1:Number) : void
      {
         if(this._zoom != param1)
         {
            if(param1 == 0)
            {
               throw new Error("Zoom cannot be 0!");
            }
            this._zoom = param1;
            this._dirty = true;
         }
      }
      
      public function get angle() : Number
      {
         return this._angle;
      }
      
      public function set angle(param1:Number) : void
      {
         if(this._angle != param1)
         {
            this._angle = param1;
            this._dirty = true;
         }
      }
      
      public function get width() : Number
      {
         return Engine.instance.width;
      }
      
      public function get height() : Number
      {
         return Engine.instance.height;
      }
      
      public function get sprite() : Sprite
      {
         return this._sprite;
      }
      
      public function get left() : Number
      {
         return this._min.x;
      }
      
      public function get top() : Number
      {
         return this._min.y;
      }
      
      public function get right() : Number
      {
         return this._max.x;
      }
      
      public function get bottom() : Number
      {
         return this._max.y;
      }
   }
}

