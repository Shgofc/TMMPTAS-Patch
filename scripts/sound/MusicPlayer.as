package sound
{
   import flashpunk2.Entity;
   import flashpunk2.Sfx;
   import flashpunk2.World;
   import game.UserData;
   
   public class MusicPlayer extends Entity
   {
      
      private static var current:MusicPlayer;
      
      private static var afterOnce:String;
      
      [Embed(source="../../assets/music/escuro.mp3")]
      public static const escuro:Class = MusicPlayer_escuro;
      
      [Embed(source="../../assets/music/boss.mp3")]
      public static const boss:Class = MusicPlayer_boss;
      
      [Embed(source="../../assets/music/shop.mp3")]
      public static const shop:Class = MusicPlayer_shop;
      
      [Embed(source="../../assets/music/main.mp3")]
      public static const main:Class = MusicPlayer_main;
      
      [Embed(source="../../assets/music/story1.mp3")]
      public static const story1:Class = MusicPlayer_story1;
      
      [Embed(source="../../assets/music/story2.mp3")]
      public static const story2:Class = MusicPlayer_story2;
      
      [Embed(source="../../assets/music/fase1.mp3")]
      public static const fase1:Class = MusicPlayer_fase1;
      
      [Embed(source="../../assets/music/fase2.mp3")]
      public static const fase2:Class = MusicPlayer_fase2;
      
      [Embed(source="../../assets/music/fase3.mp3")]
      public static const fase3:Class = MusicPlayer_fase3;
      
      [Embed(source="../../assets/music/gameOver.mp3")]
      public static const gameOver:Class = MusicPlayer_gameOver;
      
      [Embed(source="../../assets/music/vitoria.mp3")]
      public static const vitoria:Class = MusicPlayer_vitoria;
      
      private static var playingOnce:Boolean = false;
      
      private var musicList:Vector.<Sfx>;
      
      private var musicNamesList:Vector.<String>;
      
      private var currentlyPlaying:Sfx = null;
      
      public function MusicPlayer()
      {
         super();
         current = this;
         this.musicList = new Vector.<Sfx>();
         this.musicNamesList = new Vector.<String>();
      }
      
      public static function playMusic(param1:String, param2:Number = 1, param3:Boolean = false) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:Sfx = null;
         if(playingOnce)
         {
            afterOnce = param1;
         }
         else
         {
            if(param1 == "stop")
            {
               current.fadeAllOut();
               return;
            }
            _loc4_ = false;
            _loc5_ = 0;
            while(_loc5_ < current.musicNamesList.length)
            {
               if(param1 == current.musicNamesList[_loc5_])
               {
                  _loc4_ = true;
                  break;
               }
               _loc5_++;
            }
            if(_loc4_)
            {
               _loc6_ = current.musicList[_loc5_];
            }
            else
            {
               _loc6_ = new Sfx(MusicPlayer[param1]);
               _loc6_.volume = 0;
            }
            current.fadeAllOut(param1);
            if(!_loc6_.playing)
            {
               if(param3)
               {
                  _loc6_.play();
                  _loc6_.complete = resume;
                  playingOnce = true;
                  afterOnce = current.musicNamesList[current.musicNamesList.length - 1];
               }
               else
               {
                  _loc6_.loop(0);
               }
               current.tween(_loc6_,1,null,false).from("volume",0).to("volume",UserData.playMusic ? param2 * 0.9 : 0);
               current.currentlyPlaying = _loc6_;
               current.musicList.push(_loc6_);
               current.musicNamesList.push(param1);
            }
         }
      }
      
      private static function resume() : void
      {
         playingOnce = false;
         playMusic(afterOnce);
      }
      
      public static function start(param1:World) : void
      {
         if(current == null)
         {
            param1.add(new MusicPlayer());
         }
         else
         {
            param1.add(current);
         }
      }
      
      public static function updateMusicOptions() : void
      {
         if(UserData.playMusic)
         {
            if(current.currentlyPlaying != null && current.currentlyPlaying.playing)
            {
               current.tween(current.currentlyPlaying,0.1,null,false).to("volume",1);
            }
         }
         else if(current.currentlyPlaying != null && current.currentlyPlaying.playing)
         {
            current.tween(current.currentlyPlaying,0.1,null,false).to("volume",0);
         }
      }
      
      private function fadeAllOut(param1:String = "") : void
      {
         var stopMusic:Sfx = null;
         var musicName:String = null;
         var except:String = param1;
         var i:int = 0;
         var j:int = 0;
         while(j < this.musicList.length)
         {
            if(this.musicNamesList[i] != except)
            {
               stopMusic = this.musicList[i];
               musicName = this.musicNamesList[i];
               tween(stopMusic,0.1).to("volume",0).onComplete(function():void
               {
                  stopMusic.stop();
                  removeMusic(musicName);
               });
               i++;
            }
            j++;
         }
      }
      
      private function removeMusic(param1:String) : void
      {
         var _loc2_:int = int(this.musicNamesList.length - 1);
         while(_loc2_ >= 0)
         {
            if(this.musicNamesList[_loc2_] == param1)
            {
               this.musicList.splice(_loc2_,1);
               this.musicNamesList.splice(_loc2_,1);
            }
            _loc2_--;
         }
      }
   }
}

