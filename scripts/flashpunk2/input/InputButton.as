package flashpunk2.input
{
   import flashpunk2.global.Cache;
   import flashpunk2.global.Input;
   
   public class InputButton
   {
      
      private var _keys:Vector.<int> = new Vector.<int>();
      
      public function InputButton()
      {
         super();
      }
      
      public static function create(... rest) : InputButton
      {
         var _loc2_:InputButton = new InputButton();
         return _loc2_.addKeys.apply(null,rest);
      }
      
      public function addKey(param1:int) : void
      {
         if(this._keys.indexOf(param1) >= 0)
         {
            throw new Error("Duplicate key code: " + param1);
         }
         this._keys.push(param1);
      }
      
      public function addKeys(... rest) : InputButton
      {
         var _loc2_:int = 0;
         while(_loc2_ < rest.length)
         {
            if(typeof rest[_loc2_] != "number")
            {
               throw new Error("Invalid key code: " + rest[_loc2_]);
            }
            this.addKey(int(rest[_loc2_]));
            _loc2_++;
         }
         return this;
      }
      
      public function setKeys(... rest) : InputButton
      {
         this._keys.length = 0;
         var _loc2_:int = 0;
         while(_loc2_ < rest.length)
         {
            if(typeof rest[_loc2_] != "number")
            {
               throw new Error("Invalid key code: " + rest[_loc2_]);
            }
            this.addKey(int(rest[_loc2_]));
            _loc2_++;
         }
         return this;
      }
      
      public function clearKeys() : void
      {
         this._keys.length = 0;
      }
      
      public function get down() : Boolean
      {
         var _loc1_:int = 0;
         for each(_loc1_ in this._keys)
         {
            if(Input.keyDown(_loc1_))
            {
               return true;
            }
         }
         return false;
      }
      
      public function get pressed() : Boolean
      {
         var _loc1_:int = 0;
         for each(_loc1_ in this._keys)
         {
            if(Input.keyPressed(_loc1_))
            {
               return true;
            }
         }
         return false;
      }
      
      public function get released() : Boolean
      {
         var _loc1_:int = 0;
         for each(_loc1_ in this._keys)
         {
            if(Input.keyReleased(_loc1_))
            {
               return true;
            }
         }
         return false;
      }
      
      public function get up() : Boolean
      {
         return !this.up;
      }
      
      public function get allDown() : Boolean
      {
         var _loc1_:int = 0;
         for each(_loc1_ in this._keys)
         {
            if(!Input.keyDown(_loc1_))
            {
               return false;
            }
         }
         return true;
      }
      
      public function get allPressed() : Boolean
      {
         var _loc1_:int = 0;
         for each(_loc1_ in this._keys)
         {
            if(!Input.keyPressed(_loc1_))
            {
               return false;
            }
         }
         return true;
      }
      
      public function get allReleased() : Boolean
      {
         var _loc1_:int = 0;
         for each(_loc1_ in this._keys)
         {
            if(!Input.keyReleased(_loc1_))
            {
               return false;
            }
         }
         return true;
      }
      
      public function getKeys(param1:* = null) : *
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            param1 = Cache.pop(Array);
         }
         for each(_loc2_ in this._keys)
         {
            param1.push(_loc2_);
         }
         return param1;
      }
      
      public function keyCount() : int
      {
         return this._keys.length;
      }
   }
}

