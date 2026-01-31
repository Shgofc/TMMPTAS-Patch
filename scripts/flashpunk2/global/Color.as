package flashpunk2.global
{
   public final class Color
   {
      
      public static const WHITE:uint = 16777215;
      
      public static const SILVER:uint = 12632256;
      
      public static const GREY:uint = 8421504;
      
      public static const BLACK:uint = 0;
      
      public static const RED:uint = 16711680;
      
      public static const MAROON:uint = 8388608;
      
      public static const YELLOW:uint = 16776960;
      
      public static const OLIVE:uint = 8421376;
      
      public static const LIME:uint = 65280;
      
      public static const GREEN:uint = 32768;
      
      public static const AQUA:uint = 65535;
      
      public static const TEAL:uint = 32896;
      
      public static const BLUE:uint = 255;
      
      public static const NAVY:uint = 128;
      
      public static const FUCHSIA:uint = 16711935;
      
      public static const PURPLE:uint = 8388736;
      
      public static const BROWN:uint = 9127187;
      
      public function Color()
      {
         super();
      }
      
      public static function fromString(param1:String) : uint
      {
         if(param1.indexOf("0x") >= 0)
         {
            return uint(param1);
         }
         if(param1.indexOf("#") >= 0)
         {
            return uint(param1.replace("#","0x"));
         }
         return uint("0x" + param1);
      }
      
      public static function toString(param1:uint) : String
      {
         var _loc2_:String = param1.toString(16).toUpperCase();
         while(_loc2_.length < 6)
         {
            _loc2_ = "0" + _loc2_;
         }
         return "#" + _loc2_;
      }
      
      public static function rgb(param1:uint, param2:uint, param3:uint) : uint
      {
         if(param1 < 0 || param2 < 0 || param3 < 0 || param1 > 255 || param2 > 255 || param3 > 255)
         {
            throw new Error("RGB values must be within range 0-255.");
         }
         return param1 << 16 | param2 << 8 | param3;
      }
      
      public static function rgbPercent(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param1 < 0 || param2 < 0 || param3 < 0 || param1 > 1 || param2 > 1 || param3 > 1)
         {
            throw new Error("RGB values must be within range 0-1.");
         }
         return int(param1 * 255) << 16 | int(param2 * 255) << 8 | int(param3 * 255);
      }
      
      public static function hsv(param1:Number, param2:Number, param3:Number) : uint
      {
         if(param1 < 0 || param2 < 0 || param3 < 0 || param1 > 1 || param2 > 1 || param3 > 1)
         {
            throw new Error("HSV values msut be within range 0-1.");
         }
         param1 = int(param1 * 360);
         var _loc4_:int = int(param1 / 60) % 6;
         var _loc5_:Number = param1 / 60 - int(param1 / 60);
         var _loc6_:Number = param3 * (1 - param2);
         var _loc7_:Number = param3 * (1 - _loc5_ * param2);
         var _loc8_:Number = param3 * (1 - (1 - _loc5_) * param2);
         switch(_loc4_)
         {
            case 0:
               return int(param3 * 255) << 16 | int(_loc8_ * 255) << 8 | int(_loc6_ * 255);
            case 1:
               return int(_loc7_ * 255) << 16 | int(param3 * 255) << 8 | int(_loc6_ * 255);
            case 2:
               return int(_loc6_ * 255) << 16 | int(param3 * 255) << 8 | int(_loc8_ * 255);
            case 3:
               return int(_loc6_ * 255) << 16 | int(_loc7_ * 255) << 8 | int(param3 * 255);
            case 4:
               return int(_loc8_ * 255) << 16 | int(_loc6_ * 255) << 8 | int(param3 * 255);
            case 5:
               return int(param3 * 255) << 16 | int(_loc6_ * 255) << 8 | int(_loc7_ * 255);
            default:
               return 0;
         }
      }
      
      public static function getRed(param1:uint) : uint
      {
         return param1 >> 16 & 0xFF;
      }
      
      public static function getRedPercent(param1:uint) : Number
      {
         return (param1 >> 16 & 0xFF) / 255;
      }
      
      public static function getGreen(param1:uint) : uint
      {
         return param1 >> 8 & 0xFF;
      }
      
      public static function getGreenPercent(param1:uint) : Number
      {
         return (param1 >> 8 & 0xFF) / 255;
      }
      
      public static function getBlue(param1:uint) : uint
      {
         return param1 & 0xFF;
      }
      
      public static function getBluePercent(param1:uint) : Number
      {
         return (param1 & 0xFF) / 255;
      }
      
      public static function lerp(param1:uint, param2:uint, param3:Number) : uint
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(param3 <= 0)
         {
            return param1;
         }
         if(param3 >= 1)
         {
            return param2;
         }
         _loc4_ = uint(param1 >> 16 & 0xFF);
         _loc5_ = uint(param1 >> 8 & 0xFF);
         _loc6_ = uint(param1 & 0xFF);
         _loc4_ += ((param2 >> 16 & 0xFF) - _loc4_) * param3;
         _loc5_ += ((param2 >> 8 & 0xFF) - _loc5_) * param3;
         _loc6_ += ((param2 & 0xFF) - _loc6_) * param3;
         return _loc4_ << 16 | _loc5_ << 8 | _loc6_;
      }
   }
}

