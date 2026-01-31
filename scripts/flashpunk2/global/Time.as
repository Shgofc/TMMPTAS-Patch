package flashpunk2.global
{
   import flash.utils.getTimer;
   import flashpunk2.Engine;
   import flashpunk2.namespaces.fp_internal;
   
   use namespace fp_internal;
   
   public final class Time
   {
      
      private static var _frameRate:int;
      
      private static var _time:Number = 0;
      
      private static var _total:Number = 0;
      
      private static var _dt:Number = 0;
      
      private static var _rate:Number = 1;
      
      private static var _frameTimer:Number = 0;
      
      private static var _frameCounter:int = 0;
      
      public function Time()
      {
         super();
      }
      
      fp_internal static function start() : void
      {
         _time = 0;
         _total = 0;
         _dt = 0;
         _frameRate = Engine.instance.frameRate;
      }
      
      fp_internal static function update(param1:Number) : void
      {
         _dt = (param1 - _time) / 1000;
         _total += _dt * _rate;
         _time = param1;
         ++_frameCounter;
         _frameTimer += _dt;
         if(_frameTimer >= 1)
         {
            _frameTimer = _frameTimer - 1;
            _frameRate = _frameCounter;
            _frameCounter = 0;
         }
      }
      
      fp_internal static function resume() : void
      {
         _time = getTimer();
      }
      
      public static function loop(param1:Number, param2:Number, param3:Number, param4:Number = 0) : Number
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(param3 != param2 && param1 != 0)
         {
            _loc5_ = param3 - param2;
            _loc6_ = (_total + param1 * param4) * (Math.abs(_loc5_) / param1);
            if(_loc5_ > 0)
            {
               return param2 + _loc6_ - _loc5_ * int(_loc6_ / _loc5_);
            }
            return param2 - (_loc6_ - Math.abs(_loc5_) * int(_loc6_ / Math.abs(_loc5_)));
         }
         return param2;
      }
      
      public static function wave(param1:Number, param2:Number, param3:Number, param4:Number = 0) : Number
      {
         var _loc5_:Number = NaN;
         if(param3 != param2 && param1 != 0)
         {
            _loc5_ = (param3 - param2) / 2;
            return param2 + _loc5_ + Math.sin((_total + param1 * param4) / param1 * (Math.PI * 2)) * _loc5_;
         }
         return param2;
      }
      
      public static function alt(param1:Number) : Boolean
      {
         return int(_total / param1) % 2 == 0;
      }
      
      public static function altValues(param1:Number, param2:*, param3:*) : *
      {
         return alt(param1) ? param2 : param3;
      }
      
      public static function get total() : Number
      {
         return _total;
      }
      
      public static function get dt() : Number
      {
         return _dt * _rate;
      }
      
      public static function get rate() : Number
      {
         return _rate;
      }
      
      public static function set rate(param1:Number) : void
      {
         _rate = param1;
      }
      
      public static function get frameRate() : int
      {
         return _frameRate;
      }
   }
}

