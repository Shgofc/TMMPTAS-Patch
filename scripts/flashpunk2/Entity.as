package flashpunk2
{
   import flashpunk2.components.physics.RigidBody;
   import flashpunk2.components.timing.Invoker;
   import flashpunk2.components.timing.Tween;
   import flashpunk2.global.Cache;
   import flashpunk2.global.Calc;
   import flashpunk2.namespaces.fp_internal;
   import starling.display.Sprite;
   
   use namespace fp_internal;
   
   public class Entity
   {
      
      private static var _componentsTemp:Vector.<Component> = new Vector.<Component>();
      
      public const ON_START:Signal = new Signal();
      
      public const ON_END:Signal = new Signal();
      
      public const ON_UPDATE:Signal = new Signal();
      
      public const ON_DEBUG:Signal = new Signal();
      
      private var _world:World;
      
      private var _sprite:Sprite = new Sprite();
      
      private var _active:Boolean = true;
      
      private var _components:Vector.<Component> = new Vector.<Component>();
      
      private var _cleanComponents:Boolean = false;
      
      private var _groups:uint = 0;
      
      private var _angle:Number = 0;
      
      private var _depth:int = 0;
      
      private var _name:String = null;
      
      private var _cached:Boolean;
      
      private var _rigidBody:RigidBody;
      
      public function Entity(param1:Number = 0, param2:Number = 0, param3:Function = null)
      {
         super();
         this._sprite.x = param1;
         this._sprite.y = param2;
         if(param3 != null)
         {
            this.ON_UPDATE.add(param3);
         }
      }
      
      fp_internal function start(param1:World) : void
      {
         this._world = param1;
         this._world.sprite.addChild(this._sprite);
         if(this._name != null)
         {
            this._world.fp_internal::addName(this._name,this);
         }
         var _loc2_:int = int(this._components.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._components[_loc3_] != null)
            {
               this._components[_loc3_].fp_internal::start(this);
            }
            _loc3_++;
         }
         if(this._rigidBody != null)
         {
            this._rigidBody.fp_internal::addToSpace();
         }
         this.ON_START.dispatch();
      }
      
      fp_internal function end() : void
      {
         this.ON_END.dispatch();
         if(this._rigidBody != null)
         {
            this._rigidBody.fp_internal::removeFromSpace();
         }
         var _loc1_:int = int(this._components.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(this._components[_loc2_] != null)
            {
               this._components[_loc2_].fp_internal::end();
            }
            _loc2_++;
         }
         if(this._name != null)
         {
            this._world.fp_internal::removeName(this._name);
         }
         this._world.sprite.removeChild(this._sprite);
         this._world = null;
      }
      
      fp_internal function update() : void
      {
         this.ON_UPDATE.dispatch();
         if(this._cleanComponents)
         {
            this._cleanComponents = false;
            this.cleanComponents();
         }
      }
      
      fp_internal function setCached() : void
      {
         this._cached = true;
      }
      
      fp_internal function setPositionAngle(param1:Number, param2:Number, param3:Number) : void
      {
         this._sprite.x = param1;
         this._sprite.y = param2;
         this._angle = param3;
         this._sprite.rotation = param3 * Calc.RAD;
      }
      
      private function cleanComponents() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._components.length)
         {
            if(this._components[_loc1_] != null)
            {
               _componentsTemp.push(this._components[_loc1_]);
            }
            _loc1_++;
         }
         var _loc2_:Vector.<Component> = this._components;
         this._components = _componentsTemp;
         _componentsTemp = _loc2_;
         _componentsTemp.length = 0;
      }
      
      public function setSignals(param1:Function, param2:Function = null, param3:Function = null) : void
      {
         if(param1 != null)
         {
            this.ON_START.add(param1);
         }
         if(param2 != null)
         {
            this.ON_UPDATE.add(param2);
         }
         if(param3 != null)
         {
            this.ON_END.add(param3);
         }
      }
      
      public function add(param1:Component) : void
      {
         if(param1 is RigidBody)
         {
            if(this._rigidBody != null)
            {
               throw new Error("An Entity can only have one RigidBody.");
            }
            this._rigidBody = RigidBody(param1);
         }
         this._components.push(param1);
         if(this.exists)
         {
            param1.fp_internal::start(this);
         }
      }
      
      public function addComponent(param1:Component) : void
      {
         this.add(param1);
      }
      
      public function addComponents(... rest) : void
      {
         var _loc2_:Component = null;
         for each(_loc2_ in rest)
         {
            this.add(_loc2_);
         }
      }
      
      public function remove(param1:Component) : void
      {
         if(this._rigidBody == param1)
         {
            this._rigidBody = null;
         }
         if(this.exists)
         {
            param1.fp_internal::end();
         }
         this._components[this._components.indexOf(param1)] = null;
         this._cleanComponents = true;
      }
      
      public function removeComponent(param1:Component) : void
      {
         this.remove(param1);
      }
      
      public function removeComponents(... rest) : void
      {
         var _loc2_:Component = null;
         for each(_loc2_ in rest)
         {
            this.remove(_loc2_);
         }
      }
      
      public function pullComponentToFront(param1:Component) : void
      {
         if(this._components.indexOf(param1) < 0)
         {
            return;
         }
         this._components[this._components.indexOf(param1)] = null;
         this._components.push(param1);
      }
      
      public function getComponent(param1:Class) : *
      {
         var _loc2_:Component = null;
         for each(_loc2_ in this._components)
         {
            if(_loc2_ is param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getComponents(param1:Class, param2:* = null) : *
      {
         var _loc3_:Component = null;
         if(param2 == null)
         {
            param2 = new Vector.<Component>();
         }
         for each(_loc3_ in this._components)
         {
            if(_loc3_ is param1)
            {
               param2.push(_loc3_);
            }
         }
         return param2;
      }
      
      public function inGroups(param1:uint, param2:Boolean = true) : Boolean
      {
         return param2 ? (this._groups & param1) > 0 : (this._groups & param1) == param1;
      }
      
      public function removeSelf() : void
      {
         if(this.exists)
         {
            this.world.remove(this);
         }
      }
      
      public function setPosition(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function setScale(param1:Number, param2:Number) : void
      {
         this.scaleX = param1;
         this.scaleY = param2;
      }
      
      public function lookAt(param1:Number, param2:Number) : void
      {
         this.angle = Calc.atan2(param2 - this.y,param1 - this.x);
      }
      
      public function tween(param1:Object, param2:Number, param3:Object = null, param4:Boolean = true) : Tween
      {
         if(param4)
         {
            this.cancelTween(param1);
         }
         var _loc5_:Tween = Cache.pop(Tween);
         _loc5_.init(param1,param2,param3);
         this.add(_loc5_);
         return _loc5_;
      }
      
      public function cancelTween(param1:Object) : void
      {
         var _loc2_:Component = null;
         for each(_loc2_ in this._components)
         {
            if(_loc2_ is Tween && Tween(_loc2_).target == param1)
            {
               _loc2_.removeSelf();
            }
         }
      }
      
      public function cancelAllTweens() : void
      {
         var _loc1_:Component = null;
         for each(_loc1_ in this._components)
         {
            if(_loc1_ is Tween)
            {
               _loc1_.removeSelf();
            }
         }
      }
      
      private function getMethod(param1:*) : Function
      {
         var _loc2_:Function = null;
         if(param1 is String)
         {
            _loc2_ = this[param1];
         }
         else
         {
            if(!(param1 is Function))
            {
               throw new Error("Invoke method must be reference or a name of a public function. Parameter is invalid: " + param1);
            }
            _loc2_ = param1;
         }
         return _loc2_;
      }
      
      public function invoke(param1:*, param2:* = null, param3:Number = 0, param4:int = 0) : void
      {
         var _loc6_:Invoker = null;
         var _loc5_:Function = this.getMethod(param1);
         if(param3 <= 0)
         {
            while(param4 >= 0)
            {
               if(param2 != null)
               {
                  _loc5_(param2);
               }
               else
               {
                  _loc5_();
               }
               param4--;
            }
         }
         else
         {
            _loc6_ = Cache.pop(Invoker);
            _loc6_.init(this.getMethod(param1),param2,param3,param4);
            this.add(_loc6_);
         }
      }
      
      public function cancelInvoke(param1:*) : void
      {
         var _loc3_:Component = null;
         var _loc2_:Function = this.getMethod(param1);
         for each(_loc3_ in this._components)
         {
            if(_loc3_ is Invoker && Invoker(_loc3_).callback == _loc2_)
            {
               _loc3_.removeSelf();
            }
         }
      }
      
      public function cancelAllInvokes() : void
      {
         var _loc1_:Component = null;
         for each(_loc1_ in this._components)
         {
            if(_loc1_ is Invoker)
            {
               _loc1_.removeSelf();
            }
         }
      }
      
      public function distanceFrom(param1:Entity) : Number
      {
         return Calc.distance(this.x,this.y,param1.x,param1.y);
      }
      
      public function activate() : void
      {
         this.active = true;
      }
      
      public function deactivate() : void
      {
         this.active = false;
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      public function getFunction(param1:String) : Function
      {
         if(hasOwnProperty(param1))
         {
            return this[param1];
         }
         return null;
      }
      
      public function get exists() : Boolean
      {
         return this._world != null && this._world.exists;
      }
      
      public function get world() : World
      {
         return this._world;
      }
      
      public function get physics() : Physics
      {
         return this._world != null ? this._world.physics : null;
      }
      
      public function get camera() : Camera
      {
         return this._world != null ? this._world.camera : null;
      }
      
      public function get engine() : Engine
      {
         return Engine.instance;
      }
      
      public function get sprite() : Sprite
      {
         return this._sprite;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
      }
      
      public function get visible() : Boolean
      {
         return this._sprite.visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._sprite.visible = param1;
      }
      
      public function get depth() : int
      {
         return this._depth;
      }
      
      public function set depth(param1:int) : void
      {
         if(this._depth != param1)
         {
            this._depth = param1;
            if(this._world != null)
            {
               this._world.fp_internal::requestSortEntities();
            }
         }
      }
      
      public function get groups() : uint
      {
         return this._groups;
      }
      
      public function set groups(param1:uint) : void
      {
         if(this._groups != param1)
         {
            this._groups = param1;
         }
      }
      
      public function get x() : Number
      {
         return this._sprite.x;
      }
      
      public function set x(param1:Number) : void
      {
         this._sprite.x = param1;
         if(this._rigidBody != null)
         {
            this._rigidBody.x = param1;
         }
      }
      
      public function get y() : Number
      {
         return this._sprite.y;
      }
      
      public function set y(param1:Number) : void
      {
         this._sprite.y = param1;
         if(this._rigidBody != null)
         {
            this._rigidBody.y = param1;
         }
      }
      
      public function get scaleX() : Number
      {
         return this._sprite.scaleX;
      }
      
      public function set scaleX(param1:Number) : void
      {
         this._sprite.scaleX = param1;
      }
      
      public function get scaleY() : Number
      {
         return this._sprite.scaleY;
      }
      
      public function set scaleY(param1:Number) : void
      {
         this._sprite.scaleY = param1;
      }
      
      public function get angle() : Number
      {
         return this._angle;
      }
      
      public function set angle(param1:Number) : void
      {
         if(this._angle != param1)
         {
            this._angle = param1;
            this._sprite.rotation = param1 * Calc.RAD;
            if(this._rigidBody != null)
            {
               this._rigidBody.angle = this._sprite.rotation;
            }
         }
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         if(this._name != param1)
         {
            if(param1 == "")
            {
               throw new Error("Name cannot be empty string.");
            }
            if(this.exists)
            {
               if(this._name != null)
               {
                  this.world.fp_internal::removeName(this._name);
               }
               if(param1 != null)
               {
                  this.world.fp_internal::addName(param1,this);
               }
            }
            this._name = param1;
         }
      }
      
      public function get width() : Number
      {
         return this._sprite.width;
      }
      
      public function get height() : Number
      {
         return this._sprite.height;
      }
      
      public function get cached() : Boolean
      {
         return this._cached;
      }
      
      public function get rigidBody() : RigidBody
      {
         return this._rigidBody;
      }
   }
}

