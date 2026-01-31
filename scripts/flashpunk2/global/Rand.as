package flashpunk2.global
{
   import flashpunk2.namespaces.fp_internal;
   
   use namespace fp_internal;
   
   public final class Rand
   {
      
      private static var _seed:uint;
      
      public function Rand()
      {
         super();
      }
      
      fp_internal static function start() : void
      {
         randomizeSeed();
      }
      
      public static function fromSeed(param1:uint) : Number
      {
         return param1 * 16807 % 2147483647 / 2147483647;
      }
      
      public static function getNumber(param1:Number) : Number
      {
         return param1 * value;
      }
      
      public static function getNumberRange(param1:Number, param2:Number) : Number
      {
         return param1 + (param2 - param1) * value;
      }
      
      public static function getInt(param1:int) : int
      {
         return param1 * value;
      }
      
      public static function getIntRange(param1:int, param2:int) : int
      {
         if(param2 > param1)
         {
            return param1 + (param2 + 1 - param1) * value;
         }
         return param2 + (param1 + 1 - param2) * value;
      }
      
      public static function randomizeSeed() : void
      {
         seed = 2147483647 * Math.random();
      }
      
      public static function choose(... rest) : *
      {
         var values:Array = rest;
         if(values.length > 1)
         {
            return values[int(values.length * value)];
         }
         try
         {
            return values[0][int(values[0].length * value)];
         }
         catch(e:Error)
         {
            throw new Error("Invalid choose type. Provide arguments to choose from or an array of values.");
         }
      }
      
      public static function chance(param1:Number) : Boolean
      {
         return value < param1;
      }
      
      public static function get seed() : uint
      {
         return _seed;
      }
      
      public static function set seed(param1:uint) : void
      {
         _seed = Calc.clamp(param1,1,2147483646);
      }
      
      public static function get value() : Number
      {
         _seed = _seed * 16807 % 2147483647;
         return _seed / 2147483647;
      }
      
      public static function get angle() : Number
      {
         return 360 * value;
      }
      
      public static function get boolean() : Boolean
      {
         return value < 0.5;
      }
      
      public static function get color() : uint
      {
         return 16777215 * value;
      }
      
      public static function get hue() : uint
      {
         return Color.hsv(value,1,1);
      }
      
      public static function randomIndexByWeights(param1:Array) : int
      {
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ += param1[_loc3_];
            _loc3_++;
         }
         var _loc4_:Number = value * _loc2_;
         _loc2_ = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ += param1[_loc3_];
            if(_loc4_ < _loc2_)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return param1.length - 1;
      }
   }
}

