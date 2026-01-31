package flashpunk2.global
{
   import flash.display.Shape;
   import flash.geom.Matrix;
   import flashpunk2.Engine;
   import flashpunk2.namespaces.fp_internal;
   
   use namespace fp_internal;
   
   public final class Debug
   {
      
      private static var _identity:Matrix = new Matrix();
      
      private static var _shape:Shape = new Shape();
      
      public function Debug()
      {
         super();
      }
      
      fp_internal static function start() : void
      {
         Engine.instance.main.addChild(_shape);
      }
      
      fp_internal static function end() : void
      {
         Engine.instance.main.removeChild(_shape);
      }
      
      fp_internal static function update() : void
      {
         _shape.graphics.clear();
         if(Engine.instance.currentWorld != null)
         {
            _shape.transform.matrix = Engine.instance.currentWorld.camera.fp_internal::getMatrix();
         }
         else
         {
            _shape.transform.matrix = _identity;
         }
      }
      
      public static function registerCommand(param1:Function, ... rest) : void
      {
      }
      
      public static function log(... rest) : void
      {
      }
      
      public static function logError(... rest) : void
      {
      }
      
      public static function clearLog() : void
      {
      }
      
      public static function clear() : void
      {
         _shape.graphics.clear();
      }
      
      public static function drawCircle(param1:Number, param2:Number, param3:Number, param4:uint, param5:Number = 1) : void
      {
         _shape.graphics.lineStyle();
         _shape.graphics.beginFill(param4,param5);
         _shape.graphics.drawCircle(param1,param2,param3);
      }
      
      public static function drawCircleOutline(param1:Number, param2:Number, param3:Number, param4:uint, param5:Number = 1, param6:Number = 1) : void
      {
         _shape.graphics.endFill();
         _shape.graphics.lineStyle(param6,param4,param5);
         _shape.graphics.drawCircle(param1,param2,param3);
      }
      
      public static function drawRect(param1:Number, param2:Number, param3:Number, param4:Number, param5:uint, param6:Number = 1) : void
      {
         _shape.graphics.lineStyle();
         _shape.graphics.beginFill(param5,param6);
         _shape.graphics.drawRect(param1,param2,param3,param4);
      }
      
      public static function drawRectOutline(param1:Number, param2:Number, param3:Number, param4:Number, param5:uint, param6:Number = 1, param7:Number = 1) : void
      {
         _shape.graphics.endFill();
         _shape.graphics.lineStyle(param7,param5,param6);
         _shape.graphics.drawRect(param1,param2,param3,param4);
      }
      
      public static function drawLine(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number = 1, param7:Number = 1) : void
      {
         _shape.graphics.endFill();
         _shape.graphics.lineStyle(param7,param5,param6);
         _shape.graphics.moveTo(param1,param2);
         _shape.graphics.lineTo(param3,param4);
      }
   }
}

