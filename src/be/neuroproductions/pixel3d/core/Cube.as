package be.neuroproductions.pixel3d.core 
{
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Utils3D;

	/**
	 * @author kris@neuroproductions.be
	 */
	public class Cube extends Vector3D
	{
		private var localPoint : Point = new Point();
		private var vin : Vector.<Number> = new Vector.<Number>();
		private var vinStart : Vector.<Number> = new Vector.<Number>();
		private var vout : Vector.<Number> = new Vector.<Number>();
		private var  projectedVerts : Vector.<Number> = new Vector.<Number>();
		private var  uvts : Vector.<Number> = new Vector.<Number>(3, true);
		private var nonM : Matrix3D = new Matrix3D;
		
		public var screenZ : int = 0;
		public var 	colorID : int = 0;
		public  var p : Point = new Point;
		public var visible:Boolean =true
		public function Cube(x : Number = 0.0, y : Number = 0.0, z : Number = 0.0)
		{
			super(x,y,z)
			vinStart.push(x, y, z);
			vinStart.fixed = true;
			vin.push(x, y, z);
			vin.fixed = true;
		}
		public function moveCube(m : Matrix3D) : void
		{
			
			m.transformVectors(vinStart, vin);
			/*if (vin[0]>20  )
			{
				if (vin[2]>30 || vin[2]< -30  ) {visible =false}
			else
			{
			visible =true
			}	
			}*/
		}
		public function projectCube(m : Matrix3D) : void
		{
			/*if (!visible)
			{
				p.x=10000
			return
			}*/
		
			m.transformVectors(vin, vout);
			screenZ = (vout[2]+1000)*20;
			Utils3D.projectVectors(nonM, vout, projectedVerts, uvts);
			p.x = projectedVerts[0];
			p.y = projectedVerts[1];
			
			
		}
	}
}
