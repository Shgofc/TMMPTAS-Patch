package game.collectibles
{
   import flashpunk2.components.rendering.ImageRenderer;
   import game.UserData;
   import game.player.Player;
   
   public class Respirador extends Collectible
   {
      
      private var id:int;
      
      private var levelName:String;
      
      public function Respirador(param1:int, param2:int, param3:String, param4:int)
      {
         super(param1,param2,true);
         this.id = param4;
         this.levelName = param3;
         var _loc5_:ImageRenderer = new ImageRenderer("environment/respirador",true);
         add(_loc5_);
         _xSpeed = _ySpeed = 0;
      }
      
      override public function collect(param1:Player) : void
      {
         UserData.setTrigger("respirador" + this.levelName + this.id.toString());
         UserData.setTrigger("respirador");
         param1.updateSpecial();
         level.showMessage("Você achou o Re-Respirador!","Agora você pode respirar embaixo da água!");
      }
   }
}

