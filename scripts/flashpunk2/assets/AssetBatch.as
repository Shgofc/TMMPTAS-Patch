package flashpunk2.assets
{
   import flash.utils.describeType;
   import flashpunk2.global.Asset;
   import flashpunk2.global.Path;
   import flashpunk2.namespaces.fp_internal;
   
   use namespace fp_internal;
   
   public class AssetBatch extends BaseAsset
   {
      
      private var _assets:Vector.<BaseAsset> = new Vector.<BaseAsset>();
      
      private var _parsed:Vector.<BaseAsset> = new Vector.<BaseAsset>();
      
      private var _loadIndex:int;
      
      private var _autoAtlas:Boolean;
      
      public function AssetBatch(param1:Boolean)
      {
         super();
         this._autoAtlas = param1;
      }
      
      public static function createFromEmbedded(param1:Boolean, ... rest) : AssetBatch
      {
         var _loc4_:Object = null;
         var _loc3_:AssetBatch = new AssetBatch(param1);
         for each(_loc4_ in rest)
         {
            _loc3_.addAllEmbedded(_loc4_);
         }
         return _loc3_;
      }
      
      public static function loadFromEmbedded(param1:Boolean, ... rest) : AssetBatch
      {
         var _loc4_:Object = null;
         var _loc3_:AssetBatch = new AssetBatch(param1);
         for each(_loc4_ in rest)
         {
            _loc3_.addAllEmbedded(_loc4_);
         }
         _loc3_.load();
         return _loc3_;
      }
      
      public static function createFromPaths(param1:Boolean, ... rest) : AssetBatch
      {
         var _loc4_:* = undefined;
         var _loc3_:AssetBatch = new AssetBatch(param1);
         for each(_loc4_ in rest)
         {
            if(_loc4_ is String)
            {
               _loc3_.addExternal(_loc4_);
            }
            else
            {
               if(!(_loc4_ is Class))
               {
                  throw new Error("Invalid path: " + _loc4_);
               }
               _loc3_.addEmbedded(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public static function loadFromPaths(... rest) : AssetBatch
      {
         var _loc2_:AssetBatch = createFromPaths.apply(null,rest);
         _loc2_.load();
         return _loc2_;
      }
      
      public function add(param1:BaseAsset) : void
      {
         if(loaded)
         {
            throw new Error("Cannot add assets after the batch is loaded.");
         }
         this._assets.push(param1);
      }
      
      public function remove(param1:BaseAsset) : void
      {
         if(loaded)
         {
            throw new Error("Cannot remove assets after the atch is loaded.");
         }
         this._assets.splice(this._assets.indexOf(param1),1);
      }
      
      public function addExternal(param1:String) : void
      {
         this.parseAsset(null,param1);
      }
      
      public function addEmbedded(param1:Class) : void
      {
         this.parseAsset(param1,Path.embeddedPath(param1));
      }
      
      public function addAllEmbedded(param1:Object) : void
      {
         var _loc3_:XML = null;
         var _loc2_:XML = describeType(param1);
         for each(_loc3_ in _loc2_.constant)
         {
            this.addEmbeddedConstant(param1,_loc3_);
         }
      }
      
      private function loadAtlas(param1:XMLAsset) : void
      {
         var _loc2_:String = null;
         if(param1.xml.name() == "TextureAtlas")
         {
            _loc2_ = Path.fileNameWithoutExtension(param1.xml.@imagePath);
            if(!Asset.hasImageName(_loc2_))
            {
               throw new Error("Failed to auto atlas, required image was not loaded first: " + String(param1.xml.@imagePath));
            }
            this._assets.splice(this._loadIndex + 1,0,new AtlasAsset(_loc2_,param1.path));
         }
      }
      
      private function addEmbeddedConstant(param1:Object, param2:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         if(param2.@type == "Class")
         {
            for each(_loc3_ in param2.metadata)
            {
               if(_loc3_.@name == "Embed")
               {
                  for each(_loc4_ in _loc3_.arg)
                  {
                     if(_loc4_.@key == "source")
                     {
                        this.parseAsset(param1[param2.@name],_loc4_.@value);
                     }
                  }
               }
            }
         }
         else if(param2.@type == "String")
         {
            this.parseAsset(null,param1[param2.@name]);
         }
      }
      
      private function parseAsset(param1:Class, param2:String) : void
      {
         switch(Path.extension(param2))
         {
            case "png":
            case "jpg":
               if(param1 != null)
               {
                  this._parsed.push(new ImageAsset(new EmbeddedPath(param1,param2)));
                  break;
               }
               this._parsed.push(new ImageAsset(param2));
               break;
            case "xml":
            case "oel":
            case "fnt":
               if(param1 != null)
               {
                  this._parsed.push(new XMLAsset(new EmbeddedPath(param1,param2)));
                  break;
               }
               this._parsed.push(new XMLAsset(param2));
               break;
            case "zip":
               if(param1 != null)
               {
                  this._parsed.push(new ZipAsset(new EmbeddedPath(param1,param2)));
                  break;
               }
               this._parsed.push(new ZipAsset(param2));
               break;
            case "ttf":
         }
      }
      
      override public function load() : void
      {
         var _loc1_:BaseAsset = null;
         super.load();
         this._parsed.sort(this.compareAssets);
         for each(_loc1_ in this._parsed)
         {
            this._assets.push(_loc1_);
         }
         this._parsed.length = 0;
         this._loadIndex = -1;
         this.loadNext();
      }
      
      override public function dispose() : void
      {
         var _loc1_:BaseAsset = null;
         super.dispose();
         this._loadIndex = 0;
         for each(_loc1_ in this._assets)
         {
            _loc1_.dispose();
         }
      }
      
      private function compareAssets(param1:BaseAsset, param2:BaseAsset) : int
      {
         if(param1 is XMLAsset)
         {
            return 1;
         }
         if(param2 is XMLAsset)
         {
            return -1;
         }
         return 0;
      }
      
      private function loadNext() : void
      {
         if(this._loadIndex >= 0)
         {
            this._assets[this._loadIndex].ON_LOAD_PROGRESS.remove(this.onLoadProgress);
            this._assets[this._loadIndex].ON_LOAD_COMPLETE.remove(this.loadNext);
            if(this._autoAtlas && this._assets[this._loadIndex] is XMLAsset)
            {
               this.loadAtlas(XMLAsset(this._assets[this._loadIndex]));
            }
         }
         ++this._loadIndex;
         if(this._loadIndex < this._assets.length)
         {
            this._assets[this._loadIndex].ON_LOAD_PROGRESS.add(this.onLoadProgress);
            this._assets[this._loadIndex].ON_LOAD_COMPLETE.add(this.loadNext);
            this._assets[this._loadIndex].load();
         }
         else
         {
            fp_internal::loadComplete();
         }
      }
      
      private function onLoadProgress() : void
      {
         var _loc1_:Number = (Number(this._loadIndex) + this._assets[this._loadIndex].percentLoaded) / this._assets.length;
         fp_internal::loadProgress(_loc1_);
      }
   }
}

