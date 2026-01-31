package flashpunk2
{
   import flashpunk2.components.physics.Collider;
   import flashpunk2.components.physics.RigidBody;
   import flashpunk2.global.Cache;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Time;
   import flashpunk2.namespaces.fp_internal;
   import nape.dynamics.InteractionFilter;
   import nape.geom.AABB;
   import nape.geom.Vec2;
   import nape.phys.Body;
   import nape.phys.BodyList;
   import nape.shape.Shape;
   import nape.shape.ShapeList;
   import nape.space.Space;
   
   use namespace fp_internal;
   
   public class Physics
   {
      
      private static var _bodies:BodyList = new BodyList();
      
      private static var _shapes:ShapeList = new ShapeList();
      
      private static var _filter:InteractionFilter = new InteractionFilter(uint.MAX_VALUE,-1,uint.MAX_VALUE,-1,uint.MAX_VALUE,-1);
      
      private static var _aabb:AABB = new AABB();
      
      private var _space:Space = new Space();
      
      private var _velocityIterations:uint = 10;
      
      private var _positionIterations:uint = 10;
      
      public function Physics()
      {
         super();
      }
      
      fp_internal function update() : void
      {
         if(Time.dt > 0)
         {
            this._space.step(Time.dt,this._velocityIterations,this._positionIterations);
         }
      }
      
      private function getFilter(param1:uint) : InteractionFilter
      {
         _filter.collisionMask = param1;
         _filter.sensorMask = param1;
         _filter.fluidMask = param1;
         return _filter;
      }
      
      public function setGravity(param1:Number, param2:Number) : void
      {
         this._space.gravity.setxy(param1,param2);
      }
      
      public function setGravityAngle(param1:Number, param2:Number) : void
      {
         this._space.gravity = Vec2.fromPolar(param2,param1 * Calc.RAD,true);
      }
      
      public function findTypeAtPoint(param1:Class, param2:Number, param3:Number, param4:* = null) : *
      {
         var _loc5_:Body = null;
         if(param4 == null)
         {
            param4 = Cache.pop(Array);
         }
         this._space.bodiesUnderPoint(Vec2.weak(param2,param3),null,_bodies);
         while(!_bodies.empty())
         {
            _loc5_ = _bodies.pop();
            if(_loc5_.userData.entity is param1)
            {
               param4.push(_loc5_.userData.entity);
            }
         }
         return param4;
      }
      
      public function firstTypeAtPoint(param1:Class, param2:Number, param3:Number) : *
      {
         var _loc4_:Array = this.findTypeAtPoint(param1,param2,param3);
         var _loc5_:* = _loc4_.length > 0 ? _loc4_[0] : null;
         Cache.push(_loc4_);
         return _loc5_;
      }
      
      public function findTagAtPoint(param1:String, param2:Number, param3:Number, param4:* = null) : *
      {
         var _loc5_:Shape = null;
         if(param4 == null)
         {
            param4 = Cache.pop(Array);
         }
         this._space.shapesUnderPoint(Vec2.weak(param2,param3),null,_shapes);
         while(!_shapes.empty())
         {
            _loc5_ = _shapes.pop();
            if(_loc5_.userData.tag == param1 || _loc5_.body.userData.tag == param1)
            {
               param4.push(_loc5_.userData.entity);
            }
         }
         return param4;
      }
      
      public function firstTagAtPoint(param1:String, param2:Number, param3:Number) : *
      {
         var _loc4_:Array = this.findTagAtPoint(param1,param2,param3);
         var _loc5_:* = _loc4_.length > 0 ? _loc4_[0] : null;
         Cache.push(_loc4_);
         return _loc5_;
      }
      
      public function findGroupAtPoint(param1:uint, param2:Number, param3:Number, param4:* = null) : *
      {
         var _loc5_:Body = null;
         if(param4 == null)
         {
            param4 = Cache.pop(Array);
         }
         this._space.bodiesUnderPoint(Vec2.weak(param2,param3),this.getFilter(param1),_bodies);
         while(!_bodies.empty())
         {
            _loc5_ = _bodies.pop();
            if(_loc5_.userData.entity.inGroups(param1,true))
            {
               param4.push(_loc5_.userData.entity);
            }
         }
         return param4;
      }
      
      public function firstGroupAtPoint(param1:uint, param2:Number, param3:Number) : *
      {
         var _loc4_:Array = this.findGroupAtPoint(param1,param2,param3);
         var _loc5_:* = _loc4_.length > 0 ? _loc4_[0] : null;
         Cache.push(_loc4_);
         return _loc5_;
      }
      
      public function findTypeInRect(param1:Class, param2:Number, param3:Number, param4:Number, param5:Number, param6:Boolean = true, param7:* = null) : *
      {
         var _loc8_:Body = null;
         if(param7 == null)
         {
            param7 = Cache.pop(Array);
         }
         if(param4 < 0)
         {
            param2 += param4;
            param4 = -param4;
         }
         if(param5 < 0)
         {
            param3 += param5;
            param5 = -param5;
         }
         _aabb.min.setxy(param2,param3);
         _aabb.max.setxy(param2 + param4,param3 + param5);
         this._space.bodiesInAABB(_aabb,false,!param6,null,_bodies);
         while(!_bodies.empty())
         {
            _loc8_ = _bodies.pop();
            if(_loc8_.userData.entity is param1)
            {
               param7.push(_loc8_.userData.entity);
            }
         }
         return param7;
      }
      
      public function firstTypeInRect(param1:Class, param2:Number, param3:Number, param4:Number, param5:Number, param6:Boolean = true) : *
      {
         var _loc7_:Array = this.findTypeInRect(param1,param2,param3,param4,param5,param6);
         var _loc8_:* = _loc7_.length > 0 ? _loc7_[0] : null;
         Cache.push(_loc7_);
         return _loc8_;
      }
      
      public function findTagInRect(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Boolean = true, param7:* = null) : *
      {
         var _loc8_:Shape = null;
         if(param7 == null)
         {
            param7 = Cache.pop(Array);
         }
         if(param4 < 0)
         {
            param2 += param4;
            param4 = -param4;
         }
         if(param5 < 0)
         {
            param3 += param5;
            param5 = -param5;
         }
         _aabb.min.setxy(param2,param3);
         _aabb.max.setxy(param2 + param4,param3 + param5);
         this._space.bodiesInAABB(_aabb,false,!param6,null,_bodies);
         while(!_shapes.empty())
         {
            _loc8_ = _shapes.pop();
            if(_loc8_.userData.tag == param1 || _loc8_.body.userData.tag == param1)
            {
               param7.push(_loc8_.userData.entity);
            }
         }
         return param7;
      }
      
      public function firstTagInRect(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Boolean = true) : *
      {
         var _loc7_:Array = this.findTagInRect(param1,param2,param3,param4,param5,param6);
         var _loc8_:* = _loc7_.length > 0 ? _loc7_[0] : null;
         Cache.push(_loc7_);
         return _loc8_;
      }
      
      public function findGroupInRect(param1:uint, param2:Number, param3:Number, param4:Number, param5:Number, param6:Boolean = true, param7:* = null) : *
      {
         var _loc8_:Shape = null;
         if(param7 == null)
         {
            param7 = Cache.pop(Array);
         }
         if(param4 < 0)
         {
            param2 += param4;
            param4 = -param4;
         }
         if(param5 < 0)
         {
            param3 += param5;
            param5 = -param5;
         }
         _aabb.min.setxy(param2,param3);
         _aabb.max.setxy(param2 + param4,param3 + param5);
         this._space.shapesInAABB(_aabb,false,!param6,this.getFilter(param1),_shapes);
         while(!_shapes.empty())
         {
            _loc8_ = _shapes.pop();
            if(_loc8_.userData.entity.inGroups(param1,true))
            {
               param7.push(_loc8_.userData.entity);
            }
         }
         return param7;
      }
      
      public function firstGroupInRect(param1:uint, param2:Number, param3:Number, param4:Number, param5:Number, param6:Boolean = true) : *
      {
         var _loc7_:Array = this.findGroupInRect(param1,param2,param3,param4,param5,param6);
         var _loc8_:* = _loc7_.length > 0 ? _loc7_[0] : null;
         Cache.push(_loc7_);
         return _loc8_;
      }
      
      public function findTypeInCircle(param1:Class, param2:Number, param3:Number, param4:Number, param5:* = null) : *
      {
         var _loc6_:Body = null;
         if(param5 == null)
         {
            param5 = Cache.pop(Array);
         }
         this._space.bodiesInCircle(Vec2.weak(param2,param3),param4,false,null,_bodies);
         while(!_bodies.empty())
         {
            _loc6_ = _bodies.pop();
            if(_loc6_.userData.entity is param1)
            {
               param5.push(_loc6_.userData.entity);
            }
         }
         return param5;
      }
      
      public function firstTypeInCircle(param1:Class, param2:Number, param3:Number, param4:Number) : *
      {
         var _loc5_:Array = this.findTypeInCircle(param1,param2,param3,param4);
         var _loc6_:* = _loc5_.length > 0 ? _loc5_[0] : null;
         Cache.push(_loc5_);
         return _loc6_;
      }
      
      public function findTagInCircle(param1:String, param2:Number, param3:Number, param4:Number, param5:* = null) : *
      {
         var _loc6_:Shape = null;
         if(param5 == null)
         {
            param5 = Cache.pop(Array);
         }
         this._space.shapesInCircle(Vec2.weak(param2,param3),param4,false,null,_shapes);
         while(!_shapes.empty())
         {
            _loc6_ = _shapes.pop();
            if(_loc6_.userData.tag == param1 || _loc6_.body.userData.tag == param1)
            {
               param5.push(_loc6_.userData.entity);
            }
         }
         return param5;
      }
      
      public function firstTagInCircle(param1:String, param2:Number, param3:Number, param4:Number) : *
      {
         var _loc5_:Array = this.findTagInCircle(param1,param2,param3,param4);
         var _loc6_:* = _loc5_.length > 0 ? _loc5_[0] : null;
         Cache.push(_loc5_);
         return _loc6_;
      }
      
      public function findGroupInCircle(param1:uint, param2:Number, param3:Number, param4:Number, param5:* = null) : *
      {
         var _loc6_:Body = null;
         if(param5 == null)
         {
            param5 = Cache.pop(Array);
         }
         this._space.bodiesInCircle(Vec2.weak(param2,param3),param4,false,this.getFilter(param1),_bodies);
         while(!_bodies.empty())
         {
            _loc6_ = _bodies.pop();
            if(_loc6_.userData.entity.inGroups(param1,true))
            {
               param5.push(_loc6_.userData.entity);
            }
         }
         return param5;
      }
      
      public function firstGroupInCircle(param1:uint, param2:Number, param3:Number, param4:Number) : *
      {
         var _loc5_:Array = this.findGroupInCircle(param1,param2,param3,param4);
         var _loc6_:* = _loc5_.length > 0 ? _loc5_[0] : null;
         Cache.push(_loc5_);
         return _loc6_;
      }
      
      public function findTypeInBody(param1:Class, param2:RigidBody, param3:* = null) : *
      {
         var _loc4_:Body = null;
         if(param3 == null)
         {
            param3 = Cache.pop(Array);
         }
         this._space.bodiesInBody(param2.body,null,_bodies);
         while(!_bodies.empty())
         {
            _loc4_ = _bodies.pop();
            if(_loc4_.userData.entity is param1)
            {
               param3.push(_loc4_.userData.entity);
            }
         }
         return param3;
      }
      
      public function firstTypeInBody(param1:Class, param2:RigidBody) : *
      {
         var _loc3_:Array = this.findTypeInBody(param1,param2);
         var _loc4_:* = _loc3_.length > 0 ? _loc3_[0] : null;
         Cache.push(_loc3_);
         return _loc4_;
      }
      
      public function findTagInBody(param1:String, param2:RigidBody, param3:* = null) : *
      {
         var _loc4_:Shape = null;
         if(param3 == null)
         {
            param3 = Cache.pop(Array);
         }
         this._space.shapesInBody(param2.body,null,_shapes);
         while(!_shapes.empty())
         {
            _loc4_ = _shapes.pop();
            if(_loc4_.userData.tag == param1 || _loc4_.body.userData.tag == param1)
            {
               param3.push(_loc4_.userData.entity);
            }
         }
         return param3;
      }
      
      public function firstTagInBody(param1:String, param2:RigidBody) : *
      {
         var _loc3_:Array = this.findTagInBody(param1,param2);
         var _loc4_:* = _loc3_.length > 0 ? _loc3_[0] : null;
         Cache.push(_loc3_);
         return _loc4_;
      }
      
      public function findGroupInBody(param1:uint, param2:RigidBody, param3:* = null) : *
      {
         var _loc4_:Body = null;
         if(param3 == null)
         {
            param3 = Cache.pop(Array);
         }
         this._space.bodiesInBody(param2.body,this.getFilter(param1),_bodies);
         while(!_bodies.empty())
         {
            _loc4_ = _bodies.pop();
            if(_loc4_.userData.entity.inGroups(param1,true))
            {
               param3.push(_loc4_.userData.entity);
            }
         }
         return param3;
      }
      
      public function firstGroupInBody(param1:uint, param2:RigidBody) : *
      {
         var _loc3_:Array = this.findGroupInBody(param1,param2);
         var _loc4_:* = _loc3_.length > 0 ? _loc3_[0] : null;
         Cache.push(_loc3_);
         return _loc4_;
      }
      
      public function findTypeInEntity(param1:Class, param2:Entity, param3:* = null) : *
      {
         if(param2.rigidBody == null)
         {
            throw new Error("Entity does not have a rigid body!");
         }
         return this.findTypeInBody(param1,param2.rigidBody,param3);
      }
      
      public function firstTypeInEntity(param1:Class, param2:Entity) : *
      {
         var _loc3_:Array = this.findTypeInEntity(param1,param2);
         var _loc4_:* = _loc3_.length > 0 ? _loc3_[0] : null;
         Cache.push(_loc3_);
         return _loc4_;
      }
      
      public function findTagInEntity(param1:String, param2:Entity, param3:* = null) : *
      {
         if(param2.rigidBody == null)
         {
            throw new Error("Entity does not have a rigid body!");
         }
         return this.findTagInBody(param1,param2.rigidBody,param3);
      }
      
      public function firstTagInEntity(param1:String, param2:Entity) : *
      {
         var _loc3_:Array = this.findTagInEntity(param1,param2);
         var _loc4_:* = _loc3_.length > 0 ? _loc3_[0] : null;
         Cache.push(_loc3_);
         return _loc4_;
      }
      
      public function findGroupInEntity(param1:uint, param2:Entity, param3:* = null) : *
      {
         if(param2.rigidBody == null)
         {
            throw new Error("Entity does not have a rigid body!");
         }
         return this.findGroupInBody(param1,param2.rigidBody,param3);
      }
      
      public function firstGroupInEntity(param1:uint, param2:Entity) : *
      {
         var _loc3_:Array = this.findGroupInEntity(param1,param2);
         var _loc4_:* = _loc3_.length > 0 ? _loc3_[0] : null;
         Cache.push(_loc3_);
         return _loc4_;
      }
      
      public function findTypeInCollider(param1:Class, param2:Collider, param3:* = null) : *
      {
         var _loc4_:Body = null;
         if(param3 == null)
         {
            param3 = Cache.pop(Array);
         }
         this._space.bodiesInShape(param2.shape,false,null,_bodies);
         while(!_bodies.empty())
         {
            _loc4_ = _bodies.pop();
            if(_loc4_.userData.entity is param1)
            {
               param3.push(_loc4_.userData.entity);
            }
         }
         return param3;
      }
      
      public function firstTypeInCollider(param1:Class, param2:Collider) : *
      {
         var _loc3_:Array = this.findTypeInCollider(param1,param2);
         var _loc4_:* = _loc3_.length > 0 ? _loc3_[0] : null;
         Cache.push(_loc3_);
         return _loc4_;
      }
      
      public function findTagInCollider(param1:String, param2:Collider, param3:* = null) : *
      {
         var _loc4_:Shape = null;
         if(param3 == null)
         {
            param3 = Cache.pop(Array);
         }
         this._space.shapesInShape(param2.shape,false,null,_shapes);
         while(!_shapes.empty())
         {
            _loc4_ = _shapes.pop();
            if(_loc4_.userData.tag == param1 || _loc4_.body.userData.tag == param1)
            {
               param3.push(_loc4_.userData.entity);
            }
         }
         return param3;
      }
      
      public function firstTagInCollider(param1:String, param2:Collider) : *
      {
         var _loc3_:Array = this.findTagInCollider(param1,param2);
         var _loc4_:* = _loc3_.length > 0 ? _loc3_[0] : null;
         Cache.push(_loc3_);
         return _loc4_;
      }
      
      public function findGroupInCollider(param1:uint, param2:Collider, param3:* = null) : *
      {
         var _loc4_:Body = null;
         if(param3 == null)
         {
            param3 = Cache.pop(Array);
         }
         this._space.bodiesInShape(param2.shape,false,this.getFilter(param1),_bodies);
         while(!_bodies.empty())
         {
            _loc4_ = _bodies.pop();
            if(_loc4_.userData.entity.inGroups(param1,true))
            {
               param3.push(_loc4_.userData.entity);
            }
         }
         return param3;
      }
      
      public function firstGroupInCollider(param1:uint, param2:Collider) : *
      {
         var _loc3_:Array = this.findGroupInCollider(param1,param2);
         var _loc4_:* = _loc3_.length > 0 ? _loc3_[0] : null;
         Cache.push(_loc3_);
         return _loc4_;
      }
      
      public function setIterations(param1:uint, param2:uint) : void
      {
         this.velocityIterations = param1;
         this.positionIterations = param2;
      }
      
      public function get space() : Space
      {
         return this._space;
      }
      
      public function get gravityX() : Number
      {
         return this._space.gravity.x;
      }
      
      public function set gravityX(param1:Number) : void
      {
         this._space.gravity.x = param1;
      }
      
      public function get gravityY() : Number
      {
         return this._space.gravity.y;
      }
      
      public function set gravityY(param1:Number) : void
      {
         this._space.gravity.y = param1;
      }
      
      public function get velocityIterations() : uint
      {
         return this._velocityIterations;
      }
      
      public function set velocityIterations(param1:uint) : void
      {
         if(param1 == 0)
         {
            throw new Error("Velocity iterations cannot be zero.");
         }
         this._velocityIterations = param1;
      }
      
      public function get positionIterations() : uint
      {
         return this._positionIterations;
      }
      
      public function set positionIterations(param1:uint) : void
      {
         if(param1 == 0)
         {
            throw new Error("Position iterations cannot be zero.");
         }
         this._positionIterations = param1;
      }
   }
}

