package game.ui
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.Renderer;
   import flashpunk2.global.Debug;
   import flashpunk2.global.Ease;
   import flashpunk2.global.Input;
   
   public class Button extends Entity
   {
      
      public var body:Rectangle;
      
      private var pressed:Boolean = false;
      
      private var over:Boolean = false;
      
      private var simpleFunction:Function;
      
      public var overScale:Number = 1;
      
      public var image:Renderer;
      
      public var onHoverIn:Function;
      
      public var onPressed:Function;
      
      public var index:int = 0;
      
      public function Button(param1:int, param2:int, param3:Renderer, param4:Function, param5:Rectangle = null)
      {
         super(param1,param2);
         this.simpleFunction = param4;
         this.image = param3;
         this.image.scroll = 0;
         this.image.x = param3.width / 2;
         this.image.y = param3.height / 2;
         add(param3);
         if(param5 != null)
         {
            this.body = param5;
         }
         else
         {
            this.body = new Rectangle(param1,param2,param3.width,param3.height);
         }
         ON_UPDATE.add(this.onUpdate);
         ON_DEBUG.add(this.onDebug);
      }
      
      private function onDebug() : void
      {
         Debug.drawRectOutline(this.body.x,this.body.y,this.body.width,this.body.height,26367,1,2);
      }
      
      private function onUpdate() : void
      {
         if(this.body.containsPoint(new Point(Input.mouseX,Input.mouseY)))
         {
            if(!this.over)
            {
               tween(this.image,0.15).scaleTo(this.overScale + 0.2,this.overScale + 0.2).ease(Ease.backOut);
               this.over = true;
               if(this.onHoverIn != null)
               {
                  this.onHoverIn(this);
               }
            }
         }
         else if(this.over)
         {
            tween(this.image,0.15).scaleTo(this.overScale,this.overScale).ease(Ease.backOut);
            this.over = false;
         }
         if(Input.mousePressed && this.over)
         {
            if(!this.pressed)
            {
               tween(this.image,0.15).scaleTo(this.overScale - 0.2,this.overScale - 0.2).ease(Ease.backOut);
               this.pressed = true;
            }
         }
         if(!Input.mouseDown && this.over && this.pressed)
         {
            tween(this.image,0.15).scaleTo(this.overScale,this.overScale).ease(Ease.backOut);
            if(this.onPressed != null)
            {
               this.onPressed(this);
            }
            if(this.simpleFunction != null)
            {
               this.simpleFunction();
            }
         }
         if(!Input.mouseDown)
         {
            this.pressed = false;
         }
      }
      
      override public function set y(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = y - param1;
         super.y = param1;
         this.body.y -= _loc2_;
      }
      
      override public function set x(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = x - param1;
         super.x = param1;
         this.body.x -= _loc2_;
      }
      
      public function get alpha() : Number
      {
         return this.image.alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         this.image.alpha = param1;
      }
   }
}

