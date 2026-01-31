package flashpunk2.components.rendering
{
   import flashpunk2.Component;
   import flashpunk2.Entity;
   import flashpunk2.global.Calc;
   import flashpunk2.namespaces.fp_internal;
   import starling.display.DisplayObject;
   
   use namespace fp_internal;
   
   public class Renderer extends Component
   {
      
      private var _displayObject:DisplayObject;
      
      private var _angle:Number = 0;
      
      private var _x:int = 0;
      
      private var _y:int = 0;
      
      public var scroll:Number = 1;
      
      public function Renderer()
      {
         super();
      }
      
      public function updateCamera() : void
      {
         this._displayObject.y = this._y + camera.y * (1 - this.scroll);
         this._displayObject.x = this._x + camera.x * (1 - this.scroll);
      }
      
      override fp_internal function start(param1:Entity) : void
      {
         super.fp_internal::start(param1);
         camera.ON_CHANGE.add(this.updateCamera);
         this.updateCamera();
         if(this._displayObject != null)
         {
            param1.sprite.addChild(this._displayObject);
         }
      }
      
      override fp_internal function end() : void
      {
         if(this._displayObject != null)
         {
            entity.sprite.removeChild(this._displayObject);
         }
         camera.ON_CHANGE.remove(this.updateCamera);
         super.fp_internal::end();
      }
      
      fp_internal function setDisplayObject(param1:DisplayObject) : void
      {
         if(exists)
         {
            if(this._displayObject != null)
            {
               entity.sprite.removeChild(this._displayObject);
            }
            this._displayObject = param1;
            if(this._displayObject != null)
            {
               entity.sprite.addChild(this._displayObject);
            }
         }
         else
         {
            this._displayObject = param1;
         }
      }
      
      public function setPosition(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function setOrigin(param1:Number, param2:Number) : void
      {
         this.originX = param1;
         this.originY = param2;
      }
      
      public function setScale(param1:Number, param2:Number) : void
      {
         this.scaleX = param1;
         this.scaleY = param2;
      }
      
      public function lookAt(param1:Number, param2:Number) : void
      {
         if(entity != null)
         {
            this.angle = Calc.atan2(param2 - (entity.y + this.y),param1 - (entity.x + this.x));
         }
         else
         {
            this.angle = Calc.atan2(param2 - this.y,param1 - this.x);
         }
      }
      
      public function centerOrigin() : void
      {
         this.originX = this.width / 2;
         this.originY = this.height / 2;
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function set x(param1:Number) : void
      {
         this._x = param1;
         if(camera != null)
         {
            this._displayObject.x = param1 - camera.x * (1 - this.scroll);
         }
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function set y(param1:Number) : void
      {
         this._y = param1;
         if(camera != null)
         {
            this._displayObject.y = param1 - camera.y * (1 - this.scroll);
         }
      }
      
      public function get originX() : Number
      {
         return this._displayObject.pivotX;
      }
      
      public function set originX(param1:Number) : void
      {
         this._displayObject.pivotX = param1;
      }
      
      public function get originY() : Number
      {
         return this._displayObject.pivotY;
      }
      
      public function set originY(param1:Number) : void
      {
         this._displayObject.pivotY = param1;
      }
      
      public function get scaleX() : Number
      {
         return this._displayObject.scaleX;
      }
      
      public function set scaleX(param1:Number) : void
      {
         this._displayObject.scaleX = param1;
      }
      
      public function get scaleY() : Number
      {
         return this._displayObject.scaleY;
      }
      
      public function set scaleY(param1:Number) : void
      {
         this._displayObject.scaleY = param1;
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
            this._displayObject.rotation = param1 * Calc.RAD;
         }
      }
      
      public function get alpha() : Number
      {
         return this._displayObject.alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         this._displayObject.alpha = param1;
      }
      
      public function get blendMode() : String
      {
         return this._displayObject.blendMode;
      }
      
      public function set blendMode(param1:String) : void
      {
         this._displayObject.blendMode = param1;
      }
      
      public function get visible() : Boolean
      {
         return this._displayObject.visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._displayObject.visible = param1;
      }
      
      public function get width() : Number
      {
         return this._displayObject.width;
      }
      
      public function get height() : Number
      {
         return this._displayObject.height;
      }
   }
}

