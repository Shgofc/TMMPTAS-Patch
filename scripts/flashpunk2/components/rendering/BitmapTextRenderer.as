package flashpunk2.components.rendering
{
   import flashpunk2.namespaces.fp_internal;
   import starling.text.TextField;
   import starling.utils.HAlign;
   import starling.utils.VAlign;
   
   use namespace fp_internal;
   
   public class BitmapTextRenderer extends Renderer
   {
      
      private static var _formatFont:String;
      
      private static var _formatSize:Number;
      
      private static var _formatColor:uint;
      
      private static var _formatCenter:Boolean;
      
      private var _textField:TextField;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var w:int;
      
      private var h:int;
      
      public function BitmapTextRenderer(param1:int, param2:int, param3:String, param4:String, param5:Number, param6:uint, param7:Boolean)
      {
         super();
         this.h = param2;
         this.w = param1;
         this._textField = new TextField(param1,param2,param3,param4,param5,param6,false);
         if(param7)
         {
            this._textField.hAlign = HAlign.CENTER;
            this._textField.vAlign = VAlign.CENTER;
            this._textField.pivotX = param1 / 2;
            this._textField.pivotY = param2 / 2;
         }
         else
         {
            this._textField.hAlign = HAlign.LEFT;
            this._textField.vAlign = VAlign.TOP;
         }
         this.autoSize();
         fp_internal::setDisplayObject(this._textField);
      }
      
      public static function setFormat(param1:String, param2:Number, param3:uint, param4:Boolean) : void
      {
         _formatFont = param1;
         _formatSize = param2;
         _formatColor = param3;
         _formatCenter = param4;
      }
      
      public static function create(param1:int, param2:int, param3:String) : BitmapTextRenderer
      {
         return new BitmapTextRenderer(param1,param2,param3,_formatFont,_formatSize,_formatColor,_formatCenter);
      }
      
      private function autoSize() : void
      {
      }
      
      public function setText(param1:String, param2:Boolean = false) : void
      {
         this.text = param1;
         if(param2)
         {
            this.centerOrigin();
         }
      }
      
      public function get text() : String
      {
         return this._textField.text;
      }
      
      public function set text(param1:String) : void
      {
         if(this._textField.text != param1)
         {
            this._textField.text = param1;
            this.autoSize();
         }
      }
      
      public function get font() : String
      {
         return this._textField.fontName;
      }
      
      public function set font(param1:String) : void
      {
         if(this._textField.fontName != param1)
         {
            this._textField.fontName = param1;
            this.autoSize();
         }
      }
      
      public function get size() : Number
      {
         return this._textField.fontSize;
      }
      
      public function set size(param1:Number) : void
      {
         if(this._textField.fontSize != param1)
         {
            this._textField.fontSize = param1;
            this.autoSize();
         }
      }
      
      public function get color() : uint
      {
         return this._textField.color;
      }
      
      public function set color(param1:uint) : void
      {
         this._textField.color = param1;
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      public function get textWidth() : Number
      {
         return this._textField.textBounds.width;
      }
   }
}

