package   be.neuroproductions.pixel3d.core.cubes
{

	/**
	 * @author kris@neuroproductions.be
	 */
	public class Point3D 
	{
		public var x:int 
		public var y:int 
		public var z:int 
		public var index : int = 0
		
		public function Point3D(x:int,y:int,z:int)
		{
			this.x = x
			this.y = y
			this.z = z
		}

		public function isEqual(p:Point3D ):Boolean
		{
			if (this.x!= p.x) return false;
			if (this.y!= p.y) return false;
			if (this.z!= p.z) return false;
			return true;
		}
	}
}
