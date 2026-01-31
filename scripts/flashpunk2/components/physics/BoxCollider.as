package flashpunk2.components.physics
{
   import nape.geom.Vec2;
   
   public class BoxCollider extends PolygonCollider
   {
      
      private static var _vertices:Vector.<Vec2> = new Vector.<Vec2>(4);
      
      public function BoxCollider(param1:uint, param2:uint, param3:Boolean = true)
      {
         _vertices[0] = Vec2.weak(-param1 / 2,-param2 / 2);
         _vertices[1] = Vec2.weak(param1 / 2,-param2 / 2);
         _vertices[2] = Vec2.weak(param1 / 2,param2 / 2);
         _vertices[3] = Vec2.weak(-param1 / 2,param2 / 2);
         super(_vertices,param3);
      }
   }
}

