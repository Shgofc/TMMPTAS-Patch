package game.ui
{
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.BitmapTextRenderer;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.global.Ease;
   import game.Constants;
   import sound.SoundManager;
   
   public class Baloon extends Entity
   {
      
      private var bText:BitmapTextRenderer;
      
      private var image:ImageRenderer;
      
      public var alpha:Number = 1;
      
      public function Baloon(param1:Number, param2:Number, param3:String)
      {
         var x:Number = param1;
         var y:Number = param2;
         var text:String = param3;
         super(x + 5,y);
         this.image = new ImageRenderer("interface/baloon");
         this.image.setOrigin(0,this.image.height);
         this.image.alpha = 0;
         add(this.image);
         this.bText = new BitmapTextRenderer(220,130,text,"font",Constants.TEXT_SIZE,0,true);
         this.bText.x = this.image.width / 2 + 7;
         this.bText.y = -this.image.height / 2 - 8;
         this.bText.alpha = 0;
         add(this.bText);
         SoundManager.playSound("pop");
         tween(this,0.3).from("alpha",0).from("angle",3).to("alpha",1).to("angle",0).scaleFrom(0.5,0.5).scaleTo(1,1).ease(Ease.backOut).onComplete(function():void
         {
         });
         ON_UPDATE.add(function():void
         {
            image.alpha = alpha;
            bText.alpha = alpha;
         });
         depth = -1200;
         this.moveTo(x + 5,y);
      }
      
      public function moveTo(param1:int, param2:int) : void
      {
         if(param1 + this.image.width > Constants.STAGE_WIDTH)
         {
            param1 -= this.image.width + 40;
            this.image.x = this.image.width + 20;
            this.image.scaleX = -1;
            this.bText.x += 7;
         }
         this.x = param1;
         if(param2 < this.image.height)
         {
            param2 += 94;
            this.image.scaleY = -1;
            this.bText.y = this.image.height / 2;
         }
         this.y = param2;
      }
      
      public function fade() : void
      {
         tween(this,0.5).to("alpha",0).to("angle",3).onComplete(removeSelf);
      }
   }
}

