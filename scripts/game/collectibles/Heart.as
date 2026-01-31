package game.collectibles
{
   import flashpunk2.components.rendering.ImageRenderer;
   import game.player.Player;
   import sound.SoundManager;
   
   public class Heart extends Collectible
   {
      
      public function Heart(param1:int, param2:int)
      {
         super(param1,param2);
         var _loc3_:ImageRenderer = new ImageRenderer("interface/fullHeart",true);
         add(_loc3_);
      }
      
      override public function collect(param1:Player) : void
      {
         param1.modHp(2);
         SoundManager.playSound("heart");
      }
   }
}

