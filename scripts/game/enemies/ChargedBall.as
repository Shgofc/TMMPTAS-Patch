package game.enemies
{
   import flash.geom.Point;
   
   public class ChargedBall extends Projectile
   {
      
      private var owner:Enemy;
      
      private var reverse:Boolean = false;
      
      public function ChargedBall(param1:int, param2:int, param3:Number, param4:Number, param5:Enemy)
      {
         super(param1,param2,"fx/chargedShot",param3,param4);
         this.owner = param5;
      }
      
      override public function takeHit() : void
      {
         var _loc1_:Point = null;
         if(!this.reverse)
         {
            this.reverse = true;
            _loc1_ = new Point(this.owner.x,this.owner.y).subtract(new Point(x,y));
            _loc1_.normalize(9);
            xSpeed = _loc1_.x;
            ySpeed = _loc1_.y;
            ON_UPDATE.add(this.seekAndDestroy);
            tween(image,1,null,false).scaleFrom(1,1).scaleTo(0.8,0.8).repeat(-1,true);
         }
      }
      
      private function seekAndDestroy() : void
      {
         if(this.owner.body.intersects(body))
         {
            onHit();
            this.owner.takeHit(2,-1);
         }
      }
   }
}

