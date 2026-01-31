package flashpunk2.components.physics
{
   import flashpunk2.Component;
   import flashpunk2.Entity;
   import flashpunk2.global.Cache;
   import flashpunk2.namespaces.fp_internal;
   import nape.dynamics.Arbiter;
   import nape.dynamics.ArbiterList;
   import nape.phys.Body;
   import nape.phys.Material;
   import nape.shape.Shape;
   
   use namespace fp_internal;
   
   public class Collider extends Component
   {
      
      private var _shape:Shape;
      
      public function Collider(param1:Shape, param2:Boolean)
      {
         super();
         this._shape = param1;
         this._shape.sensorEnabled = !param2;
         this._shape.userData.tag = null;
      }
      
      override fp_internal function start(param1:Entity) : void
      {
         super.fp_internal::start(param1);
         if(param1.rigidBody != null)
         {
            this._shape.filter.collisionGroup = param1.groups;
            this._shape.userData.entity = param1;
            this._shape.body = rigidBody.body;
         }
      }
      
      override fp_internal function end() : void
      {
         this._shape.filter.collisionGroup = 1;
         this._shape.userData.entity = null;
         this._shape.body = null;
         super.fp_internal::end();
      }
      
      public function colliding() : *
      {
         var _loc1_:Arbiter = null;
         if(this._shape.body.arbiters.length > 0)
         {
            _loc1_ = this._shape.body.arbiters.at(0);
            return this._shape == _loc1_.shape1 ? _loc1_.body2.userData.entity : _loc1_.body1.userData.entity;
         }
         return null;
      }
      
      public function collidingWithEntity(param1:Entity) : Boolean
      {
         var _loc3_:Arbiter = null;
         var _loc4_:Body = null;
         var _loc2_:ArbiterList = this._shape.body.arbiters;
         var _loc5_:int = 0;
         while(true)
         {
            if(_loc5_ >= _loc2_.length)
            {
               return false;
            }
            _loc3_ = _loc2_.at(_loc5_);
            if(this._shape == _loc3_.shape1)
            {
               _loc4_ = _loc3_.body2;
            }
            else
            {
               if(this._shape != _loc3_.shape2)
               {
                  continue;
               }
               _loc4_ = _loc3_.body1;
            }
            if(_loc4_.userData.entity == param1)
            {
               break;
            }
            _loc5_++;
         }
         return true;
      }
      
      public function collidingWithTag(param1:String) : *
      {
         var _loc3_:Arbiter = null;
         var _loc4_:Shape = null;
         var _loc2_:ArbiterList = this._shape.body.arbiters;
         var _loc5_:int = 0;
         while(true)
         {
            if(_loc5_ >= _loc2_.length)
            {
               return null;
            }
            _loc3_ = _loc2_.at(_loc5_);
            if(this._shape == _loc3_.shape1)
            {
               _loc4_ = _loc3_.shape2;
            }
            else
            {
               if(this._shape != _loc3_.shape2)
               {
                  continue;
               }
               _loc4_ = _loc3_.shape1;
            }
            if(_loc4_.userData.tag == param1)
            {
               break;
            }
            _loc5_++;
         }
         return _loc4_.body.userData.entity;
      }
      
      public function collidingWithGroup(param1:uint) : *
      {
         var _loc3_:Arbiter = null;
         var _loc4_:Body = null;
         var _loc2_:ArbiterList = this._shape.body.arbiters;
         var _loc5_:int = 0;
         while(true)
         {
            if(_loc5_ >= _loc2_.length)
            {
               return null;
            }
            _loc3_ = _loc2_.at(_loc5_);
            if(this._shape == _loc3_.shape1)
            {
               _loc4_ = _loc3_.body2;
            }
            else
            {
               if(this._shape != _loc3_.shape2)
               {
                  continue;
               }
               _loc4_ = _loc3_.body1;
            }
            if(_loc4_.userData.entity.inGroups(param1))
            {
               break;
            }
            _loc5_++;
         }
         return _loc4_.userData.entity;
      }
      
      public function collidingWithGroups(param1:uint, param2:Boolean = true) : *
      {
         var _loc4_:Arbiter = null;
         var _loc5_:Body = null;
         var _loc3_:ArbiterList = this._shape.body.arbiters;
         var _loc6_:int = 0;
         while(true)
         {
            if(_loc6_ >= _loc3_.length)
            {
               return null;
            }
            _loc4_ = _loc3_.at(_loc6_);
            if(this._shape == _loc4_.shape1)
            {
               _loc5_ = _loc4_.body2;
            }
            else
            {
               if(this._shape != _loc4_.shape2)
               {
                  continue;
               }
               _loc5_ = _loc4_.body1;
            }
            if(_loc5_.userData.entity.inGroups(param1,param2))
            {
               break;
            }
            _loc6_++;
         }
         return _loc5_.userData.entity;
      }
      
      public function collidingWithType(param1:Class) : *
      {
         var _loc3_:Arbiter = null;
         var _loc4_:Shape = null;
         var _loc2_:ArbiterList = this._shape.body.arbiters;
         var _loc5_:int = 0;
         while(true)
         {
            if(_loc5_ >= _loc2_.length)
            {
               return null;
            }
            _loc3_ = _loc2_.at(_loc5_);
            if(this._shape == _loc3_.shape1)
            {
               _loc4_ = _loc3_.shape2;
            }
            else
            {
               if(this._shape != _loc3_.shape2)
               {
                  continue;
               }
               _loc4_ = _loc3_.shape1;
            }
            if(_loc4_.body.userData.entity is param1)
            {
               break;
            }
            _loc5_++;
         }
         return _loc4_.body.userData.entity;
      }
      
      public function getCollisions(param1:* = null) : *
      {
         var _loc3_:Arbiter = null;
         var _loc4_:Entity = null;
         if(param1 == null)
         {
            param1 = Cache.pop(Array);
         }
         var _loc2_:ArbiterList = this._shape.body.arbiters;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc3_ = _loc2_.at(_loc5_);
            _loc4_ = this._shape == _loc3_.shape1 ? _loc3_.body2.userData.entity : _loc3_.body1.userData.entity;
            if(param1.indexOf(_loc4_) < 0)
            {
               param1.push(_loc4_);
            }
            _loc5_++;
         }
         return param1;
      }
      
      public function getCollisionsByTag(param1:String, param2:* = null) : *
      {
         var _loc4_:Arbiter = null;
         var _loc5_:Shape = null;
         var _loc6_:Entity = null;
         if(param2 == null)
         {
            param2 = Cache.pop(Array);
         }
         var _loc3_:ArbiterList = this._shape.body.arbiters;
         var _loc7_:int = 0;
         for(; _loc7_ < _loc3_.length; _loc7_++)
         {
            _loc4_ = _loc3_.at(_loc7_);
            if(this._shape == _loc4_.shape1)
            {
               _loc5_ = _loc4_.shape2;
            }
            else
            {
               if(this._shape != _loc4_.shape2)
               {
                  continue;
               }
               _loc5_ = _loc4_.shape1;
            }
            if(_loc5_.userData.tag == param1 || _loc5_.body.userData.tag == param1)
            {
               _loc6_ = _loc5_.body.userData.entity;
               if(param2.indexOf(_loc6_) < 0)
               {
                  param2.push(_loc6_);
               }
            }
         }
         return param2;
      }
      
      public function getCollisionsByType(param1:Class, param2:* = null) : *
      {
         var _loc4_:Arbiter = null;
         var _loc5_:Shape = null;
         var _loc6_:Entity = null;
         if(param2 == null)
         {
            param2 = Cache.pop(Array);
         }
         var _loc3_:ArbiterList = this._shape.body.arbiters;
         var _loc7_:int = 0;
         for(; _loc7_ < _loc3_.length; _loc7_++)
         {
            _loc4_ = _loc3_.at(_loc7_);
            if(this._shape == _loc4_.shape1)
            {
               _loc5_ = _loc4_.shape2;
            }
            else
            {
               if(this._shape != _loc4_.shape2)
               {
                  continue;
               }
               _loc5_ = _loc4_.shape1;
            }
            _loc6_ = _loc5_.body.userData.entity;
            if(_loc6_ is param1 && param2.indexOf(_loc6_) < 0)
            {
               param2.push(_loc6_);
            }
         }
         return param2;
      }
      
      public function invokeOnColliding(param1:String, param2:* = null, param3:Number = 0, param4:int = 0) : void
      {
         var _loc5_:Vector.<Entity> = this.getCollisions();
         while(_loc5_.length > 0)
         {
            _loc5_.pop().invoke(param1,param2,param3,param4);
         }
         Cache.push(_loc5_);
      }
      
      public function invokeOnCollidingTag(param1:String, param2:String, param3:* = null, param4:Number = 0, param5:int = 0) : void
      {
         var _loc6_:Vector.<Entity> = this.getCollisionsByTag(param1);
         while(_loc6_.length > 0)
         {
            _loc6_.pop().invoke(param2,param3,param4,param5);
         }
         Cache.push(_loc6_);
      }
      
      public function invokeOnCollidingType(param1:Class, param2:String, param3:* = null, param4:Number = 0, param5:int = 0) : void
      {
         var _loc6_:Vector.<Entity> = this.getCollisionsByType(param1);
         while(_loc6_.length > 0)
         {
            _loc6_.pop().invoke(param2,param3,param4,param5);
         }
         Cache.push(_loc6_);
      }
      
      public function get shape() : Shape
      {
         return this._shape;
      }
      
      public function get solid() : Boolean
      {
         return !this._shape.sensorEnabled;
      }
      
      public function set solid(param1:Boolean) : void
      {
         this._shape.sensorEnabled = !param1;
      }
      
      public function get tag() : String
      {
         return this._shape.userData.tag;
      }
      
      public function set tag(param1:String) : void
      {
         this._shape.userData.tag = param1;
      }
      
      public function get material() : Material
      {
         return this._shape.material;
      }
      
      public function set material(param1:Material) : void
      {
         this._shape.material = param1;
      }
      
      public function get mask() : uint
      {
         return this._shape.filter.collisionMask;
      }
      
      public function set mask(param1:uint) : void
      {
         this._shape.filter.collisionMask = param1;
      }
   }
}

