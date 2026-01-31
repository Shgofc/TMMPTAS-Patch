package game.environment
{
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.BGRenderer;
   
   public class BackgroundImage extends Entity
   {
      
      public function BackgroundImage(param1:String, param2:Number = 0.8)
      {
         super();
         if(param1 == "none")
         {
            return;
         }
         var _loc3_:BGRenderer = new BGRenderer(param1,true,true);
         _loc3_.scroll = param2;
         addComponent(_loc3_);
         depth = 200;
      }
   }
}

