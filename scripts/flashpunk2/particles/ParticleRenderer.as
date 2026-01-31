package flashpunk2.particles
{
   import flash.display.Sprite;
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.Renderer;
   import flashpunk2.global.Asset;
   import flashpunk2.global.Time;
   import flashpunk2.namespaces.fp_internal;
   import game.Constants;
   import starling.extensions.PDParticleSystem;
   import starling.textures.Texture;
   
   use namespace fp_internal;
   
   public class ParticleRenderer extends Renderer
   {
      
      public static const SQUARE:Texture = Texture.fromColor(1,1,4294967295,false,1);
      
      private var _particleSystem:PDParticleSystem;
      
      private var time:Number;
      
      private var parDisplayObject:Sprite;
      
      private var offsetX:int = 0;
      
      private var offsetY:int = 0;
      
      private var killOnEnd:Boolean;
      
      private var name:String;
      
      private var _shouldReset:Boolean = true;
      
      public function ParticleRenderer(param1:XML, param2:String = "unknown")
      {
         super();
         this.name = param2;
         var _loc3_:Texture = param1.texture.@name == undefined ? SQUARE : Asset.getTextureFromSource(String(param1.texture.@name));
         this._particleSystem = new PDParticleSystem(param1,_loc3_);
         fp_internal::setDisplayObject(this._particleSystem);
      }
      
      private function onCheckForKill() : void
      {
         if(this.killOnEnd && this._particleSystem.numParticles == 0 && !this._particleSystem.isEmitting)
         {
            removeSelf();
         }
      }
      
      override fp_internal function start(param1:Entity) : void
      {
         super.fp_internal::start(param1);
         param1.ON_UPDATE.add(this.onJug);
         param1.ON_UPDATE.add(this.onCheckForKill);
      }
      
      private function onJug() : void
      {
         this._particleSystem.advanceTime(Constants.SECS_PER_STEP);
      }
      
      override fp_internal function end() : void
      {
         super.fp_internal::end();
      }
      
      public function burst(param1:int, param2:Boolean) : void
      {
         this.killOnEnd = param2;
         if(param1 < 0)
         {
            this._particleSystem.start();
         }
         else
         {
            this._particleSystem.start(Time.dt * param1);
         }
      }
      
      public function offset(param1:int, param2:int) : void
      {
         this.offsetX = param1;
         this.offsetY = param2;
      }
      
      public function moveEmitter(param1:int, param2:int) : void
      {
         this._particleSystem.emitterX = param1;
         this._particleSystem.emitterY = param2;
      }
      
      public function stop(param1:Boolean = true) : void
      {
         this.killOnEnd = param1;
         this._particleSystem.stop(false);
      }
      
      public function setSourceSize(param1:Number, param2:Number) : ParticleRenderer
      {
         this._particleSystem.emitterXVariance = param1 / 2;
         this._particleSystem.emitterYVariance = param2 / 2;
         return this;
      }
      
      public function simulate(param1:Number) : ParticleRenderer
      {
         while(param1 > 0)
         {
            this._particleSystem.advanceTime(1 / 60);
            param1 -= 1 / 60;
         }
         return this;
      }
      
      public function kill() : void
      {
         this._particleSystem.stop(false);
         this.killOnEnd = true;
      }
      
      public function angleVariation(param1:Number) : ParticleRenderer
      {
         this._particleSystem.emitAngleVariance = param1;
         return this;
      }
      
      public function speed(param1:Number) : ParticleRenderer
      {
         this._particleSystem.speed = param1;
         return this;
      }
      
      public function max(param1:int) : ParticleRenderer
      {
         this._particleSystem.maxNumParticles = param1;
         return this;
      }
      
      public function startSize(param1:Number) : ParticleRenderer
      {
         this._particleSystem.startSize = param1;
         return this;
      }
      
      public function shouldReset(param1:Boolean) : ParticleRenderer
      {
         this._shouldReset = param1;
         return this;
      }
      
      public function onReset() : void
      {
         if(this._shouldReset)
         {
            removeSelf();
         }
      }
   }
}

