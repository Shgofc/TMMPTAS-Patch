package game.collectibles
{
   import flashpunk2.components.rendering.ImageRenderer;
   import game.UserData;
   import game.player.Player;
   
   public class Goggles extends Collectible
   {
      
      private var levelName:String;
      
      private var id:int;
      
      public function Goggles(param1:int, param2:int, param3:String, param4:int)
      {
         super(param1,param2,true);
         this.id = param4;
         this.levelName = param3;
         var _loc5_:ImageRenderer = new ImageRenderer("environment/gogglesCollect",true);
         add(_loc5_);
         _xSpeed = _ySpeed = 0;
      }
      
      override public function collect(param1:Player) : void
      {
         UserData.setTrigger("goggles" + this.levelName + this.id.toString());
         UserData.setTrigger("goggles");
         level.showMessage("Você pegou uma Óculos Alienígena!","Agora você pode enxergar muito mais longe no escuro.");
      }
   }
}

