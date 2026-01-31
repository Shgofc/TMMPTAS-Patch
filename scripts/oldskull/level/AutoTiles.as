package oldskull.level
{
   import flash.utils.Dictionary;
   import flashpunk2.Entity;
   import flashpunk2.components.rendering.TileRenderer;
   import flashpunk2.components.rendering.Tileset;
   import flashpunk2.global.Rand;
   import game.world.PlatformLevel;
   
   public class AutoTiles
   {
      
      private var level:PlatformLevel;
      
      private var grid:Dictionary;
      
      private var coreTile:TileRenderer;
      
      private var topTile:TileRenderer;
      
      private var rightTile:TileRenderer;
      
      private var leftTile:TileRenderer;
      
      private var bottomTile:TileRenderer;
      
      private var topRightTile:TileRenderer;
      
      private var topLeftTile:TileRenderer;
      
      private var BottomBorder:Array;
      
      private var TopBorder:Array;
      
      private var SingleTopBorder:Array;
      
      private var LeftBorder:Array;
      
      private var RightBorder:Array;
      
      private var TopLeftBorder:Array;
      
      private var TopRightBorder:Array;
      
      private var Top:Array;
      
      private var Bottom:Array;
      
      private var Left:Array;
      
      private var Right:Array;
      
      private var Center:Array;
      
      private var Single:Array;
      
      private var SingleHorizontalCenter:Array;
      
      private var SingleHorizontalLeft:Array;
      
      private var SingleHorizontalRight:Array;
      
      private var SingleVerticalCenter:Array;
      
      private var SingleVerticalTop:Array;
      
      private var SingleVerticalBottom:Array;
      
      private var BottomLeft:Array;
      
      private var BottomRight:Array;
      
      private var TopLeft:Array;
      
      private var TopRight:Array;
      
      private var InsideTopLeft:Array;
      
      private var InsideTopRight:Array;
      
      private var InsideBottomLeft:Array;
      
      private var InsideBottomRight:Array;
      
      private var Junction:Array;
      
      private var coreEntity:Entity;
      
      private var borderEntity:Entity;
      
      private var tilesHeight:int;
      
      private var tilesWidth:int;
      
      private var externalBorder:Boolean;
      
      public function AutoTiles(param1:PlatformLevel, param2:Dictionary, param3:XML, param4:String = "", param5:String = "", param6:Boolean = true)
      {
         var _loc8_:Tileset = null;
         var _loc9_:* = false;
         var _loc10_:* = false;
         var _loc11_:* = false;
         var _loc12_:* = false;
         var _loc13_:* = false;
         var _loc14_:* = false;
         var _loc15_:* = false;
         var _loc16_:Tileset = null;
         var _loc17_:int = 0;
         super();
         this.externalBorder = param6;
         this.level = param1;
         this.grid = param2;
         this.tilesWidth = param1.width / 32;
         this.tilesHeight = param1.height / 32;
         if(param5 != "")
         {
            _loc8_ = new Tileset(param5,32,32);
            this.bottomTile = new TileRenderer(_loc8_,this.tilesWidth,this.tilesHeight);
            this.bottomTile.setPosition(param3.externalTiles[0].bottom[0].@x,param3.externalTiles[0].bottom[0].@y);
            this.leftTile = new TileRenderer(_loc8_,this.tilesWidth,this.tilesHeight);
            this.leftTile.setPosition(param3.externalTiles[0].left[0].@x,param3.externalTiles[0].left[0].@y);
            this.rightTile = new TileRenderer(_loc8_,this.tilesWidth,this.tilesHeight);
            this.rightTile.setPosition(param3.externalTiles[0].right[0].@x,param3.externalTiles[0].right[0].@y);
            this.topTile = new TileRenderer(_loc8_,this.tilesWidth,this.tilesHeight);
            this.topTile.setPosition(param3.externalTiles[0].top[0].@x,param3.externalTiles[0].top[0].@y);
            this.topRightTile = new TileRenderer(_loc8_,this.tilesWidth,this.tilesHeight);
            this.topRightTile.setPosition(param3.externalTiles[0].topRight[0].@x,param3.externalTiles[0].topRight[0].@y);
            this.topLeftTile = new TileRenderer(_loc8_,this.tilesWidth,this.tilesHeight);
            this.topLeftTile.setPosition(param3.externalTiles[0].topLeft[0].@x,param3.externalTiles[0].topLeft[0].@y);
            this.BottomBorder = String(param3.externalTiles[0].bottom[0].text()).split(",");
            _loc9_ = this.BottomBorder[0] != "";
            this.SingleTopBorder = String(param3.externalTiles[0].singleTop[0].text()).split(",");
            _loc10_ = this.SingleTopBorder[0] != "";
            this.TopBorder = String(param3.externalTiles[0].top[0].text()).split(",");
            _loc11_ = this.TopBorder[0] != "";
            this.LeftBorder = String(param3.externalTiles[0].left[0].text()).split(",");
            _loc12_ = this.LeftBorder[0] != "";
            this.RightBorder = String(param3.externalTiles[0].right[0].text()).split(",");
            _loc13_ = this.RightBorder[0] != "";
            this.TopLeftBorder = String(param3.externalTiles[0].topRight[0].text()).split(",");
            _loc14_ = this.TopLeftBorder[0] != "";
            this.TopRightBorder = String(param3.externalTiles[0].topLeft[0].text()).split(",");
            _loc15_ = this.TopRightBorder[0] != "";
         }
         if(param4 != "")
         {
            _loc16_ = new Tileset(param4,32,32);
            this.coreTile = new TileRenderer(_loc16_,this.tilesWidth,this.tilesHeight);
            this.Bottom = String(param3.internalTiles[0].bottom[0].text()).split(",");
            this.Top = String(param3.internalTiles[0].top[0].text()).split(",");
            this.Left = String(param3.internalTiles[0].left[0].text()).split(",");
            this.Right = String(param3.internalTiles[0].right[0].text()).split(",");
            this.Center = String(param3.internalTiles[0].middle[0].text()).split(",");
            this.Single = String(param3.internalTiles[0].single[0].text()).split(",");
            this.SingleHorizontalCenter = String(param3.internalTiles[0].singleHorizontalCenter[0].text()).split(",");
            this.SingleHorizontalLeft = String(param3.internalTiles[0].singleHorizontalLeft[0].text()).split(",");
            this.SingleHorizontalRight = String(param3.internalTiles[0].singleHorizontalRight[0].text()).split(",");
            this.SingleVerticalCenter = String(param3.internalTiles[0].singleVerticalCenter[0].text()).split(",");
            this.SingleVerticalTop = String(param3.internalTiles[0].singleVerticalTop[0].text()).split(",");
            this.SingleVerticalBottom = String(param3.internalTiles[0].singleVerticalBottom[0].text()).split(",");
            this.BottomLeft = String(param3.internalTiles[0].bottomLeft[0].text()).split(",");
            this.BottomRight = String(param3.internalTiles[0].bottomRight[0].text()).split(",");
            this.TopLeft = String(param3.internalTiles[0].topLeft[0].text()).split(",");
            this.TopRight = String(param3.internalTiles[0].topRight[0].text()).split(",");
            this.InsideBottomLeft = String(param3.internalTiles[0].insideBottomLeft[0].text()).split(",");
            this.InsideBottomRight = String(param3.internalTiles[0].insideBottomRight[0].text()).split(",");
            this.InsideTopLeft = String(param3.internalTiles[0].insideTopLeft[0].text()).split(",");
            this.InsideTopRight = String(param3.internalTiles[0].insideTopRight[0].text()).split(",");
            this.Junction = String(param3.internalTiles[0].junction[0].text()).split(",");
         }
         var _loc7_:int = 0;
         while(_loc7_ < this.tilesWidth)
         {
            _loc17_ = 0;
            while(_loc17_ < this.tilesHeight)
            {
               if(!this.check(_loc7_,_loc17_))
               {
                  if(param5 != "")
                  {
                     if(_loc9_ && this.check2(_loc7_,_loc17_ - 1) && (this.check2(_loc7_ - 1,_loc17_ - 1) && this.check2(_loc7_ + 1,_loc17_ - 1)))
                     {
                        this.bottomTile.setTile(_loc7_,_loc17_,Rand.choose(this.BottomBorder));
                     }
                     if(param6)
                     {
                        if(_loc11_ && this.check2(_loc7_,_loc17_ + 1))
                        {
                           this.topTile.setTile(_loc7_,_loc17_,Rand.choose(this.TopBorder));
                        }
                        if(_loc15_ && !this.check2(_loc7_ + 1,_loc17_) && !this.check2(_loc7_,_loc17_ + 1) && this.check2(_loc7_ + 1,_loc17_ + 1))
                        {
                           this.topRightTile.setTile(_loc7_,_loc17_,Rand.choose(this.TopRightBorder));
                        }
                        if(_loc14_ && !this.check2(_loc7_ - 1,_loc17_) && !this.check2(_loc7_,_loc17_ + 1) && this.check2(_loc7_ - 1,_loc17_ + 1))
                        {
                           this.topLeftTile.setTile(_loc7_,_loc17_,Rand.choose(this.TopLeftBorder));
                        }
                     }
                     else if(_loc11_ && this.check2(_loc7_,_loc17_ + 1) && !this.check2(_loc7_ + 1,_loc17_ + 1) && !this.check2(_loc7_ - 1,_loc17_ + 1))
                     {
                        this.topTile.setTile(_loc7_,_loc17_,Rand.choose(this.SingleTopBorder));
                     }
                     else if(_loc15_ && this.check2(_loc7_,_loc17_ + 1) && this.check2(_loc7_ + 1,_loc17_ + 1) && !this.check2(_loc7_ - 1,_loc17_ + 1))
                     {
                        this.topRightTile.setTile(_loc7_,_loc17_,Rand.choose(this.TopRightBorder));
                     }
                     else if(_loc14_ && this.check2(_loc7_,_loc17_ + 1) && this.check2(_loc7_ - 1,_loc17_ + 1) && !this.check2(_loc7_ + 1,_loc17_ + 1))
                     {
                        this.topLeftTile.setTile(_loc7_,_loc17_,Rand.choose(this.TopLeftBorder));
                     }
                     else if(_loc11_ && this.check2(_loc7_,_loc17_ + 1))
                     {
                        this.topTile.setTile(_loc7_,_loc17_,Rand.choose(this.TopBorder));
                     }
                     if(_loc12_ && this.check2(_loc7_ - 1,_loc17_))
                     {
                        this.leftTile.setTile(_loc7_,_loc17_,Rand.choose(this.LeftBorder));
                     }
                     if(_loc13_ && this.check2(_loc7_ + 1,_loc17_))
                     {
                        this.rightTile.setTile(_loc7_,_loc17_,Rand.choose(this.RightBorder));
                     }
                  }
               }
               else
               {
                  if(param4 != "")
                  {
                     this.coreTile.setTile(_loc7_,_loc17_,Rand.choose(this.getInnerTile(_loc7_,_loc17_)));
                  }
                  if(param5 != "")
                  {
                     if(_loc14_ && !this.check2(_loc7_ - 1,_loc17_) && this.check2(_loc7_ - 1,_loc17_ + 1) && this.check2(_loc7_,_loc17_ + 1))
                     {
                        this.topLeftTile.setTile(_loc7_,_loc17_,Rand.choose(this.TopLeftBorder));
                     }
                     if(_loc15_ && !this.check2(_loc7_ + 1,_loc17_) && this.check2(_loc7_ + 1,_loc17_ + 1) && this.check2(_loc7_,_loc17_ + 1))
                     {
                        this.topRightTile.setTile(_loc7_,_loc17_,Rand.choose(this.TopRightBorder));
                     }
                  }
               }
               _loc17_++;
            }
            _loc7_++;
         }
         this.coreEntity = new Entity();
         this.borderEntity = new Entity();
         this.coreEntity.add(this.coreTile);
         if(_loc12_)
         {
            this.borderEntity.add(this.leftTile);
         }
         if(_loc13_)
         {
            this.borderEntity.add(this.rightTile);
         }
         if(_loc9_)
         {
            this.borderEntity.add(this.bottomTile);
         }
         if(_loc11_)
         {
            this.borderEntity.add(this.topTile);
         }
         if(_loc14_)
         {
            this.borderEntity.add(this.topLeftTile);
         }
         if(_loc15_)
         {
            this.borderEntity.add(this.topRightTile);
         }
         this.coreEntity.sprite.flatten();
         this.borderEntity.sprite.flatten();
      }
      
      public function get coreTiles() : Entity
      {
         return this.coreEntity;
      }
      
      public function get borderTiles() : Entity
      {
         return this.borderEntity;
      }
      
      private function getInnerTile(param1:int, param2:int) : Array
      {
         var _loc3_:Boolean = this.check(param1,param2 - 1);
         var _loc4_:Boolean = this.check(param1,param2 + 1);
         var _loc5_:Boolean = this.check(param1 - 1,param2);
         var _loc6_:Boolean = this.check(param1 + 1,param2);
         var _loc7_:Boolean = this.check(param1 + 1,param2 - 1);
         var _loc8_:Boolean = this.check(param1 + 1,param2 + 1);
         var _loc9_:Boolean = this.check(param1 - 1,param2 - 1);
         var _loc10_:Boolean = this.check(param1 - 1,param2 + 1);
         if(_loc5_ && _loc6_ && _loc3_ && _loc4_ && _loc7_ && _loc8_ && _loc9_ && _loc10_)
         {
            return this.Center;
         }
         if(_loc5_ + _loc4_ + _loc3_ + _loc6_ > 2 && !(_loc7_ || _loc8_ || _loc9_ || _loc10_))
         {
            return this.Junction;
         }
         if(!_loc3_ && !_loc4_)
         {
            if(_loc5_ && _loc6_)
            {
               return this.SingleHorizontalCenter;
            }
            if(!_loc5_ && !_loc6_)
            {
               return this.Single;
            }
            if(_loc5_)
            {
               return this.SingleHorizontalRight;
            }
            return this.SingleHorizontalLeft;
         }
         if(!_loc5_ && !_loc6_)
         {
            if(_loc3_ && _loc4_)
            {
               return this.SingleVerticalCenter;
            }
            if(_loc4_)
            {
               return this.SingleVerticalTop;
            }
            return this.SingleVerticalBottom;
         }
         if(_loc3_ && _loc4_ && _loc5_ && !_loc6_)
         {
            return this.Right;
         }
         if(_loc3_ && _loc4_ && !_loc5_ && _loc6_)
         {
            return this.Left;
         }
         if(_loc3_ && !_loc5_ && _loc6_ && !_loc4_)
         {
            return this.BottomLeft;
         }
         if(_loc3_ && _loc5_ && !_loc6_ && !_loc4_)
         {
            return this.BottomRight;
         }
         if(_loc4_ && _loc6_ && !_loc5_ && !_loc3_)
         {
            return this.TopLeft;
         }
         if(_loc4_ && !_loc6_ && _loc5_ && !_loc3_)
         {
            return this.TopRight;
         }
         if(_loc3_ && _loc4_ && !_loc10_ && _loc9_)
         {
            return this.InsideTopLeft;
         }
         if(_loc3_ && _loc4_ && _loc10_ && !_loc9_)
         {
            return this.InsideTopRight;
         }
         if(_loc3_ && _loc4_ && _loc7_ && !_loc8_)
         {
            return this.InsideBottomLeft;
         }
         if(_loc3_ && _loc4_ && !_loc7_ && _loc8_)
         {
            return this.InsideBottomRight;
         }
         if(!_loc4_)
         {
            return this.Bottom;
         }
         return this.Top;
      }
      
      private function check(param1:int, param2:int) : Boolean
      {
         if(param1 < 0 || param1 >= this.tilesWidth || (param2 < 0 || param2 >= this.tilesHeight))
         {
            return true;
         }
         return this.grid[param1] == undefined || this.grid[param1][param2] == undefined ? false : this.grid[param1][param2] != null;
      }
      
      private function check2(param1:int, param2:int) : Boolean
      {
         if(param1 < 0 || param1 >= this.tilesWidth || (param2 < 0 || param2 >= this.tilesHeight))
         {
            return false;
         }
         return this.grid[param1] == undefined || this.grid[param1][param2] == undefined ? false : this.grid[param1][param2] != null;
      }
   }
}

