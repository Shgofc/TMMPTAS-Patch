package game.environment
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.global.Debug;
   import flashpunk2.global.Ease;
   import flashpunk2.global.Rand;
   import game.UserData;
   import game.collectibles.Coin;
   import game.collectibles.Collectible;
   import game.collectibles.Gem;
   import game.world.PlatformLevel;
   
   public class Chest extends Entity
   {
      
      private var _body:Rectangle;
      
      private var hp:int = 1;
      
      private var takingHit:Boolean = false;
      
      private var image:AnimationRenderer;
      
      private var contains:Collectible;
      
      private var uid:String;
      
      public var open:Boolean = false;
      
      public function Chest(param1:int, param2:int, param3:String, param4:Collectible = null)
      {
         super(param1 + 4,param2 + 4);
         this.uid = param3;
         this.contains = param4;
         this.image = new AnimationRenderer();
         this.image.addPrefix("closed","environment/chestClosed",10,false);
         this.image.addPrefix("open","environment/chestOpen",10,false);
         if(UserData.getTrigger("chest" + param3))
         {
            this.image.play("open");
            this.open = true;
         }
         else
         {
            this.image.play("closed");
            this.open = false;
         }
         this.image.centerOrigin();
         this.image.x += this.image.width / 2;
         this.image.y += this.image.height / 2;
         add(this.image);
         this._body = new Rectangle(this.x,this.y,30,30);
         this._body.y += this.body.height / 2 + this.image.height / 4;
         this._body.x += this.body.width / 2;
         ON_DEBUG.add(this.onDebug);
         depth = 2;
      }
      
      public function get body() : Rectangle
      {
         return this._body;
      }
      
      private function onDebug() : void
      {
         Debug.drawRectOutline(this.body.x,this.body.y,this.body.width,this.body.height,16777215);
      }
      
      public function onTakeHit() : void
      {
         var point:Point = null;
         if(!this.takingHit && !this.open)
         {
            if(this.uid != "none")
            {
               UserData.setTrigger("chest" + this.uid);
            }
            this.takingHit = true;
            --this.hp;
            point = new Point(this.image.x,this.image.y);
            tween(this.image,0.4).moveFrom(point.x,point.y - 10).moveTo(point.x,point.y).ease(Ease.bounceOut).onComplete(this.onHitGround);
            tween(this.image,0.4,null,false).scaleFrom(0.9,1.1).scaleTo(1,1).ease(Ease.cubeOut);
            if(this.hp <= 0)
            {
               this.image.play("open");
               this.open = true;
               if(this.contains == null)
               {
                  tween(this,0.1).repeat(9).onComplete(function():void
                  {
                     switch(Rand.getInt(4))
                     {
                        case 3:
                           world.add(new Gem(body.x + body.width / 2 + 8,body.y));
                           break;
                        default:
                           world.add(new Coin(body.x + body.width / 2 + 8,body.y));
                     }
                  });
                  (world as PlatformLevel).randomLoot(this.body.x + this.body.width / 2 + 8,this.body.y);
               }
               else
               {
                  world.add(this.contains);
                  this.contains.setPosition(x + this.body.width / 2 + 16,y);
                  this.contains.Jump(0.5);
               }
            }
         }
      }
      
      private function onHitGround() : void
      {
         this.takingHit = false;
      }
   }
}

