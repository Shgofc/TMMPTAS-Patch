package game.world
{
   import flash.geom.Point;
   import flashpunk2.Entity;
   import flashpunk2.World;
   import flashpunk2.components.rendering.AnimationRenderer;
   import flashpunk2.components.rendering.BitmapTextRenderer;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.global.Asset;
   import flashpunk2.global.Ease;
   import game.Constants;
   import game.Controls;
   import game.UserData;
   import game.collectibles.Products;
   import sound.MusicPlayer;
   import sound.SoundManager;
   
   public class ShopLevel extends World
   {
      
      private var lastWorld:World;
      
      private var selection:int = 1;
      
      private var imageList:Vector.<AnimationRenderer>;
      
      private var levelPosition:Point;
      
      private var doorId:int;
      
      private var products:Vector.<Products>;
      
      private var vendorText:BitmapTextRenderer;
      
      private var itemName:BitmapTextRenderer;
      
      private var baloonHolder:Entity;
      
      private var shopTag:String;
      
      public function ShopLevel(param1:String, param2:Point, param3:int, param4:String)
      {
         var _loc8_:Products = null;
         var _loc9_:ImageRenderer = null;
         var _loc10_:BitmapTextRenderer = null;
         var _loc11_:AnimationRenderer = null;
         super();
         this.shopTag = param4;
         this.doorId = param3;
         this.levelPosition = param2;
         addComponent(new ImageRenderer("shop/bg"));
         this.imageList = new Vector.<AnimationRenderer>();
         this.products = new Vector.<Products>();
         var _loc5_:XML = Asset.getXMLByType(Assets.SHOP_XML).xml;
         _loc5_ = _loc5_[param1][0];
         var _loc6_:XMLList = _loc5_.children();
         this.products.push(new Products(_loc6_[0].name(),_loc6_[0].@title,_loc6_[0].@price,_loc6_[0].@image,XML(_loc6_[0]).text()));
         this.products.push(new Products(_loc6_[1].name(),_loc6_[1].@title,_loc6_[1].@price,_loc6_[1].@image,XML(_loc6_[1]).text()));
         var _loc7_:int = 0;
         for each(_loc8_ in this.products)
         {
            _loc11_ = new AnimationRenderer();
            this.imageList.push(_loc11_);
            _loc11_.addPrefix("shop","shop/item",0,false);
            _loc11_.play("shop");
            _loc11_.index = _loc8_.imageIndex;
            _loc11_.x = 90;
            _loc11_.y = 80 + _loc7_ * 95;
            _loc11_.centerOrigin();
            addComponent(_loc11_);
            _loc7_++;
         }
         _loc11_ = new AnimationRenderer();
         this.imageList.push(_loc11_);
         _loc11_.addPrefix("shop","shop/item",0,false);
         _loc11_.play("shop");
         _loc11_.index = 1;
         _loc11_.x = 90;
         _loc11_.y = 80 + _loc7_ * 95;
         _loc11_.centerOrigin();
         addComponent(_loc11_);
         _loc9_ = new ImageRenderer("shop/baloon",true);
         this.baloonHolder = addComponent(_loc9_);
         this.baloonHolder.x = Constants.STAGE_WIDTH - _loc9_.width / 2;
         this.baloonHolder.y = Constants.STAGE_HEIGHT - _loc9_.height / 2;
         tween(this.baloonHolder,0.4).scaleFrom(0.3,0.3).scaleTo(1,1).ease(Ease.backInOut);
         _loc10_ = new BitmapTextRenderer(200,80,UserData.gold.toString(),"font",28,3407786,true);
         _loc10_.setPosition(135,459);
         addComponent(_loc10_);
         this.select(-1);
         ON_UPDATE.add(this.onUpdate);
         ON_START.add(this.onStart);
      }
      
      private function onStart() : void
      {
         MusicPlayer.start(this);
         MusicPlayer.playMusic("shop");
      }
      
      private function onUpdate() : void
      {
         SoundManager.refresh();
         if(Controls.AXIS.pressed)
         {
            this.select(Controls.AXIS.y);
         }
         if(Controls.JUMP.pressed || Controls.ATTACK.pressed)
         {
            this.onComplete();
         }
      }
      
      private function select(param1:int) : void
      {
         var _loc2_:* = null;
         var _loc3_:String = null;
         SoundManager.playSound("shopSelect");
         tween(this.imageList[this.selection],0.7).scaleTo(1,1).ease(Ease.elasticOut);
         this.selection += param1;
         if(this.selection < 0)
         {
            this.selection = 2;
         }
         if(this.selection > 2)
         {
            this.selection = 0;
         }
         if(this.selection < this.products.length)
         {
            _loc2_ = this.products[this.selection].description + "\n Custa " + this.products[this.selection].price + " moedas!";
         }
         else
         {
            _loc2_ = "Já vai indo embora? Volte sempre!";
         }
         if(this.vendorText != null)
         {
            this.vendorText.removeSelf();
         }
         this.vendorText = new BitmapTextRenderer(415,200,_loc2_,"font",25,0,true);
         this.vendorText.y = 8;
         this.baloonHolder.add(this.vendorText);
         if(this.selection < this.products.length)
         {
            _loc3_ = this.products[this.selection].title.toUpperCase();
         }
         else
         {
            _loc2_ = "SAIR";
         }
         if(this.itemName != null && this.itemName.entity != null)
         {
            this.itemName.entity.removeSelf();
         }
         this.itemName = new BitmapTextRenderer(415,200,_loc3_,"font",36,3407786,true);
         this.itemName.setPosition(395,40);
         addComponent(this.itemName);
         tween(this.imageList[this.selection],0.35).scaleTo(1.3,1.3).ease(Ease.elasticOut);
         tween(this.vendorText,0.9).from("alpha",0).to("alpha",1).ease(Ease.backOut);
      }
      
      private function onComplete() : void
      {
         var _loc1_:Products = null;
         if(this.selection < this.products.length)
         {
            _loc1_ = this.products[this.selection];
            if(UserData.gold >= _loc1_.price)
            {
               UserData.spendGold(_loc1_.price);
               _loc1_.onUse();
               UserData.setTrigger(this.shopTag);
               PlatformLevel.gotoLevel(this.levelPosition.x,this.levelPosition.y,PlatformLevel.DOOR,this.doorId,true);
            }
            else
            {
               this.vendorText.text = "Você não tem dinheiro suficiente, faltam " + int(_loc1_.price - UserData.gold).toString() + " moedas!";
            }
         }
         else
         {
            SoundManager.playSound("shopSelect");
            PlatformLevel.gotoLevel(this.levelPosition.x,this.levelPosition.y,PlatformLevel.DOOR,this.doorId,true);
         }
      }
   }
}

