package be.neuroproductions.pixel3d.render 
{
	import flash.text.TextField;
	import be.neuroproductions.pixel3d.core.cubes.CubeRenderer;
	import flash.geom.Matrix3D;

	import be.neuroproductions.pixel3d.core.Cube;
	import be.neuroproductions.pixel3d.objects.PixelScene;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author kris@neuroproductions.be
	 */
	public class Renderer extends Sprite 
	{
		public static var color_arr : Vector.<uint> = new Vector.<uint>()
		private var bmd : BitmapData
		private var bitmapData_arr : Vector.<BitmapData> = new Vector.<BitmapData>()
		//private var cube_arr : Vector.<Cube>
		private var cube_arr : Array
		private var clearRect : Rectangle
		private var cubeSize : Number
		private var cubeSizeSmall:Number
		private var drawCube:CubeRenderer
		public var matrix3D : Matrix3D =new Matrix3D();
		
		
		private var bmTest:Bitmap
		private var w2:int
		private var h2:int
		public function Renderer(_width : int = 800, _height : int = 600,_cubeSize : Number = 10)
		{
			/*var _q_length:int = q.length;
			for(var i:int = 0; i < _q_length; q[int(i++)] = -1);
			*/
			bmd = new BitmapData(_width, _height, false, 0)
			var bm : Bitmap = new Bitmap(bmd)
			this.addChild(bm)
			clearRect = new Rectangle(0, 0, _width, _height)
			this.cubeSize = _cubeSize
			cubeSizeSmall = _cubeSize-1
			drawCube = new CubeRenderer(_cubeSize)
			
			 w2 = _width*0.5
			 h2 = _height*0.5
		}
		public function init():void
		{
				drawCube.color_arr = color_arr
		}

		public function render(scene : PixelScene) : void
		{
			
			
			
			cube_arr = scene.cube_arr
		
			cube_arr.sortOn("screenZ", Array.NUMERIC);
			//radixSort(cube_arr)

		   	drawCube.project(matrix3D)
			for (var i : uint = 0; i < color_arr.length; i++) {
				bitmapData_arr[i] = drawCube.getBitmapData(i)
			}
		
			var l : uint = cube_arr.length;
			var cube : Cube;
			var p : Point
			var bmw : int = bitmapData_arr[0].width
			var bmh:int = bitmapData_arr[0].height
		
			
			var rec:Rectangle =new Rectangle(0,0,bmw , bmh)			
			
			bmd.lock();
			bmd.fillRect(clearRect, 0xFF000000);
			var xPos:Number
			var yPos:Number
			
			for ( i  = 0;i < l;++i)
			{
				cube = cube_arr[i];
			
				p = cube.p;
				
				if (p.x ==10000) continue;
				
				xPos = p.x * cubeSizeSmall+w2;
				yPos  = p.y * cubeSizeSmall+h2 ;
		
				//if (!clearRect.contains(xPos, yPos))continue;
				p.x = xPos
				p.y = yPos
				
				bmd.copyPixels(bitmapData_arr[cube.colorID], rec, p, null, null, true);
			}
		   
			bmd.unlock()
			
			
		}
		
		
		
		/*private var empty:int = -1;
		private var q:Vector.<int> = new Vector.<int>(256, true);
		private var ql:Vector.<int> = new Vector.<int>(256, true)
		public function radixSort(data:Vector.<Cube>):void
		{
	       
	        var i:int, j:int, k:int, l:int, m:int, _q_length:int, _data_length:int = data.length, np0:Vector.<Cube> = new Vector.<Cube>(_data_length, true), np1:Vector.<int> = new Vector.<int>(_data_length, true);
	        
	        for(k = 0; k < 16; k += 8) {
	        	
	        	l = 255 << k;
	        	
	            for(i = 0; i < _data_length; np0[i] = data[i], np1[int(i++)] = empty)
	                if(q[j = (l & data[i].screenZ) >> k] == empty)
	                    ql[j] = q[j] = i;
	                else
	                    ql[j] = np1[ql[j]] = i;
	            
	            _q_length = q.length;
	            for(m = q[i = j = 0]; i < _q_length; q[int(i++)] = empty)
	                for(m = q[i]; m != empty; m = np1[m])
	                    data[int(j++)] = np0[m];
	        }
	    }
	    */
	   
	}
}
