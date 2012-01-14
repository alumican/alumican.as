package net.alumican.as3.templates.singleton
{
	/**
	 * シングルトン
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class Singleton
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * インスタンスの取得
		 */
		static public function get instance():Singleton { return _instance ? _instance : (_instance = new Singleton(new SingletonEnforcer())); }
		static private var _instance:Singleton;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function Singleton(pvt:SingletonEnforcer):void
		{
			//初期化処理...
		}
	}
}

internal class SingletonEnforcer { }