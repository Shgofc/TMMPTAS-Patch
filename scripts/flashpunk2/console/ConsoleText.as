package flashpunk2.console
{
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class ConsoleText extends TextField
   {
      
      private static var _format:TextFormat = new TextFormat("Lucida Console",14,16777215,false);
      
      public function ConsoleText(param1:int = 0, param2:int = 0, param3:String = "")
      {
         super();
         defaultTextFormat = _format;
         autoSize = TextFieldAutoSize.LEFT;
         this.x = param1;
         this.y = param2;
         this.text = param3;
      }
   }
}

