package game.collectibles
{
   import flashpunk2.components.rendering.ImageRenderer;
   import game.UserData;
   import game.player.Player;
   import sound.SoundManager;
   
   public class Coin extends Collectible
   {
      
      public function Coin(param1:int, param2:int)
      {
         super(param1,param2);
         var _loc3_:ImageRenderer = new ImageRenderer("coin",true);
         add(_loc3_);
      }
      
      override public function collect(param1:Player) : void
      {
         UserData.collectGold(1);
         level.hud.updateCoins();
         SoundManager.playSound("coin");
      }
   }
}

