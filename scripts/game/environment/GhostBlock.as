package game.environment
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flashpunk2.components.rendering.ImageRenderer;
   import flashpunk2.global.Ease;
   import starling.display.Image;
   
   public class GhostBlock extends Wall
   {
      
      private var timer:Number = 0;
      
      private var nodes:Vector.<Point>;
      
      private var currentNode:int = 0;
      
      private var objXml:XML;
      
      private var waiting:Boolean = false;
      
      private var imageGlow:ImageRenderer;
      
      private var spot:Image;
      
      public function GhostBlock(param1:XML, param2:int = 0)
      {
         var node:XML = null;
         var obj:XML = param1;
         var currentNode:int = param2;
         super(0,0,obj.@width,obj.@height);
         this.objXml = obj;
         this.currentNode = currentNode;
         this.timer = obj.@timer;
         this.nodes = new Vector.<Point>();
         this.nodes.push(new Point(obj.@x,obj.@y));
         for each(node in obj.node)
         {
            this.nodes.push(new Point(node.@x,node.@y));
         }
         setPosition(this.nodes[currentNode].x + 16,this.nodes[currentNode].y + 16);
         tween(this,this.timer).onComplete(function():void
         {
            imageGlow.visible = true;
            image.visible = false;
            if(spot != null)
            {
               tween(spot,0.5).scaleTo(2,2).ease(Ease.elasticOut);
            }
            tween(this,0.6).onComplete(function():void
            {
               ON_UPDATE.add(nextNode);
            });
         });
         image = new ImageRenderer("environment/ghostPlatform",true);
         this.imageGlow = new ImageRenderer("environment/ghostPlatformGlow",true);
         add(image);
         add(this.imageGlow);
         this.imageGlow.visible = false;
         ON_START.add(this.onAdded);
      }
      
      private function onAdded() : void
      {
         tween(image,0.5).scaleFrom(0,0).scaleTo(1,1).ease(Ease.bounceOut);
         level.setSolid(x / 32,y / 32,this);
         level.shouldSortEntities = true;
         if(level.dark)
         {
            this.spot = level.illumination.addSpot(x - camera.x,y - camera.y,0);
            tween(this.spot,0.5).scaleFrom(0,0).scaleTo(1.5,1.5).ease(Ease.bounceOut);
            ON_UPDATE.add(function():void
            {
               spot.x = x - camera.x;
               spot.y = y - camera.y;
            });
         }
      }
      
      private function nextNode() : void
      {
         var nextNode:int;
         this.imageGlow.visible = false;
         image.visible = true;
         nextNode = this.currentNode + 1;
         if(nextNode > this.nodes.length - 1)
         {
            nextNode = 0;
         }
         if(!level.player.body.intersects(new Rectangle(this.nodes[nextNode].x,this.nodes[nextNode].y,body.width,body.height)))
         {
            level.setSolid(x / 32,y / 32,null);
            world.add(new GhostBlock(this.objXml,nextNode));
            if(this.spot)
            {
               tween(this.spot,0.4).scaleTo(0,0).ease(Ease.cubeOut).onComplete(function():void
               {
                  level.illumination.removeSpot(spot);
               });
            }
            tween(image,0.5).scaleFrom(1.25,1.25).scaleTo(0,0).ease(Ease.cubeOut).onComplete(removeSelf);
            ON_UPDATE.remove(this.nextNode);
         }
         else if(!this.waiting)
         {
            this.waiting = true;
            tween(image,0.5).scaleTo(0.75,0.75).ease(Ease.bounceOut);
         }
      }
   }
}

