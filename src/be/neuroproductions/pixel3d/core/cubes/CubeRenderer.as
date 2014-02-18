package be.neuroproductions.pixel3d.core.cubes 
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsTrianglePath;
	import flash.display.IGraphicsData;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	/**
	 * @author kris@neuroproductions.be
	 */
	public class CubeRenderer 
	{
		private	var size : int 
		private var holder : Sprite = new Sprite()
		private var g : Graphics
		private	var startX : Number = 10
		private	var startY : Number = 10
		private	var startZ : Number = 10
		public var triangle_arr : Array = new Array()
		private var indicies : Vector.<int> = new Vector.<int>()
		private var bmdDraw : BitmapData = new BitmapData(40, 40, true, 0)
		private var bmdDrawPre : BitmapData = new BitmapData(100, 100, true, 0)
		public var bmdResult : BitmapData
		private var _color_arr : Vector.<uint>;
		private var color2_arr : Array = new Array()
		private var cmbRect : Rectangle
		private var alpha_arr : Vector.<Number> =new  Vector.<Number>();
		public function CubeRenderer(size : Number)
		{
			this.size = size
			
			startX = startY = startZ =- size / 2;
				
			g = holder.graphics
			startX 
			addFront(0, 0, 0);					
			addBack(0, 0, 0);			
			addTop(0, 0, 0);				
			addBottem(0, 0, 0);			
			addLeft(0, 0, 0);		
			addRight(0, 0, 0);

			indicies.push(0, 1, 2)
		}
		public function set color_arr(_color_arr : Vector.<uint>) : void
		{
			this._color_arr = _color_arr;
			
			for (var i : int = 0; i < _color_arr.length; i++) {
				
				var color :uint = _color_arr[i]
				var arr:Array = getColorArr(color )
				
				color2_arr.push(arr)
				var a:Number = color >>> 24;
				
				alpha_arr.push(a/255) 
			}
		}
		public function project(m : Matrix3D) : void
		{
			g.clear()
						
			var mp : Matrix3D = m.clone()
			mp.appendTranslation(50, 50, 0)
			
			var vec : Vector3D = new Vector3D(30, -50, 20)
		
			var vect : Vector3D = m.transformVector(vec)
			
			vect.normalize()
			var graphicsData : Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
		
			for (var i : int = 0;i < triangle_arr.length; i++)
			{
				var tri : Triangle3D = triangle_arr[i]
				tri.project(mp, vect)
				graphicsData.push(new GraphicsSolidFill(0xFF0000, 1));
				graphicsData.push(new GraphicsTrianglePath(tri.vertices, indicies, null, TriangleCulling.POSITIVE));
			}
			g.drawGraphicsData(graphicsData);
			bmdDrawPre.fillRect(new Rectangle(0, 0, 100, 100), 0)
			bmdDrawPre.draw(holder, null, null, null, null, true)
			cmbRect = bmdDrawPre.getColorBoundsRect(0xFFFFFFFF, 0xFFFF0000, true)
			cmbRect.x -= 1
			cmbRect.y -= 1
			cmbRect.width += 2
			cmbRect.height += 2
			bmdDraw = new BitmapData(cmbRect.width, cmbRect.height, true, 0)
		}

		public function getBitmapData(id : int) : BitmapData
		{
			g.clear()
			var graphicsData : Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
		
			for (var i : int = 0;i < triangle_arr.length; i++)
			{
				var tri : Triangle3D = triangle_arr[i]
				var color : uint = color2_arr[id][tri.color]
			
				
				graphicsData.push(new GraphicsSolidFill(color, alpha_arr[id]));
				graphicsData.push(new GraphicsTrianglePath(tri.vertices, indicies, null, TriangleCulling.POSITIVE));
			}
			g.drawGraphicsData(graphicsData);
			bmdDrawPre.fillRect(new Rectangle(0, 0, 100, 100), 0)
			bmdDrawPre.draw(holder, null, null, null, null, true)
			
			bmdDraw = new BitmapData(cmbRect.width, cmbRect.height, true, 0)	
			bmdDraw.copyPixels(bmdDrawPre, cmbRect, new Point(), null, null, true)
			
			return bmdDraw.clone()
		}

		//
		//
		//
		//
		//
		private function setTriangle(p0 : Point3D, p1 : Point3D, p2 : Point3D) : Triangle3D
		{
			var triangle : Triangle3D = new Triangle3D()
			triangle.setPoints(p0, p1, p2)
			triangle_arr.push(triangle)
			return triangle;
		}

		private function addLeft(i : int, j : int, k : int) : void
		{
			var p0 : Point3D = new Point3D(startX, startY, startZ)
			var p1 : Point3D = new Point3D(startX, startY - size, startZ)
			var p2 : Point3D = new Point3D(startX, startY, startZ - size)
			var p3 : Point3D = new Point3D(startX, startY - size, startZ - size)
			setTriangle(p0, p1, p2).uvts.push(0, 0, 0, 0.1, 0.1, 0.1)
			setTriangle(p1, p3, p2).uvts.push(0, 0, 0, 0.1, 0.1, 0.1)
		}

		private function addRight(i : int, j : int, k : int) : void
		{
			var p0 : Point3D = new Point3D(startX + size, startY, startZ)
			var p1 : Point3D = new Point3D(startX + size, startY - size, startZ)
			var p2 : Point3D = new Point3D(startX + size, startY, startZ - size)
			var p3 : Point3D = new Point3D(startX + size, startY - size, startZ - size)
			setTriangle(p1, p0, p2).uvts.push(0, 0, 0, 0.1, 0.1, 0.1)
			setTriangle(p3, p1, p2).uvts.push(0, 0, 0, 0.1, 0.1, 0.1)
		}

		private function addBack(i : int, j : int, k : int) : void
		{
			var p0 : Point3D = new Point3D(startX, startY - size, startZ)
			var p1 : Point3D = new Point3D(startX + size, startY - size, startZ)
			var p2 : Point3D = new Point3D(startX, startY, startZ)
			var p3 : Point3D = new Point3D(startX + size, startY, startZ)
			setTriangle(p1, p0, p2).uvts.push(0.05, 0.27, 0, 0.24, 0.24, 0, 0.24, 0.48, 0)
			setTriangle(p3, p1, p2).uvts.push(0.05, 0.27, 0, 0.24, 0.24, 0, 0.24, 0.48, 0)
		}

		private function addFront(i : int, j : int, k : int) : void
		{
			var p0 : Point3D = new Point3D(startX, startY - size, startZ - size)
			var p1 : Point3D = new Point3D(startX + size, startY - size, startZ - size)
			var p2 : Point3D = new Point3D(startX, startY, startZ - size)
			var p3 : Point3D = new Point3D(startX + size, startY, startZ - size)
			setTriangle(p0, p1, p2).uvts.push(0.05, 0.27, 0, 0.24, 0.24, 0, 0.24, 0.48, 0)
			setTriangle(p1, p3, p2).uvts.push(0.05, 0.27, 0, 0.24, 0.24, 0, 0.24, 0.48, 0)
		}

		private function addTop(i : int, j : int, k : int) : void
		{
		
			var p0 : Point3D = new Point3D(startX, startY - size, startZ)
			var p1 : Point3D = new Point3D(startX + size, startY - size, startZ)
			var p2 : Point3D = new Point3D(startX, startY - size, startZ - size)
			var p3 : Point3D = new Point3D(startX + size, startY - size, startZ - size)
			setTriangle(p0, p1, p2).uvts.push(0.26, 0.26, 0, 0.26, 0.49, 0, 0.49, 0.49, 0)
			setTriangle(p1, p3, p2).uvts.push(0.26, 0.26, 0, 0.26, 0.49, 0, 0.49, 0.49, 0)
		}

		private function addBottem(i : int, j : int, k : int) : void
		{
		
			var p0 : Point3D = new Point3D(startX, startY, startZ)
			var p1 : Point3D = new Point3D(startX + size, startY, startZ)
			var p2 : Point3D = new Point3D(startX, startY, startZ - size)
			var p3 : Point3D = new Point3D(startX + size, startY, startZ - size)
			setTriangle(p1, p0, p2).uvts.push(0.26, 0.26, 0, 0.26, 0.49, 0, 0.49, 0.49, 0)
			setTriangle(p3, p1, p2).uvts.push(0.26, 0.26, 0, 0.26, 0.49, 0, 0.49, 0.49, 0)
		}

		//
		//
		//
		private function getColorArr(color : uint, 
                             amb : int = 140, dif : int = 110, spc : int = 5, pow : Number = 8, emi : int = 0, doubleSided : Boolean = false) : Array
		{
			var i : int
			var r : int
			var c : int
			var  lightTable : BitmapData = new BitmapData(256, 1, false)
			var  rct : Rectangle = new Rectangle();
			var colorTable : BitmapData = new BitmapData(256, 1, false)
			// base color
			colorTable.fillRect(colorTable.rect, color);

			// ambient/diffusion/emittance
			var ea : Number = (256 - emi) * 0.00390625,
            eb : Number = emi * 0.5;
			r = dif - amb;
			rct.width = 1; 
			rct.height = 1; 
			rct.y = 0;
			for (i = 0;i < 256; ++i) 
			{
				rct.x = i;
				lightTable.fillRect(rct, i * 0x10101);
			}
			
			colorTable.draw(lightTable, null, new ColorTransform(ea, ea, ea,0.5, eb, eb, eb, 0), BlendMode.MULTIPLY);
        
		
			lightTable.dispose();
		
			var c_arr : Array = new Array()
			for (i = 0;i < 256; i++) 
			{
				c_arr.push(colorTable.getPixel32(i, 0))
			}
			
			
			return c_arr
		}
	}
}
