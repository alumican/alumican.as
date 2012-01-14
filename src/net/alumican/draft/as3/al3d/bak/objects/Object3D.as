package net.alumican.draft.as3.al3d.objects
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	
	/**
	 * Object3D
	 * 
	 * @author alumican
	 */
	public class Object3D extends Sprite
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * ビューポート
		 */
		public var viewport:Sprite;
		
		/**
		 * テクスチャ
		 */
		public var texture:BitmapData;
		
		/**
		 * 3D変形マトリックス
		 */
		public var transform3D:Matrix3D;
		
		/**
		 * 頂点情報
		 */
		public var vertices3D:Vector.<Number>;
		public var vertices2D:Vector.<Number>;
		public var uvts:Vector.<Number>;
		public var indices:Vector.<int>;
		
		public var transformedVertices3D:Vector.<Number>;
		public var vertices2DCount:uint;
		
		public var triangleVertices:Vector.<Number>;
		public var triangleIndices:Vector.<int>;
		public var triangleUvts:Vector.<Number>;
		
		public var uvts2:Vector.<Number>;
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function Object3D(texture:BitmapData = null):void 
		{
			viewport = addChild( new Sprite() ) as Sprite;
			
			this.texture = texture;
			
			transform3D = new Matrix3D();
			transform3D.identity();
			
			vertices3D = new Vector.<Number>();
			vertices2D = new Vector.<Number>();
			uvts       = new Vector.<Number>();
			indices    = new Vector.<int>();
			
			triangleUvts = new Vector.<Number>();
			uvts2 = new Vector.<Number>();
			
			_create();
			
			transformedVertices3D = new Vector.<Number>(vertices3D.length, true);
			vertices2DCount = transformedVertices3D.length * 2 / 3;
			vertices2D = new Vector.<Number>(vertices2DCount, true);
		}
		
		/**
		 * オブジェクトの頂点情報を生成する(オーバーライド用)
		 */
		protected function _create():void
		{
			throw new ArgumentError("Object3D#_create : オーバーライドしてちょ");
		}
		
		/**
		 * オブジェクトをレンダリングする
		 */
		public function render():void
		{
			if (!texture) return;
			
			/*
			//projectVectors
			Utils3D.projectVectors(transform3D, vertices3D, vertices2D, uvts);
			
			var g:Graphics = viewport.graphics;
			g.clear();
			g.beginBitmapFill(texture, null, false, false);
			g.drawTriangles(vertices2D, indices, triangleUvts, TriangleCulling.NEGATIVE);
			
			trace(indices.length);
			*/
			
			/*
			//transformVectors
			transform3D.transformVectors(vertices3D, transformedVertices3D);
			var n:uint = vertices2DCount;
			var j:uint = 0;
			for (var i:uint = 0; i < n; i += 2)
			{
				vertices2D[i    ] = transformedVertices3D[j    ];
				vertices2D[i + 1] = transformedVertices3D[j + 1];
				
				j += 3;
			}
			
			var g:Graphics = viewport.graphics;
			g.clear();
			g.beginBitmapFill(texture, null, false, false);
			g.drawTriangles(vertices2D, indices, triangleUvts, TriangleCulling.NEGATIVE);
			*/
			
			/*
			//drawTrianglesの全パラメータを作り直す
			triangleVertices = new Vector.<Number>();
			triangleUvts     = new Vector.<Number>();
			triangleIndices  = new Vector.<int>();
			
			transform3D.transformVectors(vertices3D, transformedVertices3D);
			
			var n:uint = indices.length,
				index:uint = 0,
				z0:Number, z1:Number, z2:Number,
				index0:uint, index1:uint, index2:uint;
			
			for (var i:uint = 0; i < n; i += 3)
			{
				index0 = indices[i    ];
				index1 = indices[i + 1];
				index2 = indices[i + 2];
				
				z0 = transformedVertices3D[index0 * 3 + 2];
				z1 = transformedVertices3D[index1 * 3 + 2];
				z2 = transformedVertices3D[index2 * 3 + 2];
				
				if (z0 > 0 && z1 > 0 && z2 > 0) continue;
				
				triangleVertices.push(
					transformedVertices3D[index0 * 3], transformedVertices3D[index0 * 3 + 1],
					transformedVertices3D[index1 * 3], transformedVertices3D[index1 * 3 + 1],
					transformedVertices3D[index2 * 3], transformedVertices3D[index2 * 3 + 1]
				);
				
				triangleUvts.push(
					uvts2[index0 * 2], uvts2[index0 * 2 + 1],
					uvts2[index1 * 2], uvts2[index1 * 2 + 1],
					uvts2[index2 * 2], uvts2[index2 * 2 + 1]
				);
				
				triangleIndices.push(
					index++,
					index++,
					index++
				);
			}
			
			var g:Graphics = viewport.graphics;
			g.clear();
			g.beginBitmapFill(texture, null, false, false);
			g.drawTriangles(triangleVertices, triangleIndices, triangleUvts, TriangleCulling.NEGATIVE);
			
			trace(triangleIndices.length);
			*/
			
//			/*
			//indicesだけ変えてみる
			transform3D.transformVectors(vertices3D, transformedVertices3D);
			
			triangleIndices = new Vector.<int>();
			
			var n:uint = indices.length,
				index:uint = 0,
				z0:Number, z1:Number, z2:Number,
				index0:uint, index1:uint, index2:uint;
			
			for (var i:uint = 0; i < n; i += 3)
			{
				index0 = indices[i    ];
				index1 = indices[i + 1];
				index2 = indices[i + 2];
				
				z0 = transformedVertices3D[index0 * 3 + 2];
				z1 = transformedVertices3D[index1 * 3 + 2];
				z2 = transformedVertices3D[index2 * 3 + 2];
				
				if (z0 > 0 && z1 > 0 && z2 > 0) continue;
				
				vertices2D[index0 * 2    ] = transformedVertices3D[index0 * 3    ];
				vertices2D[index0 * 2 + 1] = transformedVertices3D[index0 * 3 + 1];
				
				vertices2D[index1 * 2    ] = transformedVertices3D[index1 * 3    ];
				vertices2D[index1 * 2 + 1] = transformedVertices3D[index1 * 3 + 1];
				
				vertices2D[index2 * 2    ] = transformedVertices3D[index2 * 3    ];
				vertices2D[index2 * 2 + 1] = transformedVertices3D[index2 * 3 + 1];
				
				triangleIndices.push(
					index0,
					index1,
					index2
				);
			}
			
			var g:Graphics = viewport.graphics;
			g.clear();
			g.beginBitmapFill(texture, null, false, false);
			g.drawTriangles(vertices2D, triangleIndices, uvts2, TriangleCulling.NEGATIVE);
			g.endFill();
			
			//trace(triangleIndices);
//			*/
		}
		
		/**
		 * 軸周りの回転を付与する
		 * @param	rotateX
		 * @param	rotateY
		 * @param	rotateZ
		 */
		public function rotate(rotateX:Number, rotateY:Number, rotateZ:Number):void
		{
			if (rotateX != 0) transform3D.appendRotation(-rotateX, Vector3D.X_AXIS);
			if (rotateY != 0) transform3D.appendRotation(-rotateY, Vector3D.Y_AXIS);
			if (rotateZ != 0) transform3D.appendRotation(-rotateZ, Vector3D.Z_AXIS);
		}
		
		/*
		private function _copyVectorInt(src:Vector.<int>):Vector.<int>
		{
			var n:uint = src.length;
			var dst:Vector.<int> = new Vector.<int>(n, true);
			for (var i:uint = 0; i < n; ++i) 
			{
				dst[i] = src[i];
			}
			return dst;
		}
		*/
	}
}