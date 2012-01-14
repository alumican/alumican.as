package net.alumican.as3.structure.objectpool
{
	
	/**
	 * ObjectPool
	 * 
	 * @author Yukiya Okuda<alumican.net>
	 */
	public class ObjectPool 
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 最初に生成するオブジェクト数
		 */
		public function get initCount():uint { return _initCount; }
		private var _initCount:uint;
		
		/**
		 * 足りなくなったとき一度に生成するオブジェクト数
		 */
		public function get growthCount():uint { return _growthCount; }
		public function set growthCount(value:uint):void { _growthCount = value; }
		private var _growthCount:uint;
		
		/**
		 * オブジェクトを保持しておくための配列
		 */
		public function get pool():Array { return _pool; }
		private var _pool:Array;
		
		/**
		 * 現在の配列ヘッダ
		 */
		public function get index():int { return _index; }
		private var _index:int;
		
		/**
		 * 新規オブジェクトが必要となった際に呼び出される関数
		 */
		public function get requireItem():Function { return __requireItem || _requireItem; }
		public function set requireItem(value:Function):void { __requireItem = value; }
		protected var __requireItem:Function;
		
		/**
		 * 不要オブジェクトを破棄する際に呼び出される関数
		 */
		public function get destroyItem():Function { return __destroyItem || _destroyItem; }
		public function set destroyItem(value:Function):void { __destroyItem = value; }
		protected var __destroyItem:Function;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function ObjectPool(initCount:int = 100, growthCount:int = 50, requireItem:Function = null, destroyItem:Function = null):void 
		{
			_initCount    = initCount;
			_growthCount  = growthCount;
			__requireItem = requireItem;
			__destroyItem = destroyItem;
			
			_pool = new Array(_initCount);
			for (var i:int = 0; i < _initCount; ++i)
			{
				_pool[i] = requireItem();
			}
			_index = _initCount;
		}
		
		
		
		
		
		/**
		 * インスタンスを破棄する
		 */
		public function destroy():void
		{
			var n:int = _pool.length;
			for (var i:int = 0; i < n; ++i)
			{
				destroyItem(_pool[i]);
			}
			_pool = null;
			__requireItem = null;
			__destroyItem = null;
		}
		
		/**
		 * オブジェクトを取得する
		 */
		public function getItem():Object
		{
			if (_index > 0) return _pool[--_index];
			
			for (var i:int = 0; i < _growthCount; ++i)
			{
				_pool.unshift(requireItem());
			}
			_index = _growthCount;
			
			return getItem();
		}
		
		/**
		 * オブジェクトを返却する
		 */
		public function returnItem(item:Object):void
		{
			_pool[_index++] = item;
		}
		
		
		
		
		
		//----------------------------------------
		//PROTECTED METHODS
		
		/**
		 * オブジェクトを生成する
		 */
		protected function _requireItem():*
		{
			return {};
		}
		
		/**
		 * オブジェクトを破棄する
		 */
		protected function _destroyItem(object:*):void
		{
		}
	}
}