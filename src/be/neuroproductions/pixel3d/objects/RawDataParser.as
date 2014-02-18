package be.neuroproductions.pixel3d.objects 
{

	import be.neuroproductions.pixel3d.core.Cube;
	/**
	 * @author kris@neuroproductions.be
	 */
	public class RawDataParser extends PixelObject3D 
	{
		public function RawDataParser(dataString:String)
		{
			var data:Array = dataString.split(",")
			var l:int =  data.length/4
			
			for (var i : int = 0; i < l; i++) {
				var index:int =i*4
				var cube:Cube = new Cube(data[index],data[index+1],data[index+2])
				cube.colorID = data[index+3]
				cubes_vec.push(cube)
			}
			cubes_vec.fixed =true
			frames_vec[0] = cubes_vec
		}
	}
}
