package be.neuroproductions.pixel3d.objects 
{

	import be.neuroproductions.pixel3d.core.Cube;
	/**
	 * @author kris@neuroproductions.be
	 */
	public class PixelScene extends PixelObject3D
	{
		//public var cube_arr:Vector.<Cube> =new Vector.<Cube>()
		public var cube_arr:Array =new Array()
		public function PixelScene():void
		{
		
		
		}
		override public function addCubes(cube_vec:Vector.<Cube> =null):void
		{
			//cube_arr.fixed =false
			var l:int =cube_vec.length
			for (var i : int = 0; i <l; i++) 
			{
			 cube_arr.push(cube_vec[i] )
			}
		//cube_arr.fixed =true
		}
		override public function removeCubes(cubei_vec : Vector.<Cube> = null) : void
		{
		//	cube_arr.fixed =false
			if (cubei_vec == null) return;
			var l:int =cubei_vec.length
			for (var i : int = 0; i <l; i++) 
			{
				var cube:Cube = cubei_vec [i]
				var index:int = cube_arr.indexOf( cube)
				if (index>-1)
				{
				 cube_arr.splice(index,1)
				}
			}
			//cube_arr.fixed =true
		}
	}
}
