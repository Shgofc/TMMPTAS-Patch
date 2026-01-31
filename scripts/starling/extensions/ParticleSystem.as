package starling.extensions
{
   import com.adobe.utils.AGALMiniAssembler;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DBlendFactor;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DTextureFormat;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.display3D.IndexBuffer3D;
   import flash.display3D.Program3D;
   import flash.display3D.VertexBuffer3D;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.animation.IAnimatable;
   import starling.core.RenderSupport;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.errors.MissingContextError;
   import starling.events.Event;
   import starling.textures.Texture;
   import starling.utils.MatrixUtil;
   import starling.utils.VertexData;
   
   public class ParticleSystem extends DisplayObject implements IAnimatable
   {
      
      private static var sHelperMatrix:Matrix = new Matrix();
      
      private static var sHelperPoint:Point = new Point();
      
      private static var sRenderAlpha:Vector.<Number> = new <Number>[1,1,1,1];
      
      private var mTexture:Texture;
      
      private var mParticles:Vector.<Particle>;
      
      private var mFrameTime:Number;
      
      private var mProgram:Program3D;
      
      private var mVertexData:VertexData;
      
      private var mVertexBuffer:VertexBuffer3D;
      
      private var mIndices:Vector.<uint>;
      
      private var mIndexBuffer:IndexBuffer3D;
      
      private var mNumParticles:int;
      
      private var mMaxCapacity:int;
      
      private var mEmissionRate:Number;
      
      private var mEmissionTime:Number;
      
      protected var mEmitterX:Number;
      
      protected var mEmitterY:Number;
      
      protected var mPremultipliedAlpha:Boolean;
      
      protected var mBlendFactorSource:String;
      
      protected var mBlendFactorDestination:String;
      
      public function ParticleSystem(param1:Texture, param2:Number, param3:int = 128, param4:int = 8192, param5:String = null, param6:String = null)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("texture must not be null");
         }
         this.mTexture = param1;
         this.mPremultipliedAlpha = param1.premultipliedAlpha;
         this.mParticles = new Vector.<Particle>(0,false);
         this.mVertexData = new VertexData(0);
         this.mIndices = new Vector.<uint>(0);
         this.mEmissionRate = param2;
         this.mEmissionTime = 0;
         this.mFrameTime = 0;
         this.mEmitterX = this.mEmitterY = 0;
         this.mMaxCapacity = Math.min(8192,param4);
         this.mBlendFactorDestination = param6 || Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
         this.mBlendFactorSource = param5 || (this.mPremultipliedAlpha ? Context3DBlendFactor.ONE : Context3DBlendFactor.SOURCE_ALPHA);
         this.createProgram();
         this.raiseCapacity(param3);
         Starling.current.stage3D.addEventListener(Event.CONTEXT3D_CREATE,this.onContextCreated,false,0,true);
      }
      
      override public function dispose() : void
      {
         Starling.current.stage3D.removeEventListener(Event.CONTEXT3D_CREATE,this.onContextCreated);
         if(this.mVertexBuffer)
         {
            this.mVertexBuffer.dispose();
         }
         if(this.mIndexBuffer)
         {
            this.mIndexBuffer.dispose();
         }
         if(this.mProgram)
         {
            this.mProgram.dispose();
         }
         super.dispose();
      }
      
      private function onContextCreated(param1:Object) : void
      {
         this.createProgram();
         this.raiseCapacity(0);
      }
      
      protected function createParticle() : Particle
      {
         return new Particle();
      }
      
      protected function initParticle(param1:Particle) : void
      {
         param1.x = this.mEmitterX;
         param1.y = this.mEmitterY;
         param1.currentTime = 0;
         param1.totalTime = 1;
         param1.color = Math.random() * 16777215;
      }
      
      protected function advanceParticle(param1:Particle, param2:Number) : void
      {
         param1.y += param2 * 250;
         param1.alpha = 1 - param1.currentTime / param1.totalTime;
         param1.scale = 1 - param1.alpha;
         param1.currentTime += param2;
      }
      
      private function raiseCapacity(param1:int) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:int = this.capacity;
         var _loc3_:int = Math.min(this.mMaxCapacity,this.capacity + param1);
         var _loc4_:Context3D = Starling.context;
         if(_loc4_ == null)
         {
            throw new MissingContextError();
         }
         var _loc5_:VertexData = new VertexData(4);
         _loc5_.setTexCoords(0,0,0);
         _loc5_.setTexCoords(1,1,0);
         _loc5_.setTexCoords(2,0,1);
         _loc5_.setTexCoords(3,1,1);
         this.mTexture.adjustVertexData(_loc5_,0,4);
         this.mParticles.fixed = false;
         this.mIndices.fixed = false;
         var _loc6_:int = _loc2_;
         while(_loc6_ < _loc3_)
         {
            _loc7_ = _loc6_ * 4;
            _loc8_ = _loc6_ * 6;
            this.mParticles[_loc6_] = this.createParticle();
            this.mVertexData.append(_loc5_);
            this.mIndices[_loc8_] = _loc7_;
            this.mIndices[int(_loc8_ + 1)] = _loc7_ + 1;
            this.mIndices[int(_loc8_ + 2)] = _loc7_ + 2;
            this.mIndices[int(_loc8_ + 3)] = _loc7_ + 1;
            this.mIndices[int(_loc8_ + 4)] = _loc7_ + 3;
            this.mIndices[int(_loc8_ + 5)] = _loc7_ + 2;
            _loc6_++;
         }
         this.mParticles.fixed = true;
         this.mIndices.fixed = true;
         if(this.mVertexBuffer)
         {
            this.mVertexBuffer.dispose();
         }
         if(this.mIndexBuffer)
         {
            this.mIndexBuffer.dispose();
         }
         this.mVertexBuffer = _loc4_.createVertexBuffer(_loc3_ * 4,VertexData.ELEMENTS_PER_VERTEX);
         this.mVertexBuffer.uploadFromVector(this.mVertexData.rawData,0,_loc3_ * 4);
         this.mIndexBuffer = _loc4_.createIndexBuffer(_loc3_ * 6);
         this.mIndexBuffer.uploadFromVector(this.mIndices,0,_loc3_ * 6);
      }
      
      public function start(param1:Number = 1.7976931348623157e+308) : void
      {
         if(this.mEmissionRate != 0)
         {
            this.mEmissionTime = param1;
         }
      }
      
      public function stop(param1:Boolean = false) : void
      {
         this.mEmissionTime = 0;
         if(param1)
         {
            this.mNumParticles = 0;
         }
      }
      
      override public function getBounds(param1:DisplayObject, param2:Rectangle = null) : Rectangle
      {
         if(param2 == null)
         {
            param2 = new Rectangle();
         }
         getTransformationMatrix(param1,sHelperMatrix);
         MatrixUtil.transformCoords(sHelperMatrix,0,0,sHelperPoint);
         param2.x = sHelperPoint.x;
         param2.y = sHelperPoint.y;
         param2.width = param2.height = 0;
         return param2;
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc3_:Particle = null;
         var _loc5_:uint = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc15_:Particle = null;
         var _loc16_:Number = NaN;
         var _loc17_:int = 0;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc2_:int = 0;
         while(_loc2_ < this.mNumParticles)
         {
            _loc3_ = this.mParticles[_loc2_] as Particle;
            if(_loc3_.currentTime < _loc3_.totalTime)
            {
               this.advanceParticle(_loc3_,param1);
               _loc2_++;
            }
            else
            {
               if(_loc2_ != this.mNumParticles - 1)
               {
                  _loc15_ = this.mParticles[int(this.mNumParticles - 1)] as Particle;
                  this.mParticles[int(this.mNumParticles - 1)] = _loc3_;
                  this.mParticles[_loc2_] = _loc15_;
               }
               --this.mNumParticles;
               if(this.mNumParticles == 0 && this.mEmissionTime == 0)
               {
                  dispatchEvent(new Event(Event.COMPLETE));
               }
            }
         }
         if(this.mEmissionTime > 0)
         {
            _loc16_ = 1 / this.mEmissionRate;
            this.mFrameTime += param1;
            while(this.mFrameTime > 0)
            {
               if(this.mNumParticles < this.mMaxCapacity)
               {
                  if(this.mNumParticles == this.capacity)
                  {
                     this.raiseCapacity(this.capacity);
                  }
                  _loc3_ = this.mParticles[int(this.mNumParticles++)] as Particle;
                  this.initParticle(_loc3_);
                  this.advanceParticle(_loc3_,this.mFrameTime);
               }
               this.mFrameTime -= _loc16_;
            }
            if(this.mEmissionTime != Number.MAX_VALUE)
            {
               this.mEmissionTime = Math.max(0,this.mEmissionTime - param1);
            }
         }
         var _loc4_:* = 0;
         var _loc12_:Number = this.mTexture.width;
         var _loc13_:Number = this.mTexture.height;
         var _loc14_:int = 0;
         while(_loc14_ < this.mNumParticles)
         {
            _loc4_ = _loc14_ << 2;
            _loc3_ = this.mParticles[_loc14_] as Particle;
            _loc5_ = _loc3_.color;
            _loc6_ = _loc3_.alpha;
            _loc7_ = _loc3_.rotation;
            _loc8_ = _loc3_.x;
            _loc9_ = _loc3_.y;
            _loc10_ = _loc12_ * _loc3_.scale >> 1;
            _loc11_ = _loc13_ * _loc3_.scale >> 1;
            _loc17_ = 0;
            while(_loc17_ < 4)
            {
               this.mVertexData.setColor(_loc4_ + _loc17_,_loc5_);
               this.mVertexData.setAlpha(_loc4_ + _loc17_,_loc6_);
               _loc17_++;
            }
            if(_loc7_)
            {
               _loc18_ = Math.cos(_loc7_);
               _loc19_ = Math.sin(_loc7_);
               _loc20_ = _loc18_ * _loc10_;
               _loc21_ = _loc18_ * _loc11_;
               _loc22_ = _loc19_ * _loc10_;
               _loc23_ = _loc19_ * _loc11_;
               this.mVertexData.setPosition(_loc4_,_loc8_ - _loc20_ + _loc23_,_loc9_ - _loc22_ - _loc21_);
               this.mVertexData.setPosition(_loc4_ + 1,_loc8_ + _loc20_ + _loc23_,_loc9_ + _loc22_ - _loc21_);
               this.mVertexData.setPosition(_loc4_ + 2,_loc8_ - _loc20_ - _loc23_,_loc9_ - _loc22_ + _loc21_);
               this.mVertexData.setPosition(_loc4_ + 3,_loc8_ + _loc20_ - _loc23_,_loc9_ + _loc22_ + _loc21_);
            }
            else
            {
               this.mVertexData.setPosition(_loc4_,_loc8_ - _loc10_,_loc9_ - _loc11_);
               this.mVertexData.setPosition(_loc4_ + 1,_loc8_ + _loc10_,_loc9_ - _loc11_);
               this.mVertexData.setPosition(_loc4_ + 2,_loc8_ - _loc10_,_loc9_ + _loc11_);
               this.mVertexData.setPosition(_loc4_ + 3,_loc8_ + _loc10_,_loc9_ + _loc11_);
            }
            _loc14_++;
         }
      }
      
      override public function render(param1:RenderSupport, param2:Number) : void
      {
         if(this.mNumParticles == 0)
         {
            return;
         }
         param1.finishQuadBatch();
         if(param1.hasOwnProperty("raiseDrawCount"))
         {
            param1.raiseDrawCount();
         }
         param2 *= this.alpha;
         var _loc3_:Context3D = Starling.context;
         var _loc4_:Boolean = this.texture.premultipliedAlpha;
         sRenderAlpha[0] = sRenderAlpha[1] = sRenderAlpha[2] = _loc4_ ? param2 : 1;
         sRenderAlpha[3] = param2;
         if(_loc3_ == null)
         {
            throw new MissingContextError();
         }
         this.mVertexBuffer.uploadFromVector(this.mVertexData.rawData,0,this.mNumParticles * 4);
         this.mIndexBuffer.uploadFromVector(this.mIndices,0,this.mNumParticles * 6);
         _loc3_.setBlendFactors(this.mBlendFactorSource,this.mBlendFactorDestination);
         _loc3_.setTextureAt(0,this.mTexture.base);
         _loc3_.setProgram(this.mProgram);
         _loc3_.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,param1.mvpMatrix3D,true);
         _loc3_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,sRenderAlpha,1);
         _loc3_.setVertexBufferAt(0,this.mVertexBuffer,VertexData.POSITION_OFFSET,Context3DVertexBufferFormat.FLOAT_2);
         _loc3_.setVertexBufferAt(1,this.mVertexBuffer,VertexData.COLOR_OFFSET,Context3DVertexBufferFormat.FLOAT_4);
         _loc3_.setVertexBufferAt(2,this.mVertexBuffer,VertexData.TEXCOORD_OFFSET,Context3DVertexBufferFormat.FLOAT_2);
         _loc3_.drawTriangles(this.mIndexBuffer,0,this.mNumParticles * 2);
         _loc3_.setTextureAt(0,null);
         _loc3_.setVertexBufferAt(0,null);
         _loc3_.setVertexBufferAt(1,null);
         _loc3_.setVertexBufferAt(2,null);
      }
      
      private function createProgram() : void
      {
         var _loc1_:Boolean = this.mTexture.mipMapping;
         var _loc2_:String = this.mTexture.format;
         var _loc3_:Context3D = Starling.context;
         if(_loc3_ == null)
         {
            throw new MissingContextError();
         }
         if(this.mProgram)
         {
            this.mProgram.dispose();
         }
         var _loc4_:* = "2d, clamp, linear, " + (_loc1_ ? "mipnearest" : "mipnone");
         if(_loc2_ == Context3DTextureFormat.COMPRESSED)
         {
            _loc4_ += ", dxt1";
         }
         else if(_loc2_ == "compressedAlpha")
         {
            _loc4_ += ", dxt5";
         }
         var _loc5_:* = "m44 op, va0, vc0 \n" + "mul v0, va1, vc4 \n" + "mov v1, va2      \n";
         var _loc6_:* = "tex ft1, v1, fs0 <" + _loc4_ + "> \n" + "mul oc, ft1, v0";
         var _loc7_:AGALMiniAssembler = new AGALMiniAssembler();
         _loc7_.assemble(Context3DProgramType.VERTEX,_loc5_);
         var _loc8_:AGALMiniAssembler = new AGALMiniAssembler();
         _loc8_.assemble(Context3DProgramType.FRAGMENT,_loc6_);
         this.mProgram = _loc3_.createProgram();
         this.mProgram.upload(_loc7_.agalcode,_loc8_.agalcode);
      }
      
      public function get isEmitting() : Boolean
      {
         return this.mEmissionTime > 0 && this.mEmissionRate > 0;
      }
      
      public function get capacity() : int
      {
         return this.mVertexData.numVertices / 4;
      }
      
      public function get numParticles() : int
      {
         return this.mNumParticles;
      }
      
      public function get maxCapacity() : int
      {
         return this.mMaxCapacity;
      }
      
      public function set maxCapacity(param1:int) : void
      {
         this.mMaxCapacity = Math.min(8192,param1);
      }
      
      public function get emissionRate() : Number
      {
         return this.mEmissionRate;
      }
      
      public function set emissionRate(param1:Number) : void
      {
         this.mEmissionRate = param1;
      }
      
      public function get emitterX() : Number
      {
         return this.mEmitterX;
      }
      
      public function set emitterX(param1:Number) : void
      {
         this.mEmitterX = param1;
      }
      
      public function get emitterY() : Number
      {
         return this.mEmitterY;
      }
      
      public function set emitterY(param1:Number) : void
      {
         this.mEmitterY = param1;
      }
      
      public function get blendFactorSource() : String
      {
         return this.mBlendFactorSource;
      }
      
      public function set blendFactorSource(param1:String) : void
      {
         this.mBlendFactorSource = param1;
      }
      
      public function get blendFactorDestination() : String
      {
         return this.mBlendFactorDestination;
      }
      
      public function set blendFactorDestination(param1:String) : void
      {
         this.mBlendFactorDestination = param1;
      }
      
      public function get texture() : Texture
      {
         return this.mTexture;
      }
      
      public function set texture(param1:Texture) : void
      {
         this.mTexture = param1;
         this.createProgram();
      }
   }
}

