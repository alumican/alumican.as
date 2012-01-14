package net.alumican.as3.display
{
	import flash.display.Stage;
	import jp.progression.commands.Command;
	
	/**
	 * IBaseSprite
	 * 
	 * @author Yukiya Okuda<alumican.net>
	 */
	public interface IBaseSprite
	{
		/**
		 * 表示中の場合はtrue
		 */
		function get isShowing():Boolean;
		
		/**
		 * 準備完了している場合はtrue
		 */
		function get isReady():Boolean;
		
		/**
		 * 終了処理
		 */
		function finalize(stage:Stage):*;
		
		/**
		 * リサイズ処理
		 */
		function resize(sw:int, sh:int, useTransition:Boolean = true):*;
		
		/**
		 * データの読み込み処理
		 */
		function ready():Command;
		
		/**
		 * 表示する
		 */
		function show(useTransition:Boolean = true, execute:Boolean = true):Command;
		
		/**
		 * 非表示にする
		 */
		function hide(useTransition:Boolean = true, execute:Boolean = true):Command;
		
		/**
		 * 一時停止する
		 */
		function pause(useTransition:Boolean = true, execute:Boolean = true):Command;
		
		/**
		 * 再開する
		 */
		function resume(useTransition:Boolean = true, execute:Boolean = true):Command;
	}
}