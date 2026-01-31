package game.environment
{
   import flash.geom.Rectangle;
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.components.rendering.Renderer;
   import flashpunk2.global.Asset;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Debug;
   import flashpunk2.global.Ease;
   import flashpunk2.global.Rand;
   import game.UserData;
   import game.player.Player;
   import game.ui.Baloon;
   import game.world.Cutscene;
   import game.world.PlatformLevel;
   
   public class Npc extends Entity
   {
      
      private var side:int = 1;
      
      private var image:Renderer;
      
      private var body:Rectangle;
      
      private var baloon:Baloon;
      
      private var text:String;
      
      private var flip:Boolean;
      
      private var cutscene:String;
      
      private var hasBlink:Boolean = false;
      
      public function Npc(param1:int, param2:int, param3:String, param4:String, param5:Boolean, param6:String)
      {
         this.cutscene = param6;
         this.flip = param5;
         this.text = param3;
         if(param4 == "placa")
         {
            this.image = new ImageRenderer("npc/sign",true);
         }
         else
         {
            this.image = new AnimationRenderer();
            (this.image as AnimationRenderer).addPrefix("idle","npc/" + param4,10,false);
            if(Asset.hasSubTextureName("npc/" + param4 + "Blink0000"))
            {
               (this.image as AnimationRenderer).addPrefix("blink","npc/" + param4 + "Blink",10,false);
               this.hasBlink = true;
            }
            (this.image as AnimationRenderer).play("idle");
            (this.image as AnimationRenderer).ON_COMPLETE.add(this.onBlink);
         }
         super(param1 + this.image.width / 2,param2 + this.image.height / 2);
         this.body = new Rectangle(param1 + this.image.width / 4,param2 + 16,32,32);
         this.image.centerOrigin();
         this.image.y = -this.image.height + 64;
         add(this.image);
         ON_UPDATE.add(this.onUpdate);
         ON_DEBUG.add(this.onDebug);
         depth = 5;
      }
      
      public function get level() : PlatformLevel
      {
         return world as PlatformLevel;
      }
      
      public function get player() : Player
      {
         return this.level.player;
      }
      
      private function onBlink() : void
      {
         if(this.hasBlink)
         {
            (this.image as AnimationRenderer).play(Rand.chance(0.2) ? "blink" : "idle");
         }
         else
         {
            (this.image as AnimationRenderer).play("idle");
         }
      }
      
      private function onDebug() : void
      {
         Debug.drawRectOutline(this.body.x,this.body.y,this.body.width,this.body.height,16777215);
      }
      
      private function onUpdate() : void
      {
         if(this.flip)
         {
            if(this.player.x != x)
            {
               this.side = Calc.sign(this.player.x - x);
            }
            if(Calc.sign(this.image.scaleX) != this.side)
            {
               tween(this.image,0.4).scaleFrom(0.7 * this.side,1).scaleTo(1 * this.side,1).ease(Ease.backOut);
            }
         }
         if(this.level.player.body.intersects(this.body))
         {
            if(this.cutscene != "" && !UserData.getTrigger("cut_" + this.cutscene))
            {
               engine.setWorld(new Cutscene(this.cutscene,world,false));
               UserData.setTrigger("cut_" + this.cutscene);
            }
            this.cutscene = "";
            if(this.baloon == null)
            {
               this.baloon = new Baloon(x,y - this.image.height,this.text);
               this.level.add(this.baloon);
            }
         }
         else if(this.baloon != null)
         {
            this.baloon.fade();
            this.baloon = null;
         }
      }
   }
}

