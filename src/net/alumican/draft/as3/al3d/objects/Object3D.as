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
		
		static public const PI:Number        = Math.PI;
		static public const PI2:Number       = PI * 2;
		static public const TO_RADIAN:Number = PI / 180;
		static public const TO_DEGREE:Number = 180 / PI;
		
		
		
		
		
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
		public var uvts:Vector.<Number>;
		public var indices:Vector.<int>;
		
		/**
		 * TransformVectors
		 */
		private var _vertices2D:Vector.<Number>;
		private var _transformedVertices3D:Vector.<Number>;
		
		/**
		 * Quaternion
		 */
		private var _qx:Number;
		private var _qy:Number;
		private var _qz:Number;
		private var _qw:Number;
		
		
		
		
		
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
			
			_qx = _qy = _qz = 0;
			_qw = 1;
			
			vertices3D = new Vector.<Number>();
			uvts       = new Vector.<Number>();
			indices    = new Vector.<int>();
			
			_create();
			
			_vertices2D = new Vector.<Number>(uvts.length, true);
			_transformedVertices3D = new Vector.<Number>(vertices3D.length, true);
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
			
			var n:uint     = uvts.length,
			    j:uint     = 0,
			    g:Graphics = viewport.graphics;
			
			transform3D.transformVectors(vertices3D, _transformedVertices3D);
			
			for (var i:uint = 0; i < n; i += 2)
			{
				_vertices2D[i    ] = _transformedVertices3D[j    ];
				_vertices2D[i + 1] = _transformedVertices3D[j + 1];
				j += 3;
			}
			
			g.clear();
			g.beginBitmapFill(texture, null, false, false);
			g.drawTriangles(_vertices2D, indices, uvts, TriangleCulling.NEGATIVE);
		}
		
		/**
		 * 軸周りの回転を付与する
		 * @param	rotateX
		 * @param	rotateY
		 * @param	rotateZ
		 */
		public function rotateByEuler(rotateX:Number, rotateY:Number, rotateZ:Number, useDegree:Boolean = true):void
		{
			if (!useDegree)
			{
				rotateX *= TO_DEGREE;
				rotateY *= TO_DEGREE;
				rotateZ *= TO_DEGREE;
			}
			
			if (rotateX != 0) transform3D.appendRotation(-rotateX, Vector3D.X_AXIS);
			if (rotateY != 0) transform3D.appendRotation(-rotateY, Vector3D.Y_AXIS);
			if (rotateZ != 0) transform3D.appendRotation(-rotateZ, Vector3D.Z_AXIS);
		}
		
		/**
		 * クォータニオンを用いた回転を付与する
		 * @param	rotateX
		 * @param	rotateY
		 * @param	rotateZ
		 * @param	useDegree
		 */
		public function rotateByQuaternion(rotateX:Number, rotateY:Number, rotateZ:Number, useDegree:Boolean = true):void
		{
			if (useDegree)
			{
				rotateX *= TO_RADIAN;
				rotateY *= TO_RADIAN;
				rotateZ *= TO_RADIAN;
			}
			
			//----------------------------------------
			//回転クォータニオンの生成
			var fSinPitch:Number       = Math.sin(rotateY * 0.5),
			    fCosPitch:Number       = Math.cos(rotateY * 0.5),
			    fSinYaw:Number         = Math.sin(rotateZ * 0.5),
			    fCosYaw:Number         = Math.cos(rotateZ * 0.5),
			    fSinRoll:Number        = Math.sin(rotateX * 0.5),
			    fCosRoll:Number        = Math.cos(rotateX * 0.5),
			    fCosPitchCosYaw:Number = fCosPitch * fCosYaw,
			    fSinPitchSinYaw:Number = fSinPitch * fSinYaw,
			    
			    rx:Number = fSinRoll * fCosPitchCosYaw     - fCosRoll * fSinPitchSinYaw,
			    ry:Number = fCosRoll * fSinPitch * fCosYaw + fSinRoll * fCosPitch * fSinYaw,
			    rz:Number = fCosRoll * fCosPitch * fSinYaw - fSinRoll * fSinPitch * fCosYaw,
			    rw:Number = fCosRoll * fCosPitchCosYaw     + fSinRoll * fSinPitchSinYaw,
			    
				//----------------------------------------
				//元のクォータニオンに回転を合成
				qx:Number = _qw * rx + _qx * rw + _qy * rz - _qz * ry,
				qy:Number = _qw * ry - _qx * rz + _qy * rw + _qz * rx,
				qz:Number = _qw * rz + _qx * ry - _qy * rx + _qz * rw,
				qw:Number = _qw * rw - _qx * rx - _qy * ry - _qz * rz,
			    
				//----------------------------------------
				//正規化
			    norm:Number = Math.sqrt(qx * qx + qy * qy + qz * qz + qw * qw),
			    inv:Number,
			    
				//----------------------------------------
				//行列へ変換
			    xx:Number,
			    xy:Number,
			    xz:Number,
			    xw:Number,
			    
			    yy:Number,
			    yz:Number,
			    yw:Number,
			    
			    zz:Number,
			    zw:Number,
			    
			    m:Vector.<Number> = transform3D.rawData;
			
			//----------------------------------------
			//正規化
			
			if(((norm < 0) ? -norm : norm) < 0.000001)
			{
				qx = qy = qz = 0.0;
				qw = 1.0;
			}
			else
			{
				inv = 1 / norm;
				qx *= inv;
				qy *= inv;
				qz *= inv;
				qw *= inv;
			}
			
			//----------------------------------------
			//行列へ変換
			xx = qx * qx;
			xy = qx * qy;
			xz = qx * qz;
			xw = qx * qw;
			
			yy = qy * qy;
			yz = qy * qz;
			yw = qy * qw;
			
			zz = qz * qz;
			zw = qz * qw;
			
			m[0]  = 1 - 2 * (yy + zz);
			m[1]  =     2 * (xy - zw);
			m[2]  =     2 * (xz + yw);
			
			m[4]  =     2 * (xy + zw);
			m[5]  = 1 - 2 * (xx + zz);
			m[6]  =     2 * (yz - xw);
			
			m[8]  =     2 * (xz - yw);
			m[9]  =     2 * (yz + xw);
			m[10] = 1 - 2 * (xx + yy);
			
			transform3D.rawData = m;
			
			//----------------------------------------
			//クォータニオンの保存
			_qx = qx;
			_qy = qy;
			_qz = qz;
			_qw = qw;
		}
	}
}