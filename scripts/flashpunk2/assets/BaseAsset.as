package flashpunk2.assets
{
   import flashpunk2.Signal;
   import flashpunk2.namespaces.fp_internal;
   
   use namespace fp_internal;
   
   public class BaseAsset
   {
      
      public const ON_LOAD_PROGRESS:Signal = new Signal();
      
      public const ON_LOAD_COMPLETE:Signal = new Signal();
      
      private var _loading:Boolean;
      
      private var _loaded:Boolean;
      
      private var _percentLoaded:Number = 0;
      
      public function BaseAsset()
      {
         super();
      }
      
      fp_internal function loadProgress(param1:Number) : void
      {
         this._percentLoaded = param1;
         this.ON_LOAD_PROGRESS.dispatch();
      }
      
      fp_internal function loadComplete() : void
      {
         if(this._loading)
         {
            this._loading = false;
            this._loaded = true;
            this._percentLoaded = 1;
            this.ON_LOAD_COMPLETE.dispatch();
         }
      }
      
      public function load() : void
      {
         if(this._loading)
         {
            throw new Error("Asset already loading.");
         }
         if(this._loaded)
         {
            throw new Error("Asset already loaded.");
         }
         this._loading = true;
      }
      
      public function dispose() : void
      {
         if(!this._loaded)
         {
            throw new Error("Asset not loaded.");
         }
         this._loaded = false;
      }
      
      public function get loading() : Boolean
      {
         return this._loading;
      }
      
      public function get loaded() : Boolean
      {
         return this._loaded;
      }
      
      public function get percentLoaded() : Number
      {
         return this._percentLoaded;
      }
   }
}

