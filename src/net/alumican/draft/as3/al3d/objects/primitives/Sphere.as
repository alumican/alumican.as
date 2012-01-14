package net.alumican.draft.as3.al3d.objects.primitives
{
	import flash.display.BitmapData;
	import net.alumican.draft.as3.al3d.geom.Vertex3D;
	import net.alumican.draft.as3.al3d.objects.Object3D;
	
	/**
	 * Sphere
	 * 
	 * @author alumican
	 */
	public class Sphere extends Object3D
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 半径
		 */
		public function get radius():Number { return _radius; }
		private var _radius:Number;
		
		/**
		 * 水平方向の分割数
		 */
		public function get segmentW():uint { return _segmentW; }
		private var _segmentW:uint;
		
		/**
		 * 垂直方向の分割数
		 */
		public function get segmentH():uint { return _segmentH; }
		private var _segmentH:uint;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function Sphere(texture:BitmapData = null, radius:Number = 100, segmentW:uint = 8, segmentH:uint = 6):void
		{
			_radius   = radius;
			_segmentW = segmentW;
			_segmentH = segmentH;
			
			super(texture);
		}
		
		/**
		 * 頂点情報を生成する
		 * TODO : 極と経度0で重複する頂点をマージする
		 */
		override protected function _create():void 
		{
			var i:uint,
				j:uint,
				n:uint,
				p:Vertex3D,
				index:uint,
				x:Number,
				y:Number,
				u:Number,
				v:Number,
				angleU:Number,
				angleV:Number,
				points:Vector.<Vertex3D> = new Vector.<Vertex3D>(),
				poly:Vector.<Vertex3D> = new Vector.<Vertex3D>(4),
				poleN:Vertex3D,
				poleS:Vertex3D;
			
			//頂点の生成
			for (i = 0; i < _segmentH; ++i)
			{
				for (j = 0; j < _segmentW; ++j)
				{
					p = new Vertex3D();
					
				//	if (i == 0            ) { if (j == 0) poleN = p; else p = poleN; }			// 北極
				//	if (i == _segmentH - 1) { if (j == 0) poleS = p; else p = poleS; }			// 南極
				//	if (j == _segmentW - 1) { p = _points[_points.length - _segmentW + 1]; }	// 経度0
					
					u = j / (_segmentW - 1);
					v = i / (_segmentH - 1);
					
					angleU = u * PI2;
					angleV = v * PI;
					
					y = -_radius * Math.cos(angleV);
					x =  _radius * Math.sin(angleU) * Math.sin(angleV);
					z = -_radius * Math.cos(angleU) * Math.sin(angleV);
					
					p.x = x;
					p.y = y;
					p.z = z;
					p.u = u;
					p.v = v;
					
					points.push(p);
				}
			}
			
			//ポリゴンの生成
			n = points.length;
			index = 0;
			for (i = 0; i < n; ++i)
			{
				if (i + _segmentW + 1 >= n) break;
				if ((i + 1) % _segmentW == 0) continue;
				
				poly[0] = points[i];
				poly[1] = points[i + 1];
				poly[2] = points[i + _segmentW];
				poly[3] = points[i + _segmentW + 1];
				
				for (j = 0; j < 4; ++j)
				{
					//新規頂点を追加
					if ((p = poly[j]).index == -1)
					{
						p.index = index++;
						
						//3D座標
						vertices3D.push(p.x, p.y, p.z);
						
						//UV座標
						uvts.push(p.u, p.v);
					}
				}
				
				//頂点インデックスに追加(時計回り)
				indices.push(
					poly[0].index, poly[1].index, poly[2].index,
					poly[1].index, poly[3].index, poly[2].index
				);
			}
		}
	}
}