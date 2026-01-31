package game.world
{
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flashpunk2.Engine;
   import flashpunk2.World;
   import flashpunk2.components.rendering.BGRenderer;
   import flashpunk2.global.Asset;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Debug;
   import flashpunk2.global.Input;
   import flashpunk2.global.Key;
   import flashpunk2.global.Rand;
   import flashpunk2.namespaces.fp_internal;
   import flashpunk2.particles.ParticlesController;
   import game.Constants;
   import game.UserData;
   import game.collectibles.BunnyCollect;
   import game.collectibles.Coin;
   import game.collectibles.Gem;
   import game.collectibles.Goggles;
   import game.collectibles.Heart;
   import game.collectibles.HeartTube;
   import game.collectibles.Key;
   import game.collectibles.Respirador;
   import game.collectibles.SpaceBoots;
   import game.enemies.AcidDropBase;
   import game.enemies.Bullet;
   import game.enemies.DinoBoss;
   import game.enemies.Dumb;
   import game.enemies.FallTrap;
   import game.enemies.Goomba;
   import game.enemies.Merman;
   import game.enemies.MermanBoss;
   import game.enemies.RobotBoss;
   import game.enemies.Shooter;
   import game.enemies.Turret;
   import game.enemies.Winged;
   import game.environment.BackgroundImage;
   import game.environment.Chest;
   import game.environment.Door;
   import game.environment.GhostBlock;
   import game.environment.Npc;
   import game.environment.OneWay;
   import game.environment.Prop;
   import game.environment.Solid;
   import game.environment.Wall;
   import game.environment.Water;
   import game.fx.Illumination;
   import game.fx.ScreenFlash;
   import game.player.Checkpoint;
   import game.player.Player;
   import game.ui.Hud;
   import game.ui.PauseMenu;
   import oldskull.level.AutoTiles;
   import sound.MusicPlayer;
   import sound.SoundManager;
   
   use namespace fp_internal;
   
   public class PlatformLevel extends World
   {
      
      private static var _currentLevel:PlatformLevel;
      
      private static var checkpoint:Point;
      
      private static var registered:Boolean = false;
      
      private static var slot:int = -1;
      
      public static const NONE:String = "none";
      
      public static const CHECKPOINT:String = "checkpoint";
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      public static const TOP:String = "top";
      
      public static const BOTTOM:String = "bottom";
      
      public static const DOOR:String = "door";
      
      public static const START:String = "start";
      
      public var particles:ParticlesController;
      
      private var playerSideCooldown:Number = 0;
      
      private var _player:Player;
      
      private var _heigth:int = 0;
      
      private var _width:int = 0;
      
      private var _x:int;
      
      private var _y:int;
      
      private var accumulatedTime:Number = 0;
      
      private const solids:Dictionary = new Dictionary();
      
      private const bgs:Dictionary = new Dictionary();
      
      private var _hud:Hud;
      
      private var cameraStep:int = 0;
      
      private var bossLevel:Boolean = false;
      
      private var cutscene:String = "";
      
      public var illumination:Illumination;
      
      public var dark:Boolean;
      
      public var shouldSortEntities:Boolean = false;
      
      public var cameraShake:int;
      
      public function PlatformLevel(param1:int, param2:int, param3:Player = null)
      {
         super(this.onUpdate);
         this._y = param2;
         this._x = param1;
         this.loadLevel(param1,param2,param3);
         ON_START.add(this.onStart);
      }
      
      public static function get currentLevel() : PlatformLevel
      {
         return _currentLevel;
      }
      
      public static function init(param1:PlatformLevel, param2:Boolean) : void
      {
         _currentLevel = param1;
         Engine.instance.setWorld(param1);
         if(param2)
         {
            UserData.resetSave();
         }
         checkpoint = new Point(param1.x,param1.y);
      }
      
      public static function gotoLevel(param1:int, param2:int, param3:String = "checkpoint", param4:int = 0, param5:Boolean = false) : void
      {
         var _loc6_:Player = null;
         var _loc8_:PlatformLevel = null;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Door = null;
         var _loc13_:Checkpoint = null;
         _loc6_ = _currentLevel.player;
         var _loc7_:* = _loc6_.x + "," + _loc6_.y + " --> ";
         if(param1 != _currentLevel._x || param2 != _currentLevel._y || param5)
         {
            _loc8_ = new PlatformLevel(param1,param2,_loc6_);
            if(_loc8_.cutscene != "" && !UserData.getTrigger("cut_" + _loc8_.cutscene))
            {
               Engine.instance.setWorld(new Cutscene(_loc8_.cutscene,_loc8_,false));
               UserData.setTrigger("cut_" + _loc8_.cutscene);
            }
            else
            {
               Engine.instance.setWorld(_loc8_);
            }
         }
         else
         {
            _loc8_ = _currentLevel;
         }
         var _loc9_:int = _currentLevel.height - _loc8_.height;
         switch(param3)
         {
            case LEFT:
               _loc6_.x = 1;
               break;
            case RIGHT:
               _loc6_.x = _loc8_._width - 1;
               break;
            case TOP:
               _loc6_.y = 1;
               break;
            case BOTTOM:
               _loc6_.y = _loc8_._heigth - 1;
               break;
            case DOOR:
               _loc10_ = false;
               for each(_loc12_ in _loc8_.getEntitiesByType(Door))
               {
                  if(_loc12_.uid == param4)
                  {
                     _loc6_.x = _loc12_.x;
                     _loc6_.y = _loc12_.y + 20;
                     _loc6_.setValidLocation();
                     _loc6_.stop();
                     _loc10_ = true;
                     break;
                  }
               }
               if(_loc10_)
               {
               }
               break;
            case CHECKPOINT:
               _loc11_ = false;
               var _loc14_:int = 0;
               var _loc15_:* = _loc8_.getEntitiesByType(Checkpoint);
               for each(_loc13_ in _loc15_)
               {
                  _loc6_.x = _loc13_.x + 8;
                  _loc6_.y = _loc13_.y + 26;
                  _loc11_ = true;
               }
               if(_loc10_)
               {
               }
         }
         _loc6_.stop();
         _currentLevel = _loc8_;
         _currentLevel.updateCameraY();
         _currentLevel.camera.setPosition(_loc6_.x + Constants.STAGE_WIDTH / 2,_currentLevel.cameraStep);
         _loc6_.onExitWater(false);
         _loc6_.recover();
         Debug.log("Entering level: " + param1.toString() + "_" + param2.toString());
      }
      
      public function get player() : Player
      {
         return this._player;
      }
      
      public function get height() : int
      {
         return this._heigth;
      }
      
      public function get width() : int
      {
         return this._width;
      }
      
      public function get x() : int
      {
         return this._x;
      }
      
      public function get y() : int
      {
         return this._y;
      }
      
      public function get hud() : Hud
      {
         return this._hud;
      }
      
      private function onStart() : void
      {
         sortEntities();
         add(new ScreenFlash(0.8,0,0));
         ON_START.clear();
         MusicPlayer.start(this);
         if(!this.bossLevel)
         {
            MusicPlayer.playMusic(this.dark ? "escuro" : "fase" + this.x.toString());
         }
         else
         {
            MusicPlayer.playMusic("boss");
         }
      }
      
      private function onUpdate() : void
      {
         SoundManager.refresh();
         var _loc1_:int = Calc.lerp(camera.y,this.cameraStep,0.05);
         if(this.player.y > camera.y + camera.height - 64)
         {
            this.updateCameraY();
         }
         camera.setPosition(int(Calc.lerp(camera.x,this.player.x - engine.width / 2,0.5)),int(Calc.lerp(camera.y,_loc1_,0.8)));
         camera.x = Calc.clamp(camera.x,0,this.width - engine.width);
         camera.y = Calc.clamp(camera.y,0,this.height - engine.height);
         camera.x += Rand.getNumber(this.cameraShake);
         camera.y += Rand.getNumber(this.cameraShake);
         if(this.shouldSortEntities)
         {
            sortEntities();
            this.shouldSortEntities = false;
         }
         if(Input.keyPressed(flashpunk2.global.Key.P) || Input.keyPressed(flashpunk2.global.Key.ESCAPE))
         {
            this.pauseGame();
         }
      }
      
      public function solidAt(param1:int, param2:int) : Solid
      {
         return this.solids[param1] == undefined || this.solids[param1][param2] == undefined ? null : this.solids[param1][param2];
      }
      
      public function checkAt(param1:int, param2:int, param3:Boolean = false) : Boolean
      {
         if(param1 < 0 || param1 >= this.horizontalTiles || (param2 < 0 || param2 >= this.verticalTiles))
         {
            return param3;
         }
         return this.solids[param1] == undefined || this.solids[param1][param2] == undefined ? false : this.solids[param1][param2] != null;
      }
      
      public function setSolid(param1:int, param2:int, param3:Solid = null) : void
      {
         if(this.solids[param1] == undefined)
         {
            this.solids[param1] = new Dictionary();
         }
         this.solids[param1][param2] = param3;
      }
      
      public function get verticalTiles() : int
      {
         return this._heigth / Constants.TILE_HEIGHT;
      }
      
      public function get horizontalTiles() : int
      {
         return this._width / Constants.TILE_WIDTH;
      }
      
      private function loadLevel(param1:int, param2:int, param3:Player) : void
      {
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:XML = null;
         var _loc9_:XML = null;
         var _loc10_:XML = null;
         var _loc11_:AutoTiles = null;
         var _loc12_:AutoTiles = null;
         var _loc13_:BGRenderer = null;
         var _loc14_:BGRenderer = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:Wall = null;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:XML = null;
         var _loc27_:Number = NaN;
         var _loc4_:String = param1.toString() + "_" + param2.toString();
         var _loc5_:XML = Assets.getXML("lv" + param1.toString() + "_" + param2.toString());
         this._width = int(_loc5_.@width);
         this._heigth = int(_loc5_.@height);
         if(Calc.strBool(_loc5_.@dark))
         {
            this.dark = true;
            this.illumination = new Illumination(this,true);
         }
         add(new BackgroundImage("background/sky" + this.x.toString() + "_" + String(_loc5_.@sky),0.5));
         if(int(_loc5_.@sky) == 1)
         {
            _loc13_ = new BGRenderer("background/mist",true,false);
            _loc13_.y = Constants.STAGE_HEIGHT - _loc13_.imageHeight;
            _loc13_.scroll = 0;
            addComponent(_loc13_).depth = 50;
            _loc14_ = new BGRenderer("background/sky" + this.x.toString() + "_1a",true,false);
            _loc14_.scroll = 0.6;
            _loc14_.alpha = 0.7;
            addComponent(_loc14_).depth = 195;
         }
         for each(_loc6_ in _loc5_.solid.children())
         {
            _loc15_ = int(_loc6_.@x);
            _loc16_ = int(_loc6_.@y);
            _loc17_ = int(_loc6_.@w);
            _loc18_ = int(_loc6_.@h);
            _loc19_ = new Wall(_loc15_ * Constants.TILE_WIDTH,_loc16_ * Constants.TILE_WIDTH,_loc17_ * Constants.TILE_WIDTH,_loc18_ * Constants.TILE_HEIGHT);
            _loc20_ = _loc15_;
            while(_loc20_ < _loc15_ + _loc17_)
            {
               if(this.solids[_loc20_] == undefined)
               {
                  this.solids[_loc20_] = new Dictionary();
               }
               _loc21_ = _loc16_;
               while(_loc21_ < _loc16_ + _loc18_)
               {
                  if(this.solids[_loc20_][_loc21_] != undefined)
                  {
                  }
                  this.solids[_loc20_][_loc21_] = _loc19_;
                  _loc21_++;
               }
               _loc20_++;
            }
            add(_loc19_);
         }
         for each(_loc6_ in _loc5_.bg.children())
         {
            _loc22_ = int(_loc6_.@x);
            _loc23_ = int(_loc6_.@y);
            _loc24_ = int(_loc6_.@w);
            _loc25_ = int(_loc6_.@h);
            _loc20_ = _loc22_;
            while(_loc20_ < _loc22_ + _loc24_)
            {
               if(this.bgs[_loc20_] == undefined)
               {
                  this.bgs[_loc20_] = new Dictionary();
               }
               _loc21_ = _loc23_;
               while(_loc21_ < _loc23_ + _loc25_)
               {
                  if(this.bgs[_loc20_][_loc21_] != undefined)
                  {
                  }
                  this.bgs[_loc20_][_loc21_] = _loc19_;
                  _loc21_++;
               }
               _loc20_++;
            }
         }
         _loc7_ = XML(_loc5_["objects"]);
         _loc8_ = _loc5_.props.length() > 0 ? XML(_loc5_["props"]) : null;
         for each(_loc10_ in _loc7_.en_snake)
         {
            add(new Goomba(_loc10_.@x,_loc10_.@y,_loc10_.@side,"snake2"));
         }
         for each(_loc10_ in _loc7_.en_snake2)
         {
            add(new Goomba(_loc10_.@x,_loc10_.@y,_loc10_.@side,"snake3"));
         }
         for each(_loc10_ in _loc7_.en_shooter)
         {
            add(new Shooter(_loc10_.@x,_loc10_.@y,"shooter1"));
         }
         for each(_loc10_ in _loc7_.en_turret)
         {
            add(new Turret(_loc10_.@x,_loc10_.@y));
         }
         for each(_loc10_ in _loc7_.en_dumbSnake)
         {
            add(new Dumb(_loc10_.@x,_loc10_.@y,"snake1"));
         }
         for each(_loc10_ in _loc7_.npc_alien)
         {
            add(new Npc(_loc10_.@x,_loc10_.@y,_loc10_.@talk,"alien" + Rand.choose("A","B","C","D","E"),true,""));
         }
         for each(_loc10_ in _loc7_.npc_generic)
         {
            add(new Npc(_loc10_.@x,_loc10_.@y,_loc10_.@talk,_loc10_.@image,Calc.strBool(_loc10_.@flip),_loc10_.@cutscene));
         }
         this.bossLevel = false;
         for each(_loc10_ in _loc7_.en_boss)
         {
            this.bossLevel = true;
            if(_loc10_.@type == "dino")
            {
               add(new DinoBoss(_loc10_.@x,_loc10_.@y));
            }
            else if(_loc10_.@type == "merman")
            {
               add(new MermanBoss(_loc10_.@x,_loc10_.@y));
            }
            else if(_loc10_.@type == "cebola")
            {
               add(new RobotBoss(_loc10_.@x,_loc10_.@y));
            }
         }
         for each(_loc10_ in _loc7_.en_winged)
         {
            add(new Winged(_loc10_,"flyer1"));
         }
         for each(_loc10_ in _loc7_.en_fish)
         {
            add(new Winged(_loc10_,"fish"));
         }
         for each(_loc10_ in _loc7_.en_mermaid)
         {
            add(new Merman(_loc10_.@x,_loc10_.@y));
         }
         for each(_loc10_ in _loc7_.en_bullet)
         {
            add(new Bullet(_loc10_.@x,_loc10_.@y));
         }
         if(_loc8_)
         {
            for each(_loc26_ in _loc8_.children())
            {
               add(new Prop(_loc26_.name(),_loc26_.@x,_loc26_.@y));
            }
         }
         for each(_loc10_ in _loc7_.col_bunny)
         {
            if(!UserData.getTrigger("bunny" + _loc4_ + _loc10_.@id.toString()))
            {
               add(new Chest(int(_loc10_.@x) - 16,int(_loc10_.@y) - 32,"none",new BunnyCollect(0,0,_loc4_,_loc10_.@id)));
            }
         }
         for each(_loc10_ in _loc7_.col_light)
         {
            if(!UserData.getTrigger("goggles" + _loc4_ + _loc10_.@id.toString()))
            {
               add(new Chest(int(_loc10_.@x) - 16,int(_loc10_.@y) - 32,"none",new Goggles(0,0,_loc4_,_loc10_.@id)));
            }
         }
         for each(_loc10_ in _loc7_.col_respirador)
         {
            if(!UserData.getTrigger("respirador" + _loc4_ + _loc10_.@id.toString()))
            {
               add(new Chest(int(_loc10_.@x) - 16,int(_loc10_.@y) - 32,"none",new Respirador(0,0,_loc4_,_loc10_.@id)));
            }
         }
         for each(_loc10_ in _loc7_.col_key)
         {
            if(!UserData.getTrigger("key" + _loc4_ + _loc10_.@id.toString()))
            {
               if(Calc.strBool(_loc10_.@onChest))
               {
                  add(new Chest(int(_loc10_.@x) - 16,int(_loc10_.@y),"none",new game.collectibles.Key(_loc10_.@x,_loc10_.@y,_loc4_,_loc10_.@id)));
               }
               else
               {
                  add(new game.collectibles.Key(_loc10_.@x,_loc10_.@y,_loc4_,_loc10_.@id));
               }
            }
         }
         for each(_loc10_ in _loc7_.col_heart)
         {
            if(!UserData.getTrigger("heart" + _loc4_ + _loc10_.@id.toString()))
            {
               add(new Chest(int(_loc10_.@x) - 16,int(_loc10_.@y) - 32,"none",new HeartTube(0,0,_loc4_,_loc10_.@id)));
            }
         }
         for each(_loc10_ in _loc7_.col_boots)
         {
            if(!UserData.getTrigger("boots" + _loc4_ + _loc10_.@id.toString()))
            {
               add(new Chest(int(_loc10_.@x) - 16,int(_loc10_.@y) - 32,"none",new SpaceBoots(0,0,_loc4_,_loc10_.@id)));
            }
         }
         for each(_loc10_ in _loc7_.env_door)
         {
            add(new Door(_loc10_.@x,_loc10_.@y,_loc10_.@uid,_loc10_.@goX,_loc10_.@goY,_loc10_.@shop,Calc.strBool(_loc10_.@locked),Calc.strBool(_loc10_.@oneWay),Calc.strBool(_loc10_.@noEnemies)));
         }
         for each(_loc10_ in _loc7_.env_chest)
         {
            add(new Chest(_loc10_.@x,_loc10_.@y,_loc4_ + _loc10_.@id));
         }
         for each(_loc10_ in _loc7_.env_ghostBlock)
         {
            add(new GhostBlock(_loc10_));
         }
         for each(_loc10_ in _loc7_.env_fallTrap)
         {
            add(new FallTrap(_loc10_.@x,_loc10_.@y));
         }
         for each(_loc10_ in _loc7_.env_drops)
         {
            add(new AcidDropBase(_loc10_.@x,_loc10_.@y));
         }
         for each(_loc10_ in _loc7_.env_water)
         {
            add(new Water(_loc10_.@x,_loc10_.@y,_loc10_.@width,_loc10_.@height));
         }
         for each(_loc10_ in _loc7_.env_oneWay)
         {
            add(new OneWay(_loc10_.@x,_loc10_.@y));
         }
         for each(_loc10_ in _loc7_.pl_checkpoint)
         {
            add(new Checkpoint(_loc10_.@x,_loc10_.@y));
         }
         _loc11_ = new AutoTiles(this,this.solids,Asset.getXMLByType(Assets.TILE_DATA).xml,"tilesets/" + this.x.toString() + "_innerTiles" + (this.dark ? "_b" : ""),"tilesets/" + this.x.toString() + "_overtiles" + (this.dark ? "_b" : ""),this.x != 3);
         _loc11_.coreTiles.depth = -8;
         _loc11_.borderTiles.depth = -10;
         add(_loc11_.coreTiles);
         add(_loc11_.borderTiles);
         _loc12_ = new AutoTiles(this,this.bgs,Asset.getXMLByType(Assets.BG_TILE_DATA).xml,"tilesets/" + this.x.toString() + "_bgTiles","");
         _loc12_.coreTiles.depth = 80;
         add(_loc12_.coreTiles);
         if(param3 == null)
         {
            if(_loc7_.pl_player.length() > 0 != "")
            {
               this._player = new Player(_loc7_.pl_player[0].@x,_loc7_.pl_player[0].@y);
               add(this._player);
            }
            else
            {
               this._player = new Player(64,64);
               add(this._player);
            }
         }
         else
         {
            this._player = param3;
            add(this._player);
         }
         if(this.illumination != null)
         {
            _loc27_ = UserData.getTrigger("goggles") ? 9 : 5;
            this.player.spot = this.illumination.addSpot(this.player.x,this.player.y,_loc27_,true);
            add(this.illumination);
         }
         this._hud = new Hud(this.player);
         add(this._hud);
         if(String(_loc5_.@cutscene) != "")
         {
            this.cutscene = _loc5_.@cutscene;
         }
      }
      
      private function isRelevantSlopePosition(param1:int, param2:int, param3:int, param4:int, param5:uint) : Array
      {
         switch(param5)
         {
            case 0:
               if(param1 == param3 - 1)
               {
                  return [-1,param2];
               }
               break;
            case 1:
               if(param1 == 0)
               {
                  return [this.horizontalTiles,param2];
               }
               break;
            case 2:
               if(param2 == param4 - 1)
               {
                  return [param1,-1];
               }
               break;
            case 3:
               if(param2 == 0)
               {
                  return [param1,this.verticalTiles];
               }
               break;
            default:
               throw new Error("Unknown direction: " + param5);
         }
         return null;
      }
      
      public function pauseGame() : void
      {
         active = false;
         var _loc1_:PauseMenu = new PauseMenu(this.activate);
         add(_loc1_);
         engine.ON_UPDATE.add(_loc1_.fp_internal::update);
      }
      
      public function onPlayerDeath() : void
      {
         MusicPlayer.playMusic("gameOver",1,true);
         add(new ScreenFlash(0,0.5,0,function():void
         {
            add(new ScreenFlash(1.5,0,0));
            gotoLevel(UserData.getCheckpoint().x,UserData.getCheckpoint().y,CHECKPOINT);
            player.standUp();
            hud.updateHearts(true);
         }));
      }
      
      public function randomLoot(param1:int, param2:int) : void
      {
         var _loc3_:Number = 0.15;
         var _loc4_:Number = 0.1;
         var _loc5_:Number = 1.5;
         var _loc6_:Array = [Gem,Coin,Heart];
         add(new (_loc6_[Rand.randomIndexByWeights([_loc4_,_loc5_,_loc3_])] as Class)(param1,param2));
         if(Rand.chance(0.12))
         {
            add(new (_loc6_[Rand.randomIndexByWeights([_loc4_,_loc5_,_loc3_])] as Class)(param1,param2));
         }
         if(Rand.chance(0.08))
         {
            add(new (_loc6_[Rand.randomIndexByWeights([_loc4_,_loc5_,_loc3_])] as Class)(param1,param2));
         }
      }
      
      public function updateCameraY() : void
      {
         this.cameraStep = this.player.y - 32 - engine.height / 2;
      }
      
      public function showMessage(param1:String, param2:String) : void
      {
         active = false;
         var _loc3_:MessageBox = new MessageBox(param1,param2,this.activate);
         add(_loc3_);
         engine.ON_UPDATE.add(_loc3_.fp_internal::update);
      }
      
      public function activate() : void
      {
         active = true;
      }
      
      public function endGame() : void
      {
         engine.setWorld(new Cutscene("endGame",new MainMenu(),false));
      }
   }
}

