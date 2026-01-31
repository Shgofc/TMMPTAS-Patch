package flashpunk2
{
   import flashpunk2.components.physics.RigidBody;
   import flashpunk2.namespaces.fp_internal;
   
   use namespace fp_internal;
   
   public class Component
   {
      
      public const ON_START:Signal = new Signal();
      
      public const ON_END:Signal = new Signal();
      
      public const ON_DEBUG:Signal = new Signal();
      
      private var _entity:Entity;
      
      public function Component()
      {
         super();
      }
      
      fp_internal function start(param1:Entity) : void
      {
         this._entity = param1;
         this.ON_START.dispatch();
      }
      
      fp_internal function end() : void
      {
         this.ON_END.dispatch();
         this._entity = null;
      }
      
      public function getFunction(param1:String) : Function
      {
         if(hasOwnProperty(param1))
         {
            return this[param1];
         }
         return null;
      }
      
      public function removeSelf() : void
      {
         if(this._entity != null)
         {
            this._entity.remove(this);
         }
      }
      
      public function get exists() : Boolean
      {
         return this._entity != null && this._entity.exists;
      }
      
      public function get entity() : Entity
      {
         return this._entity;
      }
      
      public function get world() : World
      {
         return this._entity != null ? this._entity.world : null;
      }
      
      public function get physics() : Physics
      {
         return this._entity != null ? this._entity.physics : null;
      }
      
      public function get camera() : Camera
      {
         return this._entity != null ? this._entity.camera : null;
      }
      
      public function get engine() : Engine
      {
         return Engine.instance;
      }
      
      public function get rigidBody() : RigidBody
      {
         return this._entity != null ? this._entity.rigidBody : null;
      }
   }
}

