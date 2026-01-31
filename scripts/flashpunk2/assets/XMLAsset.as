package flashpunk2.assets
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flashpunk2.global.Asset;
   import flashpunk2.global.Path;
   import flashpunk2.namespaces.fp_internal;
   
   use namespace fp_internal;
   
   public class XMLAsset extends BaseAsset
   {
      
      private static var _loader:URLLoader = new URLLoader();
      
      private static var _request:URLRequest = new URLRequest();
      
      private var _source:*;
      
      private var _xml:XML;
      
      private var _cacheType:Class = null;
      
      private var _cachePath:String = null;
      
      public function XMLAsset(param1:*)
      {
         super();
         this._source = param1;
      }
      
      public static function loadSource(param1:*) : XMLAsset
      {
         var _loc2_:XMLAsset = new XMLAsset(param1);
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
            Asset.fp_internal::addXML(this,this._cachePath,this._cacheType);
            this.loadXML(XML(new this._cacheType()));
         }
         else if(this._source is Class)
         {
            this._cacheType = Class(this._source);
            if(this._cachePath == null)
            {
               this._cachePath = Path.embeddedPath(this._cacheType);
            }
            Asset.fp_internal::addXML(this,this._cachePath,this._cacheType);
            this.loadXML(XML(new this._cacheType()));
         }
         else if(this._source is String)
         {
            this._cachePath = String(this._source);
            Asset.fp_internal::addXML(this,this._cachePath,this._cacheType);
            this.loadFromURL(this._cachePath);
         }
         else
         {
            if(!(this._source is XML))
            {
               throw new Error("Invalid XML source.");
            }
            Asset.fp_internal::addXML(this,this._cachePath,this._cacheType);
            this.loadXML(XML(this._source));
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._xml = null;
         Asset.fp_internal::removeXML(this,this._cachePath,this._cacheType);
         this._cachePath = null;
         this._cacheType = null;
      }
      
      private function loadXML(param1:XML) : void
      {
         this._xml = param1;
         fp_internal::loadComplete();
      }
      
      private function loadFromURL(param1:String) : void
      {
         _request.url = param1;
         _loader.addEventListener(ProgressEvent.PROGRESS,this.onLoaderProgress);
         _loader.addEventListener(Event.COMPLETE,this.onLoaderComplete);
         _loader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError);
         _loader.load(_request);
      }
      
      private function onLoaderProgress(param1:ProgressEvent) : void
      {
         fp_internal::loadProgress(param1.bytesLoaded / param1.bytesTotal);
      }
      
      private function onLoaderComplete(param1:Event) : void
      {
         _loader.removeEventListener(ProgressEvent.PROGRESS,this.onLoaderProgress);
         _loader.removeEventListener(Event.COMPLETE,this.onLoaderComplete);
         _loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoaderError);
         this._xml = new XML(_loader.data);
         fp_internal::loadComplete();
      }
      
      private function onLoaderError(param1:IOErrorEvent) : void
      {
         _request.url = this._cachePath;
         _loader.load(_request);
      }
      
      public function get xml() : XML
      {
         return this._xml;
      }
      
      public function get path() : String
      {
         return this._cachePath;
      }
   }
}

