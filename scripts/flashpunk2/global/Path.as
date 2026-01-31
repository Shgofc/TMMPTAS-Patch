package flashpunk2.global
{
   import flash.utils.describeType;
   
   public final class Path
   {
      
      public function Path()
      {
         super();
      }
      
      public static function fileName(param1:String) : String
      {
         return param1.substr(param1.lastIndexOf("/") + 1);
      }
      
      public static function fileNameWithoutExtension(param1:String) : String
      {
         var _loc2_:int = param1.lastIndexOf("/") + 1;
         var _loc3_:int = int(param1.lastIndexOf("."));
         if(_loc3_ <= 0)
         {
            _loc3_ = param1.length;
         }
         return param1.substring(_loc2_,_loc3_);
      }
      
      public static function extension(param1:String) : String
      {
         var _loc2_:int = int(param1.lastIndexOf("."));
         if(_loc2_ >= 0)
         {
            return param1.substr(_loc2_ + 1).toLowerCase();
         }
         return null;
      }
      
      public static function embeddedPath(param1:Class) : String
      {
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc2_:XML = describeType(param1);
         for each(_loc3_ in _loc2_.factory.metadata)
         {
            if(_loc3_.@name == "Embed")
            {
               for each(_loc4_ in _loc3_.arg)
               {
                  if(_loc4_.@key == "source")
                  {
                     return _loc4_.@value;
                  }
               }
            }
         }
         return null;
      }
      
      public static function isURL(param1:String) : Boolean
      {
         return param1.lastIndexOf(".") >= 0;
      }
   }
}

