package net.alumican.as3.framework.progression4.commands
{
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;
	import org.libspark.betweenas3.events.TweenEvent;
	import org.libspark.betweenas3.tweens.ITween;
	
	/**
	 * BetweenAS3 を実行するコマンド
	 */
	public class DoBetweenAS3 extends Command
	{
		/**
		 * 実行Tween
		 */
		public function get tween():ITween { return _tween; }
		public function set tween(value:ITween):void { _tween = value; }
		private var _tween:ITween;
		
		/**
		 * トランジションを使用する場合はtrue
		 */
		public function get useTransition():Boolean { return _useTransition; }
		public function set useTransition(value:Boolean):void { _useTransition = value; }
		private var _useTransition:Boolean;
		
		/**
		 * コンストラクタ
		 */
		public function DoBetweenAS3(tween:ITween, useTransition:Boolean = true, initObject:Object = null):void
		{
			super(_execute, _interrupt, initObject);
			
			_tween = tween;
			_useTransition = useTransition;
		}
		
		/**
		 * 実行関数
		 */
		private function _execute():void
		{
			if (_useTransition && _tween.duration > 0)
			{
				//トランジションあり
				_tween.addEventListener(TweenEvent.COMPLETE, _completeHandler);
				_tween.play();
			}
			else
			{
				//トランジションなし
				_tween.gotoAndStop(_tween.duration);
				_tween.dispatchEvent( new TweenEvent(TweenEvent.COMPLETE) );
				if (_tween.onComplete != null) _tween.onComplete.apply(this, _tween.onCompleteParams);
				_completeHandler(null);
			}
		}
		
		/**
		 * トゥイーン完了時の処理
		 */
		private function _completeHandler(evt:TweenEvent):void
		{
			_tween.removeEventListener(TweenEvent.COMPLETE, _completeHandler);
			executeComplete();
		}
		
		/**
		 * 割り込み関数
		 */
		private function _interrupt():void
		{
			_tween.removeEventListener(TweenEvent.COMPLETE, _completeHandler);
			_tween.stop();
		}
		
		/**
		 * クローンする
		 */
		override public function clone():Command
		{
			return new DoBetweenAS3(_tween.clone(), _useTransition, this);
		}
		
		/**
		 * ストリング表現を取得する
		 */
		override public function toString():String
		{
			return ObjectUtil.formatToString(this, super.className, super.id ? "id" : null, "tween", "useTransition");
		}
	}
}