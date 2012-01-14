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
	import jp.progression.casts.getInstanceById;
	import jp.progression.commands.Command;
	import jp.progression.commands.CommandList;
	
	/**
	 * オブジェクトの非表示アニメーションを実行するコマンド
	 */
	public class Hide extends Command
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		/**
		 * 実行メソッド名
		 */
		static public const FUNC:String  = "hide";
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * ターゲット
		 */
		public function get target():* { return _target; }
		public function set target(value:*):void { _target = value; }
		private var _target:*;
		
		/**
		 * トランジションを使用する場合はtrue
		 */
		public function get useTween():Boolean { return _useTween; }
		public function set useTween(value:Boolean):void { _useTween = value; }
		private var _useTween:Boolean;
		
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
		 * @param	instanceID  インスタンスID
		 * @param	useTween    アニメーションさせる場合はtrue
		 * @param	initObject  初期化オブジェクト
		 */
		public function Hide(target:*, useTween:Boolean = true, args:Array = null, initObject:Object = null):void
		{
			_target = target;
			_useTween = useTween;
			_args = args;
			
			//親クラスを初期化する
			super(_executeFunction, _interruptFunction, initObject);
		}
		
		/**
		 * コマンド実行ハンドラ
		 */
		private function _executeFunction():void
		{
			//ターゲットインスタンスからコマンドリストを取得
			var instance:* = (_target is String) ? getInstanceById(_target) : _target;
			var func:Function = instance[FUNC];
			var args:Array = (_args != null) ? [_useTween, _args] : [_useTween];
			var command:CommandList = func.apply(this, args);
			
			//呼び出しもとのコマンドリストに挿入
			parent.insertCommand(command);
			
			//完了
			_executeComplete();
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
			return new Hide(_target, _useTween, _args, this);
		}
		
		/**
		 * ストリング表現を取得する
		 * @return
		 */
		public override function toString():String
		{
			return ObjectUtil.formatToString(this, super.className, super.id ? "id" : null, "target", "useTween", "args");
		}
	}
}
