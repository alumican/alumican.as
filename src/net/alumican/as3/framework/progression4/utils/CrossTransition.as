package net.alumican.as3.framework.progression4.utils
{
	import jp.progression.commands.lists.SerialList;
	import net.alumican.as3.profiler.logger.Logger;
	
	/**
	 * CrossTransition
	 * 
	 * @author alumican.net
	 */
	public class CrossTransition
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * インスタンスの取得
		 */
		static public function get instance():CrossTransition { return _instance ? _instance : (_instance = new CrossTransition(new SingletonEnforcer())); }
		static private var _instance:CrossTransition;
		
		/**
		 * 実行コマンド
		 */
		public function get commands():SerialList { return _commands; }
		public function set commands(value:SerialList):void
		{
			Logger.info("CrossTransition : setCommands");
			
			//コールバックの削除
			if (_commands)
			{
				_commands.onStart = null;
				_commands.onComplete = null;
			}
			
			//コマンドの更新
			_commands = (value != null) ? value : new SerialList();
			
			//コールバックの追加
			_commands.onStart = function():void
			{
				Logger.info("CrossTransition : start");
			}
			_commands.onComplete = function():void
			{
				Logger.info("CrossTransition : complete");
				
				//コマンドのリセット
				_commands.clearCommand(true);
			}
		}
		private var _commands:SerialList;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function CrossTransition(pvt:SingletonEnforcer):void
		{
			commands = new SerialList();
		}
		
		/**
		 * コマンドを最後尾へ追加する
		 * @param	...commands
		 */
		public function addCommand(...commands:Array):void
		{
			Logger.info("CrossTransition : addCommand");
			_commands.addCommand(commands.concat());
		}
		
		/**
		 * コマンドを現在実行中のコマンドの次へ追加する
		 * @param	...commands
		 */
		public function insertCommand(...commands:Array):void
		{
			Logger.info("CrossTransition : insertCommand");
			_commands.insertCommand(commands.concat());
		}
		
		/**
		 * コマンドをクリアする
		 */
		public function clearCommand():void
		{
			Logger.info("CrossTransition : clearCommand");
			commands = null;
		}
	}
}

internal class SingletonEnforcer { }