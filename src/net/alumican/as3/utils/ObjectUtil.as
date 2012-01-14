package net.alumican.as3.utils
{
	import flash.utils.ByteArray;
	
	/**
	 * ObjectUtil
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public class ObjectUtil 
	{
		
		//-------------------------------------
		// CLASS CONSTANTS
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// variable
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// STAGE INSTANCES
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// GETTER/SETTER
		//-------------------------------------
		
		
		
		
		
		//-------------------------------------
		// CONSTRUCTOR
		//-------------------------------------
		
		/**
		 * コンストラクタ
		 */
		public function ObjectUtil():void 
		{
			throw new ArgumentError("Utility class is static.");
		}
		
		
		
		
		
		//-------------------------------------
		// METHODS
		//-------------------------------------
		
		/**
		 * オブジェクトのdeep copyを返します
		 * @param	src
		 * @return
		 */
		static public function clone(src:*):*
		{
			var b:ByteArray = new ByteArray();
			b.writeObject(src);
			b.position = 0;
			return b.readObject();
		}
		
		/**
		 * o1とo2を結合した新しいオブジェクトを返します
		 * o1とo2に同名のプロパティが存在する場合はobject2が優先されます
		 * @param	o1
		 * @param	o2
		 * @return
		 */
		static public function merge(o1:Object, o2:Object):Object
		{
			var o:Object = clone(o1);
			for (var key:String in o2) o[key] = o2[key];
			return o;
		}
		
		
		
		
		
		//-------------------------------------
		// EVENT HANDLER
		//-------------------------------------
	}
}