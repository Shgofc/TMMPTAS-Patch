package flashpunk2
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flashpunk2.console.Console;
   import flashpunk2.global.Input;
   import flashpunk2.global.Rand;
   import flashpunk2.global.Time;
   import flashpunk2.namespaces.fp_internal;
   import starling.core.Starling;
   import starling.display.Sprite;
   import starling.events.EnterFrameEvent;
   import starling.events.Event;
   
   use namespace fp_internal;
   
   public class Engine
   {
      
      private static var _instance:Engine;
      
      public const ON_START:Signal = new Signal();
      
      public const ON_END:Signal = new Signal();
      
      public const ON_PRE_UPDATE:Signal = new Signal();
      
      public const ON_UPDATE:Signal = new Signal();
      
      public const ON_POST_UPDATE:Signal = new Signal();
      
      public const ON_DEBUG:Signal = new Signal();
      
      public const ON_ACTIVATE:Signal = new Signal();
      
      public const ON_DEACTIVATE:Signal = new Signal();
      
      private var _started:Boolean = false;
      
      private var _main:flash.display.Sprite;
      
      private var _starling:Starling;
      
      private var _root:starling.display.Sprite;
      
      private var _currentWorld:World;
      
      private var _targetWorld:World;
      
      private var _smoothing:Boolean;
      
      private var _console:Console;
      
      private var _paused:Boolean = false;
      
      private var _focused:Boolean = true;
      
      private var _fixedUpdateInterval:Boolean;
      
      private var _lastFrame:Number;
      
      public function Engine(param1:flash.display.Sprite, param2:Boolean = true, param3:Boolean = false)
      {
         super();
         _instance = this;
         this._main = param1;
         this._smoothing = param2;
         this._fixedUpdateInterval = param3;
      }
      
      public static function get instance() : Engine
      {
         return _instance;
      }
      
      public function start() : void
      {
         if(!this._started)
         {
            this._started = true;
            if(this._main.stage != null)
            {
               this.onAddedToStage(null);
            }
            else
            {
               this._main.addEventListener(flash.events.Event.ADDED_TO_STAGE,this.onAddedToStage);
            }
         }
      }
      
      private function onAddedToStage(param1:flash.events.Event) : void
      {
         this._main.removeEventListener(flash.events.Event.ADDED_TO_STAGE,this.onAddedToStage);
         this._main.addEventListener(flash.events.Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this._main.stage.addEventListener(flash.events.Event.ACTIVATE,this.onActivate);
         this._main.stage.addEventListener(flash.events.Event.DEACTIVATE,this.onDeactivate);
         this._starling = new Starling(starling.display.Sprite,this._main.stage);
         this._starling.addEventListener(starling.events.Event.ROOT_CREATED,this.onRootCreated);
         this._starling.start();
      }
      
      private function onRemovedFromStage(param1:flash.events.Event) : void
      {
         this.ON_END.dispatch();
         Input.fp_internal::end();
         this._main.stage.removeEventListener(flash.events.Event.ACTIVATE,this.onActivate);
         this._main.stage.removeEventListener(flash.events.Event.DEACTIVATE,this.onDeactivate);
         this._main.removeEventListener(flash.events.Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this._starling.removeEventListener(starling.events.Event.ROOT_CREATED,this.onRootCreated);
         this._starling.stop();
         this._starling.dispose();
         this._starling = null;
      }
      
      private function onRootCreated(param1:starling.events.Event) : void
      {
         this._starling.removeEventListener(starling.events.Event.ROOT_CREATED,this.onRootCreated);
         this._root = Sprite(this._starling.root);
         this._root.addEventListener(EnterFrameEvent.ENTER_FRAME,this.onEnterFrame);
         this._lastFrame = 0;
         Rand.fp_internal::start();
         Time.fp_internal::start();
         Input.fp_internal::start();
         this.ON_START.dispatch();
      }
      
      private function onEnterFrame(param1:EnterFrameEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this._focused)
         {
            _loc2_ = this._lastFrame + param1.passedTime;
            _loc3_ = 1000 / this.frameRate;
            do
            {
               _loc4_ = this._fixedUpdateInterval ? this._lastFrame + _loc3_ : _loc2_;
               Time.fp_internal::update(_loc4_);
               if(!this._paused)
               {
                  this.ON_PRE_UPDATE.dispatch();
                  if(this._currentWorld != null && this._currentWorld.active)
                  {
                     this._currentWorld.fp_internal::update();
                  }
                  this.ON_UPDATE.dispatch();
                  this.ON_POST_UPDATE.dispatch();
               }
               Input.fp_internal::update();
               if(this._currentWorld != this._targetWorld)
               {
                  if(this._currentWorld != null)
                  {
                     this._currentWorld.fp_internal::end();
                  }
                  this._currentWorld = this._targetWorld;
                  if(this._currentWorld != null)
                  {
                     this._currentWorld.fp_internal::start(this);
                  }
                  this._main.stage.focus = this._main.stage;
               }
               this._lastFrame = _loc4_;
            }
            while(_loc2_ - _loc3_ > this._lastFrame);
            
         }
      }
      
      private function onActivate(param1:flash.events.Event) : void
      {
         if(!this._fixedUpdateInterval)
         {
            Time.fp_internal::resume();
         }
         this._focused = true;
         this.ON_ACTIVATE.dispatch();
      }
      
      private function onDeactivate(param1:flash.events.Event) : void
      {
         this.ON_DEACTIVATE.dispatch();
         this._focused = false;
      }
      
      fp_internal function get paused() : Boolean
      {
         return this._paused;
      }
      
      fp_internal function set paused(param1:Boolean) : void
      {
         this._paused = param1;
      }
      
      public function setWorld(param1:World) : void
      {
         this._targetWorld = param1;
      }
      
      public function get main() : flash.display.Sprite
      {
         return this._main;
      }
      
      public function get starling() : Starling
      {
         return this._starling;
      }
      
      public function get root() : starling.display.Sprite
      {
         return this._root;
      }
      
      public function get currentWorld() : World
      {
         return this._currentWorld;
      }
      
      public function get width() : int
      {
         return this._starling.stage.stageWidth;
      }
      
      public function get height() : int
      {
         return this._starling.stage.stageHeight;
      }
      
      public function get backgroundColor() : uint
      {
         return this._starling.stage.color;
      }
      
      public function set backgroundColor(param1:uint) : void
      {
         this._starling.stage.color = param1;
      }
      
      public function get frameRate() : Number
      {
         return this._main.stage.frameRate;
      }
      
      public function set frameRate(param1:Number) : void
      {
         this._main.stage.frameRate = param1;
      }
      
      public function get smoothing() : Boolean
      {
         return this._smoothing;
      }
   }
}

