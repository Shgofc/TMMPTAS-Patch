package game.environment
{
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.global.Asset;
   import flashpunk2.global.Rand;
   
   public class Prop extends Entity
   {
      
      private var anim:AnimationRenderer;
      
      public function Prop(param1:String, param2:int, param3:int)
      {
         var _loc4_:ImageRenderer = null;
         super(param2,param3);
         if(param1.search("anim") >= 0)
         {
            this.anim = new AnimationRenderer();
            if(Asset.hasSubTextureName("props/" + param1 + "Blink0000"))
            {
               this.anim.addPrefix("blink","props/" + param1 + "Blink",12,false);
               this.anim.addPrefix("idle","props/" + param1,12,false);
               this.anim.ON_COMPLETE.add(this.onBlink);
            }
            else
            {
               this.anim.addPrefix("idle","props/" + param1,12,true);
            }
            this.anim.play("idle");
            add(this.anim);
         }
         else
         {
            _loc4_ = new ImageRenderer("props/" + param1,false);
            add(_loc4_);
         }
         depth = 20;
      }
      
      private function onBlink() : void
      {
         this.anim.play(Rand.chance(0.15) ? "blink" : "idle");
      }
   }
}

