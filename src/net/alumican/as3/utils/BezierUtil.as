package net.alumican.as3.utils
{
	import flash.geom.Point;
	
	/**
	 * Bezier Utility
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class BezierUtil
	{
		/**
		 * curveToで3点を滑らかにつなぐためのp0のコントロールポイント
		 * @param	p0	始点
		 * @param	p1	中間点
		 * @param	p2	終点
		 * @return	p0からp2へp1を通りつつcurveToするためのコントロールポイント
		 */
		static public function getQuadricBezierSmoothControlPoint(p0:Point, p1:Point, p2:Point):Point
		{
			return new Point(
				2 * p1.x - (p0.x + p2.x) * 0.5,
				2 * p1.y - (p0.y + p2.y) * 0.5
			);
		}
		
		/**
		 * 3次ベジェ曲線を滑らかにつなぐためのp1のコントロールポイント
		 * @param	p0	始点
		 * @param	p1	中間点
		 * @param	p2	終点
		 * @param	k	係数
		 * @return	中間点p1のコントロールポイント2点を格納した配列
		 * 
		 * @see		Anti-Grain Geometry - Interpolation with Bezier Curves
		 * 			http://www.antigrain.com/research/bezier_interpolation/index.html
		 */
		static public function getAGGControlPoints(p0:Point, p1:Point, p2:Point, k:Number = 0.6667):Array
		{
			var d0x:Number = p0.x - p1.x,
				d0y:Number = p0.y - p1.y,
				
				d2x:Number = p2.x - p1.x,
				d2y:Number = p2.y - p1.y,
				
				l0:Number = Math.sqrt(d0x * d0x + d0y * d0y),
				l2:Number = Math.sqrt(d2x * d2x + d2y * d2y),
				
				a0:Number = k * l0 / (l0 + l2),
				a2:Number = k * l2 / (l0 + l2),
				
				bx:Number = (p0.x - p2.x) * 0.5,
				by:Number = (p0.y - p2.y) * 0.5;
			
			return [
				new Point(p1.x + a0 * bx, p1.y + a0 * by),
				new Point(p1.x - a2 * bx, p1.y - a2 * by)
			];
		}
		
		/**
		 * 3次ベジェ曲線上の点を取得
		 * @param	p0	始点
		 * @param	p1	制御点1
		 * @param	p2	制御点2
		 * @param	p3	終点
		 * @param	t	始点からの比率(0, 1)
		 * @return	tにおけるベジェ3次ベジェ曲線上の点
		 */
		static public function getCubicBezierPoint(p0:Point, p1:Point, p2:Point, p3:Point, t:Number):Point
		{
			var u:Number = 1 - t,
			
				a0:Number = u * u * u,
				a1:Number = 3 * t * u * u,
				a2:Number = 3 * t * t * u,
				a3:Number = t * t * t;
			
			return new Point(
				a0 * p0.x + a1 * p1.x + a2 * p2.x + a3 * p3.x,
				a0 * p0.y + a1 * p1.y + a2 * p2.y + a3 * p3.y
			);
		}
		
		/**
		 * 3次ベジェ曲線上の点をまとめて取得
		 * @param	p0	始点
		 * @param	p1	制御点1
		 * @param	p2	制御点2
		 * @param	p3	終点
		 * @param	seg	分割数
		 * @return	p0からp3における3次ベジェ曲線上の点を格納した配列
		 */
		static public function getCubicBezierPoints(p0:Point, p1:Point, p2:Point, p3:Point, seg:uint = 10):Array
		{
			var o:Array   = [p0],
				dt:Number = 1 / seg;
			
			for (var t:Number = dt; t < 1; t += dt) 
			{
				o.push( getCubicBezierPoint(p0, p1, p2, p3, t) );
			}
			o.push(p3);
			
			return o;
		}
	}
}