package flashpunk2.assets
{
   import flashpunk2.global.Asset;
   import flashpunk2.namespaces.fp_internal;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   
   use namespace fp_internal;
   
   public class AtlasAsset extends BaseAsset
   {
      
      private var _imageSource:*;
      
      private var _xmlSource:*;
      
      private var _textureAtlas:TextureAtlas;
      
      public function AtlasAsset(param1:*, param2:*)
      {
         super();
         this._imageSource = param1;
         this._xmlSource = param2;
      }
      
      override public function load() : void
      {
         var _loc3_:XML = null;
         super.load();
         var _loc1_:Texture = Asset.getTextureFromSource(this._imageSource);
         var _loc2_:XML = Asset.getXMLFromSource(this._xmlSource);
         this._textureAtlas = new TextureAtlas(_loc1_,_loc2_);
         for each(_loc3_ in _loc2_.SubTexture)
         {
            Asset.fp_internal::addSubTexture(_loc3_.@name,this._textureAtlas.getTexture(_loc3_.@name));
         }
         fp_internal::loadComplete();
      }
      
      override public function dispose() : void
      {
         var _loc2_:XML = null;
         super.dispose();
         var _loc1_:XML = Asset.getXMLFromSource(this._xmlSource);
         for each(_loc2_ in _loc1_.SubTexture)
         {
            Asset.fp_internal::removeSubTexture(_loc2_.@name);
         }
         this._textureAtlas.dispose();
         this._textureAtlas = null;
      }
      
      public function get textureAtlas() : TextureAtlas
      {
         return this._textureAtlas;
      }
   }
}

