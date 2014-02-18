package  
{
	import be.neuroproductions.pixel3d.objects.ColladaParser;
	import be.neuroproductions.pixel3d.objects.PixelScene;
	import be.neuroproductions.pixel3d.render.Renderer;

	import mx.core.ByteArrayAsset;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	/**
	 * @author kris@neuroproductions.be
	 */
	public class RayTest extends Sprite 
	{

		[Embed(source="Elefant1.dae", mimeType="application/octet-stream")]
		public var Elefant : Class;
		private var renderer : Renderer
		private var scene : PixelScene
		private var m : Matrix3D 
		private var cp : ColladaParser

		public function RayTest()
		{
			
			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.align = StageAlign.TOP_LEFT
			
			init()
		}

		public function init() : void
		{
			
			
			Renderer.color_arr.push(0xFF393e4a)
			Renderer.color_arr.push(0xFFfdfbca)
			scene = new PixelScene();
			renderer = new Renderer(800, 600, 10);
			
			var ba : ByteArrayAsset = ByteArrayAsset(new Elefant());
			var xml : XML = new XML(ba.readUTFBytes(ba.length));
			
			cp = new ColladaParser()
			cp.addEventListener(Event.COMPLETE, addZ)
			cp.parse(xml, 100)
			
		
			this.addChild(renderer)
			
			m = renderer.matrix3D
			m.identity()
			m.prependRotation(-30, Vector3D.X_AXIS)
			var vecRot : Vector3D = Vector3D.Y_AXIS.clone()
			m.transformVector(vecRot)
			m.prependRotation(-30, vecRot)
			
			
			
			
			
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, mDown)	
			this.addEventListener(Event.ENTER_FRAME, render)
			//render()
		}

		private function addZ(event : Event) : void
		{
			scene.addChild(cp)
		}

		private function render(event : Event = null) : void
		{		
			scene.project(m)
			renderer.render(scene)
		}

		//
		//
		//     mouse stuff
		//
		//
		private var startX : Number
		private var startY : Number
		private var rotX : Number = -30
		private var rotY : Number = -30
		private var rotXStart : Number = -30
		private var rotYStart : Number = -30

		private function mDown(event : MouseEvent) : void
		{
			Mouse.cursor = MouseCursor.HAND
			startX = mouseX
			startY = mouseY
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mMove)
			stage.addEventListener(MouseEvent.MOUSE_UP, mUp)
		}

		private function mUp(event : MouseEvent) : void
		{
			Mouse.cursor = MouseCursor.AUTO
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mMove)
			stage.removeEventListener(MouseEvent.MOUSE_UP, mUp)
			rotXStart = rotX
			rotYStart = rotY
		}

		private function mMove(event : MouseEvent) : void
		{
			rotX = rotXStart + (startY - mouseY) / 5
			rotY = rotYStart + (startX - mouseX) / -5
			 
			
			 
			m.identity()
			m.prependRotation(rotX, Vector3D.X_AXIS)
			var vecRot : Vector3D = Vector3D.Y_AXIS.clone()
			m.transformVector(vecRot)
			m.prependRotation(rotY, vecRot)
		}
	}
}
