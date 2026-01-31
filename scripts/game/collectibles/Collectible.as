package game.collectibles
{
   import flash.geom.Rectangle;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.global.Ease;
   import flashpunk2.global.Rand;
   import game.PlatformObject;
   import game.player.Player;
   import sound.SoundManager;
   
   public class Collectible extends PlatformObject
   {
      
      private var initialYSpeed:Number;
      
      private var bounces:int = 3;
      
      private var canBeCollected:Boolean = false;
      
      private var collected:Boolean = false;
      
      private var glow:ImageRenderer;
      
      public function Collectible(param1:int, param2:int, param3:Boolean = false)
      {
         super(param1,param2,20,20);
         this.Jump();
         if(param3)
         {
            this.glow = new ImageRenderer("fx/glow",true);
            this.glow.alpha = 0.3;
            add(this.glow);
            tween(this.glow,2).from("angle",0).to("angle",360).repeat(-1);
         }
      }
      
      public function intersect(param1:Player) : void
      {
         if(this.canBeCollected && !this.collected)
         {
            this.collect(param1);
            this.canBeCollected = false;
            this.collected = true;
            _body = new Rectangle();
            ON_UPDATE.clear();
            cancelAllTweens();
            tween(this,0.3).ease(Ease.backIn).scaleTo(0,0).onComplete(removeSelf);
         }
      }
      
      public function collect(param1:Player) : void
      {
      }
      
      override protected function onHitGround() : void
      {
         super.onHitGround();
         this.canBeCollected = true;
         if(this.bounces > 0)
         {
            _xSpeed = 0;
            _ySpeed = this.initialYSpeed * (this.bounces / 3);
            --this.bounces;
            SoundManager.playSound("clink",0.5);
         }
      }
      
      public function Jump(param1:Number = 1) : void
      {
         this.initialYSpeed = _ySpeed = Rand.getNumberRange(-100,-200);
         _xSpeed = Rand.getNumberRange(-150,150);
      }
   }
}

