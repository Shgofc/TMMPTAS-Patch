package game.fx
{
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.global.Ease;
   import sound.SoundManager;
   
   public class Splash extends Entity
   {
      
      public function Splash(param1:int, param2:int, param3:Boolean)
      {
         super(param1,param2);
         var _loc4_:AnimationRenderer = new AnimationRenderer();
         _loc4_.addPrefix("splash","fx/splash",16,false);
         _loc4_.play("splash");
         _loc4_.centerOrigin();
         _loc4_.ON_COMPLETE.add(removeSelf);
         add(_loc4_);
         depth = -20;
         tween(this,0.4).scaleTo(1.3,0.6).moveTo(param1,param2 + 10).ease(Ease.backIn);
         SoundManager.playSound("splash" + (param3 ? "0" : "1"));
      }
   }
}

