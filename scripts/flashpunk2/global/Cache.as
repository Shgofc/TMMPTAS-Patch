package flashpunk2.global
{
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public final class Cache
   {
      
      private static var _marked:Dictionary = new Dictionary();
      
      private static var _lookup:Dictionary = new Dictionary();
      
      public function Cache()
      {
         super();
      }
      
      private static function getList(param1:Class) : Vector.<Object>
      {
         if(param1 in _lookup)
         {
            return _lookup[param1];
         }
         return _lookup[param1] = new Vector.<Object>();
      }
      
      public static function push(param1:*) : void
      {
         var _loc2_:Class = Class(getDefinitionByName(getQualifiedClassName(param1)));
         getList(_loc2_).push(param1);
         _marked[param1] = true;
         if(param1 is Array)
         {
            param1.length = 0;
         }
      }
      
      public static function pop(param1:Class) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:Vector.<Object> = getList(param1);
         if(_loc2_.length > 0)
         {
            return _loc2_.pop();
         }
         _loc3_ = new param1();
         _marked[_loc3_] = true;
         return new param1();
      }
      
      public static function has(param1:Class) : Boolean
      {
         return param1 in _lookup;
      }
      
      public static function clear() : void
      {
         _marked = new Dictionary();
         _lookup = new Dictionary();
      }
      
      public static function clearType(param1:Class) : void
      {
         var _loc2_:Vector.<Object> = getList(param1);
         _loc2_.length = 0;
      }
      
      public static function marked(param1:*) : Boolean
      {
         return param1 in _marked;
      }
   }
}

