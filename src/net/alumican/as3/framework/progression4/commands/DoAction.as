﻿/**
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
	 * オブジェクトのカスタムアクションを実行するコマンド
	 */
	public class DoAction extends Command
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		/**
		 * 実行メソッド名
		 */
		static public const FUNC:String  = "doAction";
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * ターゲット
		 */
		public function get target():* { return _target; }
		private var _target:*;
		
		/**
		 * 実行アクション
		 */
		public function get action():String { return _action; }
		private var _action:String;
		
		/**
		 * 実行引数
		 */
		public function get args():Array { return _args; }
		private var _args:Array;
		
		/**
		 * ターゲットインスタンス
		 */
		private var _instance:*;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 * @param	instanceID  インスタンスID
		 * @param	initObject  初期化オブジェクト
		 */
		public function DoAction(target:*, action:String, args:Array = null, initObject:Object = null):void
		{
			_target = target;
			_action = action;
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
			_instance = (_target is String) ? getInstanceById(_target) : _target;
			var func:Function = _instance[FUNC];
			var args:Array = (_args != null) ? [action].concat([_args]) : [action]; 
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
			return new DoAction(_target, _action, _args, this);
		}
		
		/**
		 * ストリング表現を取得する
		 * @return
		 */
		public override function toString():String
		{
			return ObjectUtil.formatToString(this, super.className, super.id ? "id" : null, "target", "action", "args");
		}
	}
}