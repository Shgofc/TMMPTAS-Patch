package flashpunk2.global
{
   public final class Ease
   {
      
      private static const PI:Number = Math.PI;
      
      private static const PI2:Number = Math.PI / 2;
      
      private static const B1:Number = 1 / 2.75;
      
      private static const B2:Number = 2 / 2.75;
      
      private static const B3:Number = 1.5 / 2.75;
      
      private static const B4:Number = 2.5 / 2.75;
      
      private static const B5:Number = 2.25 / 2.75;
      
      private static const B6:Number = 2.625 / 2.75;
      
      public function Ease()
      {
         super();
      }
      
      public static function quadIn(param1:Number) : Number
      {
         return param1 * param1;
      }
      
      public static function quadOut(param1:Number) : Number
      {
         return -param1 * (param1 - 2);
      }
      
      public static function quadInOut(param1:Number) : Number
      {
         return param1 <= 0.5 ? param1 * param1 * 2 : 1 - --param1 * param1 * 2;
      }
      
      public static function cubeIn(param1:Number) : Number
      {
         return param1 * param1 * param1;
      }
      
      public static function cubeOut(param1:Number) : Number
      {
         return 1 + --param1 * param1 * param1;
      }
      
      public static function cubeInOut(param1:Number) : Number
      {
         return param1 <= 0.5 ? param1 * param1 * param1 * 4 : 1 + --param1 * param1 * param1 * 4;
      }
      
      public static function quartIn(param1:Number) : Number
      {
         return param1 * param1 * param1 * param1;
      }
      
      public static function quartOut(param1:Number) : Number
      {
         return 1 - (param1 = param1 - 1) * param1 * param1 * param1;
      }
      
      public static function quartInOut(param1:Number) : Number
      {
         return param1 <= 0.5 ? param1 * param1 * param1 * param1 * 8 : (1 - (param1 = param1 * 2 - 2) * param1 * param1 * param1) / 2 + 0.5;
      }
      
      public static function quintIn(param1:Number) : Number
      {
         return param1 * param1 * param1 * param1 * param1;
      }
      
      public static function quintOut(param1:Number) : Number
      {
         param1 = param1 - 1;
         return param1 * param1 * param1 * param1 * param1 + 1;
      }
      
      public static function quintInOut(param1:Number) : Number
      {
         param1 = param1 - 2;
         param1 = param1 * 2;
         return param1 < 1 ? param1 * param1 * param1 * param1 * param1 / 2 : (param1 * param1 * param1 * param1 * param1 + 2) / 2;
      }
      
      public static function sineIn(param1:Number) : Number
      {
         return -Math.cos(PI2 * param1) + 1;
      }
      
      public static function sineOut(param1:Number) : Number
      {
         return Math.sin(PI2 * param1);
      }
      
      public static function sineInOut(param1:Number) : Number
      {
         return -Math.cos(PI * param1) / 2 + 0.5;
      }
      
      public static function bounceIn(param1:Number) : Number
      {
         param1 = 1 - param1;
         if(param1 < B1)
         {
            return 1 - 7.5625 * param1 * param1;
         }
         if(param1 < B2)
         {
            return 1 - (7.5625 * (param1 - B3) * (param1 - B3) + 0.75);
         }
         if(param1 < B4)
         {
            return 1 - (7.5625 * (param1 - B5) * (param1 - B5) + 0.9375);
         }
         return 1 - (7.5625 * (param1 - B6) * (param1 - B6) + 0.984375);
      }
      
      public static function bounceOut(param1:Number) : Number
      {
         if(param1 < B1)
         {
            return 7.5625 * param1 * param1;
         }
         if(param1 < B2)
         {
            return 7.5625 * (param1 - B3) * (param1 - B3) + 0.75;
         }
         if(param1 < B4)
         {
            return 7.5625 * (param1 - B5) * (param1 - B5) + 0.9375;
         }
         return 7.5625 * (param1 - B6) * (param1 - B6) + 0.984375;
      }
      
      public static function bounceInOut(param1:Number) : Number
      {
         if(param1 < 0.5)
         {
            param1 = 1 - param1 * 2;
            if(param1 < B1)
            {
               return (1 - 7.5625 * param1 * param1) / 2;
            }
            if(param1 < B2)
            {
               return (1 - (7.5625 * (param1 - B3) * (param1 - B3) + 0.75)) / 2;
            }
            if(param1 < B4)
            {
               return (1 - (7.5625 * (param1 - B5) * (param1 - B5) + 0.9375)) / 2;
            }
            return (1 - (7.5625 * (param1 - B6) * (param1 - B6) + 0.984375)) / 2;
         }
         param1 = param1 * 2 - 1;
         if(param1 < B1)
         {
            return 7.5625 * param1 * param1 / 2 + 0.5;
         }
         if(param1 < B2)
         {
            return (7.5625 * (param1 - B3) * (param1 - B3) + 0.75) / 2 + 0.5;
         }
         if(param1 < B4)
         {
            return (7.5625 * (param1 - B5) * (param1 - B5) + 0.9375) / 2 + 0.5;
         }
         return (7.5625 * (param1 - B6) * (param1 - B6) + 0.984375) / 2 + 0.5;
      }
      
      public static function circIn(param1:Number) : Number
      {
         return -(Math.sqrt(1 - param1 * param1) - 1);
      }
      
      public static function circOut(param1:Number) : Number
      {
         return Math.sqrt(1 - (param1 - 1) * (param1 - 1));
      }
      
      public static function circInOut(param1:Number) : Number
      {
         return param1 <= 0.5 ? (Math.sqrt(1 - param1 * param1 * 4) - 1) / -2 : (Math.sqrt(1 - (param1 * 2 - 2) * (param1 * 2 - 2)) + 1) / 2;
      }
      
      public static function expoIn(param1:Number) : Number
      {
         return Math.pow(2,10 * (param1 - 1));
      }
      
      public static function expoOut(param1:Number) : Number
      {
         return -Math.pow(2,-10 * param1) + 1;
      }
      
      public static function expoInOut(param1:Number) : Number
      {
         return param1 < 0.5 ? Math.pow(2,10 * (param1 * 2 - 1)) / 2 : (-Math.pow(2,-10 * (param1 * 2 - 1)) + 2) / 2;
      }
      
      public static function backIn(param1:Number) : Number
      {
         return param1 * param1 * (2.70158 * param1 - 1.70158);
      }
      
      public static function backOut(param1:Number) : Number
      {
         return 1 - --param1 * param1 * (-2.70158 * param1 - 1.70158);
      }
      
      public static function backInOut(param1:Number) : Number
      {
         param1 *= 2;
         if(param1 < 1)
         {
            return param1 * param1 * (2.70158 * param1 - 1.70158) / 2;
         }
         param1--;
         return (1 - --param1 * param1 * (-2.70158 * param1 - 1.70158)) / 2 + 0.5;
      }
      
      public static function elasticIn(param1:Number) : Number
      {
         return 1 - elasticOut(1 - param1);
      }
      
      public static function elasticOut(param1:Number) : Number
      {
         return Math.pow(2,-10 * param1) * Math.sin((param1 - 0.075) * (2 * Math.PI) / 0.3) + 1;
      }
      
      public static function elasticInOut(param1:Number) : Number
      {
         return param1 <= 0.5 ? elasticIn(param1 * 2) / 2 : elasticOut(param1 * 2 - 1) / 2 + 0.5;
      }
   }
}

