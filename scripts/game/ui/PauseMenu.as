package game.ui
{
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.components.rendering.RectRenderer;
   import flashpunk2.global.Ease;
   import flashpunk2.global.Input;
   import flashpunk2.global.Key;
   import flashpunk2.namespaces.fp_internal;
   import game.Constants;
   import game.world.MainMenu;
   
   use namespace fp_internal;
   
   public class PauseMenu extends Entity
   {
      
      private var activateFunction:Function;
      
      private var bg:ImageRenderer;
      
      private var release:Boolean = false;
      
      private var fade:RectRenderer;
      
      private var unPause:Button;
      
      private var goHome:Button;
      
      private var confirmation:Confirmation;
      
      public function PauseMenu(param1:Function)
      {
         this.activateFunction = param1;
         super();
         this.bg = new ImageRenderer("interface/pauseMenuBg",true);
         this.bg.setPosition(Constants.STAGE_WIDTH / 2,Constants.STAGE_HEIGHT / 2);
         this.bg.scroll = 0;
         this.bg.alpha = 0;
         this.bg.angle = 90;
         this.bg.setScale(0.2,0.2);
         this.fade = new RectRenderer(Constants.STAGE_WIDTH + 32,Constants.STAGE_HEIGHT + 32,0,true);
         this.fade.setPosition(Constants.STAGE_WIDTH / 2,Constants.STAGE_HEIGHT / 2);
         this.fade.scroll = 0;
         this.fade.alpha = 0;
         this.fade.setScale(0.2,0.2);
         this.fade.angle = 90;
         tween(this.fade,0.5).to("alpha",0.6).scaleTo(1,1).to("angle",0).ease(Ease.cubeOut);
         tween(this.bg,0.5).to("alpha",1).scaleTo(1,1).to("angle",0).ease(Ease.elasticOut);
         add(this.fade);
         add(this.bg);
         ON_UPDATE.add(this.onUpdate);
         ON_START.add(this.onStart);
         depth = -2000;
      }
      
      private function onStart() : void
      {
         this.unPause = new Button(Constants.STAGE_WIDTH / 2 - 64 - 32,Constants.STAGE_HEIGHT / 2 + 20,new ImageRenderer("interface/back",true),this.exitPause);
         this.goHome = new Button(Constants.STAGE_WIDTH / 2 + 64 - 32,Constants.STAGE_HEIGHT / 2 + 20,new ImageRenderer("interface/home",true),this.goToMain);
         this.unPause.active = false;
         this.goHome.active = false;
         this.goHome.depth = this.unPause.depth = depth - 10;
         world.add(this.unPause);
         world.add(this.goHome);
         tween(this.unPause.image,1).scaleFrom(0,0).scaleTo(1,1).ease(Ease.elasticOut);
         tween(this.goHome.image,1).scaleFrom(0,0).scaleTo(1,1).ease(Ease.elasticOut);
      }
      
      private function goToMain() : void
      {
         var backToMain:Function = null;
         var clearConfirmation:Function = null;
         backToMain = function():void
         {
            ON_UPDATE.remove(onUpdate);
            engine.ON_UPDATE.remove(fp_internal::update);
            engine.setWorld(new MainMenu());
         };
         clearConfirmation = function():void
         {
            ON_UPDATE.remove(onUpdate);
            engine.ON_UPDATE.remove(fp_internal::update);
            confirmation = null;
         };
         this.confirmation = new Confirmation("Você tem certeza que quer começar um novo jogo? Isso irá apagar o progresso de sua última jogada!",backToMain,clearConfirmation,true);
         this.confirmation.depth = depth - 1;
         world.add(this.confirmation);
      }
      
      private function onUpdate() : void
      {
         this.unPause.fp_internal::update();
         this.goHome.fp_internal::update();
         if(this.confirmation != null)
         {
            this.confirmation.fp_internal::update();
         }
         if(!Input.keyDown(Key.P) && !Input.keyDown(Key.ESCAPE))
         {
            this.release = true;
         }
         if((Input.keyPressed(Key.P) || Input.keyPressed(Key.ESCAPE)) && this.release)
         {
            this.exitPause();
         }
      }
      
      private function exitPause() : void
      {
         ON_UPDATE.remove(this.onUpdate);
         engine.ON_UPDATE.remove(fp_internal::update);
         this.activateFunction();
         tween(this.goHome,0.5).to("alpha",0).onComplete(removeSelf).ease(Ease.backOut);
         tween(this.unPause,0.5).to("alpha",0).onComplete(removeSelf).ease(Ease.backOut);
         tween(this.bg,0.5).scaleTo(0,0).onComplete(removeSelf).ease(Ease.backOut);
         tween(this.fade,0.5).to("alpha",0);
      }
   }
}

