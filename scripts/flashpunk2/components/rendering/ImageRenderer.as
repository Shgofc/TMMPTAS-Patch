package flashpunk2.components.rendering
{
   import flashpunk2.global.Asset;
   import flashpunk2.namespaces.fp_internal;
   import starling.display.Image;
   import starling.textures.TextureSmoothing;
   
   use namespace fp_internal;
   
   public class ImageRenderer extends Renderer
   {
      
      private var _image:Image;
      
      private var _smooth:Boolean;
      
      public function ImageRenderer(param1:*, param2:Boolean = false)
      {
         super();
         this._image = new Image(Asset.getTextureFromSource(param1));
         this._image.smoothing = TextureSmoothing.NONE;
         this.smooth = engine.smoothing;
         fp_internal::setDisplayObject(this._image);
         if(param2)
         {
            this.centerOrigin();
         }
      }
      
      public static function create(param1:*, param2:Number, param3:Number) : ImageRenderer
      {
         var _loc4_:ImageRenderer = new ImageRenderer(param1,false);
         _loc4_.setOrigin(param2,param3);
         return _loc4_;
      }
      
      public function setSource(param1:*, param2:Boolean = false) : void
      {
         this._image.texture = Asset.getTextureFromSource(param1);
         this._image.readjustSize();
         if(param2)
         {
            this.centerOrigin();
         }
      }
      
      public function get image() : Image
      {
         return this._image;
      }
      
      public function get color() : uint
      {
         return this._image.color;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._image.color != param1)
         {
            this._image.color = param1;
         }
      }
      
      public function get smooth() : Boolean
      {
         return this._smooth;
      }
      
      public function set smooth(param1:Boolean) : void
      {
         if(this._smooth != param1)
         {
            this._smooth = param1;
            this._image.smoothing = param1 ? TextureSmoothing.BILINEAR : TextureSmoothing.NONE;
         }
      }
   }
}

