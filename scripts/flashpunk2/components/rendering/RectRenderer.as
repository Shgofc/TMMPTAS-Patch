package flashpunk2.components.rendering
{
   import flashpunk2.namespaces.fp_internal;
   import starling.display.Quad;
   
   use namespace fp_internal;
   
   public class RectRenderer extends Renderer
   {
      
      private var _quad:Quad;
      
      public function RectRenderer(param1:Number, param2:Number, param3:uint = 16777215, param4:Boolean = true)
      {
         super();
         this._quad = new Quad(param1,param2,param3);
         fp_internal::setDisplayObject(this._quad);
         if(param4)
         {
            this.centerOrigin();
         }
      }
      
      public function get color() : uint
      {
         return this._quad.color;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._quad.color != param1)
         {
            this._quad.color = param1;
         }
      }
   }
}

