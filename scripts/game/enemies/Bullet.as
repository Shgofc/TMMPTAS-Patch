package game.enemies
{
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.global.Calc;
   
   public class Bullet extends Enemy
   {
      
      private var moving:Boolean = false;
      
      public function Bullet(param1:int, param2:int)
      {
         super(param1,param2,32,32,true);
         gravity = 0;
         image = new AnimationRenderer();
         image.addPrefix("stand","enemies/flyer2Idle",18,true);
         image.play("stand");
         image.centerOrigin();
         add(image);
         ON_UPDATE.add(this.onUpdate);
         hp = 1;
      }
      
      private function onUpdate() : void
      {
         image.scaleX = _xSpeed > 0 ? 1 : -1;
         if(camera.x + camera.width >= x - image.width && camera.x < x + image.width * 2 && !this.moving)
         {
            _xSpeed = Calc.sign(level.player.x - x) * 210;
            image.scaleX = Calc.sign(level.player.x - x);
            if(xSpeed != 0)
            {
               this.moving = true;
            }
         }
      }
      
      override public function onHorizontalCollide() : void
      {
         _xSpeed *= -1;
      }
   }
}

