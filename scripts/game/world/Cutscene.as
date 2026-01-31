package game.world
{
   import flashpunk2.Entity;
   import flashpunk2.Sfx;
   import flashpunk2.World;
   import flashpunk2.components.rendering.BitmapTextRenderer;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.components.rendering.RectRenderer;
   import flashpunk2.components.rendering.Renderer;
   import flashpunk2.global.Asset;
   import flashpunk2.global.Ease;
   import flashpunk2.global.Input;
   import flashpunk2.global.Key;
   import game.Constants;
   import game.Controls;
   import game.fx.ScreenFlash;
   import game.ui.Button;
   import sound.MusicPlayer;
   import sound.SoundManager;
   
   public class Cutscene extends World
   {
      
      private var cutXml:XML;
      
      private var nextLevel:World;
      
      private var backGround:Renderer;
      
      private var bgTaggedForRemove:Renderer;
      
      private var char:ImageRenderer;
      
      private var charTaggedForRemove:ImageRenderer;
      
      private var charName:String;
      
      private var charLeft:Boolean;
      
      private var baloon:ImageRenderer;
      
      private var baloonTaggedForRemove:ImageRenderer;
      
      private var baloonEntity:Entity;
      
      private var ballonText:BitmapTextRenderer;
      
      private var currentLine:int = 0;
      
      private var canGoNext:Boolean = true;
      
      private var autoNext:Boolean = false;
      
      private var firstLevel:Boolean;
      
      private var lastVoice:Sfx;
      
      public function Cutscene(param1:String, param2:World, param3:Boolean)
      {
         var _loc4_:Button = null;
         super();
         this.firstLevel = param3;
         this.nextLevel = param2;
         this.cutXml = Asset.getXMLByType(Assets.CUTSCENES_XML).xml;
         this.cutXml = this.cutXml[param1][0];
         _loc4_ = new Button(Constants.STAGE_WIDTH - 60,Constants.STAGE_HEIGHT - 55,new ImageRenderer("interface/pular",true),this.nextWorld);
         _loc4_.depth = -100;
         add(_loc4_);
         var _loc5_:ImageRenderer = new ImageRenderer("interface/nextLine",true);
         _loc5_.x = Constants.STAGE_WIDTH / 2 - 230;
         _loc5_.y = Constants.STAGE_HEIGHT - 18;
         addComponent(_loc5_).depth = -100;
         ON_UPDATE.add(this.onUpdate);
         ON_START.add(this.onStart);
      }
      
      private function onStart() : void
      {
         MusicPlayer.start(this);
         this.nextLine();
      }
      
      private function nextLine() : void
      {
         var currentNode:XML = null;
         if(this.currentLine >= this.cutXml.children().length())
         {
            this.nextWorld();
         }
         else
         {
            currentNode = this.cutXml.children()[this.currentLine];
            if(String(currentNode.@voice) != "")
            {
               tween(this,0.5,null,false).onComplete(function():void
               {
                  if(lastVoice != null && lastVoice.playing)
                  {
                     lastVoice.stop();
                  }
                  lastVoice = SoundManager.playSound("line_" + String(currentNode.@voice));
               });
            }
            if(String(currentNode.@bg) == "none")
            {
               if(this.backGround != null && this.backGround.world != null)
               {
                  this.bgTaggedForRemove = this.backGround;
                  tween(this.backGround,0.5).onComplete(function():void
                  {
                     bgTaggedForRemove.entity.removeSelf();
                  });
               }
               this.backGround = new RectRenderer(Constants.STAGE_WIDTH,Constants.STAGE_HEIGHT,0,false);
               addComponentAt(this.backGround,0,0,10);
               this.backGround.alpha = 0;
               tween(this.backGround,0.5).to("alpha",1);
            }
            else if(String(currentNode.@bg) != "")
            {
               if(this.backGround != null && this.backGround.world != null)
               {
                  remove(this.backGround.entity);
               }
               this.backGround = new ImageRenderer("cutscenes/" + String(currentNode.@bg));
               addComponentAt(this.backGround,0,0,10);
               this.backGround.alpha = 0;
               tween(this.backGround,0.5).to("alpha",1);
            }
            if(String(currentNode.@char) != "" && this.charName != String(currentNode.@char))
            {
               if(this.char != null && this.char.world != null)
               {
                  this.charTaggedForRemove = this.char;
                  this.canGoNext = false;
                  tween(this.char,0.3).ease(Ease.backIn).moveTo(this.charLeft ? -this.char.width : Constants.STAGE_WIDTH + this.char.width,this.char.y).onComplete(function():void
                  {
                     charTaggedForRemove.entity.removeSelf();
                     canGoNext = true;
                  });
               }
               if(String(currentNode.@char) != "none")
               {
                  this.charName = String(currentNode.@char);
                  this.char = new ImageRenderer("characters/" + this.charName,false);
                  this.char.originX = this.char.width / 2;
                  addComponentAt(this.char,0,0,-5);
                  if(String(currentNode.@side) == "left")
                  {
                     this.charLeft = true;
                     this.char.setPosition(-this.char.width / 2,Constants.STAGE_HEIGHT - this.char.height);
                     tween(this.char,0.9).moveTo(30 + this.char.width / 2,this.char.y).ease(Ease.backOut);
                  }
                  else
                  {
                     this.charLeft = false;
                     this.char.setPosition(Constants.STAGE_WIDTH,Constants.STAGE_HEIGHT - this.char.height);
                     tween(this.char,0.9).moveTo(Constants.STAGE_WIDTH - this.char.width / 2 - 30,this.char.y).ease(Ease.backOut);
                     this.char.scaleX = -1;
                  }
               }
               if(this.baloon != null && this.baloon.world != null)
               {
                  this.baloonTaggedForRemove = this.baloon;
                  tween(this.baloonEntity,0.3).ease(Ease.backIn).scaleTo(0,0).onComplete(function():void
                  {
                     remove(baloonTaggedForRemove.entity);
                  });
               }
               if(String(currentNode.text()) != "")
               {
                  this.baloonEntity = addComponentAt(this.baloon = new ImageRenderer("cutBaloon",true),Constants.STAGE_WIDTH / 2 - 64,Constants.STAGE_HEIGHT / 2 - 128,0);
                  this.baloonEntity.setScale(0,0);
                  tween(this.baloonEntity,0.7).scaleTo(1,1).ease(Ease.bounceOut);
                  if(this.charLeft)
                  {
                     this.baloon.scaleX = -1;
                     this.baloonEntity.x += 120;
                  }
               }
            }
            if(this.ballonText != null && this.ballonText.entity != null)
            {
               this.ballonText.removeSelf();
            }
            if(String(currentNode.text()) != "")
            {
               this.ballonText = new BitmapTextRenderer(290,200,String(currentNode.text()).toUpperCase(),"font",20,4386,true);
               this.ballonText.y = -6;
               this.baloonEntity.add(this.ballonText);
            }
            if(String(currentNode.@flashAfter) != "")
            {
               tween(this,currentNode.@flashAfter,null,false).onComplete(function():void
               {
                  add(new ScreenFlash(1,0.1));
               });
            }
            if(String(currentNode.@autoNext) != "")
            {
               this.autoNext = true;
               tween(this,currentNode.@autoNext,null,false).onComplete(this.nextLine);
            }
            else
            {
               this.autoNext = false;
            }
            if(String(currentNode.@music) != "")
            {
               MusicPlayer.playMusic(String(currentNode.@music),0.4,false);
            }
            if(String(currentNode.@sound) != "")
            {
               SoundManager.playSound(String(currentNode.@sound));
            }
            ++this.currentLine;
         }
      }
      
      private function nextWorld() : void
      {
         cancelAllTweens();
         if(this.lastVoice != null && this.lastVoice.playing)
         {
            this.lastVoice.stop();
         }
         if(this.nextLevel is PlatformLevel)
         {
            if(this.firstLevel)
            {
               PlatformLevel.init(this.nextLevel as PlatformLevel,true);
            }
            else
            {
               PlatformLevel.gotoLevel((this.nextLevel as PlatformLevel).x,(this.nextLevel as PlatformLevel).y,PlatformLevel.NONE,0,true);
            }
         }
         else
         {
            engine.setWorld(this.nextLevel);
         }
      }
      
      private function onUpdate() : void
      {
         if(Controls.ACCEPT.pressed && this.canGoNext && !this.autoNext)
         {
            this.nextLine();
         }
         if(Input.keyPressed(Key.ESCAPE))
         {
            this.nextWorld();
         }
      }
   }
}

