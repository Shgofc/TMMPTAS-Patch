package flashpunk2.console
{
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.system.System;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flashpunk2.Camera;
   import flashpunk2.Engine;
   import flashpunk2.Entity;
   import flashpunk2.Physics;
   import flashpunk2.World;
   import flashpunk2.global.Debug;
   import flashpunk2.global.Input;
   import flashpunk2.global.Key;
   import flashpunk2.global.Time;
   import flashpunk2.namespaces.fp_internal;
   import nape.geom.Mat23;
   import nape.util.ShapeDebug;
   
   use namespace fp_internal;
   
   public class Console
   {
      
      private static var _instance:Console;
      
      public var toggleKey:int = 192;
      
      public var tabKey:int = 9;
      
      public var lineColor:uint = 0;
      
      public var showHandles:Boolean = true;
      
      private var _bgColor:uint = 0;
      
      private var _bgAlpha:Number = 0.25;
      
      private var _visible:Boolean;
      
      private var _simpleView:Boolean = true;
      
      private var _pauseEngine:Boolean = true;
      
      private var _sprite:Sprite = new Sprite();
      
      private var _header:Sprite = new Sprite();
      
      private var _footer:Sprite = new Sprite();
      
      private var _log:Sprite = new Sprite();
      
      private var _bg:Shape = new Shape();
      
      private var _fpsLabel:ConsoleText;
      
      private var _memoryLabel:ConsoleText;
      
      private var _entitiesLabel:ConsoleText;
      
      private var _bodiesLabel:ConsoleText;
      
      private var _logLabels:Vector.<ConsoleText> = new Vector.<ConsoleText>(20);
      
      private var _logLabel:ConsoleText;
      
      private var _logIndex:int;
      
      private var _physicsView:ShapeDebug;
      
      private var _entityView:Shape = new Shape();
      
      private var _point:Point = new Point();
      
      private var _consoleLabel:ConsoleText;
      
      private var _consoleCaret:ConsoleText;
      
      private var _caretTimer:Number = 0;
      
      private var _lastCommand:String = "";
      
      private var _commands:Object = {};
      
      private var _help:Object = {};
      
      public function Console()
      {
         super();
         _instance = this;
      }
      
      public static function get instance() : Console
      {
         return _instance;
      }
      
      private function getLineColor(param1:int) : uint
      {
         return this.lineColor;
      }
      
      fp_internal function start() : void
      {
         this.drawBG();
         this._bg.visible = false;
         this._sprite.addChild(this._bg);
         this._physicsView = new ShapeDebug(this.width,this.height,0);
         this._physicsView.cullingEnabled = false;
         this._physicsView.display.visible = false;
         this._physicsView.colour = this.getLineColor;
         this._physicsView.thickness = 1;
         this._physicsView.drawBodyDetail = false;
         this._physicsView.drawCollisionArbiters = false;
         this._physicsView.drawShapeDetail = false;
         this._physicsView.drawShapeAngleIndicators = false;
         this._sprite.addChild(this._physicsView.display);
         this._entityView.visible = false;
         this._sprite.addChild(this._entityView);
         var _loc1_:Array = [new DropShadowFilter(0,45,0,1,3,3,10)];
         var _loc2_:int = 0;
         while(_loc2_ < this._logLabels.length)
         {
            this._logLabels[_loc2_] = new ConsoleText();
            this._logLabels[_loc2_].filters = _loc1_;
            this._logLabels[_loc2_].y = _loc2_ * 20;
            this._log.addChild(this._logLabels[_loc2_]);
            _loc2_++;
         }
         this._log.y = this.height - (this._logLabels.length + 1) * 20 - 20;
         this._log.visible = false;
         this._sprite.addChild(this._log);
         this._header.graphics.beginFill(0);
         this._header.graphics.drawRect(0,0,this.width,20);
         this._sprite.addChild(this._header);
         this._footer.graphics.beginFill(0);
         this._footer.graphics.drawRect(0,0,this.width,20);
         this._footer.y = this.height - 20;
         this._sprite.addChild(this._footer);
         this._header.addChild(this._fpsLabel = new ConsoleText(0,0,"FPS:00"));
         this._header.addChild(this._memoryLabel = new ConsoleText(this._fpsLabel.width + 20,0,"MEM:"));
         this._header.addChild(this._entitiesLabel = new ConsoleText(this.width,0,"Entities"));
         this._header.addChild(this._bodiesLabel = new ConsoleText(this.width,0,"Bodies"));
         this._logLabel = new ConsoleText();
         this._footer.addChild(this._logLabel);
         this._consoleLabel = new ConsoleText();
         this._consoleLabel.restrict = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_ .+=.,></-_`~!@#$%^&*()";
         this._footer.addChild(this._consoleLabel);
         this._consoleCaret = new ConsoleText(0,2,"_");
         this._consoleCaret.visible = false;
         this._footer.addChild(this._consoleCaret);
         this.registerCommand(this.repeatCommand,"repeat");
         this.registerCommand(this.logCommand,"log","print","trace");
         this.registerCommand(this.pauseCommand,"pause");
         this.registerCommand(this.playCommand,"play","resume");
         this.registerCommand(this.camCommand,"camera","cam");
         this.registerCommand(this.camResetCommand,"cameraReset","camReset");
         this.registerCommand(this.camPositionCommand,"cameraPosition","camPosition","cameraPos","camPos");
         this.registerCommand(this.camAngleCommand,"cameraAngle","camAngle");
         this.registerCommand(this.camZoomCommand,"cameraZoom","camZoom","camZ");
         this.registerCommand(this.restartCommand,"restartWorld","restart");
         this.registerCommand(this.clearCommand,"clear","clearLog");
         this.registerCommand(this.bgCommand,"bg");
         this.registerCommand(this.bgResetCommand,"bgReset");
         this.registerCommand(this.bgColorCommand,"bgColor","bgColour");
         this.registerCommand(this.bgAlphaCommand,"bgAlpha");
         this.registerCommand(this.lineSizeCommand,"lineSize");
         this.registerCommand(this.lineColorCommand,"lineColor","lineColour");
         this.registerCommand(this.showCommand,"show");
         this.registerCommand(this.hideCommand,"hide");
         this.registerCommand(this.setCommand,"set","setVar");
         this.registerCommand(this.getCommand,"get","getVar");
         this.registerCommand(this.performCommand,"perform","do");
         this.registerCommand(this.performOnCommand,"performOn","doOn");
         this.registerCommand(this.setWorldCommand,"setWorld");
         this.engine.main.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      fp_internal function update() : void
      {
         var _loc1_:Entity = null;
         if(this._visible)
         {
            if(Input.keyPressed(this.toggleKey))
            {
               this.hide();
            }
            if(Input.keyPressed(this.tabKey))
            {
               this.toggleView();
            }
            this._fpsLabel.text = "FPS:" + Time.frameRate;
            this._memoryLabel.text = "Memory:" + Number(System.totalMemory / 1048576).toFixed(2);
            this._entitiesLabel.text = this.world.entityCount + " Entities";
            this._entitiesLabel.x = this.width - this._entitiesLabel.width;
            this._bodiesLabel.text = this.physics.space.bodies.length + " Bodies";
            this._bodiesLabel.x = Math.min(this._bodiesLabel.x,this._entitiesLabel.x - this._bodiesLabel.width - 20);
            if(!this._simpleView)
            {
               this._consoleCaret.x = this._consoleLabel.width - 3;
               this._caretTimer -= Time.dt;
               if(this._caretTimer <= 0)
               {
                  this._consoleCaret.visible = !this._consoleCaret.visible;
                  this._caretTimer = this._consoleLabel.visible ? 0.5 : 0.1;
               }
            }
            this._physicsView.clear();
            this._physicsView.transform = Mat23.fromMatrix(this.camera.fp_internal::getMatrix());
            this._physicsView.draw(this.world.physics.space);
            this._physicsView.flush();
            this._entityView.graphics.clear();
            if(this.showHandles)
            {
               this._entityView.graphics.lineStyle(0,16777215,1,false,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.MITER,3);
               for each(_loc1_ in this.world.fp_internal::entities)
               {
                  if(_loc1_ != null)
                  {
                     this._point.setTo(0,0);
                     _loc1_.sprite.localToGlobal(this._point,this._point);
                     if(this._point.x > 0 && this._point.y > 0 && this._point.x < this.width && this._point.y < this.height)
                     {
                        this._entityView.graphics.drawRect(this._point.x - 5,this._point.y - 5,10,10);
                     }
                  }
               }
            }
            this.camera.fp_internal::update();
         }
         else if(Input.keyPressed(this.toggleKey))
         {
            this.show();
         }
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(this._visible && !this._simpleView)
         {
            if(param1.keyCode == Key.ENTER)
            {
               if(this._consoleLabel.text.length > 0)
               {
                  this.parseCommand(this._consoleLabel.text);
                  this._consoleLabel.text = "";
               }
            }
            else if(param1.keyCode == Key.BACKSPACE)
            {
               if(this._consoleLabel.text.length > 0)
               {
                  this._consoleLabel.text = this._consoleLabel.text.substr(0,this._consoleLabel.length - 1);
               }
            }
            else if(param1.keyCode == Key.DELETE)
            {
               this._consoleLabel.text = "";
            }
            else
            {
               this._consoleLabel.text += String.fromCharCode(param1.charCode);
            }
         }
      }
      
      private function parseCommand(param1:String) : void
      {
         var _loc3_:Function = null;
         var _loc4_:int = 0;
         var _loc2_:Array = param1.split(" ");
         if(_loc2_[0] in this._commands)
         {
            _loc3_ = this._commands[_loc2_[0]];
            if(_loc3_ != this.repeatCommand)
            {
               this._lastCommand = param1;
            }
            _loc2_.shift();
            if(_loc2_.length > 0)
            {
               if(String(_loc2_[_loc2_.length - 1]).indexOf("*") == 0)
               {
                  _loc4_ = int(String(_loc2_.pop()).replace("*",""));
                  while(_loc4_--)
                  {
                     _loc3_(_loc2_);
                  }
               }
               else
               {
                  _loc3_(_loc2_);
               }
            }
            else
            {
               _loc3_();
            }
         }
         else
         {
            Debug.logError("Unknown command: " + _loc2_[0]);
         }
      }
      
      private function drawBG() : void
      {
         this._bg.graphics.clear();
         this._bg.graphics.beginFill(this._bgColor,this._bgAlpha);
         this._bg.graphics.drawRect(0,0,this.width,this.height);
      }
      
      public function show() : void
      {
         this._visible = true;
         this._consoleLabel.text = "";
         if(!this._simpleView)
         {
            this.engine.fp_internal::paused = this._pauseEngine;
         }
         Engine.instance.main.addChild(this._sprite);
      }
      
      public function hide() : void
      {
         this._visible = false;
         this._consoleLabel.text = "";
         this.engine.fp_internal::paused = false;
         Engine.instance.main.removeChild(this._sprite);
      }
      
      private function toggleView() : void
      {
         this._simpleView = !this._simpleView;
         this._log.visible = !this._simpleView;
         this._logLabel.visible = this._simpleView;
         this._bg.visible = !this._simpleView;
         this._physicsView.display.visible = !this._simpleView;
         this._entityView.visible = !this._simpleView;
         this._consoleLabel.visible = !this._simpleView;
         this._consoleLabel.text = "";
         this.engine.fp_internal::paused = !this._simpleView;
      }
      
      public function writeLine(param1:String, param2:uint = 16777215) : void
      {
         var _loc3_:ConsoleText = this._logLabels[0];
         var _loc4_:int = 1;
         while(_loc4_ < this._logLabels.length)
         {
            this._logLabels[_loc4_].y -= 20;
            this._logLabels[_loc4_ - 1] = this._logLabels[_loc4_];
            _loc4_++;
         }
         this._logLabels[this._logLabels.length - 1] = _loc3_;
         _loc3_.y = this._logLabels.length * 20;
         _loc3_.text = param1;
         _loc3_.textColor = param2;
         this._logLabel.text = param1;
      }
      
      public function clear() : void
      {
         var _loc1_:ConsoleText = null;
         for each(_loc1_ in this._logLabels)
         {
            _loc1_.text = "";
         }
      }
      
      public function registerCommand(param1:Function, ... rest) : void
      {
         var _loc3_:String = null;
         if(param1.length > 1)
         {
            throw new Error("Commands cannot have more than 1 Array parameter.");
         }
         for each(_loc3_ in rest)
         {
            if(_loc3_ in this._commands)
            {
               throw new Error("Command name already taken: " + _loc3_);
            }
            this._commands[_loc3_] = param1;
         }
      }
      
      public function get bgColor() : uint
      {
         return this._bgColor;
      }
      
      public function set bgColor(param1:uint) : void
      {
         if(this._bgColor != param1)
         {
            this._bgColor = param1;
            this.drawBG();
         }
      }
      
      public function get bgAlpha() : Number
      {
         return this._bgColor;
      }
      
      public function set bgAlpha(param1:Number) : void
      {
         if(this._bgAlpha != param1)
         {
            this._bgAlpha = param1;
            this.drawBG();
         }
      }
      
      public function get lineSize() : Number
      {
         return this._physicsView.thickness;
      }
      
      public function set lineSize(param1:Number) : void
      {
         this._physicsView.thickness = Math.abs(param1);
      }
      
      public function get showDetail() : Boolean
      {
         return this._physicsView.drawShapeDetail;
      }
      
      public function set showDetail(param1:Boolean) : void
      {
         this._physicsView.drawCollisionArbiters = param1;
         this._physicsView.drawShapeDetail = param1;
         this._physicsView.drawShapeAngleIndicators = param1;
      }
      
      public function get showBodies() : Boolean
      {
         return this._physicsView.drawBodies;
      }
      
      public function set showBodies(param1:Boolean) : void
      {
         this._physicsView.drawBodies = param1;
      }
      
      public function get showLog() : Boolean
      {
         return this._log.visible;
      }
      
      public function set showLog(param1:Boolean) : void
      {
         this._log.visible = param1;
      }
      
      public function get engine() : Engine
      {
         return Engine.instance;
      }
      
      public function get world() : World
      {
         return Engine.instance.currentWorld;
      }
      
      public function get camera() : Camera
      {
         return Engine.instance.currentWorld.camera;
      }
      
      public function get physics() : Physics
      {
         return Engine.instance.currentWorld.physics;
      }
      
      public function get width() : int
      {
         return Engine.instance.width;
      }
      
      public function get height() : int
      {
         return Engine.instance.height;
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      private function repeatCommand(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:String = this._lastCommand;
         if(_loc2_ != null && _loc2_ != "")
         {
            if(param1.length > 1)
            {
               Debug.logError("Invalid parameters, expected [count].");
            }
            else if(param1.length == 1)
            {
               _loc3_ = int(param1[0]);
               if(_loc3_ > 0)
               {
                  while(_loc3_--)
                  {
                     this.parseCommand(_loc2_);
                  }
               }
               else
               {
                  Debug.logError("Invalid repeat count: " + _loc3_);
               }
            }
            else
            {
               this.parseCommand(_loc2_);
            }
         }
      }
      
      private function logCommand(param1:Array) : void
      {
         Debug.log.apply(null,param1);
      }
      
      private function pauseCommand() : void
      {
         this._pauseEngine = true;
         this.engine.fp_internal::paused = true;
      }
      
      private function playCommand() : void
      {
         this._pauseEngine = false;
         this.engine.fp_internal::paused = false;
      }
      
      private function camCommand(param1:Array) : void
      {
         if(param1.length < 2 || param1.length > 4)
         {
            Debug.logError("Invalid parameters, expected [x, y, angle, zoom].");
         }
         else
         {
            if(param1.length > 1)
            {
               this.world.camera.setPosition(Number(param1[0]),Number(param1[1]));
            }
            if(param1.length > 2)
            {
               this.world.camera.angle = Number(param1[2]);
            }
            if(param1.length > 3)
            {
               this.world.camera.zoom = Number(param1[3]);
            }
         }
      }
      
      private function camResetCommand() : void
      {
         this.world.camera.setPosition(0,0);
         this.world.camera.angle = 0;
         this.world.camera.zoom = 1;
      }
      
      private function camPositionCommand(param1:Array) : void
      {
         if(param1.length != 2)
         {
            Debug.logError("Invalid parameters, expected [x, y].");
         }
         else
         {
            this.world.camera.setPosition(Number(param1[0]),Number(param1[1]));
         }
      }
      
      private function camAngleCommand(param1:Array) : void
      {
         if(param1.length != 1)
         {
            Debug.logError("Invalid parameters, expected [angle].");
         }
         else
         {
            this.world.camera.angle = Number(param1[0]);
         }
      }
      
      private function camZoomCommand(param1:Array) : void
      {
         if(param1.length != 1)
         {
            Debug.logError("Invalid parameters, expected [zoom].");
         }
         else
         {
            this.world.camera.zoom = Number(param1[0]);
         }
      }
      
      private function restartCommand() : void
      {
         var world:World = null;
         var type:Class = Class(getDefinitionByName(getQualifiedClassName(this.world)));
         try
         {
            world = new type();
         }
         catch(e:Error)
         {
            Debug.logError(e.message);
            return;
         }
         this.engine.setWorld(world);
      }
      
      private function clearCommand() : void
      {
         this.clear();
      }
      
      private function bgCommand(param1:Array) : void
      {
         if(param1.length < 1 || param1.length > 2)
         {
            Debug.logError("Invalid parameters, expected [color, alpha].");
         }
         else
         {
            this._bgColor = uint(param1[0]);
            if(param1.length > 1)
            {
               this._bgAlpha = Number(param1[1]);
            }
            this.drawBG();
         }
      }
      
      private function bgResetCommand() : void
      {
         this._bgColor = 0;
         this._bgAlpha = 0.25;
         this.drawBG();
      }
      
      private function bgColorCommand(param1:Array) : void
      {
         if(param1.length != 1)
         {
            Debug.logError("Invalid parameters, expected [color].");
         }
         else
         {
            this.bgColor = uint(param1[0]);
         }
      }
      
      private function bgAlphaCommand(param1:Array) : void
      {
         if(param1.length != 1)
         {
            Debug.logError("Invalid parameters, expected [alpha].");
         }
         else
         {
            this.bgAlpha = Number(param1[0]);
         }
      }
      
      private function lineSizeCommand(param1:Array) : void
      {
         if(param1.length != 1)
         {
            Debug.logError("Invalid parameters, expected [size].");
         }
         else
         {
            this.lineSize = Number(param1[0]);
         }
      }
      
      private function lineColorCommand(param1:Array) : void
      {
         if(param1.length != 1)
         {
            Debug.logError("Invalid parameters, expected [color].");
         }
         else
         {
            this.lineColor = Number(param1[0]);
         }
      }
      
      private function proxyShowHide(param1:Array, param2:Boolean) : void
      {
         var _loc3_:String = null;
         if(param1.length == 0)
         {
            Debug.logError("Invalid parameters, expected [...].");
         }
         else
         {
            for each(_loc3_ in param1)
            {
               switch(_loc3_)
               {
                  case "log":
                     this.showLog = param2;
                     break;
                  case "detail":
                     this.showDetail = param2;
                     break;
                  case "bodies":
                     this.showBodies = param2;
                     break;
                  case "handles":
                     this.showHandles = param2;
                     break;
                  case "all":
                     this.showDetail = param2;
                     this.showBodies = param2;
                     this.showHandles = param2;
                     break;
                  default:
                     Debug.logError("Invalid parameter: " + _loc3_);
               }
            }
         }
      }
      
      private function showCommand(param1:Array) : void
      {
         this.proxyShowHide(param1,true);
      }
      
      private function hideCommand(param1:Array) : void
      {
         this.proxyShowHide(param1,false);
      }
      
      private function setCommand(param1:Array) : void
      {
         var e:Entity = null;
         var p:String = null;
         var params:Array = param1;
         if(params.length != 3)
         {
            Debug.logError("Invalid parameters, expected [name, var, value].");
         }
         else
         {
            e = this.world.getEntityByName(params[0]);
            if(e != null)
            {
               p = params[1];
               if(e.hasOwnProperty(p))
               {
                  try
                  {
                     switch(typeof e[p])
                     {
                        case "number":
                           e[p] = Number(params[2]);
                           break;
                        case "string":
                           e[p] = params[2];
                           break;
                        case "boolean":
                           switch(String(params[2]).toLowerCase())
                           {
                              case "true":
                                 e[p] = true;
                                 break;
                              case "false":
                                 e[p] = false;
                                 break;
                              default:
                                 Debug.logError("Invalid boolean: " + params[2]);
                           }
                           break;
                        default:
                           Debug.logError("Cannot set variable type: " + typeof e[p]);
                     }
                  }
                  catch(e:Error)
                  {
                     Debug.logError(e.message);
                  }
               }
               else
               {
                  Debug.logError("Entity does not have public property: " + p);
               }
            }
            else
            {
               Debug.logError("No entity with name: " + params[0]);
            }
         }
      }
      
      private function getCommand(param1:Array) : void
      {
         var e:Entity = null;
         var p:String = null;
         var params:Array = param1;
         if(params.length != 2)
         {
            Debug.logError("Invalid parameters, expected [name, var].");
         }
         else
         {
            e = this.world.getEntityByName(params[0]);
            if(e != null)
            {
               p = params[1];
               if(e.hasOwnProperty(p))
               {
                  try
                  {
                     Debug.log(e[p]);
                  }
                  catch(e:Error)
                  {
                     Debug.logError(e.message);
                  }
               }
               else
               {
                  Debug.logError("Entity does not have public property: " + p);
               }
            }
            else
            {
               Debug.logError("No entity with name: " + params[0]);
            }
         }
      }
      
      private function performCommand(param1:Array) : void
      {
         var e:Entity = null;
         var p:String = null;
         var i:int = 0;
         var params:Array = param1;
         if(params.length < 2)
         {
            Debug.logError("Invalid parameters, expected [name, method, ...params].");
         }
         else
         {
            e = this.world.getEntityByName(params[0]);
            if(e != null)
            {
               p = params[1];
               if(e.hasOwnProperty(p))
               {
                  params.shift();
                  params.shift();
                  if(e[p].length == params.length)
                  {
                     if(params.length > 0)
                     {
                        try
                        {
                           e[p].apply(null,params);
                        }
                        catch(a:Error)
                        {
                           try
                           {
                              i = 0;
                              while(i < params.length)
                              {
                                 params[i] = Number(params[i]);
                                 i++;
                              }
                              e[p].apply(null,params);
                           }
                           catch(b:Error)
                           {
                              Debug.logError("Could not perform function. Function parameters must be all strings or all numeric.");
                           }
                        }
                     }
                     else
                     {
                        e[p]();
                     }
                  }
                  else
                  {
                     Debug.logError("Argument mismatch. Expected " + e[p].length + ", got " + params.length + ".");
                  }
               }
               else
               {
                  Debug.logError("Entity does not have public property: " + p);
               }
            }
            else
            {
               Debug.logError("No entity with name: " + params[0]);
            }
         }
      }
      
      private function performOnCommand(param1:Array) : void
      {
         var type:Class = null;
         var list:Array = null;
         var p:String = null;
         var e:Object = null;
         var params:Array = param1;
         if(params.length < 2)
         {
            Debug.logError("Invalid parameters, expected [name, method, ...params].");
         }
         else
         {
            try
            {
               type = Class(getDefinitionByName(params[0]));
            }
            catch(e:Error)
            {
               Debug.logError("Class type does not exist: " + params[0]);
               return;
            }
            list = this.world.getEntitiesByType(type,[]);
            p = params[1];
            params.shift();
            params.shift();
            for each(e in list)
            {
               if(Boolean(e.hasOwnProperty(p)) && e[p].length == 0 && params.length == 0)
               {
                  e[p]();
               }
            }
         }
      }
      
      private function setWorldCommand(param1:Array) : void
      {
         var type:Class = null;
         var world:World = null;
         var params:Array = param1;
         if(params.length != 1)
         {
            Debug.logError("Invalid parameters, expected [worldType].");
         }
         else
         {
            try
            {
               type = Class(getDefinitionByName(params[0]));
            }
            catch(e:Error)
            {
               Debug.logError("Class type does not exist (or is not a World): " + params[0]);
               return;
            }
            try
            {
               world = new type();
            }
            catch(e:Error)
            {
               Debug.logError(e.message);
            }
            this.engine.setWorld(world);
         }
      }
   }
}

