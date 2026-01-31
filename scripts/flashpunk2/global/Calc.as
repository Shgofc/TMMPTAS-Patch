package flashpunk2.global
{
   public final class Calc
   {
      
      public static const DEG:Number = 180 / Math.PI;
      
      public static const RAD:Number = Math.PI / 180;
      
      public static const PI:Number = Math.PI;
      
      public static const PI2:Number = Math.PI * 2;
      
      public static const RIGHT:Number = 0;
      
      public static const LEFT:Number = 180;
      
      public static const DOWN:Number = 90;
      
      public static const UP:Number = -90;
      
      public function Calc()
      {
         super();
      }
      
      public static function deg(param1:Number) : Number
      {
         return param1 * DEG;
      }
      
      public static function rad(param1:Number) : Number
      {
         return param1 * RAD;
      }
      
      public static function sin(param1:Number) : Number
      {
         return Math.sin(param1 * RAD);
      }
      
      public static function cos(param1:Number) : Number
      {
         return Math.cos(param1 * RAD);
      }
      
      public static function tan(param1:Number) : Number
      {
         return Math.tan(param1 * RAD);
      }
      
      public static function asin(param1:Number) : Number
      {
         return Math.asin(param1 * RAD);
      }
      
      public static function acos(param1:Number) : Number
      {
         return Math.acos(param1 * RAD);
      }
      
      public static function atan(param1:Number) : Number
      {
         return Math.atan(param1 * RAD);
      }
      
      public static function atan2(param1:Number, param2:Number) : Number
      {
         return Math.atan2(param1,param2) * DEG;
      }
      
      public static function log2(param1:uint) : uint
      {
         return Math.ceil(Math.log(param1) * Math.LOG2E);
      }
      
      public static function isPowerOf2(param1:uint) : Boolean
      {
         return param1 != 0 && (param1 & param1 - 1) == 0;
      }
      
      public static function nextPowerOf2(param1:uint, param2:Boolean = false) : uint
      {
         if(!param2)
         {
            param1--;
         }
         param1 |= param1 >> 1;
         param1 |= param1 >> 2;
         param1 |= param1 >> 4;
         param1 |= param1 >> 8;
         param1 |= param1 >> 16;
         return ++param1;
      }
      
      public static function hob(param1:uint) : uint
      {
         param1 |= param1 >> 1;
         param1 |= param1 >> 2;
         param1 |= param1 >> 4;
         param1 |= param1 >> 8;
         param1 |= param1 >> 16;
         return param1 - (param1 >> 1);
      }
      
      public static function hobLog2(param1:uint) : uint
      {
         param1 |= param1 >> 1;
         param1 |= param1 >> 2;
         param1 |= param1 >> 4;
         param1 |= param1 >> 8;
         param1 |= param1 >> 16;
         return Math.round(Math.log(hob(param1 - (param1 >> 1))) * Math.LOG2E);
      }
      
      public static function sign(param1:Number) : Number
      {
         if(param1 > 0)
         {
            return 1;
         }
         if(param1 < 0)
         {
            return -1;
         }
         return 0;
      }
      
      public static function approach(param1:Number, param2:Number, param3:Number) : Number
      {
         return param1 < param2 ? (param2 < param1 + param3 ? param2 : param1 + param3) : (param2 > param1 - param3 ? param2 : param1 - param3);
      }
      
      public static function lerp(param1:Number, param2:Number, param3:Number) : Number
      {
         return param1 + (param2 - param1) * param3;
      }
      
      public static function lerpClamp(param1:Number, param2:Number, param3:Number) : Number
      {
         return lerp(param1,param2,Math.min(param3,1));
      }
      
      public static function inverseLerp(param1:Number, param2:Number, param3:Number) : Number
      {
         return (param3 - param1) / (param2 - param1);
      }
      
      public static function angleTo(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return Math.atan2(param4 - param2,param3 - param1) * DEG;
      }
      
      public static function angleOf(param1:Number, param2:Number) : Number
      {
         return Math.atan2(param2,param1) * DEG;
      }
      
      public static function angleDifference(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = (param2 - param1) % 360;
         if(_loc3_ > 180)
         {
            return Math.abs(_loc3_ - 360);
         }
         if(_loc3_ <= -180)
         {
            return Math.abs(_loc3_ + 360);
         }
         return Math.abs(_loc3_);
      }
      
      public static function angleOffset(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = (param2 - param1) % 360;
         if(_loc3_ > 180)
         {
            return _loc3_ - 360;
         }
         if(_loc3_ <= -180)
         {
            return _loc3_ + 360;
         }
         return _loc3_;
      }
      
      public static function wrapAngle(param1:Number) : Number
      {
         param1 %= 360;
         if(param1 > 180)
         {
            return param1 - 360;
         }
         if(param1 <= -180)
         {
            return param1 + 360;
         }
         return param1;
      }
      
      public static function angleEquals(param1:Number, param2:Number) : Boolean
      {
         return angleOffset(param1,param2) == 0;
      }
      
      public static function distance(param1:Number, param2:Number, param3:Number = 0, param4:Number = 0) : Number
      {
         return Math.sqrt((param3 - param1) * (param3 - param1) + (param4 - param2) * (param4 - param2));
      }
      
      public static function sqrDistance(param1:Number, param2:Number, param3:Number = 0, param4:Number = 0) : Number
      {
         return (param3 - param1) * (param3 - param1) + (param4 - param2) * (param4 - param2);
      }
      
      public static function rectRectDistance(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Number
      {
         if(param1 < param5 + param7 && param5 < param1 + param3)
         {
            if(param2 < param6 + param8 && param6 < param2 + param4)
            {
               return 0;
            }
            if(param2 > param6)
            {
               return param2 - (param6 + param8);
            }
            return param6 - (param2 + param4);
         }
         if(param2 < param6 + param8 && param6 < param2 + param4)
         {
            if(param1 > param5)
            {
               return param1 - (param5 + param7);
            }
            return param5 - (param1 + param3);
         }
         if(param1 > param5)
         {
            if(param2 > param6)
            {
               return distance(param1,param2,param5 + param7,param6 + param8);
            }
            return distance(param1,param2 + param4,param5 + param7,param6);
         }
         if(param2 > param6)
         {
            return distance(param1 + param3,param2,param5,param6 + param8);
         }
         return distance(param1 + param3,param2 + param4,param5,param6);
      }
      
      public static function pointRectDistance(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Number
      {
         if(param1 >= param3 && param1 <= param3 + param5)
         {
            if(param2 >= param4 && param2 <= param4 + param6)
            {
               return 0;
            }
            if(param2 > param4)
            {
               return param2 - (param4 + param6);
            }
            return param4 - param2;
         }
         if(param2 >= param4 && param2 <= param4 + param6)
         {
            if(param1 > param3)
            {
               return param1 - (param3 + param5);
            }
            return param3 - param1;
         }
         if(param1 > param3)
         {
            if(param2 > param4)
            {
               return distance(param1,param2,param3 + param5,param4 + param6);
            }
            return distance(param1,param2,param3 + param5,param4);
         }
         if(param2 > param4)
         {
            return distance(param1,param2,param3,param4 + param6);
         }
         return distance(param1,param2,param3,param4);
      }
      
      public static function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param3 > param2)
         {
            param1 = param1 < param3 ? param1 : param3;
            return param1 > param2 ? param1 : param2;
         }
         param1 = param1 < param2 ? param1 : param2;
         return param1 > param3 ? param1 : param3;
      }
      
      public static function clamp01(param1:Number) : Number
      {
         if(param1 < 0)
         {
            return 0;
         }
         if(param1 > 1)
         {
            return 1;
         }
         return param1;
      }
      
      public static function scale(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Number
      {
         return param4 + (param1 - param2) / (param3 - param2) * (param5 - param4);
      }
      
      public static function scale01(param1:Number, param2:Number, param3:Number) : Number
      {
         return (param1 - param2) / (param3 - param2);
      }
      
      public static function scaleClamp(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Number
      {
         param1 = param4 + (param1 - param2) / (param3 - param2) * (param5 - param4);
         if(param5 > param4)
         {
            param1 = param1 < param5 ? param1 : param5;
            return param1 > param4 ? param1 : param4;
         }
         param1 = param1 < param4 ? param1 : param4;
         return param1 > param5 ? param1 : param5;
      }
      
      public static function quadraticBezier(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param1 * (1 - param4) * (1 - param4) + param2 * 2 * (1 - param4) * param4 + param3 * param4 * param4;
      }
      
      public static function cubicBezier(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Number
      {
         return param5 * param5 * param5 * (param4 + 3 * (param2 - param3) - param1) + 3 * param5 * param5 * (param1 - 2 * param2 + param3) + 3 * param5 * (param2 - param1) + param1;
      }
      
      public static function catmullRom(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Number
      {
         return 0.5 * (2 * param2 + (-param1 + param3) * param5 + (2 * param1 - 5 * param2 + 4 * param3 - param4) * param5 * param5 + (-param1 + 3 * param2 - 3 * param3 + param4) * param5 * param5 * param5);
      }
      
      public static function circumference(param1:Number) : Number
      {
         return PI2 * param1;
      }
      
      public static function arcLength(param1:Number, param2:Number, param3:Number) : Number
      {
         return PI2 * param1 * (angleDifference(param2,param3) / 360);
      }
      
      public static function determinant(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param1 * param4 - param2 * param3;
      }
      
      public static function dotProduct(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param1 * param3 + param2 * param4;
      }
      
      public static function loop(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc4_:Number = Math.min(param2,param3);
         var _loc5_:Number = Math.max(param2,param3);
         var _loc6_:Number = _loc5_ - _loc4_;
         param1 %= _loc6_;
         if(param1 < _loc4_)
         {
            return param1 + _loc6_;
         }
         if(param1 > _loc5_)
         {
            return param1 - _loc6_;
         }
         return param1;
      }
      
      public static function loop01(param1:Number) : Number
      {
         param1 %= 1;
         if(param1 < 0)
         {
            return param1 + 1;
         }
         return param1;
      }
      
      public static function wave(param1:Number, param2:Number, param3:Number) : Number
      {
         return scale(Math.sin(scale(loop(param1,param2,param3),param2,param3,-PI,PI)),-1,1,param2,param3);
      }
      
      public static function wave01(param1:Number) : Number
      {
         return scale(Math.sin(scale(loop01(param1),0,1,-PI,PI)),-1,1,0,1);
      }
      
      public static function moveAngleX(param1:Number, param2:Number) : Number
      {
         return Math.cos(param1 * RAD) * param2;
      }
      
      public static function moveAngleY(param1:Number, param2:Number) : Number
      {
         return Math.sin(param1 * RAD) * param2;
      }
      
      public static function smoothStep(param1:Number) : Number
      {
         return param1 * param1 * (3 - 2 * param1);
      }
      
      public static function smoothLerp(param1:Number, param2:Number, param3:Number) : Number
      {
         return param1 + smoothStep(param3) * (param2 - param1);
      }
      
      public static function round(param1:Number) : int
      {
         return Math.round(param1);
      }
      
      public static function floor(param1:Number) : int
      {
         return Math.floor(param1);
      }
      
      public static function ceil(param1:Number) : int
      {
         return Math.ceil(param1);
      }
      
      public static function pow(param1:Number, param2:Number) : Number
      {
         return Math.pow(param1,param2);
      }
      
      public static function exp(param1:Number) : Number
      {
         return Math.exp(param1);
      }
      
      public static function sqrt(param1:Number) : Number
      {
         return Math.sqrt(param1);
      }
      
      public static function isMultiple(param1:int, param2:int) : Boolean
      {
         return param2 % param1 == 0;
      }
      
      public static function strBool(param1:String) : Boolean
      {
         return param1 == "True";
      }
   }
}

