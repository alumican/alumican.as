package net.alumican.as3.algorithm.ga.packets
{
	/**
	 * Chromosomes
	 * 染色体配列の集合を保持するデータ構造
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class Chromosomes
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 染色体を格納する配列
		 */
		public function get(index:uint):Array { return _chrosomes[index]; }
		public function set(index:uint, chrosome:Array):void { _chrosomes[index] = chrosome; }
		private var _chrosomes:Array;
		
		/**
		 * 染色体数
		 */
		public function get length():uint { return _chrosomes.length; }
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 * @param	n
		 */
		public function Chromosomes(n:uint):void
		{
			_chrosomes = new Array(n);
		}
	}
}