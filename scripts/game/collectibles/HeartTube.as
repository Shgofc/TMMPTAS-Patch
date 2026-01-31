package game.collectibles
{
   import flashpunk2.components.rendering.ImageRenderer;
   import game.UserData;
   import game.player.Player;
   
   public class HeartTube extends Collectible
   {
      
      private var id:int;
      
      private var levelName:String;
      
      public function HeartTube(param1:int, param2:int, param3:String, param4:int)
      {
         super(param1,param2,true);
         this.levelName = param3;
         this.id = param4;
         var _loc5_:ImageRenderer = new ImageRenderer("environment/heartCollect",true);
         add(_loc5_);
         _xSpeed = _ySpeed = 0;
      }
      
      override public function collect(param1:Player) : void
      {
         UserData.setTrigger("heart" + this.levelName + this.id.toString());
         param1.getUltraVitamin();
         level.showMessage("Você pegou uma Ultra-Vitamina Alienígena!","Você ganhou mais um coração!");
      }
   }
}

