package flashpunk2.assets
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flashpunk2.global.Asset;
   import flashpunk2.global.Path;
   import flashpunk2.namespaces.fp_internal;
   import starling.textures.Texture;
   
   use namespace fp_internal;
   
   public class ImageAsset extends BaseAsset
   {
      
      private static var _drawMatrix:Matrix = new Matrix();
      
      private static var _loader:Loader = new Loader();
      
      private static var _request:URLRequest = new URLRequest();
      
      private var _source:*;
      
      private var _texture:Texture;
      
      private var _cachePath:String = null;
      
      private var _cacheType:Class = null;
      
      public function ImageAsset(param1:*)
      {
         super();
         this._source = param1;
      }
      
      public static function loadSource(param1:*) : ImageAsset
      {
         var _loc2_:ImageAsset = new ImageAsset(param1);
         _loc2_.load();
         return _loc2_;
      }
      
      override public function load() : void
      {
         super.load();
         if(this._source is EmbeddedPath)
         {
            this._cacheType = EmbeddedPath(this._source).type;
            this._cachePath = EmbeddedPath(this._source).path;
            Asset.fp_internal::addImage(this,this._cachePath,this._cacheType);
            this.loadFromObject(new this._cacheType());
         }
         else if(this._source is Class)
         {
            this._cacheType = Class(this._source);
            if(this._cachePath == null)
            {
               this._cachePath = Path.embeddedPath(this._cacheType);
            }
            Asset.fp_internal::addImage(this,this._cachePath,this._cacheType);
            this.loadFromObject(new this._cacheType());
         }
         else if(this._source is String)
         {
            this._cachePath = String(this._source);
            Asset.fp_internal::addImage(this,this._cachePath,this._cacheType);
            this.loadFromURL(this._cachePath);
         }
         else
         {
            Asset.fp_internal::addImage(this,this._cachePath,this._cacheType);
            this.loadFromObject(this._source);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._texture.dispose();
         this._texture = null;
         Asset.fp_internal::removeImage(this,this._cachePath,this._cacheType);
         this._cachePath = null;
         this._cacheType = null;
      }
      
      private function loadFromObject(param1:Object) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Rectangle = null;
         var _loc4_:BitmapData = null;
         if(param1 is BitmapData)
         {
            this._texture = Texture.fromBitmapData(BitmapData(param1));
         }
         else if(param1 is Bitmap)
         {
            this._texture = Texture.fromBitmap(Bitmap(param1));
         }
         else
         {
            if(!(param1 is DisplayObject))
            {
               throw new Error("Invalid source object.");
            }
            _loc2_ = DisplayObject(param1);
            _loc3_ = _loc2_.getBounds(_loc2_);
            _drawMatrix.tx = _loc3_.x;
            _drawMatrix.ty = _loc3_.y;
            _loc4_ = new BitmapData(_loc3_.width,_loc3_.height,true,0);
            _loc4_.draw(_loc2_,_drawMatrix);
            this._texture = Texture.fromBitmapData(_loc4_);
         }
         fp_internal::loadComplete();
      }
      
      private function loadFromURL(param1:String) : void
      {
         _request.url = param1;
         _loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onLoaderProgress);
         _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderComplete);
         _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError);
         _loader.load(_request);
      }
      
      private function onLoaderProgress(param1:ProgressEvent) : void
      {
         fp_internal::loadProgress(param1.bytesLoaded / param1.bytesTotal);
      }
      
      private function onLoaderComplete(param1:Event) : void
      {
         _loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onLoaderProgress);
         _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaderComplete);
         _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError);
         this._texture = Texture.fromBitmap(Bitmap(_loader.content));
         _loader.unload();
         fp_internal::loadComplete();
      }
      
      private function onLoaderError(param1:IOErrorEvent) : void
      {
         _request.url = this._cachePath;
         _loader.load(_request);
      }
      
      public function get texture() : Texture
      {
         if(!loaded)
         {
            throw new Error("Asset is not loaded.");
         }
         return this._texture;
      }
      
      public function get path() : String
      {
         return this._cachePath;
      }
      
      public function get type() : Class
      {
         return this._cacheType;
      }
   }
}

