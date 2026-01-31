package flashpunk2.assets
{
   internal class EmbeddedPath
   {
      
      private var _type:Class;
      
      private var _path:String;
      
      public function EmbeddedPath(param1:Class, param2:String)
      {
         super();
         this._type = param1;
         this._path = param2;
      }
      
      public function get type() : Class
      {
         return this._type;
      }
      
      public function get path() : String
      {
         return this._path;
      }
   }
}

