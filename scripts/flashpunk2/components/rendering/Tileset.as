package flashpunk2.components.rendering
{
   import flash.geom.Rectangle;
   import flashpunk2.global.Asset;
   import flashpunk2.namespaces.fp_internal;
   import starling.textures.Texture;
   
   use namespace fp_internal;
   
   public class Tileset
   {
      
      private var _tileWidth:int;
      
      private var _tileHeight:int;
      
      private var _columns:int;
      
      private var _rows:int;
      
      private var _tiles:Vector.<Texture>;
      
      public function Tileset(param1:*, param2:uint, param3:uint)
      {
         super();
         this._tileWidth = param2;
         this._tileHeight = param3;
         var _loc4_:Texture = Asset.getTextureFromSource(param1);
         this._columns = _loc4_.width / this._tileWidth;
         this._rows = _loc4_.height / this._tileHeight;
         var _loc5_:Rectangle = new Rectangle(0,0,this._tileWidth,this._tileHeight);
         this._tiles = new Vector.<Texture>(this._columns * this._rows);
         var _loc6_:int = 0;
         while(_loc6_ < this._tiles.length)
         {
            this._tiles[_loc6_] = Texture.fromTexture(_loc4_,_loc5_);
            _loc5_.x += this._tileWidth;
            if(_loc5_.x >= this._columns * this._tileWidth)
            {
               _loc5_.x = 0;
               _loc5_.y += this._tileHeight;
            }
            _loc6_++;
         }
      }
      
      public function getTileIndex(param1:Texture) : int
      {
         return this._tiles.indexOf(param1);
      }
      
      public function getTileByIndex(param1:uint) : Texture
      {
         if(param1 >= this._tiles.length)
         {
            throw new Error("Tile index out of bounds: " + param1);
         }
         return this._tiles[param1];
      }
      
      public function getTileByPosition(param1:uint, param2:uint) : Texture
      {
         if(param1 >= this._columns)
         {
            throw new Error("Column out of bounds: " + param1);
         }
         if(param2 >= this._rows)
         {
            throw new Error("Row out of bounds: " + param2);
         }
         return this._tiles[this._columns * param2 + param1];
      }
      
      public function get tileCount() : int
      {
         return this._tiles.length;
      }
      
      public function get tileWidth() : int
      {
         return this._tileWidth;
      }
      
      public function get tileHeight() : int
      {
         return this._tileHeight;
      }
      
      public function get columns() : int
      {
         return this._columns;
      }
      
      public function get rows() : int
      {
         return this._rows;
      }
   }
}

