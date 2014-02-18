package  be.neuroproductions.pixel3d.core.cubes
{
	
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	/**
	 * @author kris@neuroproductions.be
	 */
	[SWF(width='400', height='300', backgroundColor='#000000', frameRate='30')]

	public class Triangle3D 
	{
		public var color : uint
		public var vertices : Vector.<Number> = new Vector.<Number>() ;
		private var vertices3D : Vector.<Number>;
		public var uvts : Vector.<Number>;
		public var normal : Vector.<Number> = new Vector.<Number>();
	//	public var screenZ : Number = 0
		private var vecZ : Vector3D
		private var vecMidle : Vector3D
		public var n:Vector3D //normaml
		
		public var v0:Vector3D
		public var v1:Vector3D
		public var v2:Vector3D
		public function Triangle3D()
		{
		
			uvts = new Vector.<Number>()
			
		}

		public function setPoints(p0 : Point3D, p1 : Point3D, p2 : Point3D) : void
		{
			
			v0 =new Vector3D(p0.x, p0.y, p0.z)
			v1 =new Vector3D(p1.x, p1.y, p1.z)
			v2 =new Vector3D(p2.x, p2.y, p2.z)
			
			
			vertices3D = new Vector.<Number>()
			
			
			
			
			vertices3D.push(p0.x, p0.y, p0.z)
			vertices3D.push(p1.x, p1.y, p1.z)
			vertices3D.push(p2.x, p2.y, p2.z)
			calculateNormal(vertices3D)
			vecMidle = new Vector3D((p0.x + p1.x + p2.x) / 3, (p0.y + p1.y + p2.y) / 3, (p0.z + p1.z + p2.z) / 3)
			vecZ = new Vector3D(p0.x + p1.x + p2.x, p0.y + p1.y + p2.y, p0.z + p1.z + p2.z)
		}

		public function project(m : Matrix3D,lightVecN : Vector3D) : void
		{
		
			var zd:Number = normal[0]*lightVecN.x +normal[1]*lightVecN.y+normal[2]*lightVecN.z
			zd = (1+zd)/2
			if(zd < 0){zd = 0;}
			
         
			var  zAngle:int = zd*255//*0xff;
		
			
            color = zAngle;
			
			
			/*
			var vec:Vector3D  = Utils3D.projectVector(m, vecZ)
			screenZ = vec.z*/
			Utils3D.projectVectors(m, vertices3D, vertices, uvts)
		}
		public function calculateNormal(tVector:Vector.<Number>):void
		{
			//normal = (p1-p2) x (p3-p2)
		 	
			var  dif1:Vector.<Number> =new Vector.<Number> ()
			var  dif2:Vector.<Number> =new Vector.<Number> ()
			
			dif1.push(tVector[0]-tVector[3] ,tVector[1]-tVector[4]  ,tVector[2]-tVector[5]  )
			dif2.push(tVector[6]-tVector[3] ,tVector[7]-tVector[4]  ,tVector[8]-tVector[5]  )
			//
		
			
			//A x B = <Ay*Bz - Az*By, Az*Bx - Ax*Bz, Ax*By - Ay*Bx>
			normal.push((dif1[1]*dif2[2])  -(dif1[2]*dif2[1]))
			normal.push((dif1[0]*dif2[2])  -(dif1[2]*dif2[0] ))
			normal.push((dif1[0]*dif2[1] ) -(dif1[1]*dif2[0]))
			var v:Vector3D  = new Vector3D(normal[0],normal[1],normal[2])
			n= new Vector3D(normal[0],normal[1],normal[2])
			var distance :Number =	Vector3D.distance(v,new Vector3D())
			normal[0] = (normal[0] /distance )
			normal[1] = (normal[1] /distance )*-1
			normal[2] = (normal[2] /distance) 
			
			
		
		}
		
	}
}
