package game.environment
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.global.Debug;
   import flashpunk2.global.Ease;
   import flashpunk2.global.Rand;
   import game.Controls;
   import game.UserData;
   import game.world.PlatformLevel;
   import game.world.ShopLevel;
   
   public class Door extends Entity
   {
      
      private var goY:int;
      
      private var goX:int;
      
      private var _uid:int;
      
      private var _body:Rectangle;
      
      private var shop:String;
      
      private var oneWay:Boolean;
      
      private var locked:Boolean;
      
      private var image:ImageRenderer;
      
      private var noEnemies:Boolean;
      
      private var fading:Boolean = false;
      
      public function Door(param1:int, param2:int, param3:int, param4:int, param5:int, param6:String, param7:Boolean, param8:Boolean, param9:Boolean)
      {
         this.noEnemies = param9;
         this.locked = param7;
         this.oneWay = param8;
         this.shop = param6;
         this._uid = param3;
         this.goX = param4;
         this.goY = param5;
         super(param1 + 24,param2 + 24);
         if(!param8)
         {
            ON_UPDATE.add(this.waitForRelease);
         }
         if(param9)
         {
            ON_UPDATE.add(this.onNoEnemies);
            setScale(0,0);
         }
         depth = 2;
         ON_DEBUG.add(this.onDebug);
         ON_START.add(this.onStart);
      }
      
      public function get uid() : int
      {
         return this._uid;
      }
      
      public function get body() : Rectangle
      {
         return this._body;
      }
      
      private function onStart() : void
      {
         this.UpdateImage();
         if(this.oneWay)
         {
            this.SelfDestruct();
         }
      }
      
      private function onNoEnemies() : void
      {
         if(this.noEnemies)
         {
            if((world.getEntitiesByGroup(Groups.ENEMY) as Array).length == 0)
            {
               this.noEnemies = false;
               tween(this,1).scaleTo(1,1).ease(Ease.elasticOut);
            }
         }
      }
      
      private function onDebug() : void
      {
         if(this.body != null)
         {
            Debug.drawRectOutline(this.body.x,this.body.y,this.body.width,this.body.height,16777215);
         }
      }
      
      private function SelfDestruct() : void
      {
         if(!this.fading)
         {
            ON_START.add(function():void
            {
               tween(image,0.5).delay(0.5).scaleTo(0,0).onComplete(removeSelf).ease(Ease.backOut);
            });
            this.fading = true;
         }
      }
      
      private function waitForRelease() : void
      {
         if(Controls.AXIS.y > -0.1)
         {
            this._body = new Rectangle(x - 20,y,40,40);
            ON_UPDATE.remove(this.waitForRelease);
         }
      }
      
      private function UpdateImage() : void
      {
         if(this.locked && UserData.doorLocked(this._uid))
         {
            this.image = new ImageRenderer("environment/doorLocked" + Rand.getInt(2).toString(),false);
         }
         else if(this.shop == "")
         {
            this.image = new ImageRenderer("environment/door",false);
         }
         else
         {
            this.image = new ImageRenderer("environment/doorShop" + Rand.getIntRange(0,3).toString(),false);
            if(UserData.getTrigger(this.shopTag))
            {
               this.SelfDestruct();
            }
         }
         this.image.centerOrigin();
         add(this.image);
      }
      
      public function onEnter() : void
      {
         var _loc1_:PlatformLevel = null;
         if(!this.noEnemies)
         {
            if(this.locked && UserData.doorLocked(this.uid))
            {
               if(UserData.hasKey())
               {
                  this.locked = false;
                  UserData.useKey();
                  UserData.unlockDoor(this.uid);
                  this.UpdateImage();
               }
            }
            else if(this.shop == "")
            {
               PlatformLevel.gotoLevel(this.goX,this.goY,PlatformLevel.DOOR,this.uid);
            }
            else
            {
               _loc1_ = world as PlatformLevel;
               engine.setWorld(new ShopLevel(this.shop,new Point(_loc1_.x,_loc1_.y),this.uid,this.shopTag));
            }
         }
      }
      
      public function get shopTag() : String
      {
         return "shop_" + this.shop + "_" + (world as PlatformLevel).x.toString() + "_" + (world as PlatformLevel).y.toString() + "_" + this.uid.toString();
      }
   }
}

