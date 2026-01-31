package game
{
   import flash.geom.Rectangle;
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.Renderer;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Debug;
   import game.environment.MovingPlatform;
   import game.environment.Slope;
   import game.environment.Solid;
   import game.environment.Wall;
   import game.world.PlatformLevel;
   
   public class PlatformObject extends Entity
   {
      
      public var gravity:Number = 800;
      
      protected var damping:Number = 0.7;
      
      private var image:Renderer;
      
      protected var _xSpeed:Number = 0;
      
      protected var _ySpeed:Number = 0;
      
      protected var level:PlatformLevel;
      
      protected var _body:Rectangle;
      
      private var remainder:Vector.<Number> = Vector.<Number>([0,0]);
      
      private var _onGround:Boolean = false;
      
      private var keepOnBounds:Boolean;
      
      public function PlatformObject(param1:int, param2:int, param3:uint, param4:uint, param5:Boolean = false, param6:Boolean = true)
      {
         this.keepOnBounds = param5;
         this._body = new Rectangle(-param3 / 2,-param4 / 2,param3,param4);
         super(param1 + this._body.x,param2 + this.body.y);
         ON_START.add(this.onStart);
         ON_DEBUG.add(this.onDebug);
         if(param6)
         {
            ON_UPDATE.add(this.onUpdate);
         }
      }
      
      public function get xSpeed() : Number
      {
         return this._xSpeed;
      }
      
      public function get ySpeed() : Number
      {
         return this._ySpeed;
      }
      
      public function get body() : Rectangle
      {
         return this._body;
      }
      
      public function get onGround() : Boolean
      {
         return this._onGround;
      }
      
      public function onBounce(param1:Number) : void
      {
         this._ySpeed = -Math.abs(param1);
      }
      
      protected function onDebug() : void
      {
         Debug.drawRectOutline(this.body.x,this.body.y,this.body.width,this.body.height,16711680);
      }
      
      private function onStart() : void
      {
         this.level = world as PlatformLevel;
         if(this.level == null)
         {
            throw new Error("Platform objects needs to be in a level!");
         }
      }
      
      private function onUpdate() : void
      {
         this.applyGravity();
         this.updatePosition();
         this.body.x = x - this.body.width / 2;
         this.body.y = y - this.body.height / 2;
      }
      
      protected function applyDamping() : void
      {
         this._xSpeed *= this.damping;
      }
      
      protected function updatePosition() : void
      {
         var _loc1_:Vector.<Number> = this.remainder;
         this.remainder = Vector.<Number>([0,0]);
         var _loc2_:Vector.<Number> = new Vector.<Number>(2,true);
         _loc2_[0] = x;
         _loc2_[1] = y;
         this.move(_loc2_,0,this._xSpeed * Constants.SECS_PER_STEP + _loc1_[0]);
         this.move(_loc2_,1,this._ySpeed * Constants.SECS_PER_STEP + _loc1_[1]);
         if(this.keepOnBounds)
         {
            x = Calc.clamp(_loc2_[0],-this.body.width / 2 + this.body.width / 2,this.level.width - this.body.width / 2);
            y = Calc.clamp(_loc2_[1],-this.body.height / 2,this.level.height + this.body.height / 2);
         }
         else
         {
            x = _loc2_[0];
            y = _loc2_[1];
            if(y > this.level.height)
            {
               removeSelf();
            }
         }
      }
      
      private function move(param1:Vector.<Number>, param2:int, param3:Number) : void
      {
         var _loc7_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Solid = null;
         var _loc20_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:MovingPlatform = null;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:Solid = null;
         var _loc30_:Boolean = false;
         var _loc31_:Rectangle = null;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Solid = null;
         var _loc35_:int = 0;
         var _loc36_:Solid = null;
         if(param2 == 1 && param3 > 0 && param3 < 1)
         {
            param3 = 1;
         }
         var _loc4_:Vector.<Number> = Vector.<Number>([this.body.width,this.body.height]);
         var _loc5_:int = 1 - param2;
         var _loc6_:int = param3 > 0 ? 1 : -1;
         _loc7_ = param1[param2] + _loc6_ * _loc4_[param2] / 2;
         var _loc8_:int = (param1[_loc5_] - _loc4_[_loc5_] / 2) / 32;
         var _loc9_:int = param1[_loc5_] / 32;
         var _loc10_:int = param1[_loc5_] % 32;
         var _loc11_:int = (param1[_loc5_] + _loc4_[_loc5_] / 2 - 1) / 32;
         var _loc12_:int = (_loc7_ - 1) / 32;
         var _loc13_:int = _loc6_ == 1 ? int((param2 == 0 ? this.level.horizontalTiles : this.level.verticalTiles) + 1) : -2;
         var _loc14_:Vector.<Solid> = Vector.<Solid>(this.level.getEntitiesByType(MovingPlatform));
         _loc15_ = param1[0] / Constants.TILE_WIDTH;
         _loc16_ = (param1[1] + _loc4_[1] / 2) / Constants.TILE_HEIGHT;
         _loc17_ = this.level.solidAt(_loc15_,_loc16_);
         var _loc18_:Boolean = (Boolean(_loc17_)) && (_loc17_.floorRight == 0 || _loc17_.floorLeft == 0);
         var _loc19_:Boolean = false;
         var _loc21_:Boolean = true;
         var _loc22_:Boolean = this._onGround;
         var _loc23_:int = _loc12_;
         while(_loc23_ != _loc13_ && !_loc19_)
         {
            if(x > this.level.width + 32 || x < -64 || y > this.level.height + 32 || y < -64)
            {
               break;
            }
            _loc25_ = _loc8_;
            for(; _loc25_ <= _loc11_; _loc25_++)
            {
               _loc27_ = _loc23_;
               _loc28_ = _loc25_;
               if(param2 == 1)
               {
                  _loc28_ = _loc23_;
                  _loc27_ = _loc25_;
               }
               else if(_loc18_ && _loc28_ == _loc16_)
               {
                  continue;
               }
               _loc29_ = this.level.solidAt(_loc27_,_loc28_);
               if((Boolean(_loc29_)) && _loc29_.isObstacle(param2,_loc6_))
               {
                  if(param2 == 1 || (_loc29_.floorLeft == _loc29_.floorRight || _loc6_ == 1 && _loc29_.floorLeft > _loc29_.floorRight || _loc6_ == -1 && _loc29_.floorLeft < _loc29_.floorRight))
                  {
                     if(param2 == 1)
                     {
                        if(!(_loc6_ == -1 && param1[1] < _loc29_.bottom))
                        {
                           if(_loc6_ == 1 && (_loc29_.floorLeft != Constants.TILE_HEIGHT - 1 || _loc29_.floorRight != Constants.TILE_HEIGHT - 1))
                           {
                              if(_loc27_ == _loc15_)
                              {
                                 _loc20_ = (_loc23_ + 1) * 32 - ((32 - _loc10_) * _loc29_.floorLeft + _loc10_ * _loc29_.floorRight) / 32;
                                 _loc19_ = true;
                                 break;
                              }
                           }
                           else
                           {
                              _loc20_ = _loc23_ * 32;
                              if(_loc6_ == -1)
                              {
                                 _loc20_ += 32;
                              }
                              _loc19_ = true;
                           }
                        }
                     }
                     else
                     {
                        _loc20_ = _loc23_ * 32;
                        if(_loc6_ == -1)
                        {
                           _loc20_ += 32;
                        }
                        _loc19_ = true;
                     }
                  }
               }
            }
            for each(_loc26_ in _loc14_)
            {
               _loc30_ = false;
               _loc31_ = new Rectangle(this.x + (param2 == 0 ? _loc23_ : 0) - this.body.width / 2,this.y + (param2 == 1 ? _loc23_ : 0) - this.body.height / 2,this.body.width,this.body.height);
               if(_loc31_.intersects(new Rectangle(_loc26_.x - _loc26_.body.width / 2,_loc26_.y - _loc26_.body.height / 2,_loc26_.body.width,_loc26_.body.height)))
               {
                  _loc30_ = true;
                  _loc26_.willCollide();
                  _loc19_ = true;
               }
               if(_loc30_)
               {
                  if(param2 == 1)
                  {
                     _loc20_ = _loc26_.y - _loc26_.body.height / 2 * _loc6_;
                  }
                  else if(_loc6_ < 0 && this.body.right <= _loc26_.x - _loc26_.width / 2)
                  {
                     _loc19_ = false;
                  }
                  else
                  {
                     _loc20_ = _loc26_.x - _loc26_.body.width / 2 * _loc6_;
                  }
               }
            }
            _loc23_ += _loc6_;
         }
         if(param2 == 1)
         {
            this._onGround = false;
         }
         if(_loc19_)
         {
            _loc32_ = param3;
            if(_loc6_ > 0)
            {
               param3 = Math.min(param3,_loc20_ - _loc7_);
            }
            else
            {
               param3 = Math.max(param3,_loc20_ - _loc7_);
            }
            if(param3 != _loc32_)
            {
               if(param2 == 0)
               {
                  this.onHorizontalCollide();
               }
               else
               {
                  if(this._ySpeed > 0)
                  {
                     this._onGround = true;
                     if(_loc17_)
                     {
                        this.onStep(_loc17_);
                        _loc17_.onStepped(this);
                     }
                  }
                  this._ySpeed = 0;
               }
            }
         }
         var _loc24_:int = Calc.sign(param3);
         param1[param2] += int(param3);
         this.remainder[param2] += param3 - int(param3);
         if(param2 == 1)
         {
            if(_loc22_)
            {
               if(!this.onGround)
               {
                  this.onLeaveGround();
               }
               if(!this.onGround && this._ySpeed > 0)
               {
                  _loc33_ = param1[1] + _loc4_[1] / 2;
                  _loc34_ = this.level.solidAt(_loc15_,_loc33_ / Constants.TILE_HEIGHT);
                  if((Boolean(_loc34_)) && _loc34_.floorRight != _loc34_.floorLeft)
                  {
                     this.remainder[1] = 0;
                     this._onGround = true;
                     this.snapToFloor(param1,_loc34_,_loc33_);
                  }
               }
            }
            else if(this._onGround)
            {
               this.onHitGround();
            }
         }
         else if(_loc18_ && _loc22_)
         {
            _loc35_ = param1[0] / Constants.TILE_WIDTH;
            if(_loc15_ != _loc35_ && !this.level.solidAt(_loc35_,_loc16_))
            {
               _loc36_ = this.level.solidAt(_loc35_,_loc16_ + 1);
               if(_loc36_ != null)
               {
                  if(_loc36_ is Slope && (_loc6_ < 0 && _loc36_.floorRight > 0 || _loc6_ > 0 && _loc36_.floorLeft > 0))
                  {
                     this.snapToFloor(param1,_loc36_,param1[1] + _loc4_[1] / 2);
                  }
                  else if(_loc36_ is Wall)
                  {
                     param1[1] = _loc36_.top - _loc4_[1] / 2;
                  }
               }
            }
         }
      }
      
      public function onHorizontalCollide() : void
      {
         this._xSpeed = 0;
      }
      
      protected function onStep(param1:Solid) : void
      {
      }
      
      protected function onLeaveGround() : void
      {
      }
      
      private function snapToFloor(param1:Vector.<Number>, param2:Solid, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         _loc4_ = param1[0] % Constants.TILE_WIDTH / Constants.TILE_WIDTH;
         _loc5_ = param2.top + param2.floorLeft * _loc4_ + param2.floorRight * (1 - _loc4_);
         var _loc6_:Number = _loc5_ - param3;
         param1[1] += _loc6_;
      }
      
      protected function onHitGround() : void
      {
         var _loc1_:Solid = this.level.solidAt((x - this.body.width / 2) / Constants.TILE_WIDTH,y / Constants.TILE_HEIGHT + 1);
         var _loc2_:Solid = this.level.solidAt((x + this.body.width / 2) / Constants.TILE_WIDTH,y / Constants.TILE_HEIGHT + 1);
         if(_loc1_)
         {
            _loc1_.onHit(this);
         }
         if(_loc2_)
         {
            _loc2_.onHit(this);
         }
      }
      
      private function applyGravity() : void
      {
         this._ySpeed += this.gravity * Constants.SECS_PER_STEP;
      }
      
      public function willCollide(param1:int, param2:int) : Boolean
      {
         var _loc3_:Rectangle = null;
         var _loc9_:int = 0;
         _loc3_ = new Rectangle(param1 - this.body.width / 2,param2 - this.body.height / 2,this.body.width,this.body.height);
         var _loc4_:int = _loc3_.left / 32;
         var _loc5_:int = _loc3_.top / 32;
         var _loc6_:int = _loc3_.right / 32;
         var _loc7_:int = (_loc3_.bottom - 1) / 32;
         var _loc8_:int = _loc5_;
         while(_loc8_ <= _loc7_)
         {
            _loc9_ = _loc4_;
            while(_loc9_ <= _loc6_)
            {
               if(this.level.solidAt(_loc9_,_loc8_))
               {
                  return true;
               }
               _loc9_++;
            }
            _loc8_++;
         }
         return false;
      }
   }
}

