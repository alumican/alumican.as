package net.alumican.as3.algorithm.ga.packets
{
	/**
	 * Parents
	 * インデックスのペアを保持するデータ構造
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class Parents 
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		public function getPair(index:uint):Array { return _pairs[index]; }
		private var _pairs:Array;
		
		public function get pairCount():uint { return _pairCount; }
		private var _pairCount:uint;
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 * @param	a
		 * @param	b
		 */
		public function Parents():void 
		{
			_pairs = new Array();
			_pairCount = 0;
		}
		
		/**
		 * ペアの追加
		 * @param	a
		 * @param	b
		 */
		public function addPair(a:uint, b:uint):void
		{
			_pairCount = _pairs.push([a, b]);
		}
	}
}