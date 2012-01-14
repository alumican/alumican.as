package particlefilter
{
	
	/**
	 * IParticle
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class ImageParticle implements IParticle 
	{
		/*==========================================================================//**
		 * 画像中のx座標
		 */
		public function get x():uint { return _x; }
		public function set x(value:uint):void { _x = value; }
		private var _x:uint;
		
		
		
		
		
		/*==========================================================================//**
		 * 画像中のy座標
		 */
		public function get y():uint { return _y; }
		public function set y(value:uint):void { _y = value; }
		private var _y:uint;
		
		
		
		
		
		/*==========================================================================//**
		 * 重み
		 */
		public function get weight():Number { return _weight; }
		public function set weight(value:Number):void { _weight = value; }
		private var _weight:Number;
		
		
		
		
		
		/*==========================================================================//**
		 * 時針の複製を生成する関数
		 */
		public function clone():IParticle 
		{
			return new ImageParticle(_x, _y, _weight);
		}
		
		
		
		
		
		/*==========================================================================//**
		 * コンストラクタ
		 */
		public function ImageParticle(x:uint = 0, y:uint = 0, weight:Number = 0):void 
		{
			_x      = x;
			_y      = y;
			_weight = weight;
		}
	}
}