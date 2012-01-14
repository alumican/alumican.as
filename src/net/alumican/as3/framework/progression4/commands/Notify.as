/**
 * Progression 4
 * 
 * @author Copyright (C) 2007-2009 taka:nium.jp, All Rights Reserved.
 * @version 4.0.1 Public Beta 1.1
 * @see http://progression.jp/
 * 
 * Progression Software is released under the Progression Software License:
 * http://progression.jp/ja/overview/license
 * 
 * Progression Libraries is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */
package net.alumican.as3.framework.progression4.commands
{
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;
	
	/**
	 * コールバック駆動
	 */
	public class Notify extends Command
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 実行関数
		 */
		public function get func():Function { return _func; }
		public function set func(value:Function):void { _func = value; }
		private var _func:Function;
		
		/**
		 * 実行引数
		 */
		public function get args():Array { return _args; }
		public function set args(value:Array):void { _args = value; }
		private var _args:Array;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function Notify(func:Function, args:Array = null, initObject:Object = null):void
		{
			_func = func;
			_args = args;
			
			//親クラスを初期化する
			super(_executeFunction, _interruptFunction, initObject);
		}
		
		/**
		 * 呼ばれたらコマンド完了
		 */
		public function notifyComplete():void
		{
			_executeComplete();
		}
		
		/**
		 * コマンド実行ハンドラ
		 */
		private function _executeFunction():void
		{
			var args:Array = (_args != null) ? _args.concat(notifyComplete) : [notifyComplete];
			_func.apply(this, args);
		}
		
		/**
		 * コマンド中断ハンドラ
		 */
		private function _interruptFunction():void
		{
		}
		
		/**
		 * コマンド完了ハンドラ
		 */
		private function _executeComplete():void
		{
			if (super.state > 1)
			{
				super.executeComplete();
			}
		}
		
		/**
		 * クローンを取得する
		 * @return
		 */
		public override function clone():Command
		{
			return new Notify(_func, _args, this);
		}
		
		/**
		 * ストリング表現を取得する
		 * @return
		 */
		public override function toString():String
		{
			return ObjectUtil.formatToString(this, super.className, super.id ? "id" : null, "func", "args");
		}
	}
}
