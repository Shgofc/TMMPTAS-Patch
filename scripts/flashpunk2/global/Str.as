package flashpunk2.global
{
   public final class Str
   {
      
      public function Str()
      {
         super();
      }
      
      public static function contains(param1:String, param2:String) : Boolean
      {
         return param1.indexOf(param2) >= 0;
      }
      
      public static function containsAny(param1:String, ... rest) : Boolean
      {
         var _loc3_:String = null;
         for each(_loc3_ in rest)
         {
            if(param1.indexOf(_loc3_) >= 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function pad(param1:String, param2:String, param3:int) : String
      {
         while(param1.length < param3)
         {
            param1 = param2 + param1;
         }
         return param1;
      }
      
      public static function repeat(param1:String, param2:int, param3:String = null) : String
      {
         var _loc4_:String = "";
         if(param3 != null)
         {
            while(param2--)
            {
               _loc4_ += param1 + param3;
            }
            return _loc4_.substr(0,_loc4_.length - param3.length);
         }
         while(param2--)
         {
            _loc4_ += param1;
         }
         return _loc4_;
      }
      
      public static function replace(param1:String, param2:String, param3:String) : String
      {
         return param1.split(param2).join(param3);
      }
      
      public static function replaceChars(param1:String, param2:String, param3:String) : String
      {
         var _loc4_:String = "";
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            if(param1.charAt(_loc5_) == param2)
            {
               _loc4_ += param3;
            }
            else
            {
               _loc4_ += param1.charAt(_loc5_);
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function restrict(param1:String, param2:String) : String
      {
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(param2.indexOf(param1.charAt(_loc4_)) >= 0)
            {
               _loc3_ += param1.charAt(_loc4_);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function alpha(param1:String) : String
      {
         return restrict(param1,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz");
      }
      
      public static function numeric(param1:String) : String
      {
         return restrict(param1,"1234567890");
      }
      
      public static function alphaNumeric(param1:String) : String
      {
         return restrict(param1,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890");
      }
      
      public static function trim(param1:String) : String
      {
         var _loc2_:RegExp = /[\s]+/g;
         return param1.replace(_loc2_,"");
      }
      
      public static function trimEnds(param1:String) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1.charCodeAt(_loc3_) >= 32)
            {
               _loc2_ += param1.charAt(_loc3_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function abbreviate(param1:String, param2:int) : String
      {
         if(param2 < 3)
         {
            throw new Error("Max length must be longer than 3 to abbreviate.");
         }
         if(param1.length > param2)
         {
            return param1.substr(0,param2 - 3) + "...";
         }
         return param1;
      }
   }
}

