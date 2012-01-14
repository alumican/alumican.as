package net.alumican.as3.algorithm.ga.packets
{
	/**
	 * Children
	 * 染色体のペアを保持するデータ構造
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class Children
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 子A
		 */
		public var a:Array;
		
		/**
		 * 子B
		 */
		public var b:Array;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 * @param	a
		 * @param	b
		 */
		public function Children(a:Array = null, b:Array = null):void 
		{
			this.a = a;
			this.b = b;
		}
	}
}