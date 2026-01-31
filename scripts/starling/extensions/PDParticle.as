package starling.extensions
{
   public class PDParticle extends Particle
   {
      
      public var colorArgb:ColorArgb;
      
      public var colorArgbDelta:ColorArgb;
      
      public var startX:Number;
      
      public var startY:Number;
      
      public var velocityX:Number;
      
      public var velocityY:Number;
      
      public var tangentialAcceleration:Number;
      
      public var scaleDelta:Number;
      
      public function PDParticle()
      {
         super();
         this.colorArgb = new ColorArgb();
         this.colorArgbDelta = new ColorArgb();
      }
   }
}

