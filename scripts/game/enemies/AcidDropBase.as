package game.enemies
{
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.AnimationRenderer;
   
   public class AcidDropBase extends Entity
   {
      
      private var image:AnimationRenderer;
      
      public function AcidDropBase(param1:int, param2:int)
      {
         super(param1,param2);
         this.image = new AnimationRenderer();
         this.image.addPrefix("drop","environment/acidDrop",6,false);
         this.image.play("drop");
         this.image.y = -4;
         add(this.image);
         this.image.ON_COMPLETE.add(this.onDrop);
      }
      
      private function onDrop() : void
      {
         world.add(new AcidDrop(x,y));
         this.image.index = 0;
         tween(this,0.7).onComplete(function():void
         {
            image.play("drop",true);
         });
      }
   }
}

