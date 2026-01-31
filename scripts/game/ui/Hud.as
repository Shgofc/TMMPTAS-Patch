package game.ui
{
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.BitmapTextRenderer;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.components.timing.Tween;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Ease;
   import game.Constants;
   import game.UserData;
   import game.player.Player;
   import game.world.PlatformLevel;
   import sound.MusicPlayer;
   
   public class Hud extends Entity
   {
      
      private static const HEART_BORDER:Number = 25;
      
      private static const HEART_BORDER_X:Number = 85;
      
      public var superJump:Boolean;
      
      public var superSpeed:Boolean;
      
      public var superInvenc:Boolean;
      
      public var superHeavy:Boolean;
      
      private var superJumpImage:ImageRenderer;
      
      private var superSpeedImage:ImageRenderer;
      
      private var superInvencImage:ImageRenderer;
      
      private var superHeavyImage:ImageRenderer;
      
      private var musicOn:Button;
      
      private var player:Player;
      
      private var hearts:Vector.<ImageRenderer> = new Vector.<ImageRenderer>();
      
      private var pumping:Tween;
      
      private var hudBg:ImageRenderer;
      
      private var coinCounter:BitmapTextRenderer;
      
      private var keyCounter:BitmapTextRenderer;
      
      private var updated:Boolean;
      
      private var musicOff:Button;
      
      private var oxigen:ImageRenderer;
      
      private var oxigenPointer:ImageRenderer;
      
      private var showingOxigen:Boolean = false;
      
      public function Hud(param1:Player)
      {
         super();
         this.player = param1;
         this.hudBg = new ImageRenderer("interface/hudHolder");
         this.hudBg.scroll = 0;
         add(this.hudBg);
         this.generateHearts();
         this.updateCoins();
         this.updateKeys();
         depth = -1100;
         ON_UPDATE.add(this.OnUpdate);
         add(this.superJumpImage = new ImageRenderer("interface/stats_jump",false));
         this.superJumpImage.x = 480;
         this.superJumpImage.scroll = 0;
         add(this.superHeavyImage = new ImageRenderer("interface/stats_heavy",false));
         this.superHeavyImage.x = 480;
         this.superHeavyImage.scroll = 0;
         add(this.superInvencImage = new ImageRenderer("interface/stats_invenc",false));
         this.superInvencImage.x = 480;
         this.superInvencImage.scroll = 0;
         add(this.superSpeedImage = new ImageRenderer("interface/stats_rapido",false));
         this.superSpeedImage.x = 480;
         this.superSpeedImage.scroll = 0;
         add(this.oxigen = new ImageRenderer("interface/oxigen",false));
         this.oxigen.setPosition(Constants.STAGE_WIDTH,Constants.STAGE_HEIGHT - this.oxigen.height);
         this.oxigen.scroll = 0;
         add(this.oxigenPointer = new ImageRenderer("interface/oxigenPointer",true));
         this.oxigenPointer.setPosition(Constants.STAGE_WIDTH + this.oxigenPointer.width / 2 + 10,Constants.STAGE_HEIGHT - this.oxigenPointer.height / 2);
         this.oxigenPointer.scroll = 0;
         ON_START.add(this.onStart);
      }
      
      private function onStart() : void
      {
         world.add(this.musicOn = new Button(600,8,new ImageRenderer("interface/music",true),this.switchMusic));
         world.add(this.musicOff = new Button(600,8,new ImageRenderer("interface/noMusic",true),null));
         var _loc1_:Button = new Button(560,8,new ImageRenderer("interface/pause",true),this.pauseGame);
         world.add(_loc1_);
         _loc1_.depth = this.musicOff.depth = this.musicOn.depth = depth;
         this.UpdateMusic();
      }
      
      private function switchMusic() : void
      {
         UserData.switchMusic();
         this.UpdateMusic();
         MusicPlayer.updateMusicOptions();
      }
      
      private function pauseGame() : void
      {
         (world as PlatformLevel).pauseGame();
      }
      
      public function showOxigen(param1:int) : void
      {
         if(this.player.breath <= 10)
         {
            if(!this.showingOxigen)
            {
               world.tween(this.oxigen,0.7).to("x",Constants.STAGE_WIDTH - this.oxigen.width).ease(Ease.elasticOut).onUpdate(this.oxigen.updateCamera);
               world.tween(this.oxigenPointer,0.7).to("x",Constants.STAGE_WIDTH - this.oxigen.width / 2 + 3).ease(Ease.elasticOut).onUpdate(this.oxigenPointer.updateCamera);
               this.showingOxigen = true;
            }
         }
         else
         {
            this.hideOxigen();
         }
      }
      
      public function hideOxigenNow() : void
      {
         this.oxigenPointer.x = Constants.STAGE_WIDTH + this.oxigenPointer.width / 2 + 5;
         this.oxigen.x = Constants.STAGE_WIDTH;
      }
      
      public function hideOxigen() : void
      {
         if(this.showingOxigen)
         {
            this.showingOxigen = false;
            world.tween(this.oxigenPointer,0.8).delay(1).ease(Ease.backIn).moveTo(Constants.STAGE_WIDTH + this.oxigenPointer.width / 2 + 5,this.oxigenPointer.y).onUpdate(this.oxigenPointer.updateCamera);
            world.tween(this.oxigen,0.8).delay(1).ease(Ease.backIn).to("x",Constants.STAGE_WIDTH).onUpdate(this.oxigen.updateCamera);
         }
      }
      
      private function OnUpdate() : void
      {
         this.updated = false;
         this.superJumpImage.visible = this.superJump;
         this.superHeavyImage.visible = this.superHeavy;
         this.superSpeedImage.visible = this.superSpeed;
         this.superInvencImage.visible = this.superInvenc;
         this.oxigenPointer.angle = Calc.lerp(this.oxigenPointer.angle,Calc.scale(this.player.breath,0,10,355,10),0.2);
      }
      
      public function UpdateMusic() : void
      {
         if(UserData.playMusic)
         {
            this.musicOff.visible = false;
            this.musicOn.visible = true;
         }
         else
         {
            this.musicOff.visible = true;
            this.musicOn.visible = false;
         }
      }
      
      public function updateCoins() : void
      {
         if(this.coinCounter != null)
         {
            this.coinCounter.removeSelf();
         }
         var _loc1_:String = UserData.gold > 0 ? UserData.gold.toString() : "Nada!";
         this.coinCounter = new BitmapTextRenderer(70,28,_loc1_,"font",28,0,true);
         this.coinCounter.x = 322;
         this.coinCounter.y = HEART_BORDER - 4;
         this.coinCounter.scroll = 0;
         addComponent(this.coinCounter);
      }
      
      public function updateKeys() : void
      {
         if(this.keyCounter != null)
         {
            this.keyCounter.removeSelf();
         }
         var _loc1_:String = UserData.keys > 0 ? UserData.keys.toString() : "0";
         this.keyCounter = new BitmapTextRenderer(70,28,_loc1_,"font",28,0,true);
         this.keyCounter.x = 442;
         this.keyCounter.y = HEART_BORDER - 4;
         this.keyCounter.scroll = 0;
         addComponent(this.keyCounter);
      }
      
      public function updateHearts(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         if(!this.updated || param1)
         {
            this.updated = true;
            cancelAllTweens();
            _loc2_ = 0;
            while(_loc2_ < this.player.maxHp / 2)
            {
               if(this.player.hp < (_loc2_ + 1) * 2)
               {
                  if(this.player.hp < (_loc2_ + 1) * 2 - 1)
                  {
                     this.hearts[_loc2_].setSource("interface/emptyHeart");
                  }
                  else
                  {
                     this.hearts[_loc2_].setSource("interface/halfHeart");
                  }
               }
               else
               {
                  this.hearts[_loc2_].setSource("interface/fullHeart");
               }
               this.hearts[_loc2_].setScale(1,1);
               _loc2_++;
            }
            if(this.player.hp > 0)
            {
               this.pumping = tween(this.hearts[Math.floor((this.player.hp - 1) / 2)],0.5).scaleFrom(1.2,1.2).scaleTo(1,1).ease(Ease.backInOut).repeat(-1);
            }
         }
      }
      
      public function generateHearts() : void
      {
         var _loc1_:ImageRenderer = null;
         var _loc2_:int = 0;
         var _loc3_:ImageRenderer = null;
         cancelAllTweens();
         for each(_loc1_ in this.hearts)
         {
            _loc1_.removeSelf();
         }
         this.hearts = new Vector.<ImageRenderer>();
         _loc2_ = 0;
         while(_loc2_ < this.player.maxHp / 2)
         {
            _loc3_ = new ImageRenderer("interface/fullHeart");
            _loc3_.x = _loc2_ * (_loc3_.width * 0.8) + HEART_BORDER_X;
            _loc3_.y = HEART_BORDER;
            _loc3_.centerOrigin();
            _loc3_.scroll = 0;
            this.hearts.push(_loc3_);
            add(_loc3_);
            _loc2_++;
         }
      }
   }
}

