package flashpunk2.components.rendering
{
   import flashpunk2.Engine;
   import flashpunk2.Entity;
   import flashpunk2.Signal;
   import flashpunk2.global.Asset;
   import flashpunk2.global.Time;
   import flashpunk2.namespaces.fp_internal;
   import starling.display.Image;
   import starling.textures.Texture;
   import starling.textures.TextureSmoothing;
   
   use namespace fp_internal;
   
   public class AnimationRenderer extends Renderer
   {
      
      public const ON_COMPLETE:Signal = new Signal();
      
      private var _animationLookup:Object = {};
      
      private var _chain:Object = {};
      
      private var _chainTo:String;
      
      private var _image:Image;
      
      private var _animation:Animation;
      
      private var _rate:Number = 1;
      
      private var _index:int = 0;
      
      private var _elapsed:Number = 0;
      
      private var _smooth:Boolean;
      
      private var _textureName:String;
      
      private var paused:Boolean = false;
      
      public function AnimationRenderer()
      {
         super();
      }
      
      override fp_internal function start(param1:Entity) : void
      {
         if(this._image == null)
         {
            throw new Error("Animator must have animations before being added to the world.");
         }
         super.fp_internal::start(param1);
         param1.ON_UPDATE.add(this.onUpdate);
      }
      
      override fp_internal function end() : void
      {
         entity.ON_UPDATE.remove(this.onUpdate);
         super.fp_internal::end();
      }
      
      private function onUpdate() : void
      {
         var _loc1_:String = null;
         if(this._animation != null && !this.paused)
         {
            this._elapsed += Time.dt * this._rate;
            if(this._elapsed >= this._animation.frameDuration)
            {
               this._elapsed -= this._animation.frameDuration;
               ++this.index;
               if(this._index == this._animation.length - 1)
               {
                  _loc1_ = this._animation.name;
                  if(!this._animation.loop)
                  {
                     this.pause();
                  }
                  this.performChain(_loc1_);
                  this.ON_COMPLETE.dispatch();
               }
            }
         }
      }
      
      private function performChain(param1:String) : void
      {
         if(param1 in this._chain)
         {
            if(this._chain[param1] is String)
            {
               this.play(this._chain[param1]);
            }
            else if(this._chain[param1] is Function)
            {
               this._chain[param1]();
            }
         }
      }
      
      public function chain(param1:String, param2:*) : void
      {
         this._chain[param1] = param2;
      }
      
      public function add(param1:Animation) : void
      {
         if(param1.name in this._animationLookup)
         {
            throw new Error("Animation already exists: " + param1.name);
         }
         if(this._image == null)
         {
            this._image = new Image(param1.getTextureByIndex(0));
            this._image.smoothing = TextureSmoothing.NONE;
            this.smooth = Engine.instance.smoothing;
            fp_internal::setDisplayObject(this._image);
         }
         this._animationLookup[param1.name] = param1;
      }
      
      public function addAnimation(param1:Animation) : void
      {
         this.add(param1);
      }
      
      public function addPrefix(param1:String, param2:String, param3:Number, param4:Boolean) : Animation
      {
         var _loc5_:Animation = new Animation(param1,Asset.getSubTexturesByPrefix(param2),param3,param4);
         this.add(_loc5_);
         return _loc5_;
      }
      
      public function addPrefixRange(param1:String, param2:String, param3:uint, param4:uint, param5:Number, param6:Boolean) : Animation
      {
         var _loc7_:Animation = new Animation(param1,Asset.getSubTexturesByPrefixRange(param2,param3,param4),param5,param6);
         this.add(_loc7_);
         return _loc7_;
      }
      
      public function addPrefixSet(param1:String, param2:String, param3:uint, param4:uint, param5:Number, param6:Boolean) : Animation
      {
         var _loc7_:Animation = new Animation(param1,Asset.getSubTexturesByPrefixRange(param2,param3,param4 - param3 + 1),param5,param6);
         this.add(_loc7_);
         return _loc7_;
      }
      
      public function play(param1:String, param2:Boolean = false) : void
      {
         if(!(param1 in this._animationLookup))
         {
            throw new Error("Animation does not exist: " + param1);
         }
         this.playAnimation(this._animationLookup[param1],param2);
      }
      
      public function playAnimation(param1:Animation, param2:Boolean = false) : void
      {
         if(this._animation != param1 || param2 || param1 == this._animation && this.paused)
         {
            this._animation = param1;
            this._index = 0;
            this.index = 0;
            this.paused = false;
         }
      }
      
      public function restart() : void
      {
         if(this._animation != null)
         {
            this.playAnimation(this._animation,true);
         }
      }
      
      public function pause() : void
      {
         this.paused = true;
      }
      
      public function resume() : void
      {
         this.paused = false;
      }
      
      public function stop() : void
      {
         if(this._animation != null)
         {
            this._animation = null;
         }
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         if(this._index != param1)
         {
            this._index = param1;
            if(this._index >= this._animation.length)
            {
               this._index %= this._animation.length - 1;
            }
            this._image.texture = this._animation.getTextureByIndex(this._index);
            this._textureName = this._animation.getFrameName(this._index);
            this._elapsed = 0;
         }
      }
      
      public function get textureName() : String
      {
         return this._textureName != null ? this._textureName : this._animation.getFrameName(this._index);
      }
      
      public function get frame() : String
      {
         return this._animation.getFrameName(this._index);
      }
      
      public function set frame(param1:String) : void
      {
         if(this.frame != param1 && this._animation.hasFrame(param1))
         {
            this._index = this._animation.getFrameIndex(param1);
         }
      }
      
      public function get animation() : Animation
      {
         return this._animation;
      }
      
      public function get animationName() : String
      {
         return this._animation != null ? this._animation.name : null;
      }
      
      public function get playing() : Boolean
      {
         return this._animation != null || this.paused;
      }
      
      public function get looping() : Boolean
      {
         return this._animation != null && this._animation.loop;
      }
      
      public function get rate() : Number
      {
         return this._rate;
      }
      
      public function set rate(param1:Number) : void
      {
         this._rate = Math.max(param1,0);
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
      
      override public function get width() : Number
      {
         return this._image.texture.frame.width;
      }
      
      override public function get height() : Number
      {
         return super.height;
      }
      
      public function set texture(param1:Texture) : void
      {
         this._image.texture = param1;
      }
   }
}

