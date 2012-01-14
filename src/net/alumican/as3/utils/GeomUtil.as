package net.alumican.as3.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	/**
	 * GeomUtil
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class GeomUtil
	{
		/**
		 * ローカル座標から別のローカル座標への変換をおこないます
		 * @param	x
		 * @param	y
		 * @param	from
		 * @param	to
		 * @return
		 */
		static public function localToLocal(p:Point, from:DisplayObjectContainer, to:DisplayObjectContainer):Point
		{
			return to.globalToLocal(from.localToGlobal(p));
		}
		
		/**
		 * x, y座標を指定してローカル座標から別のローカル座標への変換をおこないます
		 * @param	x
		 * @param	y
		 * @param	from
		 * @param	to
		 * @return
		 */
		static public function localToLocal2D(x:Number, y:Number, from:DisplayObjectContainer, to:DisplayObjectContainer):Point
		{
			return to.globalToLocal(from.localToGlobal( new Point(x, y) ));
		}
	}
}