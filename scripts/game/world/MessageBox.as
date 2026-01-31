package game.world
{
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.BitmapTextRenderer;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.components.timing.Tween;
   import flashpunk2.global.Ease;
   import flashpunk2.namespaces.fp_internal;
   import game.Constants;
   import game.Controls;
   
   use namespace fp_internal;
   
   public class MessageBox extends Entity
   {
      
      private var activateLevel:Function;
      
      private var fadeIn:Tween;
      
      private var done:Boolean = false;
      
      public function MessageBox(param1:String, param2:String, param3:Function)
      {
         var bg:ImageRenderer;
         var title:BitmapTextRenderer;
         var text:BitmapTextRenderer;
         var sTitle:String = param1;
         var sText:String = param2;
         var activateLevel:Function = param3;
         super();
         this.activateLevel = activateLevel;
         bg = new ImageRenderer("interface/messageBg",true);
         bg.scroll = 0;
         add(bg);
         title = new BitmapTextRenderer(bg.width,30,sTitle,"font",30,0,true);
         text = new BitmapTextRenderer(bg.width - 10,200,sText,"font",24,0,true);
         title.y = -55;
         text.y = 0;
         title.scroll = text.scroll = 0;
         add(title);
         add(text);
         this.fadeIn = tween(this,0.5).ease(Ease.backOut).moveTo(Constants.STAGE_WIDTH / 2,Constants.STAGE_HEIGHT / 2).onComplete(function():void
         {
            done = true;
         });
         depth = -1100;
         ON_UPDATE.add(this.onUpdate);
      }
      
      private function onUpdate() : void
      {
         if((this.fadeIn.percent > 0.5 || this.done) && (Controls.ATTACK.pressed || Controls.JUMP.pressed))
         {
            cancelAllTweens();
            tween(this,0.5).ease(Ease.backIn).moveTo(x,Constants.STAGE_HEIGHT + 200).onComplete(this.kill);
         }
      }
      
      public function kill() : void
      {
         removeSelf();
         this.activateLevel();
         engine.ON_UPDATE.remove(this.fp_internal::update);
      }
   }
}

