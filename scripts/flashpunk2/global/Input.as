package flashpunk2.global
{
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flashpunk2.Engine;
   import flashpunk2.input.InputAxis;
   import flashpunk2.input.InputButton;
   import flashpunk2.namespaces.fp_internal;
   
   use namespace fp_internal;
   
   public final class Input
   {
      
      private static var _stage:Stage;
      
      private static var _mouseDown:Boolean;
      
      private static var _mousePressed:Boolean;
      
      private static var _mouseReleased:Boolean;
      
      private static var _rightMouseDown:Boolean;
      
      private static var _rightMousePressed:Boolean;
      
      private static var _rightMouseReleased:Boolean;
      
      private static var _mouseX:int;
      
      private static var _mouseY:int;
      
      private static var _mouseWheel:int;
      
      public static var enabled:Boolean = true;
      
      private static var _keyStates:Vector.<Boolean> = new Vector.<Boolean>(256);
      
      private static var _pressedKeys:Vector.<uint> = new Vector.<uint>();
      
      private static var _releasedKeys:Vector.<uint> = new Vector.<uint>();
      
      private static var _downKeys:int = 0;
      
      private static var _buttonLookup:Object = {};
      
      private static var _axisLookup:Object = {};
      
      public function Input()
      {
         super();
      }
      
      fp_internal static function start() : void
      {
         _stage = Engine.instance.main.stage;
         _stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
         _stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         _stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
         _stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
         _mouseX = _stage.mouseX;
         _mouseY = _stage.mouseY;
      }
      
      fp_internal static function end() : void
      {
         _stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
         _stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         _stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
         _stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
         _stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,onRightMouseDown);
         _stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,onRightMouseUp);
         _stage.removeEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
         _stage = null;
      }
      
      fp_internal static function update() : void
      {
         _pressedKeys.length = 0;
         _releasedKeys.length = 0;
         _mousePressed = false;
         _mouseReleased = false;
         _rightMousePressed = false;
         _rightMouseReleased = false;
         _mouseX = _stage.mouseX;
         _mouseY = _stage.mouseY;
         _mouseWheel = 0;
      }
      
      private static function onKeyDown(param1:KeyboardEvent) : void
      {
         if(!_keyStates[param1.keyCode] && enabled)
         {
            ++_downKeys;
            _keyStates[param1.keyCode] = true;
            _pressedKeys.push(param1.keyCode);
         }
      }
      
      private static function onKeyUp(param1:KeyboardEvent) : void
      {
         if(enabled)
         {
            --_downKeys;
            _keyStates[param1.keyCode] = false;
            _releasedKeys.push(param1.keyCode);
         }
      }
      
      private static function onMouseDown(param1:MouseEvent) : void
      {
         if(enabled)
         {
            _mouseDown = true;
            _mousePressed = true;
         }
      }
      
      private static function onMouseUp(param1:MouseEvent) : void
      {
         if(enabled)
         {
            _mouseDown = false;
            _mouseReleased = true;
         }
      }
      
      private static function onRightMouseDown(param1:MouseEvent) : void
      {
         if(enabled)
         {
            _rightMouseDown = true;
            _rightMousePressed = true;
         }
      }
      
      private static function onRightMouseUp(param1:MouseEvent) : void
      {
         if(enabled)
         {
            _rightMouseDown = false;
            _rightMouseReleased = true;
         }
      }
      
      private static function onMouseWheel(param1:MouseEvent) : void
      {
         if(enabled)
         {
            _mouseWheel = param1.delta > 0 ? 1 : -1;
         }
      }
      
      public static function addButton(param1:String, param2:InputButton) : InputButton
      {
         _buttonLookup[param1] = param2;
         return param2;
      }
      
      public static function createButton(param1:String) : InputButton
      {
         return addButton(param1,new InputButton());
      }
      
      public static function removeButton(param1:String) : void
      {
         if(param1 in _buttonLookup)
         {
            delete _buttonLookup[param1];
         }
      }
      
      public static function clearButtons() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in _buttonLookup)
         {
            delete _buttonLookup[_loc1_];
         }
      }
      
      public static function addAxis(param1:String, param2:InputAxis) : InputAxis
      {
         _axisLookup[param1] = param2;
         return param2;
      }
      
      public static function createAxis(param1:String) : InputAxis
      {
         return addAxis(param1,new InputAxis());
      }
      
      public static function removeAxis(param1:String) : void
      {
         if(param1 in _axisLookup)
         {
            delete _axisLookup[param1];
         }
      }
      
      public static function clearAxes() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in _axisLookup)
         {
            delete _axisLookup[_loc1_];
         }
      }
      
      public static function getButton(param1:String) : InputButton
      {
         if(!(param1 in _buttonLookup))
         {
            throw new Error("Button not defined: " + param1);
         }
         return _buttonLookup[param1];
      }
      
      public static function getAxis(param1:String) : InputAxis
      {
         if(!(param1 in _axisLookup))
         {
            throw new Error("Button not defined: " + param1);
         }
         return _axisLookup[param1];
      }
      
      public static function keyDown(param1:uint) : Boolean
      {
         return param1 >= 0 ? _keyStates[param1] : _downKeys > 0;
      }
      
      public static function keyPressed(param1:uint) : Boolean
      {
         return param1 >= 0 ? _pressedKeys.indexOf(param1) >= 0 : _pressedKeys.length > 0;
      }
      
      public static function keyReleased(param1:uint) : Boolean
      {
         return param1 >= 0 ? _releasedKeys.indexOf(param1) >= 0 : _releasedKeys.length > 0;
      }
      
      public static function keyUp(param1:uint) : Boolean
      {
         return !keyDown(param1);
      }
      
      public static function buttonDown(param1:String) : Boolean
      {
         return getButton(param1).down;
      }
      
      public static function buttonPressed(param1:String) : Boolean
      {
         return getButton(param1).pressed;
      }
      
      public static function buttonReleased(param1:String) : Boolean
      {
         return getButton(param1).released;
      }
      
      public static function buttonUp(param1:String) : Boolean
      {
         return getButton(param1).up;
      }
      
      public static function axisDown(param1:String) : Boolean
      {
         return getAxis(param1).down;
      }
      
      public static function axisPressed(param1:String) : Boolean
      {
         return getAxis(param1).pressed;
      }
      
      public static function axisReleased(param1:String) : Boolean
      {
         return getAxis(param1).released;
      }
      
      public static function axisUp(param1:String) : Boolean
      {
         return getAxis(param1).up;
      }
      
      public static function axisX(param1:String) : Number
      {
         return getAxis(param1).x;
      }
      
      public static function axisY(param1:String) : Number
      {
         return getAxis(param1).y;
      }
      
      public static function get mouseDown() : Boolean
      {
         return _mouseDown;
      }
      
      public static function get mousePressed() : Boolean
      {
         return _mousePressed;
      }
      
      public static function get mouseReleased() : Boolean
      {
         return _mouseReleased;
      }
      
      public static function get rightMouseDown() : Boolean
      {
         return _rightMouseDown;
      }
      
      public static function get rightMousePressed() : Boolean
      {
         return _rightMousePressed;
      }
      
      public static function get rightMouseReleased() : Boolean
      {
         return _rightMouseReleased;
      }
      
      public static function get mouseX() : int
      {
         return _mouseX;
      }
      
      public static function get mouseY() : int
      {
         return _mouseY;
      }
      
      public static function get mouseWheel() : int
      {
         return _mouseWheel;
      }
   }
}

