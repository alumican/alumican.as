package net.alumican.as3.system
{
	
	/**
	 * Flashvars
	 * 
	 * @author Yukiya Okuda
	 */
	public class Flashvars
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * パラメータ
		 */
		public function get param():Object { return _param; }
		public function set param(value:Object):void { _param = value; }
		private var _param:Object;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function Flashvars(param:Object = null):void
		{
			_param = param;
		}
		
		/**
		 * パラメータをStringとして取得する
		 */
		public function getString(name:String, defaultValue:String = ""):String
		{
			return _param[name] != null ? _param[name] : defaultValue;
		}
		
		/**
		 * パラメータをNumberとして取得する
		 */
		public function getFloat(name:String, defaultValue:Number = 0):Number
		{
			return _param[name] != null ? parseFloat(_param[name]) : defaultValue;
		}
		
		/**
		 * パラメータをintとして取得する
		 */
		public function getInt(name:String, defaultValue:int = 0):int
		{
			return _param[name] != null ? parseInt(_param[name]) : defaultValue;
		}
		
		/**
		 * パラメータをBooleanとして取得する
		 */
		public function getBoolean(name:String, defaultValue:Boolean = false):Boolean
		{
			return _param[name] != null ? String(_param[name]).toLowerCase() != "false" && String(_param[name]) != "0" : defaultValue;
		}
		
		/**
		 * パラメータを任意型で取得する
		 */
		public function getData(name:String, defaultValue:* = null):*
		{
			return _param[name] != null ? _param[name] : defaultValue;
		}
	}
}