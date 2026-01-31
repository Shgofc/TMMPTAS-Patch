package game
{
   import flash.geom.Point;
   import flash.net.SharedObject;
   import game.world.PlatformLevel;
   
   public class UserData
   {
      
      private static var _gold:int = 0;
      
      private static var _maxHp:int = 6;
      
      private static var _weapon:String = "";
      
      private static var _key:int = 0;
      
      private static var _triggers:Vector.<String> = new Vector.<String>();
      
      private static var _doors:Vector.<int> = new Vector.<int>();
      
      private static var _checkpoint:Point = new Point(1,1);
      
      public static var playMusic:Boolean = true;
      
      public static var saveData:XML = <saveGame></saveGame>;
      
      public static var sharedOBJ:SharedObject = SharedObject.getLocal("monica");
      
      public function UserData()
      {
         super();
      }
      
      public static function get weapon() : String
      {
         return _weapon;
      }
      
      public static function get gold() : int
      {
         return _gold;
      }
      
      public static function collectGold(param1:uint) : int
      {
         _gold += param1;
         return _gold;
      }
      
      public static function spendGold(param1:int) : void
      {
         _gold -= param1;
      }
      
      public static function collectWeapon(param1:String) : void
      {
         _weapon = param1;
      }
      
      public static function collectKey() : void
      {
         ++_key;
      }
      
      public static function useKey() : void
      {
         --_key;
      }
      
      public static function hasKey() : Boolean
      {
         return _key > 0;
      }
      
      public static function get keys() : int
      {
         return _key;
      }
      
      public static function doorLocked(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         for each(_loc2_ in _doors)
         {
            if(_loc2_ == param1)
            {
               return false;
            }
         }
         return true;
      }
      
      public static function unlockDoor(param1:int) : void
      {
         if(doorLocked(param1))
         {
            _doors.push(param1);
         }
      }
      
      public static function setTrigger(param1:String) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in _triggers)
         {
            if(_loc2_ == param1)
            {
               return;
            }
         }
         _triggers.push(param1);
      }
      
      public static function getTrigger(param1:String) : Boolean
      {
         var _loc2_:String = null;
         for each(_loc2_ in _triggers)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getMaxHp() : int
      {
         return _maxHp;
      }
      
      public static function addMaxHp() : void
      {
         _maxHp += 2;
      }
      
      public static function switchMusic() : void
      {
         playMusic = !playMusic;
         saveOptions();
      }
      
      public static function setCheckpoint(param1:int, param2:int) : void
      {
         _checkpoint = new Point(param1,param2);
         save();
      }
      
      public static function isCheckpoint(param1:PlatformLevel) : Boolean
      {
         return _checkpoint != null && param1.x == _checkpoint.x && param1.y == _checkpoint.y;
      }
      
      public static function getCheckpoint() : Point
      {
         return _checkpoint;
      }
      
      public static function loadOptions() : void
      {
         sharedOBJ = SharedObject.getLocal("monicaOptions");
         if(sharedOBJ.data != null)
         {
            playMusic = sharedOBJ.data.music;
         }
         else
         {
            playMusic = true;
         }
      }
      
      public static function load() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         sharedOBJ = SharedObject.getLocal("monica");
         if(sharedOBJ.data != null)
         {
            _gold = sharedOBJ.data.gold;
            _maxHp = sharedOBJ.data.maxHp;
            _weapon = sharedOBJ.data.weapon;
            _key = sharedOBJ.data.key;
            _triggers = new Vector.<String>();
            for each(_loc1_ in sharedOBJ.data.triggers)
            {
               _triggers.push(_loc1_ as String);
            }
            _doors = new Vector.<int>();
            for each(_loc2_ in sharedOBJ.data.doors)
            {
               _doors.push(_loc2_ as int);
            }
            _checkpoint = new Point(sharedOBJ.data.checkpointX,sharedOBJ.data.checkpointY);
         }
         else
         {
            _gold = 0;
            _maxHp = 6;
            _weapon = "";
            _key = 0;
            _triggers = new Vector.<String>();
            _doors = new Vector.<int>();
            _checkpoint = new Point(1,1);
         }
      }
      
      public static function saveOptions() : void
      {
         sharedOBJ = SharedObject.getLocal("monicaOptions");
         sharedOBJ.data.music = playMusic;
         sharedOBJ.flush();
      }
      
      public static function save() : void
      {
         sharedOBJ = SharedObject.getLocal("monica");
         sharedOBJ.data.gold = _gold;
         sharedOBJ.data.maxHp = _maxHp;
         sharedOBJ.data.weapon = _weapon;
         sharedOBJ.data.key = _key;
         sharedOBJ.data.triggers = _triggers;
         sharedOBJ.data.doors = _doors;
         sharedOBJ.data.checkpointX = _checkpoint.x;
         sharedOBJ.data.checkpointY = _checkpoint.y;
         sharedOBJ.data.music = playMusic;
         sharedOBJ.flush();
      }
      
      public static function resetSave() : void
      {
         sharedOBJ = SharedObject.getLocal("monica");
         _gold = 0;
         _maxHp = 6;
         _weapon = "";
         _key = 0;
         _triggers = new Vector.<String>();
         _doors = new Vector.<int>();
         _checkpoint = new Point(1,1);
         sharedOBJ.flush();
      }
      
      public static function hasSave() : Boolean
      {
         sharedOBJ = SharedObject.getLocal("monica");
         return sharedOBJ != null && sharedOBJ.data != null && sharedOBJ.data.checkpointX != null;
      }
   }
}

