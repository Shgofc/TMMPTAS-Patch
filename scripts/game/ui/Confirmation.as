package game.ui
{
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.BitmapTextRenderer;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.global.Ease;
   import flashpunk2.namespaces.fp_internal;
   import game.Constants;
   
   use namespace fp_internal;
   
   public class Confirmation extends Entity
   {
      
      private var forceUpdate:Boolean;
      
      private var selector:SelectorMenu;
      
      public function Confirmation(param1:String, param2:Function, param3:Function = null, param4:Boolean = false)
      {
         var message:BitmapTextRenderer;
         var bg:ImageRenderer = null;
         var text:String = param1;
         var yesFunction:Function = param2;
         var noFunction:Function = param3;
         var forceUpdate:Boolean = param4;
         super();
         this.forceUpdate = forceUpdate;
         this.forceUpdate = forceUpdate;
         bg = new ImageRenderer("interface/confirmationBg",true);
         bg.setPosition(Constants.STAGE_WIDTH / 2,Constants.STAGE_HEIGHT / 2 + 8);
         bg.scroll = 0;
         bg.alpha = 0;
         bg.angle = 90;
         bg.setScale(0.2,0.2);
         add(bg);
         message = new BitmapTextRenderer(256,100,text,"font",Constants.TEXT_SIZE,16777215,true);
         message.setPosition(Constants.STAGE_WIDTH / 2,Constants.STAGE_HEIGHT / 2 - 40);
         message.scroll = 0;
         add(message);
         ON_START.add(function():void
         {
            if(noFunction != null)
            {
               selector = new SelectorMenu(Vector.<String>(["sim","não"]),Vector.<Function>([yesFunction,noFunction]),removeSelf,true);
               selector.y = Constants.STAGE_HEIGHT / 2 + 48;
               selector.setTextScale(2);
               selector.depth = depth - 1;
               world.add(selector);
            }
            else
            {
               selector = new SelectorMenu(Vector.<String>(["ok"]),Vector.<Function>([yesFunction]),removeSelf,true);
               selector.y = Constants.STAGE_HEIGHT / 2 + 48;
               selector.setTextScale(2);
               selector.depth = depth - 1;
               world.add(selector);
            }
            tween(bg,0.5).scaleTo(1,1).to("alpha",1).to("angle",0).ease(Ease.elasticOut);
            if(forceUpdate)
            {
               ON_UPDATE.add(selector.fp_internal::update);
            }
         });
         depth = -1010;
      }
      
      override public function removeSelf() : void
      {
         this.selector.removeSelf();
         super.removeSelf();
      }
   }
}

