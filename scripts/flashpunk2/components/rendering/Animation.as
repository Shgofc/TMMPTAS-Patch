package flashpunk2.components.rendering
{
   import flashpunk2.global.Asset;
   import starling.textures.Texture;
   
   public class Animation
   {
      
      private var _name:String;
      
      private var _frameRate:Number;
      
      private var _frames:Vector.<String>;
      
      private var _loop:Boolean;
      
      private var _rate:Number = 1;
      
      public function Animation(param1:String, param2:Vector.<String>, param3:Number, param4:Boolean)
      {
         super();
         this._name = param1;
         this._frames = param2;
         this._frameRate = param3;
         this._loop = param4;
      }
      
      public function getTextureByIndex(param1:uint) : Texture
      {
         return Asset.getSubTextureByName(this.getFrameName(param1));
      }
      
      public function getTextureByName(param1:String) : Texture
      {
         if(this._frames.indexOf(param1) < 0)
         {
            throw new Error("Animation does not contain the frame: " + param1);
         }
         return Asset.getSubTextureByName(param1);
      }
      
      public function getFrameName(param1:uint) : String
      {
         if(param1 >= this._frames.length)
         {
            throw new Error("Frame index out of bounds.");
         }
         return this._frames[param1];
      }
      
      public function getFrameIndex(param1:String) : int
      {
         var _loc2_:int = int(this._frames.indexOf(param1));
         if(_loc2_ < 0)
         {
            throw new Error("Animation does not contain frame: " + param1);
         }
         return _loc2_;
      }
      
      public function hasFrame(param1:String) : Boolean
      {
         return this._frames.indexOf(param1) >= 0;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get frameRate() : Number
      {
         return this._frameRate;
      }
      
      public function set frameRate(param1:Number) : void
      {
         this._frameRate = param1;
      }
      
      public function get loop() : Boolean
      {
         return this._loop;
      }
      
      public function set loop(param1:Boolean) : void
      {
         this._loop = param1;
      }
      
      public function get length() : int
      {
         return this._frames.length;
      }
      
      public function get rate() : Number
      {
         return this._rate;
      }
      
      public function set rate(param1:Number) : void
      {
         this._rate = param1;
      }
      
      public function get frameDuration() : Number
      {
         return 1 / this._frameRate * this._rate;
      }
   }
}

