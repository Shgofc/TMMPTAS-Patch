package game
{
   import flashpunk2.global.Key;
   import flashpunk2.input.InputAxis;
   import flashpunk2.input.InputButton;
   
   public class Controls
   {
      
      public static const JUMP:InputButton = InputButton.create(Key.Z,Key.SPACE,Key.ENTER);
      
      public static const ATTACK:InputButton = InputButton.create(Key.X,Key.CONTROL);
      
      public static const ACCEPT:InputButton = InputButton.create(Key.SPACE,Key.Z);
      
      public static const AXIS:InputAxis = InputAxis.create(false);
      
      public function Controls()
      {
         super();
      }
   }
}

