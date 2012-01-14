package net.alumican.as3.algorithm.kmeans
{
	import flash.geom.Point;
	
	/**
	 * 2-dimensional K-means clustering
	 * 
	 * @author Yukiya Okuda <alumican.net>
	 */
	public class KMeans2
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * sample data
		 */
		public function get datas():Vector.<Point> { return _datas; }
		private var _datas:Vector.<Point>;
		
		/**
		 * label index
		 */
		public function get labels():Vector.<int> { return _labels; }
		private var _labels:Vector.<int>;
		
		/**
		 * mean value
		 */
		public function get means():Vector.<Point> { return _means; }
		private var _means:Vector.<Point>;
		
		/**
		 * data count for each cluster
		 */
		public function get counts():Vector.<int> { return _counts; }
		private var _counts:Vector.<int>;
		
		/**
		 * cluster total count
		 */
		public function get k():int { return _k; }
		private var _k:int;
		
		/**
		 * data total count
		 */
		public function get n():int { return _n; }
		private var _n:int;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * Constructor
		 */
		public function KMeans2():void
		{
		}
		
		/**
		 * calc
		 * @param	datas
		 * @param	k
		 */
		public function calc(datas:Vector.<Point>, k:int):void
		{
			var i:int,
				j:int,
				n:int = datas.length,
				l:int,
				l0:int,
				d:Number,
				dMin:Number,
				d0:Number = Number.MAX_VALUE,
				p:Point,
				c:Point,
				m:int,
				dx:Number,
				dy:Number,
				loop:Boolean,
				labels:Vector.<int> = new Vector.<int>(n),
				cs:Vector.<Point> = new Vector.<Point>(k),
				cn:Vector.<int> = new Vector.<int>(k);
			
			//init
			for (i = 0; i < k; ++i)
			{
				cs[i] = new Point(0, 0);
				cn[i] = 0;
			}
			
			for (i = 0; i < n; ++i)
			{
				l = int(Math.random() * k);
				labels[i] = l;
				
				p = datas[i];
				
				c = cs[l];
				c.x += p.x;
				c.y += p.y;
				++cn[l];
			}
			
			for (i = 0; i < k; ++i)
			{
				m = cn[i];
				if (m > 0)
				{
					c = cs[i];
					c.x /= m;
					c.y /= m;
				}
			}
			
			//loop
			while (true)
			{
				loop = false;
				
				//update label
				for (i = 0; i < n; ++i)
				{
					p = datas[i];
					l0 = l = labels[i];
					dMin = d0;
					for (j = 0; j < k; ++j)
					{
						c = cs[j];
						dx = p.x - c.x;
						dy = p.y - c.y;
					//	d = Math.sqrt(dx * dx + dy * dy);
						d = dx * dx + dy * dy;
						if (d <= dMin)
						{
							dMin = d;
							l = j;
						}
					}
					if (l0 != l) loop = true;
					labels[i] = l;
				}
				
				//calc mean
				for (i = 0; i < k; ++i)
				{
					c = cs[l];
					c.x = c.y = 0;
					cn[i] = 0;
				}
				
				for (i = 0; i < n; ++i)
				{
					l = labels[i];
					
					p = datas[i];
					
					c = cs[l];
					c.x += p.x;
					c.y += p.y;
					++cn[l];
				}
				
				for (i = 0; i < k; ++i)
				{
					m = cn[i];
					if (m > 0)
					{
						c = cs[i];
						c.x /= m;
						c.y /= m;
					}
				}
				
				if (!loop) break;
			}
			
			//result
			_datas  = datas;
			_labels = labels;
			_means  = cs;
			_counts = cn;
			_k      = k;
			_n      = datas.length;
		}
	}
}