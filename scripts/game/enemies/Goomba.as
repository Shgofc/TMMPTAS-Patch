package game.enemies
{
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Ease;
   import flashpunk2.global.Rand;
   
   public class Goomba extends Enemy
   {
      
      private var speed:Number = 2;
      
      private var side:int = -1;
      
      private var type:String;
      
      public function Goomba(param1:int, param2:int, param3:int, param4:String)
      {
         super(param1,param2,28,28);
         this.type = param4;
         this.side = param3;
         image = new AnimationRenderer();
         image.addPrefix("stand","enemies/" + param4 + "Idle",10,true);
         image.addPrefix("blink","enemies/" + param4 + "IdleBlink",8,false);
         image.ON_COMPLETE.add(this.onBlink);
         image.centerOrigin();
         image.originY = image.height;
         image.y = body.height / 2;
         add(image);
         image.play("stand");
         switch(param4)
         {
            case "snake2":
               hp = 1;
               this.speed = 1.1;
               break;
            case "snake3":
               hp = 3;
               this.speed = 2;
         }
         ON_UPDATE.add(this.onUpdate);
      }
      
      private function onBlink() : void
      {
         (image as AnimationRenderer).play(Rand.chance(0.2) ? "blink" : "stand");
      }
      
      private function onUpdate() : void
      {
         var _loc1_:Boolean = false;
         if(!takingHit)
         {
            _loc1_ = false;
            if(willCollide(x + this.speed * this.side,y))
            {
               _loc1_ = true;
            }
            if(!willCollide(x + body.width * this.side,y + 1))
            {
               willCollide(x + body.width * this.side,y + 1);
               _loc1_ = true;
            }
            if(!_loc1_)
            {
               x += this.speed * this.side;
            }
            else
            {
               this.side = -this.side;
            }
         }
         if(Calc.sign(image.scaleX) != this.side)
         {
            tween(image,0.4).scaleFrom(0.7 * this.side,1).scaleTo(1 * this.side,1).ease(Ease.backOut);
         }
      }
   }
}

