package flashpunk2
{
   public class Signal
   {
      
      private static var _temp:Vector.<Function> = new Vector.<Function>();
      
      private var _listeners:Vector.<Function> = new Vector.<Function>();
      
      private var _containsNull:Boolean = false;
      
      public function Signal()
      {
         super();
      }
      
      public function add(param1:Function) : void
      {
         this._listeners.push(param1);
      }
      
      public function addListener(param1:Function) : void
      {
         this.add(param1);
      }
      
      public function addListeners(... rest) : void
      {
         var _loc2_:Function = null;
         for each(_loc2_ in rest)
         {
            this.add(_loc2_);
         }
      }
      
      public function addAtFront(param1:Function) : void
      {
         _temp.push(param1);
         var _loc2_:int = 0;
         while(_loc2_ < this._listeners.length)
         {
            _temp.push(this._listeners[_loc2_]);
            _loc2_++;
         }
         var _loc3_:Vector.<Function> = this._listeners;
         this._listeners = _temp;
         _temp = _loc3_;
         _temp.length = 0;
      }
      
      public function remove(param1:Function) : void
      {
         if(this._listeners.length > 0)
         {
            this._listeners[this._listeners.indexOf(param1)] = null;
            this._containsNull = true;
         }
         else
         {
            this._listeners.length = 0;
         }
      }
      
      public function clear() : void
      {
         this._listeners.length = 0;
      }
      
      public function dispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<Function> = null;
         if(this._listeners.length > 0)
         {
            if(this._containsNull)
            {
               this._containsNull = false;
               _loc1_ = 0;
               while(_loc1_ < this._listeners.length)
               {
                  if(this._listeners[_loc1_] != null)
                  {
                     _temp.push(this._listeners[_loc1_]);
                  }
                  _loc1_++;
               }
               _loc2_ = this._listeners;
               this._listeners = _temp;
               _temp = _loc2_;
               _temp.length = 0;
            }
            _loc1_ = 0;
            while(_loc1_ < this._listeners.length)
            {
               if(this._listeners[_loc1_] != null)
               {
                  this._listeners[_loc1_]();
               }
               _loc1_++;
            }
         }
      }
      
      public function get length() : int
      {
         return this._listeners.length;
      }
   }
}

