package sound
{
   import flashpunk2.Sfx;
   
   public class SoundManager
   {
      
      [Embed(source="../../assets/sounds/jump.mp3")]
      public static const jump:Class = SoundManager_jump;
      
      [Embed(source="../../assets/sounds/splash0.mp3")]
      public static const splash0:Class = SoundManager_splash0;
      
      [Embed(source="../../assets/sounds/splash1.mp3")]
      public static const splash1:Class = SoundManager_splash1;
      
      [Embed(source="../../assets/sounds/coelhadaHit0.mp3")]
      public static const coelhadaHit0:Class = SoundManager_coelhadaHit0;
      
      [Embed(source="../../assets/sounds/coelhadaHit1.mp3")]
      public static const coelhadaHit1:Class = SoundManager_coelhadaHit1;
      
      [Embed(source="../../assets/sounds/coelhadaFail0.mp3")]
      public static const coelhadaFail0:Class = SoundManager_coelhadaFail0;
      
      [Embed(source="../../assets/sounds/coelhadaFail1.mp3")]
      public static const coelhadaFail1:Class = SoundManager_coelhadaFail1;
      
      [Embed(source="../../assets/sounds/checkpoint.mp3")]
      public static const checkpoint:Class = SoundManager_checkpoint;
      
      [Embed(source="../../assets/sounds/microJump.mp3")]
      public static const microJump:Class = SoundManager_microJump;
      
      [Embed(source="../../assets/sounds/impact.mp3")]
      public static const impact:Class = SoundManager_impact;
      
      [Embed(source="../../assets/sounds/goo0.mp3")]
      public static const goo0:Class = SoundManager_goo0;
      
      [Embed(source="../../assets/sounds/goo1.mp3")]
      public static const goo1:Class = SoundManager_goo1;
      
      [Embed(source="../../assets/sounds/hit0.mp3")]
      public static const hit0:Class = SoundManager_hit0;
      
      [Embed(source="../../assets/sounds/hit1.mp3")]
      public static const hit1:Class = SoundManager_hit1;
      
      [Embed(source="../../assets/sounds/hit2.mp3")]
      public static const hit2:Class = SoundManager_hit2;
      
      [Embed(source="../../assets/sounds/takeHit.mp3")]
      public static const takeHit:Class = SoundManager_takeHit;
      
      [Embed(source="../../assets/sounds/spit.mp3")]
      public static const spit:Class = SoundManager_spit;
      
      [Embed(source="../../assets/sounds/bossHit.mp3")]
      public static const bossHit:Class = SoundManager_bossHit;
      
      [Embed(source="../../assets/sounds/coin.mp3")]
      public static const coin:Class = SoundManager_coin;
      
      [Embed(source="../../assets/sounds/clink.mp3")]
      public static const clink:Class = SoundManager_clink;
      
      [Embed(source="../../assets/sounds/heart.mp3")]
      public static const heart:Class = SoundManager_heart;
      
      [Embed(source="../../assets/sounds/menuSelect.mp3")]
      public static const menuSelect:Class = SoundManager_menuSelect;
      
      [Embed(source="../../assets/sounds/menuAccept.mp3")]
      public static const menuAccept:Class = SoundManager_menuAccept;
      
      [Embed(source="../../assets/sounds/shopBuy.mp3")]
      public static const shopBuy:Class = SoundManager_shopBuy;
      
      [Embed(source="../../assets/sounds/shopSelect.mp3")]
      public static const shopSelect:Class = SoundManager_shopSelect;
      
      [Embed(source="../../assets/sounds/pop.mp3")]
      public static const pop:Class = SoundManager_pop;
      
      [Embed(source="../../assets/sounds/teleport.mp3")]
      public static const teleport:Class = SoundManager_teleport;
      
      [Embed(source="../../assets/sounds/plasma.mp3")]
      public static const plasma:Class = SoundManager_plasma;
      
      [Embed(source="../../assets/sounds/plasma2.mp3")]
      public static const plasma2:Class = SoundManager_plasma2;
      
      [Embed(source="../../assets/sounds/plasma3.mp3")]
      public static const plasma3:Class = SoundManager_plasma3;
      
      [Embed(source="../../assets/sounds/voice_jump0.mp3")]
      public static const voice_jump0:Class = SoundManager_voice_jump0;
      
      [Embed(source="../../assets/sounds/voice_jump1.mp3")]
      public static const voice_jump1:Class = SoundManager_voice_jump1;
      
      [Embed(source="../../assets/sounds/voice_jump2.mp3")]
      public static const voice_jump2:Class = SoundManager_voice_jump2;
      
      [Embed(source="../../assets/sounds/voice_hit0.mp3")]
      public static const voice_hit0:Class = SoundManager_voice_hit0;
      
      [Embed(source="../../assets/sounds/voice_hit1.mp3")]
      public static const voice_hit1:Class = SoundManager_voice_hit1;
      
      [Embed(source="../../assets/sounds/voice_hit2.mp3")]
      public static const voice_hit2:Class = SoundManager_voice_hit2;
      
      [Embed(source="../../assets/sounds/voice_hit3.mp3")]
      public static const voice_hit3:Class = SoundManager_voice_hit3;
      
      [Embed(source="../../assets/sounds/voice_death.mp3")]
      public static const voice_death:Class = SoundManager_voice_death;
      
      [Embed(source="../../assets/sounds/voice/franjinha1.mp3")]
      public static const line_franjinha1:Class = SoundManager_line_franjinha1;
      
      [Embed(source="../../assets/sounds/voice/franjinha2.mp3")]
      public static const line_franjinha2:Class = SoundManager_line_franjinha2;
      
      [Embed(source="../../assets/sounds/voice/franjinha3.mp3")]
      public static const line_franjinha3:Class = SoundManager_line_franjinha3;
      
      [Embed(source="../../assets/sounds/voice/franjinha4.mp3")]
      public static const line_franjinha4:Class = SoundManager_line_franjinha4;
      
      [Embed(source="../../assets/sounds/voice/franjinha5.mp3")]
      public static const line_franjinha5:Class = SoundManager_line_franjinha5;
      
      [Embed(source="../../assets/sounds/voice/franjinha6.mp3")]
      public static const line_franjinha6:Class = SoundManager_line_franjinha6;
      
      [Embed(source="../../assets/sounds/voice/franjinha7.mp3")]
      public static const line_franjinha7:Class = SoundManager_line_franjinha7;
      
      [Embed(source="../../assets/sounds/voice/franjinha8.mp3")]
      public static const line_franjinha8:Class = SoundManager_line_franjinha8;
      
      [Embed(source="../../assets/sounds/voice/franjinha9.mp3")]
      public static const line_franjinha9:Class = SoundManager_line_franjinha9;
      
      [Embed(source="../../assets/sounds/voice/franjinha10.mp3")]
      public static const line_franjinha10:Class = SoundManager_line_franjinha10;
      
      [Embed(source="../../assets/sounds/voice/monica1.mp3")]
      public static const line_monica1:Class = SoundManager_line_monica1;
      
      [Embed(source="../../assets/sounds/voice/monica2.mp3")]
      public static const line_monica2:Class = SoundManager_line_monica2;
      
      [Embed(source="../../assets/sounds/voice/monica3.mp3")]
      public static const line_monica3:Class = SoundManager_line_monica3;
      
      [Embed(source="../../assets/sounds/voice/monica4.mp3")]
      public static const line_monica4:Class = SoundManager_line_monica4;
      
      [Embed(source="../../assets/sounds/voice/monica5.mp3")]
      public static const line_monica5:Class = SoundManager_line_monica5;
      
      [Embed(source="../../assets/sounds/voice/monica6.mp3")]
      public static const line_monica6:Class = SoundManager_line_monica6;
      
      [Embed(source="../../assets/sounds/voice/monica7.mp3")]
      public static const line_monica7:Class = SoundManager_line_monica7;
      
      [Embed(source="../../assets/sounds/voice/monica8.mp3")]
      public static const line_monica8:Class = SoundManager_line_monica8;
      
      [Embed(source="../../assets/sounds/voice/monica9.mp3")]
      public static const line_monica9:Class = SoundManager_line_monica9;
      
      [Embed(source="../../assets/sounds/voice/monica10.mp3")]
      public static const line_monica10:Class = SoundManager_line_monica10;
      
      [Embed(source="../../assets/sounds/voice/monica11.mp3")]
      public static const line_monica11:Class = SoundManager_line_monica11;
      
      [Embed(source="../../assets/sounds/voice/monica12.mp3")]
      public static const line_monica12:Class = SoundManager_line_monica12;
      
      [Embed(source="../../assets/sounds/voice/monica13.mp3")]
      public static const line_monica13:Class = SoundManager_line_monica13;
      
      [Embed(source="../../assets/sounds/voice/monica14.mp3")]
      public static const line_monica14:Class = SoundManager_line_monica14;
      
      [Embed(source="../../assets/sounds/voice/monica15.mp3")]
      public static const line_monica15:Class = SoundManager_line_monica15;
      
      [Embed(source="../../assets/sounds/voice/monica16.mp3")]
      public static const line_monica16:Class = SoundManager_line_monica16;
      
      [Embed(source="../../assets/sounds/voice/monica17.mp3")]
      public static const line_monica17:Class = SoundManager_line_monica17;
      
      [Embed(source="../../assets/sounds/voice/monica18.mp3")]
      public static const line_monica18:Class = SoundManager_line_monica18;
      
      [Embed(source="../../assets/sounds/voice/monica19.mp3")]
      public static const line_monica19:Class = SoundManager_line_monica19;
      
      [Embed(source="../../assets/sounds/voice/monica20.mp3")]
      public static const line_monica20:Class = SoundManager_line_monica20;
      
      [Embed(source="../../assets/sounds/voice/monica21.mp3")]
      public static const line_monica21:Class = SoundManager_line_monica21;
      
      [Embed(source="../../assets/sounds/voice/monica22.mp3")]
      public static const line_monica22:Class = SoundManager_line_monica22;
      
      [Embed(source="../../assets/sounds/voice/cebolinha1.mp3")]
      public static const line_cebolinha1:Class = SoundManager_line_cebolinha1;
      
      [Embed(source="../../assets/sounds/voice/cebolinha2.mp3")]
      public static const line_cebolinha2:Class = SoundManager_line_cebolinha2;
      
      [Embed(source="../../assets/sounds/voice/cebolinha3.mp3")]
      public static const line_cebolinha3:Class = SoundManager_line_cebolinha3;
      
      [Embed(source="../../assets/sounds/voice/cebolinha4.mp3")]
      public static const line_cebolinha4:Class = SoundManager_line_cebolinha4;
      
      [Embed(source="../../assets/sounds/voice/cebolinha5.mp3")]
      public static const line_cebolinha5:Class = SoundManager_line_cebolinha5;
      
      [Embed(source="../../assets/sounds/voice/cebolinha6.mp3")]
      public static const line_cebolinha6:Class = SoundManager_line_cebolinha6;
      
      [Embed(source="../../assets/sounds/voice/cebolinha7.mp3")]
      public static const line_cebolinha7:Class = SoundManager_line_cebolinha7;
      
      [Embed(source="../../assets/sounds/voice/cebolinha8.mp3")]
      public static const line_cebolinha8:Class = SoundManager_line_cebolinha8;
      
      [Embed(source="../../assets/sounds/voice/cebolinha9.mp3")]
      public static const line_cebolinha9:Class = SoundManager_line_cebolinha9;
      
      [Embed(source="../../assets/sounds/voice/cebolinha10.mp3")]
      public static const line_cebolinha10:Class = SoundManager_line_cebolinha10;
      
      [Embed(source="../../assets/sounds/voice/cebolinha11.mp3")]
      public static const line_cebolinha11:Class = SoundManager_line_cebolinha11;
      
      [Embed(source="../../assets/sounds/voice/cebolinha12.mp3")]
      public static const line_cebolinha12:Class = SoundManager_line_cebolinha12;
      
      [Embed(source="../../assets/sounds/voice/cascao1.mp3")]
      public static const line_cascao1:Class = SoundManager_line_cascao1;
      
      [Embed(source="../../assets/sounds/voice/cascao2.mp3")]
      public static const line_cascao2:Class = SoundManager_line_cascao2;
      
      [Embed(source="../../assets/sounds/voice/cascao3.mp3")]
      public static const line_cascao3:Class = SoundManager_line_cascao3;
      
      [Embed(source="../../assets/sounds/voice/cascao4.mp3")]
      public static const line_cascao4:Class = SoundManager_line_cascao4;
      
      [Embed(source="../../assets/sounds/voice/cascao5.mp3")]
      public static const line_cascao5:Class = SoundManager_line_cascao5;
      
      [Embed(source="../../assets/sounds/voice/cascao6.mp3")]
      public static const line_cascao6:Class = SoundManager_line_cascao6;
      
      [Embed(source="../../assets/sounds/voice/cascao7.mp3")]
      public static const line_cascao7:Class = SoundManager_line_cascao7;
      
      [Embed(source="../../assets/sounds/voice/cascao8.mp3")]
      public static const line_cascao8:Class = SoundManager_line_cascao8;
      
      [Embed(source="../../assets/sounds/voice/magali1.mp3")]
      public static const line_magali1:Class = SoundManager_line_magali1;
      
      [Embed(source="../../assets/sounds/voice/magali2.mp3")]
      public static const line_magali2:Class = SoundManager_line_magali2;
      
      [Embed(source="../../assets/sounds/voice/magali3.mp3")]
      public static const line_magali3:Class = SoundManager_line_magali3;
      
      [Embed(source="../../assets/sounds/voice/magali4.mp3")]
      public static const line_magali4:Class = SoundManager_line_magali4;
      
      [Embed(source="../../assets/sounds/voice/magali5.mp3")]
      public static const line_magali5:Class = SoundManager_line_magali5;
      
      [Embed(source="../../assets/sounds/voice/magali6.mp3")]
      public static const line_magali6:Class = SoundManager_line_magali6;
      
      [Embed(source="../../assets/sounds/voice/magali7.mp3")]
      public static const line_magali7:Class = SoundManager_line_magali7;
      
      private static var nowPlaying:Vector.<String> = new Vector.<String>();
      
      public function SoundManager()
      {
         super();
      }
      
      public static function playSound(param1:String, param2:Number = 1) : Sfx
      {
         var _loc4_:String = null;
         var _loc5_:Sfx = null;
         var _loc3_:Boolean = false;
         for each(_loc4_ in nowPlaying)
         {
            if(_loc4_ == param1)
            {
               _loc3_ = true;
               break;
            }
         }
         if(!_loc3_)
         {
            nowPlaying.push(param1);
            _loc5_ = new Sfx(SoundManager[param1]);
            _loc5_.play(param2);
            return _loc5_;
         }
         return null;
      }
      
      public static function refresh() : void
      {
         nowPlaying = new Vector.<String>();
      }
   }
}

