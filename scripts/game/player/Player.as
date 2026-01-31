package game.player
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.global.Calc;
   import flashpunk2.global.Debug;
   import flashpunk2.global.Ease;
   import flashpunk2.global.Rand;
   import game.Constants;
   import game.Controls;
   import game.PlatformObject;
   import game.UserData;
   import game.collectibles.Collectible;
   import game.enemies.Enemy;
   import game.enemies.Projectile;
   import game.environment.Chest;
   import game.environment.Door;
   import game.environment.Water;
   import game.fx.CameraShake;
   import game.fx.Explosion;
   import game.fx.ScreenFlash;
   import game.fx.Splash;
   import sound.SoundManager;
   import starling.display.Image;
   
   public class Player extends PlatformObject
   {
      
      private static const MAX_H_SPEED:Number = 250;
      
      private static const MAX_V_SPEED:Number = 500;
      
      private static const ACCELERATION:Number = 10;
      
      private static const JUMP_FORCE:Number = 415;
      
      private static const JUMP_DAMAGE:int = 1;
      
      private static const IMAGE_SCALE:Number = 0.75;
      
      private static const TIME_INVULNERABLE:Number = 60;
      
      private static const MAX_AIR:Number = 10;
      
      public var spot:Image;
      
      public var onWater:Water;
      
      private var image:AnimationRenderer;
      
      private var imageBoots:AnimationRenderer;
      
      private var imageGoggles:AnimationRenderer;
      
      private var _side:int = 1;
      
      private var walking:Boolean = false;
      
      private var takingHit:Boolean = false;
      
      private var attacking:int = 0;
      
      private var attackBody:Rectangle;
      
      private var stompBody:Rectangle;
      
      public var maxHp:int;
      
      public var superJump:int = 0;
      
      public var superSpeed:int = 0;
      
      public var superInvenc:int = 0;
      
      public var superHeavy:int = 0;
      
      private var _hp:int = this.maxHp;
      
      public var breath:Number = 10;
      
      private var lastValidPosition:Point;
      
      private var invulnerable:int;
      
      private var maxHSpeed:Number = 250;
      
      private var forgivingJump:int = 0;
      
      private var doubleJump:Boolean = false;
      
      private var canDoubleJump:Boolean = false;
      
      private var recovering:Boolean = false;
      
      private var bunny:Bunny;
      
      private var wasOnWater:Boolean = false;
      
      private var alive:Boolean = true;
      
      private var blink:Boolean;
      
      private var animationCompleted:Boolean = false;
      
      private var attackSwoosh:ImageRenderer;
      
      private var attackDuration:int = 0;
      
      private var attackAngle:Number = 0;
      
      public function Player(param1:int, param2:int)
      {
         super(param1,param2 + 32,20,54,true);
         this.image = new AnimationRenderer();
         this.image.addPrefix("stand","player/stand",8,false);
         this.image.addPrefix("stand_b","player/standBlink",8,false);
         this.image.addPrefix("run","player/run",8,false);
         this.image.addPrefix("run_b","player/runBlink",8,false);
         this.image.addPrefix("jump","player/jump",8,true);
         this.image.addPrefix("fall","player/fall",8,true);
         this.image.addPrefix("jumpHit","player/hitUp",8,true);
         this.image.addPrefix("fallHit","player/hitDown",8,true);
         this.image.addPrefix("attack","player/attack",12,false);
         this.image.addPrefix("standUp","player/getup",6,false);
         this.image.centerOrigin();
         this.image.originY = this.image.height;
         this.image.y = body.height / 2;
         this.imageBoots = new AnimationRenderer();
         this.imageBoots.addPrefix("stand","player/stand_botas",8,false);
         this.imageBoots.addPrefix("stand_b","player/stand_botas",8,false);
         this.imageBoots.addPrefix("run","player/run_botas",8,false);
         this.imageBoots.addPrefix("run_b","player/run_botas",8,false);
         this.imageBoots.addPrefix("jump","player/jumpHitUp_botas",8,true);
         this.imageBoots.addPrefix("fall","player/fallHitDown_botas",8,true);
         this.imageBoots.addPrefix("jumpHit","player/jumpHitUp_botas",8,true);
         this.imageBoots.addPrefix("fallHit","player/fallHitDown_botas",8,true);
         this.imageBoots.addPrefix("attack","player/attack_botas",12,false);
         this.imageBoots.addPrefix("standUp","player/getup_botas",6,false);
         this.imageBoots.centerOrigin();
         this.imageBoots.originY = this.imageBoots.height;
         this.imageBoots.y = body.height / 2;
         this.imageGoggles = new AnimationRenderer();
         this.imageGoggles.addPrefix("stand","player/stand_bunny",8,false);
         this.imageGoggles.addPrefix("stand_b","player/standBlink_bunny",8,false);
         this.imageGoggles.addPrefix("run","player/run_bunny",8,false);
         this.imageGoggles.addPrefix("run_b","player/runBlink_bunny",8,false);
         this.imageGoggles.addPrefix("jump","player/jump_bunny",8,true);
         this.imageGoggles.addPrefix("fall","player/fall_bunny",8,true);
         this.imageGoggles.addPrefix("jumpHit","player/hitUp_bunny",8,true);
         this.imageGoggles.addPrefix("fallHit","player/hitDown_bunny",8,true);
         this.imageGoggles.addPrefix("attack","player/attack",12,false);
         this.imageGoggles.addPrefix("standUp","player/getup_bunny",6,false);
         this.imageGoggles.centerOrigin();
         this.imageGoggles.originY = this.imageGoggles.height;
         this.imageGoggles.y = body.height / 2;
         this.attackSwoosh = new ImageRenderer("player/bunnySwoosh",false);
         this.attackSwoosh.centerOrigin();
         this.attackSwoosh.originY = 20;
         this.attackSwoosh.visible = false;
         add(this.attackSwoosh);
         this.playAnim("stand");
         this.image.ON_COMPLETE.add(this.onAnimationComplete);
         this.imageBoots.setScale(IMAGE_SCALE,IMAGE_SCALE);
         add(this.image);
         add(this.imageBoots);
         add(this.imageGoggles);
         ON_UPDATE.add(this.onUpdate);
         ON_START.add(this.onStart);
         this.spot = null;
         this.maxHp = this._hp = UserData.getMaxHp();
      }
      
      public function get hp() : int
      {
         return this._hp;
      }
      
      private function onStart() : void
      {
         this.recover();
         level.hud.updateHearts();
         this.updateWeapons();
         cancelAllTweens();
         this.image.setScale(IMAGE_SCALE,IMAGE_SCALE);
         this.imageBoots.setScale(IMAGE_SCALE,IMAGE_SCALE);
         this.attackSwoosh.setScale(IMAGE_SCALE,IMAGE_SCALE);
         this.updateSpecial();
         camera.centerOn(x,y);
         this.stompBody = new Rectangle(body.x,body.y + body.height,body.width,4);
         level.hud.hideOxigenNow();
      }
      
      public function updateWeapons() : void
      {
         if(UserData.weapon == "sansao")
         {
            this.image.removeSelf();
            this.image = new AnimationRenderer();
            this.image.addPrefix("stand","player/stand_bunny",8,false);
            this.image.addPrefix("stand_b","player/standBlink_bunny",8,false);
            this.image.addPrefix("run","player/run_bunny",8,false);
            this.image.addPrefix("run_b","player/runBlink_bunny",8,false);
            this.image.addPrefix("jump","player/jump_bunny",8,true);
            this.image.addPrefix("fall","player/fall_bunny",8,true);
            this.image.addPrefix("jumpHit","player/hitUp_bunny",8,true);
            this.image.addPrefix("fallHit","player/hitDown_bunny",8,true);
            this.image.addPrefix("attack","player/attack",12,false);
            this.image.addPrefix("standUp","player/getup_bunny",6,false);
            this.image.centerOrigin();
            this.image.originY = this.image.height;
            this.image.y = body.height / 2;
            this.image.setScale(IMAGE_SCALE,IMAGE_SCALE);
            this.image.ON_COMPLETE.add(this.onAnimationComplete);
            add(this.image);
            this.imageBoots.removeSelf();
            add(this.imageBoots);
            this.imageGoggles.removeSelf();
            add(this.imageGoggles);
            if(this.bunny != null)
            {
               this.bunny.destroy();
            }
            world.add(this.bunny = new Bunny(this));
            this.attackSwoosh.visible = false;
         }
         else if(UserData.weapon == "")
         {
            if(this.bunny != null)
            {
               this.bunny.destroy();
               this.bunny = null;
            }
            this.attackSwoosh.visible = false;
         }
      }
      
      private function onAnimationComplete() : void
      {
         this.blink = Rand.chance(0.2);
         if(onGround)
         {
            if(this.walking)
            {
               this.playAnim("run" + (!this.blink ? "" : "_b"));
            }
            else
            {
               this.playAnim("stand" + (!this.blink ? "" : "_b"));
            }
            this.walking = false;
         }
         else
         {
            this.onAir();
         }
      }
      
      public function onTakeHit(param1:int, param2:int) : void
      {
         if(!this.takingHit && this.invulnerable <= 0 && this.superInvenc <= 0 && !this.recovering)
         {
            this._hp -= param1;
            world.add(new CameraShake(5,0.25));
            world.add(new ScreenFlash(0.1,0,16737792,null,0.1));
            SoundManager.playSound("takeHit",0.15);
            this.recovering = false;
            applyDamping();
            if(param2 != 0)
            {
               _xSpeed = param2 * 150;
               _ySpeed = -185;
               this.takingHit = true;
            }
            this.invulnerable = TIME_INVULNERABLE;
            level.hud.updateHearts();
            if(this.hp <= 0)
            {
               SoundManager.playSound("voice_death");
               this.onDeath();
            }
            else
            {
               SoundManager.playSound("voice_hit" + Rand.getInt(4).toString());
            }
         }
      }
      
      public function modHp(param1:int) : void
      {
         this._hp += param1;
         if(this.hp <= 0)
         {
            level.onPlayerDeath();
         }
         if(this.hp > this.maxHp)
         {
            this._hp = this.maxHp;
         }
         level.hud.updateHearts();
      }
      
      public function applySpeedDamping(param1:Number, param2:Number) : void
      {
         _xSpeed *= param1;
         _ySpeed *= param2;
      }
      
      public function restoreHp() : void
      {
         this._hp = this.maxHp;
         level.hud.updateHearts();
      }
      
      public function updateMaxHp() : void
      {
         this.maxHp = this._hp = UserData.getMaxHp();
         level.hud.generateHearts();
         level.hud.updateHearts();
      }
      
      public function updateSpecial() : void
      {
         if(UserData.getTrigger("boots"))
         {
            this.doubleJump = true;
         }
         else
         {
            this.doubleJump = false;
         }
         this.imageBoots.visible = this.doubleJump;
         this.imageGoggles.visible = UserData.getTrigger("goggles");
      }
      
      public function stop() : void
      {
         _xSpeed = _ySpeed = 0;
      }
      
      public function onEnterWater(param1:Water) : void
      {
         if(this.onWater == null)
         {
            this.onWater = param1;
            world.add(new Splash(x,y + 32,true));
            _ySpeed *= 0.1;
         }
      }
      
      public function onExitWater(param1:Boolean = true) : void
      {
         if(this.onWater != null)
         {
            this.onWater = null;
            if(param1)
            {
               world.add(new Splash(x,y + 32,false));
            }
            this.breath = MAX_AIR;
            level.hud.hideOxigen();
            _ySpeed *= 0.8;
         }
      }
      
      public function standUp() : void
      {
         this.playAnim("standUp");
         this.image.ON_COMPLETE.add(this.onRecover);
         this.recovering = true;
         this.alive = true;
         _xSpeed = 0;
         _ySpeed = 0;
         this.restoreHp();
         tween(this.image,0.25).to("alpha",1);
      }
      
      public function setValidLocation() : void
      {
         var _loc1_:int = int(x / 32) * 32 + 12;
         var _loc2_:int = int(y / 32) * 32;
         this.lastValidPosition = new Point(_loc1_,_loc2_);
      }
      
      public function recover() : void
      {
         this.takingHit = false;
         this.invulnerable = 0;
         this.recovering = false;
         this.alive = true;
      }
      
      public function getUltraVitamin() : void
      {
         UserData.addMaxHp();
         this.updateMaxHp();
      }
      
      private function onUpdate() : void
      {
         if(this.alive)
         {
            this.updateColisions();
            if(!this.takingHit && !this.recovering)
            {
               this.updateControls();
            }
            this.updateAnimations();
            this.updateProperties();
            this.updateDirectAttack();
         }
         if(this.spot != null)
         {
            this.spot.x = x - camera.x;
            this.spot.y = y - camera.y;
         }
         if(this.image.animation != null)
         {
            this.imageBoots.play(this.image.animationName);
            this.imageBoots.index = this.image.index;
            this.imageBoots.scaleX = this.image.scaleX;
            this.imageBoots.scaleY = this.image.scaleY;
            this.imageGoggles.play(this.image.animationName);
            this.imageGoggles.index = this.image.index;
            this.imageGoggles.scaleX = this.image.scaleX;
            this.imageGoggles.scaleY = this.image.scaleY;
         }
         else
         {
            this.imageGoggles.stop();
            this.imageBoots.stop();
         }
      }
      
      private function updateDirectAttack() : void
      {
         if(this.attackDuration > 0)
         {
            --this.attackDuration;
            this.attackAngle += this._side == 1 ? 20 : -20;
            this.attackSwoosh.angle = this.attackAngle;
            this.attackSwoosh.x = x + this._side * 20;
            this.attackSwoosh.y = y - 10;
            this.attackSwoosh.scaleX = this._side;
            this.attackSwoosh.alpha = this.attackDuration / 15;
            if(this.attackDuration <= 0)
            {
               this.attackSwoosh.visible = false;
            }
         }
      }
      
      private function updateColisions() : void
      {
         var _loc1_:Enemy = null;
         var _loc2_:Chest = null;
         var _loc3_:Projectile = null;
         var _loc4_:Collectible = null;
         if(this.attackBody != null)
         {
            this.attackBody.x = x + this.side * 12;
            if(this._side < 0)
            {
               this.attackBody.x -= this.attackBody.width;
            }
            this.attackBody.y = y - 24;
         }
         this.stompBody.x = body.x;
         this.stompBody.y = body.y + body.height;
         for each(_loc1_ in level.getEntitiesByGroup(Groups.ENEMY))
         {
            if(!onGround && ySpeed > 0 && !this.takingHit && body.bottom < _loc1_.y)
            {
               if(this.stompBody.intersects(_loc1_.body))
               {
                  if(_loc1_.onBounced(this.superHeavy > 0 ? JUMP_DAMAGE * 10 : JUMP_DAMAGE))
                  {
                     SoundManager.playSound("hit" + Rand.getInt(3).toString(),0.6);
                     onBounce(JUMP_FORCE);
                  }
               }
            }
            if(this.attacking > 0 || this.attackDuration > 0)
            {
               if(this.attackBody.intersects(_loc1_.body))
               {
                  _loc1_.takeHit(this.superHeavy > 0 ? 10 : 1,Calc.sign(x - _loc1_.x));
                  if(this.attackDuration > 0)
                  {
                     world.add(new Explosion(_loc1_.x,_loc1_.y,"hit",0.3));
                     SoundManager.playSound("hit" + Rand.getInt(3).toString(),0.5);
                  }
               }
            }
            else if(Calc.sqrDistance(_loc1_.x,_loc1_.y,x,y) < Math.pow(_loc1_.body.width + _loc1_.body.height + body.height + body.width,2) && _loc1_.canAttack && _loc1_.body.intersects(body))
            {
               this.onTakeHit(_loc1_.damage,Calc.sign(x - _loc1_.x));
            }
         }
         for each(_loc2_ in level.getEntitiesByType(Chest))
         {
            if(!onGround && ySpeed > 0 && !this.takingHit && !_loc2_.open)
            {
               if(this.stompBody.intersects(_loc2_.body))
               {
                  onBounce(JUMP_FORCE);
                  _loc2_.onTakeHit();
               }
            }
            if(this.attacking > 0 || this.attackDuration > 0)
            {
               this.attackBody.x = x;
               if(this._side < 0)
               {
                  this.attackBody.x -= this.attackBody.width;
               }
               this.attackBody.y = y - 8;
               if(this.attackBody.intersects(_loc2_.body))
               {
                  _loc2_.onTakeHit();
               }
            }
         }
         for each(_loc3_ in level.getEntitiesByGroup(Groups.PROJECTILE))
         {
            if(this.attacking > 0 || this.attackDuration > 0)
            {
               if(this.attackBody.intersects(_loc3_.body))
               {
                  _loc3_.takeHit();
               }
            }
            else if(Calc.sqrDistance(_loc3_.x,_loc3_.y,x,y) < Math.pow(body.width + 10,2))
            {
               _loc3_.onHit();
               this.onTakeHit(_loc3_.damage,_loc3_.side);
            }
         }
         for each(_loc4_ in level.getEntitiesByType(Collectible))
         {
            if(body.intersects(_loc4_.body))
            {
               _loc4_.intersect(this);
            }
         }
      }
      
      private function updateControls() : void
      {
         if(Controls.AXIS.y == -1)
         {
            this.checkForDoor();
         }
         if(Controls.ATTACK.pressed && this.canAttack())
         {
            this.onAttack();
         }
         else
         {
            --this.attacking;
         }
         if(Calc.sign(this.image.scaleX) != this._side)
         {
            tween(this.image,0.3).scaleFrom(0.7 * this._side * IMAGE_SCALE,1 * IMAGE_SCALE).scaleTo(1 * this._side * IMAGE_SCALE,1 * IMAGE_SCALE).ease(Ease.backOut);
         }
         if(Controls.JUMP.pressed && (onGround || this.forgivingJump > 0 || this.canDoubleJump && this.doubleJump))
         {
            if(this.superJump > 0)
            {
               _ySpeed = -JUMP_FORCE * 1.25;
               --this.superJump;
            }
            else
            {
               _ySpeed = -JUMP_FORCE;
            }
            if(!(onGround || this.forgivingJump > 0))
            {
               this.canDoubleJump = false;
               world.add(new Explosion(x,y + 16,"puff",0.4));
            }
            SoundManager.playSound("jump",0.5);
            if(Rand.chance(0.25))
            {
               SoundManager.playSound("voice_jump" + Rand.getInt(3),0.5);
            }
            this.forgivingJump = 0;
         }
         if(!Controls.JUMP.down && ySpeed < 0)
         {
            _ySpeed *= 0.9;
         }
         if(Math.abs(Controls.AXIS.x) > 0.1)
         {
            this.walking = true;
            if(this.superHeavy > 0)
            {
               _xSpeed += Controls.AXIS.x * ACCELERATION / 3;
            }
            else if(this.superSpeed > 0)
            {
               _xSpeed += Controls.AXIS.x * ACCELERATION * 2;
            }
            else
            {
               _xSpeed += Controls.AXIS.x * ACCELERATION;
            }
            this._side = Calc.sign(Controls.AXIS.x);
            if(_xSpeed * Controls.AXIS.x < 0)
            {
               applyDamping();
            }
         }
         else
         {
            applyDamping();
         }
         if(this.superSpeed > 0)
         {
            _xSpeed = Calc.clamp(xSpeed,-this.maxHSpeed * 1.5,this.maxHSpeed * 1.5);
         }
         else
         {
            _xSpeed = Calc.clamp(xSpeed,-this.maxHSpeed,this.maxHSpeed);
         }
         _ySpeed = Calc.clamp(ySpeed,-MAX_V_SPEED * 2,MAX_V_SPEED);
      }
      
      private function canAttack() : Boolean
      {
         return this.attacking <= 0 && this.attackDuration <= 0 && (UserData.weapon == "" || this.bunny == null);
      }
      
      private function checkForDoor() : void
      {
         var _loc1_:Door = null;
         for each(_loc1_ in level.getEntitiesByType(Door))
         {
            if(_loc1_.body != null && body.intersects(_loc1_.body))
            {
               _loc1_.onEnter();
               break;
            }
         }
      }
      
      private function onAttack() : void
      {
         if(!UserData.getTrigger("goggles"))
         {
            return;
         }
         if(UserData.weapon == "sansao" && this.bunny != null)
         {
            this.attackWithBunny();
         }
         else if(UserData.weapon == "")
         {
            this.attackDirect();
         }
      }
      
      private function attackWithBunny() : void
      {
         if(this.attacking <= 0)
         {
            if(onGround)
            {
               _xSpeed *= 0.1;
            }
            this.playAnim(onGround ? "attack" : "attack");
            SoundManager.playSound("coelhadaFail" + Rand.getInt(2).toString());
            tween(this,0.1,null,false).onComplete(function():void
            {
               bunny.attack();
               attacking = 5;
               attackBody = new Rectangle(x,y - 24,64,30);
               if(_side < 0)
               {
                  attackBody.x -= attackBody.width;
               }
            });
         }
      }
      
      private function attackDirect() : void
      {
         if(this.attackDuration <= 0)
         {
            if(onGround)
            {
               _xSpeed *= 0.1;
            }
            this.playAnim("attack");
            SoundManager.playSound("coelhadaFail" + Rand.getInt(2).toString());
            this.attackDuration = 15;
            this.attackAngle = this._side == 1 ? 180 : 0;
            this.attackSwoosh.visible = true;
            this.attackSwoosh.scaleX = this._side;
            this.attackSwoosh.alpha = 1;
            this.attacking = 5;
            this.attackBody = new Rectangle(x + this._side * 25,y - 20,50,35);
            if(this._side < 0)
            {
               this.attackBody.x -= this.attackBody.width;
            }
            world.add(new ScreenFlash(0.05,16777215,null,null,0.2));
            world.add(new CameraShake(3,0.15));
            this.attackSwoosh.x = x + this._side * 20;
            this.attackSwoosh.y = y - 10;
         }
      }
      
      private function updateAnimations() : void
      {
         if(this.alive && this.image.animationName != "attack" && this.image.animationName != "attackJump" && this.image.animationName != "standUp")
         {
            if(onGround)
            {
               if(this.walking)
               {
                  if(this.image.animationName != "run" && this.image.animationName != "run_b")
                  {
                     this.playAnim("run" + (!this.blink ? "" : "_b"));
                  }
               }
               else if(this.image.animationName != "stand" && this.image.animationName != "stand_b")
               {
                  this.playAnim("stand" + (!this.blink ? "" : "_b"));
               }
               this.walking = false;
            }
            else
            {
               this.onAir();
            }
         }
         else if(!this.alive)
         {
            this.playAnim("fallHit");
         }
      }
      
      override protected function onHitGround() : void
      {
         super.onHitGround();
         tween(this.image,0.3).scaleFrom(1.3 * this._side * IMAGE_SCALE,0.8 * IMAGE_SCALE).scaleTo(1 * this._side * IMAGE_SCALE,1 * IMAGE_SCALE).ease(Ease.backOut);
         this.takingHit = false;
         level.updateCameraY();
         this.canDoubleJump = true;
         SoundManager.playSound("impact",0.5);
      }
      
      override protected function onLeaveGround() : void
      {
         super.onLeaveGround();
         this.forgivingJump = 7;
      }
      
      override protected function onDebug() : void
      {
         Debug.drawRectOutline(body.x,body.y,body.width,body.height,this.forgivingJump > 0 ? 4456703 : 16711680);
         if(this.attacking > 0 || this.attackDuration > 0)
         {
            Debug.drawRect(this.attackBody.x,this.attackBody.y,this.attackBody.width,this.attackBody.height,16711680,0.75);
         }
         if(this.stompBody)
         {
            Debug.drawRect(this.stompBody.x,this.stompBody.y,this.stompBody.width,this.stompBody.height,16711680,0.75);
         }
      }
      
      override protected function updatePosition() : void
      {
         super.updatePosition();
         if(onGround && Boolean(level.solidAt(x / 32,y / 32 + 1)))
         {
            this.setValidLocation();
         }
         if(y > level.height)
         {
            setPosition(this.lastValidPosition.x,this.lastValidPosition.y);
            this.playAnim("standUp");
            this.image.ON_COMPLETE.add(this.onRecover);
            this.onTakeHit(1,0);
            this.recovering = true;
            _xSpeed = 0;
            _ySpeed = 0;
         }
      }
      
      private function onRecover() : void
      {
         this.image.ON_COMPLETE.remove(this.onRecover);
         _xSpeed = 0;
         _ySpeed = 0;
         this.recovering = false;
      }
      
      public function get currentFrame() : String
      {
         return this.getAnimName();
      }
      
      public function get imageX() : int
      {
         return x + (this.image.x - this.image.originX) * this.side;
      }
      
      public function get imageY() : int
      {
         return y + this.image.y - this.image.originY;
      }
      
      private function getAnimName() : String
      {
         var _loc1_:Array = null;
         _loc1_ = String(this.image.textureName).split("/");
         return _loc1_[_loc1_.length - 1];
      }
      
      private function updateProperties() : void
      {
         if(!this.takingHit)
         {
            --this.invulnerable;
            if(this.invulnerable > 0)
            {
               this.image.alpha = this.invulnerable % 8 < 4 ? 0.2 : 1;
               this.imageBoots.alpha = this.invulnerable % 8 < 4 ? 0.2 : 1;
               this.imageGoggles.alpha = this.invulnerable % 8 < 4 ? 0.2 : 1;
               if(this.attackSwoosh.visible)
               {
                  this.attackSwoosh.alpha = this.invulnerable % 8 < 4 ? 0.2 : 1;
               }
            }
            else
            {
               this.image.alpha = 1;
               this.imageBoots.alpha = 1;
               this.imageGoggles.alpha = 1;
               if(this.attackSwoosh.visible)
               {
                  this.attackSwoosh.alpha = this.attackDuration / 15;
               }
            }
         }
         if(this.onWater != null)
         {
            gravity = Constants.GRAVITY / 2;
            this.maxHSpeed = MAX_H_SPEED / 2;
            if(this.onWater.y < y - 32)
            {
               if(!UserData.getTrigger("respirador"))
               {
                  this.breath -= 0.02;
                  level.hud.showOxigen(this.breath);
                  if(this.breath <= 0)
                  {
                     this.onTakeHit(1,0);
                     this.breath = MAX_AIR / 6;
                  }
               }
            }
         }
         else
         {
            gravity = Constants.GRAVITY;
            this.maxHSpeed = MAX_H_SPEED;
         }
         if(this.superSpeed > 0)
         {
            --this.superSpeed;
            level.hud.superSpeed = true;
         }
         else
         {
            level.hud.superSpeed = false;
         }
         if(this.superHeavy > 0)
         {
            --this.superHeavy;
            level.hud.superHeavy = true;
         }
         else
         {
            level.hud.superHeavy = false;
         }
         if(this.superInvenc > 0)
         {
            --this.superInvenc;
            level.hud.superInvenc = true;
         }
         else
         {
            level.hud.superInvenc = false;
         }
         if(this.superJump)
         {
            level.hud.superJump = true;
         }
         else
         {
            level.hud.superJump = false;
         }
      }
      
      private function onAir() : void
      {
         --this.forgivingJump;
         this.playAnim(ySpeed > 0 ? "fall" + (this.takingHit ? "Hit" : "") : "jump" + (this.takingHit ? "Hit" : ""));
      }
      
      private function playAnim(param1:String, param2:Boolean = false) : void
      {
         this.image.play(param1,param2);
      }
      
      private function onDeath() : void
      {
         this.alive = false;
         this.invulnerable = 0;
         this.takingHit = false;
         tween(this.image,0.75).to("alpha",0);
         level.onPlayerDeath();
      }
      
      public function get side() : int
      {
         return this._side;
      }
   }
}

