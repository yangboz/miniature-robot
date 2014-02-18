package  
{
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.ui.MouseCursor;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	import be.neuroproductions.pixel3d.objects.BitmapParser;
	import be.neuroproductions.pixel3d.objects.PixelScene;
	import be.neuroproductions.pixel3d.render.Renderer;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	/**
	 * @author kris@neuroproductions.be
	 */
	public class Pixel3DTest extends Sprite 
	{

		[Embed(source="landscape.png")]
		//[Embed(source="speedtest.png")]	
		private var FloorImage : Class

		[Embed(source="man2.png")]
		private var ManImage : Class

		[Embed(source="flower.png")]
		private var FlowerImage : Class
		
		[Embed(source="ducks.png")]
		private var DucksImage : Class
		
		
		private var renderer : Renderer
		private var scene : PixelScene
		private var hero : BitmapParser
		private var ducks: BitmapParser
				
		private var m : Matrix3D 

		public function Pixel3DTest()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.align = StageAlign.TOP_LEFT
			
			init()
		}

		public function init() : void
		{
			
			
			
			
			scene = new PixelScene();
			renderer = new Renderer(800, 600, 10);
		
			var landscapeBM : Bitmap = new FloorImage() as Bitmap
			var floor:BitmapParser = new BitmapParser(landscapeBM.bitmapData, 60, 60)
			floor.y =5
			scene.addChild(floor)
	
			var manBM : Bitmap = new ManImage() as Bitmap
			hero = new BitmapParser(manBM.bitmapData, 17, 16)
			scene.addChild(hero)
			hero.rotationX = -90
			hero.rotationY = -90
			hero.y = -3.3
			hero.z = 0
			hero.x = -20
			
			
			var ducksBM : Bitmap = new DucksImage() as Bitmap
			ducks = new BitmapParser(ducksBM.bitmapData, 13, 4)
			scene.addChild(ducks)
			ducks.rotationX = -90
			ducks.rotationY = 90
			ducks.y =8
			ducks.x = 26
			
			
			
			for (var i : int = 0;i < 8; i++) 
			{
				
			
				var flowerBM : Bitmap = new FlowerImage() as Bitmap
				var flower : BitmapParser = new BitmapParser(flowerBM.bitmapData,3, 4)
			
			
				flower.rotationX = -90
				flower.rotationY = 0
				flower.x = Math.round(Math.random() * 40 - 28)
				flower.z = Math.round(Math.random() * 55 - 28)
				flower.y =3
				scene.addChild(flower)
			}
			
			
			this.addChild(renderer)
			renderer.init()
			m = renderer.matrix3D
			
			
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown)
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp)
			this.addEventListener(MouseEvent.MOUSE_DOWN, mDown)
			
			
			m.identity()
			m.prependRotation(-30, Vector3D.X_AXIS)
			var vecRot : Vector3D = Vector3D.Y_AXIS.clone()
			m.transformVector(vecRot)
			m.prependRotation(-30, vecRot)
			
			this.addEventListener(Event.ENTER_FRAME, render)
		}
		//
		//
		//     mouse stuff
		//
		//
		private var startX:Number
		private var startY:Number
		
		private var rotX:Number =0
		private var rotY:Number =0
		
		private var rotXStart:Number =-30
		private var rotYStart:Number =-30
		
		private function mDown(event : MouseEvent) : void
		{
			Mouse.cursor =MouseCursor.HAND
			startX =mouseX
			startY =mouseY
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mMove)
			stage.addEventListener(MouseEvent.MOUSE_UP, mUp)
		}
		
		private function mUp(event : MouseEvent) : void
		{
			Mouse.cursor =MouseCursor.AUTO
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mMove)
			stage.removeEventListener(MouseEvent.MOUSE_UP, mUp)
			rotXStart =rotX
			rotYStart =rotY
		}
		
		private function mMove(event : MouseEvent) : void
		{
			 rotX =rotXStart  +(startY-mouseY)/5
			 rotY=rotYStart+ (startX-mouseX)/-5
			m.identity()
			m.prependRotation(rotX, Vector3D.X_AXIS)
			var vecRot : Vector3D = Vector3D.Y_AXIS.clone()
			m.transformVector(vecRot)
			m.prependRotation(rotY, vecRot)
		}
		//
		//
		//
		//  hero Stuff
		//
		//
		private var keyU:Boolean =false
		private var keyD:Boolean =false
		private var keyL:Boolean =false
		private var keyR:Boolean =false
		
		private var run:Boolean = false
		
		private function keyDown(event : KeyboardEvent) : void
		{
			if (event.keyCode == Keyboard.UP)
			{
				keyU =true;
			}
			if (event.keyCode == Keyboard.DOWN)
			{
				keyD =true;
			}
			if (event.keyCode == Keyboard.LEFT)
			{
				keyL =true
			}
			if (event.keyCode == Keyboard.RIGHT)
			{
				keyR =true
			}
		}

		private function keyUp(event : KeyboardEvent) : void
		{	
			if (event.keyCode == Keyboard.UP)
			{
				keyU =false;
			}
			if (event.keyCode == Keyboard.DOWN)
			{
				keyD =false;
			}
			if (event.keyCode == Keyboard.LEFT)
			{
				keyL =false
			}
			if (event.keyCode == Keyboard.RIGHT)
			{
				keyR =false
			}
		}
		private function calcHeroPosition():void
		{
			run =true
			var xPos:Number =hero.x
			var zPos:Number =hero.z
			if (keyU)
			{
			
			hero.rotationY =0
			zPos-=0.7
			}else if(keyD) 
			{
			hero.rotationY =180
			zPos+=0.7
			}else if(keyL) 
			{
			hero.rotationY =90
			xPos-=0.7
			}else if(keyR) 
			{
			hero.rotationY =-90
			xPos+=0.7
			}

			else
			{
			run=false
			count =3
			return
			}
			//
			//  hittest..
			//
			if (xPos>13 || xPos<-27 || zPos>27 || zPos<-28)
			{
			run=false
			return
			}
			hero.x = xPos
			hero.z = zPos
		} 
		private var count:int =3
		private function updateHero() : void
		{
			
			if (run)
			{
				count++
				if (count==4){
				hero.update(2)
				}
				if (count == 8)
				{
					hero.update(1)
					count = 0
				}
			}
			else
			{
			hero.update(0)
			}
		}
		
		
		

		//
		//   render stuff
		//
		private var duckSpeed :Number =-0.2
		private function render(event : Event = null) : void
		{
			moveDucs()
			calcHeroPosition()
			updateHero()
			/*count++
			if (count==4){
			hero.update(2)
			}
			if (count == 8)
			{
				hero.update(1)
				count = 0
			}
			hero.x+=0.5
			*/
			/*
			m.identity()
			m.prependRotation((mouseY - 600) / 10, Vector3D.X_AXIS)
			var vecRot : Vector3D = Vector3D.Y_AXIS.clone()
			m.transformVector(vecRot)
			m.prependRotation((mouseX - 400) / 10, vecRot)
			*/
			scene.project(m)
			
			renderer.render(scene)
		}
		
		

		private function moveDucs() : void
		{
			ducks.z +=duckSpeed
			if (ducks.z >40 ||ducks.z < -40)
			{
			
			ducks.rotationY +=180
			duckSpeed*= -1
			}
		}
	}
}
