package flashpunk2.components.physics
{
   import flashpunk2.Entity;
   import flashpunk2.global.Calc;
   import flashpunk2.namespaces.fp_internal;
   import nape.phys.BodyType;
   
   use namespace fp_internal;
   
   public class DynamicBody extends RigidBody
   {
      
      public function DynamicBody(param1:Boolean = true, param2:Boolean = true, param3:Boolean = true)
      {
         super(BodyType.DYNAMIC,param1,param2,param3);
      }
      
      override fp_internal function start(param1:Entity) : void
      {
         super.fp_internal::start(param1);
         param1.ON_UPDATE.add(this.onUpdate);
      }
      
      override fp_internal function end() : void
      {
         entity.ON_UPDATE.remove(this.onUpdate);
         super.fp_internal::end();
      }
      
      private function onUpdate() : void
      {
         entity.fp_internal::setPositionAngle(body.position.x,body.position.y,body.rotation * Calc.DEG);
      }
   }
}

