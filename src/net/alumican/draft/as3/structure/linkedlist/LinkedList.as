package net.alumican.as3.structure.linkedlist
{
	/**
	 * LinkedList
	 * @author alumican
	 */
	public class LinkedList
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		public function get first():LinkedListNode { return _first; }
		private var _first:LinkedListNode;
		
		public function get last():LinkedListNode { return _last; }
		private var _last:LinkedListNode;
		
		public function get length():uint { return _length; }
		private var _length:uint;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function LinkedList():void 
		{
			_first = null;
			_last = null;
			_length = 0;
		}
		
		public function push(node:LinkedListNode):void
		{
			var tmp:LinkedListNode = _last;
			_last = tmp._next = node;
			node.prev = tmp;
		}
		
		public function remove(node:LinkedListNode):void {
			
		}
	}
}