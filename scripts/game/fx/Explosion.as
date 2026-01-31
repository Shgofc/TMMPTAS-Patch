package game.fx
{
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.global.Ease;
   
   public class Explosion extends Entity
   {
      
      public function Explosion(param1:int, param2:int, param3:String = "boom", param4:Number = 1)
      {
         super(param1,param2);
         var _loc5_:AnimationRenderer = new AnimationRenderer();
         _loc5_.addPrefix("boom","fx/" + param3,14,false);
         _loc5_.play("boom");
         _loc5_.centerOrigin();
         _loc5_.alpha = param4;
         _loc5_.ON_COMPLETE.add(removeSelf);
         tween(this,0.5).scaleFrom(0.7,0.7).scaleTo(1,1).ease(Ease.backOut);
         add(_loc5_);
      }
   }
}

