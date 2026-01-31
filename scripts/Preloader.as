package
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class Preloader extends MovieClip
   {
      
      [Embed(source="../assets/loading.png")]
      private static var imgLoading:Class = Preloader_imgLoading;
      
      private var loading:Bitmap = new imgLoading();
      
      private var square:Sprite = new Sprite();
      
      private var wd:Number = loaderInfo.bytesLoaded / loaderInfo.bytesTotal * 240;
      
      private var text:TextField = new TextField();
      
      public function Preloader()
      {
         super();
         stage.color = 0;
         addEventListener(Event.ENTER_FRAME,this.checkFrame);
         loaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progress);
         addChild(this.square);
         this.square.x = 180;
         this.square.y = 174;
         addChild(this.loading);
      }
      
      private function progress(param1:ProgressEvent) : void
      {
         this.square.graphics.beginFill(15921906);
         this.square.graphics.drawRect(0,0,loaderInfo.bytesLoaded / loaderInfo.bytesTotal * 280,30);
         this.square.graphics.endFill();
         this.text.textColor = 16777215;
         this.text.text = "Loading: " + Math.ceil(loaderInfo.bytesLoaded / loaderInfo.bytesTotal * 100) + "%";
      }
      
      private function checkFrame(param1:Event) : void
      {
         if(currentFrame == totalFrames)
         {
            removeEventListener(Event.ENTER_FRAME,this.checkFrame);
            this.startup();
         }
      }
      
      private function startup() : void
      {
         removeChild(this.square);
         removeChild(this.loading);
         stop();
         loaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progress);
         var _loc1_:Class = getDefinitionByName("Main") as Class;
         addChild(new _loc1_() as DisplayObject);
      }
   }
}

