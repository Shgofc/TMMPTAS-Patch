package game.world
{
   import flashpunk2.World;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.global.Ease;
   import game.Constants;
   import game.UserData;
   import game.ui.Confirmation;
   import game.ui.SelectorMenu;
   import sound.MusicPlayer;
   
   public class MainMenu extends World
   {
      
      private var selector:SelectorMenu;
      
      public function MainMenu()
      {
         super();
         UserData.loadOptions();
         engine.backgroundColor = 0;
         var _loc1_:ImageRenderer = new ImageRenderer("interface/mainMenu",true);
         addComponent(_loc1_);
         _loc1_.x = Constants.STAGE_WIDTH / 2;
         _loc1_.y = Constants.STAGE_HEIGHT / 2;
         var _loc2_:ImageRenderer = new ImageRenderer("interface/glow",true);
         addComponent(_loc2_);
         _loc2_.setPosition(480,90);
         tween(_loc2_,2).from("angle",0).to("angle",360).repeat(-1);
         var _loc3_:ImageRenderer = new ImageRenderer("interface/tittle",false);
         addComponent(_loc3_);
         _loc3_.setPosition(Constants.STAGE_WIDTH - _loc3_.width - 10,-_loc3_.height);
         tween(_loc3_,1.5).moveTo(_loc3_.x,10).ease(Ease.elasticOut);
         this.selector = new SelectorMenu(Vector.<String>(["newGame","continue"]),Vector.<Function>([this.onNewGame,this.onContinue]),null,true,true);
         this.selector.selection = 0;
         this.selector.y = engine.height / 2 + 80;
         this.selector.x += 250;
         add(this.selector);
         this.selector.alignButtons();
         UserData.playMusic = true;
         MusicPlayer.start(this);
         MusicPlayer.playMusic("main");
      }
      
      private function onContinue() : void
      {
         if(UserData.hasSave())
         {
            UserData.load();
            PlatformLevel.init(new PlatformLevel(UserData.getCheckpoint().x,UserData.getCheckpoint().y),false);
            PlatformLevel.gotoLevel(UserData.getCheckpoint().x,UserData.getCheckpoint().y,PlatformLevel.CHECKPOINT);
         }
         else
         {
            add(new Confirmation("Nenhum arquivo de jogo encontrado! Tente começar um jogo novo!",this.backToMain));
         }
      }
      
      private function onNewGame() : void
      {
         if(UserData.hasSave())
         {
            add(new Confirmation("Você tem certeza de que quer começar um novo jogo? Isso irá apagar o progresso de sua última jogada!",this.startNewGame,this.backToMain));
         }
         else
         {
            this.startNewGame();
         }
         this.selector.removeSelf();
      }
      
      private function backToMain() : void
      {
         engine.setWorld(new MainMenu());
      }
      
      private function startNewGame() : void
      {
         engine.setWorld(new Cutscene("intro",new PlatformLevel(1,0),true));
      }
   }
}

