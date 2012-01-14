package net.alumican.as3.utils
{
	/**
	 * MathUtil
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class MathUtil
	{
		/**
		 * 値を指定区間内に丸める
		 */
		static public function normalize(value:Number, srcMin:Number, srcMax:Number, dstMin:Number, dstMax:Number):Number
		{
			value = value < srcMin ? srcMin : value > srcMax ? srcMax : value;
			return dstMin + (dstMax - dstMin) * (value - srcMin) / (srcMax - srcMin);
		}
		
		/**
		 * 2点(p1, p2)をd1:d2に内分する点を求める
		 */
		static public function internallyDividingPoint(p1:Number, p2:Number, d1:Number, d2:Number):Number
		{
			return p1 == p2 ? p1 : ((d2 * p1 + d1 * p2) / (d1 + d2));
		}
		
		/**
		 * 2点(p1, p2)をd1:d2に外分する点を求める
		 */
		static public function externallyDividingPoint(p1:Number, p2:Number, d1:Number, d2:Number):Number
		{
			return p1 == p2 ? p1 : ((d2 * p1 - d1 * p2) / (d2 - d1));
		}
		
		/**
		 * 符号を求める
		 */
		static public function sign(value:Number):Number
		{
			return value < 0 ? -1 : 1;
		}
	}
}