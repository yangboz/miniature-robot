package be.neuroproductions.pixel3d.objects 
{

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	/**
	 * @author kris@neuroproductions.be
	 */
	public class ColladaParser extends RayParser
	{
		public static var LOCATION:String =""//"http://www.neuroproductions.be/uploads/blog/examples/collada/"
		public var indicesFull : Vector.<int> = new Vector.<int>();
	
		public var uvtsFull : Vector.<Number> = new Vector.<Number>();
		public var verticesFull : Vector.<Number> = new Vector.<Number>();
		public  var triangles : Array = new Array();
		
		private var indicesPos : int = 0
		private var scale : Number
		
		private var m:Matrix3D =new Matrix3D()
		private var mi:Matrix3D =new Matrix3D()
		private var cc:int=0
		public function parse(xml : XML,scale : Number) : void
		{
			
			
			default xml namespace = "http://www.collada.org/2005/11/COLLADASchema";
			this.scale = scale
		
			
			for each (var geomXML:XML in xml.library_geometries.geometry)
			{
				if (cc==2  || cc==4|| cc==5){
				parseGeomXMLFull(geomXML)
				parseGeomXMLTriangles(geomXML)
				}
				cc++
			}
			
	rayTrace()
			
		}

		private function parseGeomXMLTriangles(geomXML : XML) : void
		{
			var id : String = geomXML.@id
			
			var colorId:int =0
			
			var uvts : Vector.<Number> = new Vector.<Number>();
			var vertices : Vector.<Number> = new Vector.<Number>();
			
			
			for each (var xmls:XML in geomXML.mesh.source)
			{
				if  (xmls.@id == id + "-position")
				{
					var verticesString : String = xmls.float_array.toString()
				}
				if  (xmls.@id == id + "-uv")
				{
					var uvString : String = xmls.float_array.toString()
				}
			}
			var uv_arr : Array = uvString.split(" ")
			var vertices_arr : Array = verticesString.split(" ")
			
			for (var i : uint = 0;i < vertices_arr.length; i++) 
			{
				var n : Number = vertices_arr[i]
				vertices.push(n * scale)
			}
			/*for (i = 0;i < uv_arr.length; i++) 
			{
				n = Number(uv_arr[i])
				
				uvts.push(n)
			}*/
			
			
			
			for each (var trian : XML in geomXML.mesh.triangles) 
			{
				
				var indices : Vector.<int> = new Vector.<int>();
				var indicesUV : Vector.<int> = new Vector.<int>();
				
				var indicesString : String = trian.p.toString()		
				var mats : String = trian.@material
				
				var indices_arr : Array = indicesString.split(" ")
				for (i = 0;i < indices_arr.length; i += 3) 
				{
					var ni : int = int(indices_arr[i])
					indices.push(ni)
				
					var nitri : int = int(indices_arr[i + 2]) 
					indicesUV.push(nitri)
				}
				var v0:Vector3D 
				var v1:Vector3D 
				var v2:Vector3D
				
					if (cc==2){
					colorId =0
					}
					else
					{
						colorId =1
					}
				
				for (i = 0;i < indices.length; i += 3) 
				{
				
				v0 = new Vector3D()
				v1= new Vector3D()
				 v2 = new Vector3D()
				
			
					
				
				 
					v0.x = vertices[ indices[i] * 3]
					v0.y  = vertices[ indices[i] * 3 + 1]
					v0.z = vertices[indices[i] * 3 + 2]
					v0.w = colorId
					
					v1.x = vertices[ indices[i + 1] * 3 ]
					v1.y  = vertices[ indices[i + 1] * 3 + 1]
					v1.z  = vertices[ indices[i + 1] * 3 + 2]
					v1.w = colorId
					
					v2.x  = vertices[ indices[i + 2] * 3]
					v2.y  = vertices[ indices[i + 2] * 3 + 1]
					v2.z  = vertices[ indices[i + 2] * 3 + 2]
					v2.w = colorId
				
					triVector.push(v0,v1,v2)
					
				}
			}
			
		}

		private var count : int = 0

		private function parseGeomXMLFull(geomXML : XML) : void
		{
			
				
			
			var id : String = geomXML.@id
			var mats : String
			var indicesString : String
			var s : String = ""
			for each (var trian : XML in geomXML.mesh.triangles) 
			{
				
				indicesString += s + trian.p.toString()	
				s = " "		
			}
			
			
			if (indicesString == "" || indicesString == null)return;
			
			
			
			for each (var xmls:XML in geomXML.mesh.source)
			{
				if  (xmls.@id == id + "-position")
				{
					var verticesString : String = xmls.float_array.toString()
				}
				if  (xmls.@id == id + "-uv")
				{
					var uvString : String = xmls.float_array.toString()
				}
			}
			var uv_arr : Array = uvString.split(" ")
		
			var vertices_arr : Array = verticesString.split(" ")
			
			for (var i : Number = 0;i < vertices_arr.length; i++) 
			{
				var n : Number = vertices_arr[i]
				verticesFull.push(n * scale)
				uvtsFull.push(0)
			}
			
			var indices_arr : Array = indicesString.split(" ")
			
			for (i = 0;i < indices_arr.length; i += 3) 
			{
				var ni : int = int(indices_arr[i]) + indicesPos
				indicesFull.push(ni)
			}
			
			indicesPos += (vertices_arr.length) / 3
		}
	}
}
		

