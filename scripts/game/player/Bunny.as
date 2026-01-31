package game.player
{
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flashpunk2.Entity;
   import flashpunk2.components.physics.BoxCollider;
   import flashpunk2.components.physics.DynamicBody;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.global.Asset;
   import nape.constraint.PivotJoint;
   import nape.geom.Vec2;
   
   public class Bunny extends Entity
   {
      
      private var carrier:Player;
      
      private var dictionary:Dictionary;
      
      private var image:ImageRenderer;
      
      private var pivot:PivotJoint;
      
      private var attacking:int = 0;
      
      private var swoosh:ImageRenderer;
      
      private var lastFrame:String;
      
      public function Bunny(param1:Player)
      {
         var _loc4_:XML = null;
         super(param1.x,param1.y + 8,this.onUpdate);
         this.carrier = param1;
         this.image = new ImageRenderer("player/bunnyMain0",false);
         this.image.originX = this.image.width / 2;
         this.image.originY = 20;
         this.image.angle = 90;
         add(this.image);
         this.swoosh = new ImageRenderer("player/bunnySwoosh",false);
         this.swoosh.originX = this.image.width / 2;
         this.swoosh.originY = 20;
         add(this.swoosh);
         this.swoosh.visible = false;
         var _loc2_:BoxCollider = new BoxCollider(this.image.width,this.image.height,false);
         add(new DynamicBody(true,true,true));
         add(_loc2_);
         this.dictionary = new Dictionary();
         var _loc3_:XML = Asset.getXMLByType(Assets.SPRITE_DATA).xml["bunny"]["position"][0];
         for each(_loc4_ in _loc3_.children())
         {
            this.dictionary[_loc4_.name()] = new Point(_loc4_.@x,_loc4_.@y);
         }
         depth = -1;
         ON_START.add(this.onStart);
      }
      
      public function attack() : void
      {
         rigidBody.angle = this.carrier.side != 1 ? 180 : 0;
         rigidBody.angularVelocity = 0;
         this.attacking = 15;
         this.swoosh.visible = true;
         this.swoosh.scaleX = this.carrier.side;
      }
      
      public function destroy() : void
      {
         removeSelf();
      }
      
      private function onStart() : void
      {
         this.pivot = new PivotJoint(physics.space.world,rigidBody.body,Vec2.weak(),new Vec2(width / 2 - 2,0));
         this.pivot.space = world.physics.space;
         physics.gravityY = 800;
      }
      
      private function onUpdate() : void
      {
         var _loc1_:Point = null;
         if(this.carrier.currentFrame != "")
         {
            _loc1_ = this.dictionary[this.carrier.currentFrame];
            this.lastFrame = this.carrier.currentFrame;
         }
         else
         {
            _loc1_ = this.dictionary[this.lastFrame];
         }
         this.pivot.anchor1.setxy(this.carrier.imageX + _loc1_.x * this.carrier.side,this.carrier.imageY + _loc1_.y + 8);
         rigidBody.angularVelocity *= 0.25;
         if(this.attacking > 0)
         {
            --this.attacking;
            rigidBody.angle = this.carrier.side == 1 ? 180 : 0;
            rigidBody.angularVelocity = 0;
            this.swoosh.angle = -rigidBody.angle;
            this.swoosh.alpha = 1 - (15 - this.attacking) / 15;
         }
         else
         {
            this.swoosh.visible = false;
         }
      }
   }
}

