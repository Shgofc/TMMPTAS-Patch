package game.fx
{
   import flashpunk2.Entity;
   import flashpunk2.global.Asset;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Time;
   import game.Constants;
   import game.world.PlatformLevel;
   import starling.display.BlendMode;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.textures.RenderTexture;
   
   public class Illumination extends Entity
   {
      
      public static const CIRCLE:String = "glow";
      
      public static const SPOT:String = "glowSpot";
      
      private var canvas:Sprite;
      
      private var renderTexture:RenderTexture;
      
      private var autoBake:Boolean;
      
      private var darkness:Boolean;
      
      public function Illumination(param1:PlatformLevel, param2:Boolean = true)
      {
         super();
         this.autoBake = param2;
         depth = -900;
         this.canvas = new Sprite();
         this.renderTexture = new RenderTexture(Constants.STAGE_WIDTH + 10,Constants.STAGE_HEIGHT + 10);
         var _loc3_:Quad = new Quad(Constants.STAGE_WIDTH + 10,Constants.STAGE_HEIGHT + 10,70179);
         this.canvas.addChild(_loc3_);
         var _loc4_:Image = new Image(this.renderTexture);
         _loc4_.blendMode = BlendMode.MULTIPLY;
         sprite.addChild(_loc4_);
         ON_END.add(this.kill);
         ON_UPDATE.add(this.onUpdate);
      }
      
      private function onUpdate() : void
      {
         sprite.x = camera.x - 5;
         sprite.y = camera.y - 5;
         sprite.alpha = Calc.wave(Time.total / 50,0.95,1);
         if(this.autoBake)
         {
            this.bake(true);
         }
      }
      
      private function kill() : void
      {
         this.canvas.dispose();
      }
      
      public function addSpot(param1:int, param2:int, param3:Number, param4:Boolean = false, param5:uint = 16777215, param6:String = "glow") : Image
      {
         var _loc7_:Image = new Image(Asset.getTextureFromSource(param6));
         _loc7_.x = param1;
         _loc7_.y = param2;
         _loc7_.pivotX = _loc7_.width / 2;
         _loc7_.pivotY = _loc7_.height / 2;
         if(param6 == SPOT)
         {
            _loc7_.y = param2 + _loc7_.height * param3 / 2;
         }
         _loc7_.color = param5;
         _loc7_.scaleX = _loc7_.scaleY = param3;
         this.canvas.addChild(_loc7_);
         if(param4)
         {
            this.bake();
         }
         return _loc7_;
      }
      
      public function bake(param1:Boolean = false) : void
      {
         if(this.autoBake && !param1)
         {
            return;
         }
         this.renderTexture.clear();
         this.renderTexture.draw(this.canvas);
      }
      
      public function removeSpot(param1:Image) : void
      {
         this.canvas.removeChild(param1,true);
      }
   }
}

