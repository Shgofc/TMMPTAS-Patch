package flashpunk2.components.physics
{
   import flashpunk2.Component;
   import flashpunk2.Entity;
   import flashpunk2.global.Cache;
   import flashpunk2.global.Calc;
   import flashpunk2.namespaces.fp_internal;
   import nape.dynamics.Arbiter;
   import nape.dynamics.ArbiterList;
   import nape.dynamics.CollisionArbiter;
   import nape.geom.Vec2;
   import nape.phys.Body;
   import nape.phys.BodyType;
   import nape.shape.Shape;
   
   use namespace fp_internal;
   
   public class RigidBody extends Component
   {
      
      public var autoSync:Boolean = true;
      
      private var _body:Body;
      
      private var _scaledX:Number;
      
      private var _scaledY:Number;
      
      public function RigidBody(param1:BodyType, param2:Boolean = true, param3:Boolean = true, param4:Boolean = true)
      {
         super();
         this.autoSync = param2;
         this._body = new Body(param1);
         this._body.userData.rigidBody = this;
         this._body.userData.tag = null;
         this._body.allowRotation = param3;
         this._body.allowMovement = param4;
      }
      
      override fp_internal function start(param1:Entity) : void
      {
         super.fp_internal::start(param1);
         this._body.userData.entity = param1;
      }
      
      override fp_internal function end() : void
      {
         this._body.userData.entity = null;
         super.fp_internal::end();
      }
      
      fp_internal function addToSpace() : void
      {
         this._body.position.setxy(entity.x,entity.y);
         this._body.rotation = entity.angle * Calc.RAD;
         this._scaledX = entity.scaleX;
         this._scaledY = entity.scaleY;
         if(this._scaledX != 1 || this._scaledY != 1)
         {
            this._body.scaleShapes(this._scaledX,this._scaledY);
         }
         this._body.space = physics.space;
      }
      
      fp_internal function removeFromSpace() : void
      {
         this._body.space = null;
         if(this._scaledX != 1 || this._scaledY != 1)
         {
            this._body.scaleShapes(1 / this._scaledX,1 / this._scaledY);
         }
      }
      
      public function setVelocity(param1:Number, param2:Number) : void
      {
         this._body.velocity.setxy(param1,param2);
      }
      
      public function setVelocityAngle(param1:Number, param2:Number) : void
      {
         this._body.velocity = Vec2.fromPolar(param2,param1 * Calc.RAD,true);
      }
      
      public function setVeloctiyTowards(param1:Number, param2:Number, param3:Number) : void
      {
         this._body.velocity = Vec2.fromPolar(param3,Calc.angleTo(this._body.position.x,this._body.position.y,param1,param2) * Calc.RAD,true);
      }
      
      public function setAllow(param1:Boolean, param2:Boolean) : void
      {
         this._body.allowMovement = param1;
         this._body.allowRotation = param2;
      }
      
      public function addImpulse(param1:Number, param2:Number) : void
      {
         this._body.applyImpulse(Vec2.weak(param1,param2));
      }
      
      public function addAngularImpulse(param1:Number) : void
      {
         this._body.applyAngularImpulse(param1);
      }
      
      public function colliding() : *
      {
         var _loc1_:Arbiter = null;
         if(this._body.arbiters.length > 0)
         {
            _loc1_ = this._body.arbiters.at(0);
            return this._body == _loc1_.body1 ? _loc1_.body2.userData.entity : _loc1_.body1.userData.entity;
         }
         return null;
      }
      
      public function collidingWithEntity(param1:Entity) : Boolean
      {
         var _loc3_:Arbiter = null;
         var _loc4_:Shape = null;
         var _loc2_:ArbiterList = this._body.arbiters;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc3_ = _loc2_.at(_loc5_);
            _loc4_ = this._body == _loc3_.body1 ? _loc3_.shape2 : _loc3_.shape1;
            if(_loc4_.userData.entity == param1)
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      public function collidingWithType(param1:Class) : *
      {
         var _loc3_:Arbiter = null;
         var _loc4_:Shape = null;
         var _loc2_:ArbiterList = this._body.arbiters;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc3_ = _loc2_.at(_loc5_);
            _loc4_ = this._body == _loc3_.body1 ? _loc3_.shape2 : _loc3_.shape1;
            if(_loc4_.userData.entity is param1)
            {
               return _loc4_.userData.entity;
            }
            _loc5_++;
         }
         return null;
      }
      
      public function collidingWithTag(param1:String) : *
      {
         var _loc3_:Arbiter = null;
         var _loc4_:Shape = null;
         var _loc2_:ArbiterList = this._body.arbiters;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc3_ = _loc2_.at(_loc5_);
            _loc4_ = this._body == _loc3_.body1 ? _loc3_.shape2 : _loc3_.shape1;
            if(_loc4_.userData.tag == param1 || _loc4_.body.userData.tag == param1)
            {
               return _loc4_.userData.entity;
            }
            _loc5_++;
         }
         return null;
      }
      
      public function collidingWithGroups(param1:uint, param2:Boolean = true) : *
      {
         var _loc4_:Arbiter = null;
         var _loc5_:Shape = null;
         var _loc3_:ArbiterList = this._body.arbiters;
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc4_ = _loc3_.at(_loc6_);
            _loc5_ = this._body == _loc4_.body1 ? _loc4_.shape2 : _loc4_.shape1;
            if(_loc5_.userData.entity.inGroups(param1,param2))
            {
               return _loc5_.userData.entity;
            }
            _loc6_++;
         }
         return null;
      }
      
      public function getCollisions(param1:* = null) : *
      {
         var _loc3_:Arbiter = null;
         if(param1 == null)
         {
            param1 = Cache.pop(Array);
         }
         var _loc2_:ArbiterList = this._body.arbiters;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = _loc2_.at(_loc4_);
            param1.push(this._body == _loc3_.body1 ? _loc3_.body2.userData.entity : _loc3_.body1.userData.entity);
            _loc4_++;
         }
         return param1;
      }
      
      public function getCollisionsByType(param1:Class, param2:* = null) : *
      {
         var _loc4_:Arbiter = null;
         var _loc5_:Shape = null;
         if(param2 == null)
         {
            param2 = Cache.pop(Array);
         }
         var _loc3_:ArbiterList = this._body.arbiters;
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc4_ = _loc3_.at(_loc6_);
            _loc5_ = this._body == _loc4_.body1 ? _loc4_.shape2 : _loc4_.shape1;
            if(_loc5_.userData.entity is param1)
            {
               param2.push(_loc5_.userData.entity);
            }
            _loc6_++;
         }
         return param2;
      }
      
      public function getCollisionsByTag(param1:String, param2:* = null) : *
      {
         var _loc4_:Arbiter = null;
         var _loc5_:Shape = null;
         if(param2 == null)
         {
            param2 = Cache.pop(Array);
         }
         var _loc3_:ArbiterList = this._body.arbiters;
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc4_ = _loc3_.at(_loc6_);
            _loc5_ = this._body == _loc4_.body1 ? _loc4_.shape2 : _loc4_.shape1;
            if(_loc5_.userData.tag == param1 || _loc5_.body.userData.tag == param1)
            {
               param2.push(_loc5_.userData.entity);
            }
            _loc6_++;
         }
         return param2;
      }
      
      public function getCollisionsByGroups(param1:uint, param2:Boolean = true, param3:* = null) : *
      {
         var _loc5_:Arbiter = null;
         var _loc6_:Shape = null;
         if(param3 == null)
         {
            param3 = Cache.pop(Array);
         }
         var _loc4_:ArbiterList = this._body.arbiters;
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_.length)
         {
            _loc5_ = _loc4_.at(_loc7_);
            _loc6_ = this._body == _loc5_.body1 ? _loc5_.shape2 : _loc5_.shape1;
            if(_loc6_.userData.entity.inGroups(param1,param2))
            {
               param3.push(_loc6_.userData.entity);
            }
            _loc7_++;
         }
         return param3;
      }
      
      public function getNormal(param1:Vec2 = null) : Vec2
      {
         var _loc3_:CollisionArbiter = null;
         if(param1 == null)
         {
            param1 = Vec2.get(0,0);
         }
         var _loc2_:ArbiterList = this._body.arbiters;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = _loc2_.at(_loc4_) as CollisionArbiter;
            if(_loc3_ != null)
            {
               if(this._body == _loc3_.body1)
               {
                  param1.x -= _loc3_.normal.x;
                  param1.y -= _loc3_.normal.y;
               }
               else
               {
                  param1.x += _loc3_.normal.x;
                  param1.y += _loc3_.normal.y;
               }
            }
            _loc4_++;
         }
         param1.normalise();
         return param1;
      }
      
      public function getNormalByType(param1:Class, param2:Vec2 = null) : Vec2
      {
         var _loc4_:CollisionArbiter = null;
         var _loc5_:Shape = null;
         if(param2 == null)
         {
            param2 = Vec2.get(0,0);
         }
         var _loc3_:ArbiterList = this._body.arbiters;
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc4_ = _loc3_.at(_loc6_) as CollisionArbiter;
            if(_loc4_ != null)
            {
               if(this._body == _loc4_.body1)
               {
                  if(_loc4_.body2.userData.entity is param1)
                  {
                     param2.x -= _loc4_.normal.x;
                     param2.y -= _loc4_.normal.y;
                  }
               }
               else if(_loc4_.body1.userData.entity is param1)
               {
                  param2.x += _loc4_.normal.x;
                  param2.y += _loc4_.normal.y;
               }
            }
            _loc6_++;
         }
         param2.normalise();
         return param2;
      }
      
      public function getNormalByTag(param1:String, param2:Vec2 = null) : Vec2
      {
         var _loc4_:CollisionArbiter = null;
         var _loc5_:Shape = null;
         if(param2 == null)
         {
            param2 = Vec2.get(0,0);
         }
         var _loc3_:ArbiterList = this._body.arbiters;
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc4_ = _loc3_.at(_loc6_) as CollisionArbiter;
            if(_loc4_ != null)
            {
               if(this._body == _loc4_.body1)
               {
                  if(_loc4_.shape2.userData.tag == param1 || _loc4_.body2.userData.tag == param1)
                  {
                     param2.x -= _loc4_.normal.x;
                     param2.y -= _loc4_.normal.y;
                  }
               }
               else if(_loc4_.shape1.userData.tag == param1 || _loc4_.body1.userData.tag == param1)
               {
                  param2.x += _loc4_.normal.x;
                  param2.y += _loc4_.normal.y;
               }
            }
            _loc6_++;
         }
         param2.normalise();
         return param2;
      }
      
      public function getNormalByGroups(param1:uint, param2:Boolean = true, param3:Vec2 = null) : Vec2
      {
         var _loc5_:CollisionArbiter = null;
         var _loc6_:Shape = null;
         if(param3 == null)
         {
            param3 = Vec2.get(0,0);
         }
         var _loc4_:ArbiterList = this._body.arbiters;
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_.length)
         {
            _loc5_ = _loc4_.at(_loc7_) as CollisionArbiter;
            if(_loc5_ != null)
            {
               if(this._body == _loc5_.body1)
               {
                  if(_loc5_.body2.userData.entity.inGroups(param1,param2))
                  {
                     param3.x -= _loc5_.normal.x;
                     param3.y -= _loc5_.normal.y;
                  }
               }
               else if(_loc5_.body1.userData.entity.inGroups(param1,param2))
               {
                  param3.x += _loc5_.normal.x;
                  param3.y += _loc5_.normal.y;
               }
            }
            _loc7_++;
         }
         param3.normalise();
         return param3;
      }
      
      public function collidingWithTypeAtAngle(param1:Class, param2:Number, param3:Number) : *
      {
         var _loc5_:CollisionArbiter = null;
         var _loc4_:ArbiterList = this._body.arbiters;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_ = _loc4_.at(_loc6_) as CollisionArbiter;
            if(_loc5_ != null)
            {
               if(this._body == _loc5_.body1)
               {
                  if(_loc5_.body2.userData.entity is param1 && Calc.angleDifference(param2,Calc.deg(_loc5_.normal.angle)) <= param3)
                  {
                     return _loc5_.body2.userData.entity;
                  }
               }
               else if(_loc5_.body1.userData.entity is param1 && Calc.angleDifference(param2,Calc.deg(_loc5_.normal.angle) + 180) <= param3)
               {
                  return _loc5_.body1.userData.entity;
               }
            }
            _loc6_++;
         }
         return null;
      }
      
      public function collidingWithTagAtAngle(param1:String, param2:Number, param3:Number) : *
      {
         var _loc5_:CollisionArbiter = null;
         var _loc4_:ArbiterList = this._body.arbiters;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_ = _loc4_.at(_loc6_) as CollisionArbiter;
            if(_loc5_ != null)
            {
               if(this._body == _loc5_.body1)
               {
                  if((_loc5_.shape2.userData.tag == param1 || _loc5_.body2.userData.tag == param1) && Calc.angleDifference(param2,Calc.deg(_loc5_.normal.angle)) <= param3)
                  {
                     return _loc5_.body2.userData.entity;
                  }
               }
               else if((_loc5_.shape1.userData.tag == param1 || _loc5_.body1.userData.tag == param1) && Calc.angleDifference(param2,Calc.deg(_loc5_.normal.angle) + 180) <= param3)
               {
                  return _loc5_.body1.userData.entity;
               }
            }
            _loc6_++;
         }
         return null;
      }
      
      public function collidingWithGroupsAtAngle(param1:uint, param2:Boolean, param3:Number, param4:Number) : *
      {
         var _loc6_:CollisionArbiter = null;
         var _loc5_:ArbiterList = this._body.arbiters;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_.length)
         {
            _loc6_ = _loc5_.at(_loc7_) as CollisionArbiter;
            if(_loc6_ != null)
            {
               if(this._body == _loc6_.body1)
               {
                  if(Boolean(_loc6_.body2.userData.entity.inGroups(param1,param2)) && Calc.angleDifference(param3,Calc.deg(_loc6_.normal.angle)) <= param4)
                  {
                     return _loc6_.body2.userData.entity;
                  }
               }
               else if(Boolean(_loc6_.body1.userData.entity.inGroups(param1,param2)) && Calc.angleDifference(param3,Calc.deg(_loc6_.normal.angle) + 180) <= param4)
               {
                  return _loc6_.body1.userData.entity;
               }
            }
            _loc7_++;
         }
         return false;
      }
      
      public function groundedOnType(param1:Class, param2:Number = -90, param3:Number = 89) : *
      {
         return this.collidingWithTypeAtAngle(param1,param2,param3);
      }
      
      public function groundedOnTag(param1:String, param2:Number = -90, param3:Number = 89) : *
      {
         return this.collidingWithTagAtAngle(param1,param2,param3);
      }
      
      public function groundedOnGroups(param1:uint, param2:Boolean = true, param3:Number = -90, param4:Number = 89) : *
      {
         return this.collidingWithGroupsAtAngle(param1,param2,param3,param4);
      }
      
      public function invokeOnColliding(param1:String, param2:* = null, param3:Number = 0, param4:int = 0) : void
      {
         var _loc5_:Array = this.getCollisions();
         while(_loc5_.length > 0)
         {
            _loc5_.pop().invoke(param1,param2,param3,param4);
         }
         Cache.push(_loc5_);
      }
      
      public function invokeOnCollidingType(param1:Class, param2:String, param3:* = null, param4:Number = 0, param5:int = 0) : void
      {
         var _loc6_:Array = this.getCollisionsByType(param1);
         while(_loc6_.length > 0)
         {
            _loc6_.pop().invoke(param2,param3,param4,param5);
         }
         Cache.push(_loc6_);
      }
      
      public function invokeOnCollidingTag(param1:String, param2:String, param3:* = null, param4:Number = 0, param5:int = 0) : void
      {
         var _loc6_:Array = this.getCollisionsByTag(param1);
         while(_loc6_.length > 0)
         {
            _loc6_.pop().invoke(param2,param3,param4,param5);
         }
         Cache.push(_loc6_);
      }
      
      public function invokeOnCollidingGroups(param1:uint, param2:Boolean, param3:String, param4:* = null, param5:Number = 0, param6:int = 0) : void
      {
         var _loc7_:Array = this.getCollisionsByGroups(param1,param2);
         while(_loc7_.length > 0)
         {
            _loc7_.pop().invoke(param3,param4,param5,param6);
         }
         Cache.push(_loc7_);
      }
      
      public function get body() : Body
      {
         return this._body;
      }
      
      public function get type() : BodyType
      {
         return this._body.type;
      }
      
      public function set type(param1:BodyType) : void
      {
         this._body.type = param1;
      }
      
      public function get x() : Number
      {
         return this._body.position.x;
      }
      
      public function set x(param1:Number) : void
      {
         this._body.position.x = param1;
      }
      
      public function get y() : Number
      {
         return this._body.position.y;
      }
      
      public function set y(param1:Number) : void
      {
         this._body.position.y = param1;
      }
      
      public function get angle() : Number
      {
         return this._body.rotation * Calc.DEG;
      }
      
      public function set angle(param1:Number) : void
      {
         this._body.rotation = param1 * Calc.RAD;
      }
      
      public function get velocity() : Number
      {
         return this._body.velocity.length;
      }
      
      public function set velocity(param1:Number) : void
      {
         this._body.velocity.normalise();
         this._body.velocity.x *= param1;
         this._body.velocity.y *= param1;
      }
      
      public function get velocityX() : Number
      {
         return this._body.velocity.x;
      }
      
      public function set velocityX(param1:Number) : void
      {
         this._body.velocity.x = param1;
      }
      
      public function get velocityY() : Number
      {
         return this._body.velocity.y;
      }
      
      public function set velocityY(param1:Number) : void
      {
         this._body.velocity.y = param1;
      }
      
      public function get angularVelocity() : Number
      {
         return this._body.angularVel * Calc.DEG;
      }
      
      public function set angularVelocity(param1:Number) : void
      {
         this._body.angularVel = param1 * Calc.RAD;
      }
      
      public function get allowMovement() : Boolean
      {
         return this._body.allowMovement;
      }
      
      public function set allowMovement(param1:Boolean) : void
      {
         this._body.allowMovement = param1;
      }
      
      public function get allowRotation() : Boolean
      {
         return this._body.allowRotation;
      }
      
      public function set allowRotation(param1:Boolean) : void
      {
         this._body.allowRotation = param1;
      }
      
      public function get tag() : String
      {
         return this._body.userData.tag;
      }
      
      public function set tag(param1:String) : void
      {
         this._body.userData.tag = param1;
      }
      
      public function get resting() : Boolean
      {
         return this._body.isSleeping;
      }
   }
}

