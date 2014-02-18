package be.neuroproductions.pixel3d.objects 
{
	import be.neuroproductions.pixel3d.render.Renderer;
	import flash.display.BitmapData;
	import be.neuroproductions.pixel3d.objects.PixelObject3D;
	import be.neuroproductions.pixel3d.core.Cube;
	/**
	 * @author kris@neuroproductions.be
	 */
	public class BitmapParser extends PixelObject3D 
	{
		private var bmd:BitmapData
		private var w:int
		private var h:int
		private var heightsteps:int
		
		
		public function BitmapParser(bmd:BitmapData,w:int,h:int)
		{
			super();
			this.bmd =bmd
			this.w = w
			this.h = h
			heightsteps= bmd.width/w
		    _frames= bmd.height/h
		  
		    for (var i : int = 0; i < _frames; i++) {
		    	parseFrame(i*h)
		    }
		    cubes_vec=frames_vec[0]
		}
		
	

		private function parseFrame(startY : int) : void
		{
			var cubes:Vector.<Cube> = new Vector.<Cube>()
			for (var i : int = 0; i < heightsteps; i++)
			{
				var startX:int = i*w
				for (var j : int = 0; j < w; j++) {
					for (var k : int = 0; k < h; k++) 
					{
						var color:uint=bmd.getPixel32( startX+j,startY+k)
						if (color !=0x00000000)
						{
							var colorIndex:int = Renderer.color_arr.indexOf(color)
							if (colorIndex ==-1)
							{
								
								Renderer.color_arr.push(color)
								colorIndex = Renderer.color_arr.length-1
								
							}
							var cube:Cube = new Cube(j-(h/2),i,k-w/2)
							cube.colorID = colorIndex 
							cubes.push( cube)
							
						}
						
					}
				}
			}
			cubes.fixed =true
			
			frames_vec.push(cubes)
		}
	}
}
