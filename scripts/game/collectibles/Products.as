package game.collectibles
{
   import game.UserData;
   import game.player.Player;
   import game.world.PlatformLevel;
   
   public class Products
   {
      
      public var title:String;
      
      public var description:String;
      
      public var imageIndex:int;
      
      public var price:int;
      
      public var name:String;
      
      public function Products(param1:String, param2:String, param3:int, param4:int, param5:String)
      {
         super();
         this.description = param5;
         this.imageIndex = param4;
         this.title = param2;
         this.name = param1;
         this.price = param3;
      }
      
      public function onUse() : void
      {
         var _loc1_:Player = PlatformLevel.currentLevel.player;
         _loc1_.superJump = 0;
         _loc1_.superHeavy = 0;
         _loc1_.superInvenc = 0;
         _loc1_.superSpeed = 0;
         switch(this.name)
         {
            case "suco":
               _loc1_.modHp(2);
               break;
            case "vitamina":
               _loc1_.modHp(6);
               break;
            case "puloAlto":
               _loc1_.superJump = 15;
               break;
            case "velocidade":
               _loc1_.superSpeed = 30 * 60;
               break;
            case "invencivel":
               _loc1_.superInvenc = 20 * 60;
               break;
            case "pesada":
               _loc1_.superHeavy = 30 * 60;
               break;
            case "coracao":
               _loc1_.getUltraVitamin();
               break;
            case "oculos":
               UserData.setTrigger("goggles");
         }
      }
   }
}

