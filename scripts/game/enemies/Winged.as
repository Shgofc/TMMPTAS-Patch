package game.enemies
{
   import flash.geom.Point;
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Ease;
   import flashpunk2.global.Rand;
   
   public class Winged extends Enemy
   {
      
      private var nodes:Vector.<Point>;
      
      private var currentNode:int = 0;
      
      private var side:int = 1;
      
      public function Winged(param1:XML, param2:String)
      {
         var _loc3_:XML = null;
         super(param1.@x,param1.@y,32,32,true);
         _xSpeed = 0;
         _ySpeed = 0;
         gravity = 0;
         image = new AnimationRenderer();
         image.addPrefix("stand","enemies/" + param2 + "Idle",10,false);
         image.addPrefix("blink","enemies/" + param2 + "IdleBlink",8,false);
         image.ON_COMPLETE.add(this.onBlink);
         image.play("stand");
         image.centerOrigin();
         add(image);
         this.nodes = new Vector.<Point>();
         this.nodes.push(new Point(param1.@x,param1.@y));
         for each(_loc3_ in param1.node)
         {
            this.nodes.push(new Point(int(_loc3_.@x) + 16,int(_loc3_.@y) + 16));
         }
         ON_UPDATE.add(this.onUpdate);
      }
      
      private function onBlink() : void
      {
         (image as AnimationRenderer).play(Rand.chance(0.14) ? "blink" : "stand");
      }
      
      private function onUpdate() : void
      {
         var _loc1_:Point = this.nodes[this.currentNode + 1 < this.nodes.length ? this.currentNode + 1 : 0];
         var _loc2_:Point = new Point(x,y);
         var _loc3_:Point = _loc1_.subtract(_loc2_);
         _loc3_.normalize(150);
         _xSpeed = _loc3_.x;
         _ySpeed = _loc3_.y;
         if(Math.abs(xSpeed) > 5)
         {
            this.side = xSpeed > 0 ? 1 : -1;
            if(Calc.sign(image.scaleX) != this.side)
            {
               tween(image,0.4,null,false).scaleFrom(0.7 * this.side,1).scaleTo(1 * this.side,1).ease(Ease.backOut);
            }
         }
         if(Calc.distance(x,y,this.nodes[this.currentNode + 1 < this.nodes.length ? this.currentNode + 1 : 0].x,this.nodes[this.currentNode + 1 < this.nodes.length ? this.currentNode + 1 : 0].y) < 2)
         {
            ++this.currentNode;
            if(this.currentNode >= this.nodes.length)
            {
               this.currentNode = 0;
            }
         }
      }
      
      override public function onBounced(param1:int) : Boolean
      {
         var jumpDamage:int = param1;
         var ret:Boolean = super.onBounced(jumpDamage);
         tween(this,0.1,null,false).onComplete(function():void
         {
            takingHit = false;
         });
         return ret;
      }
      
      override public function takeHit(param1:int, param2:int) : void
      {
         super.takeHit(param1 * 5,param2);
      }
   }
}

