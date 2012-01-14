package net.alumican.as3.structure.linkedlist
{
	/**
	 * LinkedListNode
	 * @author alumican
	 */
	public class LinkedListNode
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 前のノード
		 */
		public function get prev():LinkedListNode { return __prev; }
		internal function set _prev(value:LinkedListNode):void { __rev = value; }
		private var __prev:LinkedListNode;
		
		/**
		 * 次のノード
		 */
		public function get next():LinkedListNode { return __next; }
		internal function set _next(value:LinkedListNode):void { __next = value; }
		private var __next:LinkedListNode;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function LinkedListNode():void 
		{
			__prev = null;
			__next = null;
		}
	}
}