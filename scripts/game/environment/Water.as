package game.environment
{
   import flash.geom.Rectangle;
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.components.rendering.RectRenderer;
   import flashpunk2.global.Ease;
   import game.player.Player;
   import game.world.PlatformLevel;
   
   public class Water extends Entity
   {
      
      private var body:Rectangle;
      
      private var playerIn:Boolean = false;
      
      private var image:RectRenderer;
      
      private var i:int;
      
      private var WasOnWater:Boolean = false;
      
      private var LastX:int;
      
      private var Speed:Number;
      
      private var Shake:Number;
      
      public var waves:Vector.<AnimationRenderer>;
      
      public function Water(param1:int, param2:int, param3:int, param4:int)
      {
         var _loc6_:AnimationRenderer = null;
         this.waves = new Vector.<AnimationRenderer>();
         super(param1,param2 + 8);
         ON_UPDATE.add(this.onUpdate);
         this.body = new Rectangle(param1,param2 + 8,param3,param4);
         this.image = new RectRenderer(param3 + 16,param4 - 16,6207724);
         this.image.setOrigin(param3 / 2,param4);
         this.image.setPosition(param3 / 2 - 8,param4 + 16);
         this.image.alpha = 0.7;
         add(this.image);
         var _loc5_:int = -8;
         while(_loc5_ < param3 + 8)
         {
            _loc6_ = new AnimationRenderer();
            _loc6_.addPrefix("flow","environment/water",10,true);
            _loc6_.play("flow");
            _loc6_.x = _loc5_ - _loc6_.width / 2;
            _loc6_.y = 0;
            _loc6_.alpha = 0.9;
            this.waves.push(_loc6_);
            add(_loc6_);
            _loc5_ += 16;
         }
         depth = -5;
      }
      
      public function get player() : Player
      {
         return (world as PlatformLevel).player;
      }
      
      private function onUpdate() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         if(this.player.body.intersects(this.body))
         {
            if(!this.WasOnWater)
            {
               this.WasOnWater = true;
               this.Shake = 0;
               this.Speed = 2;
               this.LastX = this.player.x;
               this.player.onEnterWater(this);
            }
            this.Speed *= 0.995;
            this.Shake += 0.2;
            _loc2_ = (this.LastX - this.x) / 16;
            _loc1_ = 0;
            while(_loc1_ < this.waves.length)
            {
               _loc4_ = Math.abs(_loc1_ - _loc2_) * 1.2 + this.Shake;
               _loc3_ = int(4 + 7 * (_loc4_ != 0 ? Math.sin(_loc4_) / _loc4_ : 1) * this.Speed);
               if(_loc3_ < 0)
               {
                  _loc3_ = 0;
               }
               if(_loc3_ > 7)
               {
                  _loc3_ = 7;
               }
               this.waves[_loc1_].y = _loc3_ - 8;
               _loc1_++;
            }
         }
         else if(this.WasOnWater)
         {
            this.WasOnWater = false;
            this.player.onExitWater();
         }
         else
         {
            this.Speed *= 0.995;
            this.Shake += 0.1;
            _loc2_ = (this.LastX - this.x) / 16;
            _loc1_ = 0;
            while(_loc1_ < this.waves.length)
            {
               _loc4_ = Math.abs(_loc1_ - _loc2_) * 2 + this.Shake;
               _loc3_ = int(4 + 7 * (_loc4_ != 0 ? Math.sin(_loc4_) / _loc4_ : 1) * this.Speed);
               if(_loc3_ < 0)
               {
                  _loc3_ = 0;
               }
               if(_loc3_ > 7)
               {
                  _loc3_ = 7;
               }
               this.waves[_loc1_].y = _loc3_ - 4;
               _loc1_++;
            }
         }
      }
      
      private function onUpdate2() : void
      {
         var _loc1_:AnimationRenderer = null;
         var _loc2_:Number = NaN;
         if(this.player.body.intersects(this.body))
         {
            if(!this.playerIn)
            {
               this.playerIn = true;
               this.player.onWater = this;
               this.i = -8;
               for each(_loc1_ in this.waves)
               {
                  _loc2_ = Math.abs(_loc1_.x - this.player.x) * (this.waves.length * 0.1) != 0 ? Math.abs(_loc1_.x - this.player.x) * (this.waves.length * 0.1) : 0.1;
                  tween(_loc1_,_loc2_).moveFrom(this.i,_loc1_.y).moveTo(this.i,-6).ease(Ease.elasticOut);
                  this.i += 16;
               }
            }
         }
         else if(this.playerIn)
         {
            this.playerIn = false;
            this.player.onWater = null;
            this.player.applySpeedDamping(1,0.85);
            this.i = -8;
            for each(_loc1_ in this.waves)
            {
               _loc2_ = Math.abs(x + _loc1_.x - this.player.x) * (this.waves.length * 0.1) != 0 ? Math.abs(_loc1_.x - this.player.x) * (this.waves.length * 0.1) : 0.1;
               tween(_loc1_,_loc2_).moveFrom(this.i,_loc1_.y).moveTo(this.i,0).ease(Ease.elasticOut);
               this.i += 16;
            }
         }
      }
   }
}

