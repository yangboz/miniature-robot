package be.neuroproductions.pixel3d.objects 
{
	import flash.events.EventDispatcher;
	import be.neuroproductions.pixel3d.core.Cube;

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	/**
	 * @author kris@neuroproductions.be
	 */
	public class PixelObject3D extends EventDispatcher
	{	
		public var cubes_vec : Vector.<Cube> = new Vector.<Cube>;
		public var matrix3D : Matrix3D = new Matrix3D();
		public var children : Vector.<PixelObject3D> = new Vector.<PixelObject3D>();
		public var parent : PixelObject3D;
		private var _rotationX : Number = 0;
		private var _rotationY : Number = 0;
		private var _rotationZ : Number = 0;
		private var _x : Number = 0;
		private var _y : Number = 0;
		private var _z : Number = 0	;	
		private var updated : Boolean;
		protected var _frames : int
		protected var frames_vec : Vector.<Vector.<Cube>> = new Vector.<Vector.<Cube>>()
		public var currentFrame : int =0
		public function PixelObject3D()
		{
		}

		public function addChild(pObject : PixelObject3D) : void
		{
			var index : int = children.indexOf(pObject);
			if (index == -1) children.push(pObject);// check if is child
			//if (pObject.parent != null) pObject.parent.removeChild(pObject); 
			pObject.parent = this;
			pObject.addCubes();
		}

		public function removeChild(pObject : PixelObject3D) : void
		{
			var index : int = children.indexOf(pObject);
			if (index > -1)
			{
				for (var i : int = 0;i < children.length; ++i)
				{
					var child : PixelObject3D = children[i]
					child.removeCubes()
				}				
				children.splice(index, 1);
			}
		}

		public function update(frame : int) : void
		{
			if (frame== currentFrame)return;
			currentFrame =frame
			removeCubes(cubes_vec)
			cubes_vec = frames_vec[frame]
			addCubes(cubes_vec)
			move()
		}

		public function addCubes(cubei_vec : Vector.<Cube> = null) : void
		{
			if (cubei_vec == null)
			{
				cubei_vec = cubes_vec;
				
				for (var i : int = 0;i < children.length; ++i)
				{
					var child : PixelObject3D = children[i]
					child.addCubes()
				}
			}
			
			parent.addCubes(cubei_vec);
		}

		public function removeCubes(cubei_vec : Vector.<Cube> = null) : void
		{
			if (cubei_vec == null)
			{
				cubei_vec = cubes_vec;
			}
			
			parent.removeCubes(cubei_vec);
		}

		public function move(m : Matrix3D = null) : void
		{
			
			if (m == null) 
			{
				m = matrix3D;	
				m.identity();
				m.appendRotation(_rotationX, Vector3D.X_AXIS)
				m.appendRotation(_rotationY, Vector3D.Y_AXIS)
				m.appendRotation(_rotationZ, Vector3D.Z_AXIS)
				m.appendTranslation(_x, _y, _z);
			}
			var cube : Cube;
			var c_vec : Vector.<Cube>
			for (var i : uint = 0;i < frames_vec.length; ++i) 
			{
				c_vec = frames_vec[i]
				for (var j : uint = 0;j < c_vec.length; ++j) 
				{
					cube = c_vec[j]
					cube.moveCube(m)
				}
			}
			
			
			var child : PixelObject3D
			for (i = 0;i < children.length; ++i)
			{
				child = children[i]
				child.move(m)
			}
			updated = false
		}

		public function project(m : Matrix3D) : void
		{
			if (updated)
			{
				move()
			}
			
			var cube : Cube
			for (var i : uint = 0;i < cubes_vec.length; ++i) 
			{
				cube = cubes_vec[i]
				
				cube.projectCube(m)
			}
			
			var child : PixelObject3D
			for (i = 0;i < children.length; ++i)
			{
				child = children[i]
				child.project(m)
			}
		}

		//
		//
		//
		//
		public function get rotationX() : Number
		{
			return _rotationX;
		}

		public function set rotationX(rotationX : Number) : void
		{
			updated = true
			_rotationX = rotationX;
		}

		public function get rotationY() : Number
		{
			return _rotationY;
		}

		public function set rotationY(rotationY : Number) : void
		{
			updated = true
			_rotationY = rotationY;
		}

		public function get rotationZ() : Number
		{
		
			return _rotationZ;
		}

		public function set rotationZ(rotationZ : Number) : void
		{
			updated = true
			_rotationZ = rotationZ;
		}

		public function get x() : Number
		{
			return _x;
		}

		public function set x(x : Number) : void
		{
			updated = true
			_x = x;
		}

		public function get y() : Number
		{
			return _y;
		}

		public function set y(y : Number) : void
		{
			updated = true
			_y = y;
		}

		public function get z() : Number
		{
			
			return _z;
		}

		public function set z(z : Number) : void
		{
			updated = true
			_z = z;
		}
	}
}
