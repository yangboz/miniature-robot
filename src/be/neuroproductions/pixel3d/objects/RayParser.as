package be.neuroproductions.pixel3d.objects 
{
	import be.neuroproductions.pixel3d.core.Cube;
	import be.neuroproductions.pixel3d.objects.PixelObject3D;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	/**
	 * @author kris@neuroproductions.be
	 */
	public class RayParser extends PixelObject3D 
	{
		public var triVector : Vector.<Vector3D> = new Vector.<Vector3D>();
		public var cubesTemp_vec : Vector.<Cube> = new Vector.<Cube>();
		private var m : Matrix3D = new Matrix3D();
		private var mi : Matrix3D = new Matrix3D();
		private var s : Sprite = new Sprite();
		
		public function RayParser()
		{
			super();
		}

		public function rayTrace() : void
		{
			
		
			s.addEventListener(Event.ENTER_FRAME, goFrame)
			
			
			
			
		}

		private var deg : Number = 60
		private var xcount : int = 0
		private var ycount : int = 0
		private var zcount : int = 0
			private var max:int =2
		private function goFrame(event : Event) : void
		{
			var triL : int = triVector.length / 3
			
			var v0 : Vector3D
			var v1 : Vector3D
			var v2 : Vector3D
			
			m.identity()
			mi.identity()
			m.appendRotation(xcount * deg, Vector3D.X_AXIS)	
			m.appendRotation(ycount * deg, Vector3D.Y_AXIS)
			m.appendRotation(zcount * deg, Vector3D.Z_AXIS)
			mi = m.clone()
			mi.invert()
			cubesTemp_vec =   new Vector.<Cube>();
			
			for (var i : int = 0;i < triL; i++) 
			{
			
				v0 = triVector[i * 3]
				var cid:Number = v0.w
				v1 = triVector[i * 3 + 1]
				v2 = triVector[i * 3 + 2]
				v0 = m.transformVector(v0)
				v1 = m.transformVector(v1)
				v2 = m.transformVector(v2)
				
				rayTraceTri(v0, v1, v2, cid, mi)
			}
			var found:Boolean
			for (i = 0;i < 	cubesTemp_vec .length; i++) {
				found  =false
				for (var j : int = 0; j < cubes_vec.length; j++) 
				{
					
					if (cubes_vec[j].equals(cubesTemp_vec[i]))
					{
					found =true
					break
					}
					
				}
				if (!found) cubes_vec.push(cubesTemp_vec[i])
			}
			 xcount++
			 if (xcount>max)
			 {
			 ycount++
			 xcount=0
			
			 }
			  if (ycount>max)
			 {
			 zcount++
			 ycount=0
			 }
			 if (zcount>max)
			 {
			 s.removeEventListener(Event.ENTER_FRAME, goFrame)
			 	var printString:String =""
			 	for (i = 0; i < cubes_vec.length; i++) {
			 		var cube:Cube =cubes_vec[i]
			 		printString+= ","+cube.x+","+ cube.y+","+ cube.z+"," + cube.colorID
				}
			 trace (printString)
			 
			 this.dispatchEvent(new Event(Event.COMPLETE))
			}
			 trace (xcount,ycount,zcount,cubes_vec.length)
		}	

		public function rayTraceTri(v0 : Vector3D,v1 : Vector3D,v2 : Vector3D,colorId : int = 0,m : Matrix3D = null) : void
		{
			
			var minX : Number = Math.min(v0.x, v1.x)
			minX = Math.floor(Math.min(minX, v2.x))
			
			var minY : Number = Math.min(v0.y, v1.y)
			minY = Math.floor(Math.min(minY, v2.y))
			
			
			var minZ : Number = Math.min(v0.z, v1.z)
			minZ = Math.floor(Math.min(minZ, v2.z))
			
			
			var maxX : Number = Math.max(v0.x, v1.x)
			maxX = Math.ceil(Math.max(maxX, v2.x))
			
			var maxY : Number = Math.max(v0.y, v1.y)
			maxY = Math.ceil(Math.max(maxY, v2.y))
			
			
			var maxZ : Number = Math.max(v0.z, v1.z)
			maxZ = Math.ceil(Math.max(maxZ, v2.z))
			
			var inter : Vector3D = new Vector3D(maxX, maxY, maxZ)
			//inter = m.transformVector(inter)
			var cube : Cube = new Cube(Math.round(inter.x), Math.round(inter.y), Math.round(inter.z))
			/*	cube.colorID = 1
			cubes_vec.push(cube)
					
			inter = new Vector3D(minX, minY, minZ)
			//	inter = m.transformVector(inter)
			cube = new Cube(Math.round(inter.x), Math.round(inter.y), Math.round(inter.z))
			cube.colorID = 1
			cubes_vec.push(cube)*/
			var tu : Vector3D = v1.subtract(v0)
			var tv : Vector3D = v2.subtract(v0)
			
			var n : Vector3D = tu.crossProduct(tv)
			var nMin : Vector3D = new Vector3D(-n.x, -n.y, -n.z)
			var found : Boolean = false
			for (var i : int = minX;i < maxX + 1; i+=100) 
			{
				for (var j : int = minY;j < maxY + 1;j+=100) 
				{
					
					
					
					
					
					
					var RPoint1 : Vector3D = new Vector3D(i, j, minZ/10 - 1)
					var RPoint2 : Vector3D = new Vector3D(i, j, maxZ/10 + 1)
					
					
					var dir : Vector3D = RPoint1.subtract(RPoint2)
					var  origin : Vector3D = RPoint2.subtract(v0);
					
					
					
					
					var a : Number = nMin.dotProduct(origin)
			if (a ==0) continue;
					var b : Number = n.dotProduct(dir)
		  
		   
		   
					var r : Number = a / b
		 
		
					inter = new Vector3D(RPoint1.x + (dir.x * r), RPoint1.y + (dir.y * r), RPoint1.z + (dir.z * r))
		   			
		   			
					var uu : Number = tu.dotProduct(tu);
					var uv : Number = tu.dotProduct(tv);
					var vv : Number = tv.dotProduct(tv);
			
					var w : Vector3D = inter.subtract(v0);
					var wu : Number = w.dotProduct(tu);
					var wv : Number = w.dotProduct(tv);
					var d : Number = uv * uv - uu * vv;

					var v : Number = (uv * wv - vv * wu) / d;
					if (v < 0 || v > 1)continue;
			
					var t : Number = (uv * wu - uu * wv) / d;
					if (t < 0 || (v + t) > 1.0)continue;
					
					inter = m.transformVector(inter)
					cube = new Cube(Math.round(inter.x/100), Math.round(inter.y/100), Math.round(inter.z/100))
				
					cube.colorID =colorId
					cubesTemp_vec.push(cube)
				}
			}
		}
	}
}
