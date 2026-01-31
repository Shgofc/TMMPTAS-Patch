package game.enemies
{
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Ease;
   import flashpunk2.global.Rand;
   
   public class Dumb extends Enemy
   {
      
      private var type:String;
      
      private var side:int = 1;
      
      public function Dumb(param1:int, param2:int, param3:String)
      {
         super(param1,param2,28,28);
         this.type = param3;
         image = new AnimationRenderer();
         image.addPrefix("stand","enemies/" + param3 + "Idle",8,false);
         image.addPrefix("blink","enemies/" + param3 + "IdleBlink",8,false);
         image.ON_COMPLETE.add(this.onBlink);
         image.centerOrigin();
         image.originY = image.height;
         image.y = body.height / 2;
         add(image);
         image.play("stand");
         ON_UPDATE.add(this.onUpdate);
         hp = 2;
      }
      
      private function onBlink() : void
      {
         (image as AnimationRenderer).play(Rand.chance(0.2) ? "blink" : "stand");
      }
      
      private function onUpdate() : void
      {
         if(player.x != x)
         {
            this.side = Calc.sign(player.x - x);
         }
         if(Calc.sign(image.scaleX) != this.side)
         {
            tween(image,0.4).scaleFrom(0.7 * this.side,1).scaleTo(1 * this.side,1).ease(Ease.backOut);
         }
      }
   }
}

