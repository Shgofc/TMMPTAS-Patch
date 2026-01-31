package
{
   import flash.display.Sprite;
   import flashpunk2.Engine;
   import flashpunk2.assets.AssetBatch;
   import game.world.MainMenu;
   
   public class Main extends Sprite
   {
      
      private var mFlashpunk:Engine;
      
      public function Main()
      {
         super();
         this.mFlashpunk = new Engine(this,true,true);
         this.mFlashpunk.start();
         this.mFlashpunk.ON_START.add(this.loadAssets);
      }
      
      private function loadAssets() : void
      {
         var _loc1_:AssetBatch = new AssetBatch(true);
         _loc1_.addAllEmbedded(Assets);
         _loc1_.ON_LOAD_COMPLETE.add(this.onStart);
         _loc1_.load();
      }
      
      private function onStart() : void
      {
         Assets.addBitmapFont();
         this.mFlashpunk.setWorld(new MainMenu());
      }
   }
}

