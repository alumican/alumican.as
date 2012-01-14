package net.alumican.as3.algorithm.random
{
	import flash.geom.Point;
	
	/**
	 * SIMD-oriented Fast Mersenne Twister (SFMT)
	 * 高速メルセンヌツイスターのAS3移植版
	 * 
	 * @see http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/index-jp.html
	 * @see http://www001.upp.so-net.ne.jp/isaku/rand2.html
	 * 
	 * @author Yukiya Okuda <alumican.net>
	 */
	public class SFMT
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		static public const ID:String = "SFMT-19937:122-18-1-11-1:dfffffef-ddfecb7f-bffaffff-bffffff6";
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		private var _parity:Vector.<int>;
		private var _index:int;
		private var _x:Vector.<int>;    /* 状態テーブル */
		
		private var _coinBits:int;      /* nextBit での残りのビット */
		private var _coinSave:int;      /* nextBit での値保持 */
		
		private var _bytePos:int;       /* nextByte で使用したバイト数 */
		private var _byteSave:int;      /* nextByte での値保持 */
		
		private var _range:int;         /* nextIntEx で前回の範囲 */
		private var _base:int;          /* nextIntEx で前回の基準値 */
		private var _shift:int;         /* nextIntEx で前回のシフト数 */
		
		private var _normalSw:int;      /* nextNormal で残りを持っている */
		private var _normalSave:Number; /* nextNormal の残りの値 */
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function SFMT(seed:int):void
		{
			_parity = Vector.<int>([0x00000001, 0x00000000, 0x00000000, 0x13c9e684]);
			_x = new Vector.<int>(624);
			init(seed);
		}
		
		private function _genRandAll():void
		{
			var a:int = 0,
				b:int = 488,
				c:int = 616,
				d:int = 620,
				y:int,
				p:Vector.<int> = _x;
			
			do
			{
				y = p[a + 3] ^ (p[a + 3] << 8) ^ (p[a + 2] >>> 24) ^ ((p[b + 3] >>> 11) & 0xbffffff6);
				p[a + 3] = y ^ (p[c + 3] >>> 8) ^ (p[d + 3] << 18);
				y = p[a + 2] ^ (p[a + 2] << 8) ^ (p[a + 1] >>> 24) ^ ((p[b + 2] >>> 11) & 0xbffaffff);
				p[a + 2] = y ^ ((p[c + 2] >>> 8) | (p[c + 3] << 24)) ^ (p[d + 2] << 18);
				y = p[a + 1] ^ (p[a + 1] << 8) ^ (p[a] >>> 24) ^ ((p[b + 1] >>> 11) & 0xddfecb7f);
				p[a + 1] = y ^ ((p[c + 1] >>> 8) | (p[c + 2] << 24)) ^ (p[d + 1] << 18);
				y = p[a] ^ (p[a] << 8) ^ ((p[b] >>> 11) & 0xdfffffef);
				p[a] = y ^ ((p[c] >>> 8) | (p[c + 1] << 24)) ^ (p[d] << 18);
				c = d; d = a; a += 4; b += 4;
				if (b == 624) b = 0;
			}
			while (a != 624);
		}
		
		private function _periodCertification():void
		{
			var work:int,
				inner:int = 0,
				i:int,
				j:int,
				parity:Vector.<int> = _parity;
			
			_index = 624; _range = 0; _normalSw = 0; _coinBits = 0; _bytePos = 0;
			for (i = 0; i < 4; i++) inner ^= _x[i] & parity[i];
			for (i = 16; i > 0; i >>>= 1) inner ^= inner >>> i;
			inner &= 1;
			if (inner == 1) return;
			for (i = 0; i < 4; ++i)
			{
				for (j = 0, work = 1; j < 32; j++, work <<= 1)
				{
					if ((work & parity[i]) != 0) { _x[i] ^= work; return; }
				}
			}
		}
		
		/**
		 * 整数seedによる初期化
		 * @param	seed
		 */
		public function init(seed:int):void
		{
			_x[0] = seed;
			for (var p:int = 1; p < 624; ++p) _x[p] = seed = 1812433253 * (seed ^ (seed >>> 30)) + p;
			_periodCertification();
		}
		
		/**
		 * 配列keyによる初期化
		 * @param	key
		 */
		public function initEx(key:Vector.<int>):void {
			var r:int,
				i:int,
				j:int,
				c:int,
				n:int = key.length;
			
			for (i = 0; i < 624; i++) _x[i] = 0x8b8b8b8b;
			if (n + 1 > 624) c = n + 1; else c = 624;
			r = _x[0] ^ _x[306] ^ _x[623]; r = (r ^ (r >>> 27)) * 1664525;
			_x[306] += r; r += n; _x[317] += r; _x[0] = r; c--;
			for (i = 1, j = 0; j < c && j < n; j++)
			{
				r = _x[i] ^ _x[(i + 306) % 624] ^ _x[(i + 623) % 624];
				r = (r ^ (r >>> 27)) * 1664525; _x[(i + 306) % 624] += r;
				r += key[j] + i; _x[(i + 317) % 624] += r;
				_x[i] = r; i = (i + 1) % 624;
			}
			for (; j < c; j++)
			{
				r = _x[i] ^ _x[(i + 306) % 624] ^ _x[(i + 623) % 624];
				r = (r ^ (r >>> 27)) * 1664525; _x[(i + 306) % 624] += r; r += i;
				_x[(i + 317) % 624] += r; _x[i] = r; i = (i + 1) % 624;
			}
			for (j = 0; j < 624; j++)
			{
				r = _x[i] + _x[(i + 306) % 624] + _x[(i + 623) % 624];
				r = (r ^ (r >>> 27)) * 1566083941; _x[(i + 306) % 624] ^= r;
				r -= i; _x[(i + 317) % 624] ^= r; _x[i] = r; i = (i + 1) % 624;
			}
			_periodCertification();
		}
		
		/**
		 * [0, 1)未満の小数(53bit精度)
		 * @return
		 */
		public function nextUnif():Number
		{
			var z:Number = nextInt() >>> 11,
				y:Number = nextInt();
			if (y < 0) y += 4294967296.0;
			return (y * 2097152.0 + z) * (1.0 / 9007199254740992.0);
		}
		
		/**
		 * 32ビット符号あり整数
		 * @return
		 */
		public function nextInt():int
		{
			if (_index == 624)
			{
				_genRandAll();
				_index = 0;
			}
			return _x[_index++];
		}
		
		/**
		 * [0, n)の整数
		 * @param	n
		 * @return
		 */
		public function nextUint(n:int):int
		{
			var z:Number = nextInt();
			if (z < 0) z += 4294967296.0;
			return int(n * (1.0 / 4294967296.0) * z);
		}
		
		/**
		 * 0 or 1 の整数
		 * @return
		 */
		public function nextBit():int
		{
			if (--_coinBits == -1)
			{
				_coinBits = 31;
				return (_coinSave = nextInt()) & 1; 
			}
			else
			{
				return (_coinSave >>>= 1) & 1;
			}
		}
		
		/**
		 * [0, 255] の整数
		 * @return
		 */
		public function nextByte():int
		{
			if (--_bytePos == -1)
			{
				_bytePos = 3;
				return int(_byteSave = nextInt()) & 255;
			}
			else
			{
				return int(_byteSave >>>= 8) & 255;
			}
		}
		
		/* 丸め誤差のない [0, range_) の整数 */
		public function nextIntEx(range:int):int {
			var y:int,
				base:int,
				remain:int,
				shift:int;
			
			if (range <= 0) return 0;
			if (range != _range)
			{
				_base = (_range = range);
				for (_shift = 0; _base <= (1 << 30) && _base != 1 << 31; _shift++) _base <<= 1;
			}
			while (true)
			{
				y = nextInt() >>> 1;
				if (y < _base || _base == 1 << 31) return int(y >>> _shift);
				base = _base; shift = _shift; y -= base;
				remain = (1 << 31) - base;
				for (; remain >= int(range); remain -= base)
				{
					for (; base > remain; base >>>= 1) shift--;
					if (y < base)
					{
						return int(y >>> shift);
					}
					else
					{
						y -= base;
					}
				}
			}
			return 0;
		}
		
		/**
		 * 自由度nのカイ2乗分布
		 * @param	n
		 * @return
		 */
		public function nextChisq(n:Number):Number
		{
			return 2 * nextGamma(0.5 * n);
		}
		
		/**
		 * パラメータaのガンマ分布
		 * @param	a
		 * @return
		 */
		public function nextGamma(a:Number):Number
		{
			var t:Number,
				u:Number,
				X:Number,
				y:Number;
			
			if (a > 1)
			{
				t = Math.sqrt(2 * a - 1);
				do
				{
					do
					{
						do
						{
							X = 1 - nextUnif();
							y = 2 * nextUnif() - 1;
						}
						while (X * X + y * y > 1);
						y /= X; X = t * y + a - 1;
					}
					while (X <= 0);
					u = (a - 1) * Math.log(X / (a - 1)) - t * y;
				}
				while (u < -50 || nextUnif() > (1 + y * y) * Math.exp(u));
			}
			else
			{
				t = 2.718281828459045235 / (a + 2.718281828459045235);
				do
				{
					if (nextUnif() < t)
					{
						X = Math.pow(nextUnif(), 1 / a); y = Math.exp( -X);
					}
					else
					{
						X = 1 - Math.log(1 - nextUnif()); y = Math.pow(X, a - 1);
					}
				}
				while (nextUnif() >= y);
			}
			return X;
		}
		
		/**
		 * 確率pの幾何分布
		 * @param	p
		 * @return
		 */
		public function nextGeometric(p:Number):int
		{
			return int(Math.ceil(Math.log(1.0 - nextUnif()) / Math.log(1 - p)));
		}
		
		/**
		 * 三角分布
		 * @return
		 */
		public function nextTriangle():Number
		{
			var a:Number = nextUnif(),
				b:Number = nextUnif();
			
			return a - b;
		}
		
		/**
		 * 平均1の指数分布
		 * @return
		 */
		public function nextExp():Number
		{
			return - Math.log(1 - nextUnif());
		}
		
		/**
		 * 標準正規分布(最大8.57σ)
		 * @return
		 */
		public function nextNormal():Number
		{
			if (_normalSw == 0)
			{
				var t:Number = Math.sqrt(-2 * Math.log(1.0 - nextUnif()));
				var u:Number = 3.141592653589793 * 2 * nextUnif();
				_normalSave = t * Math.sin(u); _normalSw = 1;
				return t * Math.cos(u);
			}
			else
			{
				_normalSw = 0;
				return _normalSave;
			}
		}
		
		/**
		 * n次元のランダム単位ベクトル
		 * @param	n
		 * @return
		 */
		public function nextUnitVect(n:int):Vector.<Number>
		{
			var i:int,
				r:Number = 0,
				v:Vector.<Number> = new Vector.<Number>(n);
			
			for (i = 0; i < n; i++)
			{
				v[i] = nextNormal();
				r += v[i] * v[i];
			}
			if (r == 0.0) r = 1.0;
			r = Math.sqrt(r);
			for (i = 0; i < n; i++) v[i] /= r;
			return v;
		}
		
		/**
		 * パラメータn,pの2項分布
		 * @param	n
		 * @param	p
		 * @return
		 */
		public function nextBinomial(n:int, p:Number):int
		{
			var i:int,
				r:int = 0;
			
			for (i = 0; i < n; i++) if (nextUnif() < p) r++;
			return r;
		}
		
		/**
		 * 相関係数rの2変量正規分布
		 * @param	r
		 * @return
		 */
		public function nextBinormal(r:Number):Point
		{
			var r1:Number,
				r2:Number,
				s:Number;
			
			do
			{
				r1 = 2 * nextUnif() - 1;
				r2 = 2 * nextUnif() - 1;
				s = r1 * r1 + r2 * r2;
			}
			while (s > 1 || s == 0);
			s = -Math.log(s) / s; r1 = Math.sqrt((1 + r) * s) * r1;
			r2 = Math.sqrt((1 - r) * s) * r2;
			return new Point(r1 + r2, r1 - r2);
		}
		
		/**
		 * パラメータa,bのベータ分布
		 * @param	a
		 * @param	b
		 * @return
		 */
		public function nextBeta(a:Number, b:Number):Number
		{
			var temp:Number = nextGamma(a);
			return temp / (temp + nextGamma(b));
		}
		
		/**
		 * パラメータnの累乗分布
		 * @param	n
		 * @return
		 */
		public function nextPower(n:Number):Number
		{
			return Math.pow(nextUnif(), 1.0 / (n + 1));
		}
		
		/**
		 * ロジスティック分布
		 * @return
		 */
		public function nextLogistic():Number
		{
			var r:Number;
			do r = nextUnif(); while (r == 0);
			return Math.log(r / (1 - r));
		}
		
		/**
		 * コーシー分布
		 * @return
		 */
		public function nextCauchy():Number
		{
			var x:Number, y:Number;
			do { x = 1 - nextUnif(); y = 2 * nextUnif() - 1; }
			while (x * x + y * y > 1);
			return y / x;
		}
		
		/**
		 * 自由度n1,n2のＦ分布
		 * @param	n1
		 * @param	n2
		 * @return
		 */
		public function nextFDist(n1:Number, n2:Number):Number
		{
			var nc1:Number = nextChisq(n1),
				nc2:Number = nextChisq(n2);
			return (nc1 * n2) / (nc2 * n1);
		}
		
		/**
		 * 平均lambdaのポアソン分布
		 * @param	lambda
		 * @return
		 */
		public function nextPoisson(lambda:Number):int
		{
			var k:int;
			lambda = Math.exp(lambda) * nextUnif();
			for (k = 0; lambda > 1; k++) lambda *= nextUnif();
			return k;
		}
		
		/**
		 * 自由度nのt分布
		 * @param	n
		 * @return
		 */
		public function nextTDist(n:Number):Number
		{
			var a:Number,
				b:Number,
				c:Number;
			
			if (n <= 2)
			{
				do a = nextChisq(n); while (a == 0);
				return nextNormal() / Math.sqrt(a / n);
			}
			do {
				a = nextNormal(); b = a * a / (n - 2);
				c = Math.log(1 - nextUnif()) / (1 - 0.5 * n);
			} while (Math.exp(-b - c) > 1 - b);
			return a / Math.sqrt((1 - 2.0 / n) * (1 - b));
		}
		
		/**
		 * パラメータalphaのワイブル分布
		 * @param	alpha
		 * @return
		 */
		public function nextWeibull(alpha:Number):Number
		{
			return Math.pow(-Math.log(1 - nextUnif()), 1 / alpha);
		}
	}
}