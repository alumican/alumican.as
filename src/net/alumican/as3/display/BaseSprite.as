package net.alumican.as3.display
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import jp.progression.commands.Command;
	import jp.progression.commands.Func;
	import jp.progression.commands.Listen;
	import jp.progression.commands.lists.SerialList;
	import jp.progression.commands.Prop;
	import jp.progression.executors.ExecutorObjectState;
	import net.alumican.as3.profiler.logger.Logger;
	
	/**
	 * BaseSprite
	 * 
	 * @author Yukiya Okuda<alumican.net>
	 */
	public class BaseSprite extends MovieClip implements IBaseSprite
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		static public const READY:String = "ready";
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 表示中の場合はtrue
		 */
		public function get isShowing():Boolean { return _isShowing; }
		protected var _isShowing:Boolean;
		
		/**
		 * 準備完了している場合はtrue
		 */
		public function get isReady():Boolean { return _isReady; }
		protected var _isReady:Boolean;
		
		public function get isReadyProgress():Boolean { return _isReadyProgress; }
		protected var _isReadyProgress:Boolean;
		
		/**
		 * 一時停止中はtrue
		 */
		public function get isPausing():Boolean { return _isPausing; }
		protected var _isPausing:Boolean;
		
		/**
		 * 表示用コマンド
		 */
		protected var _showCommand:Command;
		protected var _pauseCommand:Command;
		protected var _readyCommand:Command;
		
		/**
		 * this参照
		 */
		protected var _this:BaseSprite;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function BaseSprite():void 
		{
			_isShowing = true;
			_isPausing = false;
			_isReady   = false;
			_this      = this;
		}
		
		
		
		
		
		/**
		 * 初期化処理
		 */
		/*
		public function initialize():*
		{
			return this;
		}
		*/
		
		/**
		 * 終了処理
		 */
		public function finalize(stage:Stage):*
		{
			_isReady = false;
			
			if (_showCommand)
			{
				if (_showCommand.state == ExecutorObjectState.EXECUTING) _showCommand.interrupt(true);
				_showCommand = null;
			}
			
			if (_pauseCommand)
			{
				if (_pauseCommand.state == ExecutorObjectState.EXECUTING) _pauseCommand.interrupt(true);
				_pauseCommand = null;
			}
			
			if (_readyCommand)
			{
				if (_readyCommand.state == ExecutorObjectState.EXECUTING) _readyCommand.interrupt(true);
				_readyCommand = null;
			}
			
			return this;
		}
		
		/**
		 * リサイズ処理
		 */
		public function resize(sw:int, sh:int, useTransition:Boolean = true):*
		{
			return this;
		}
		
		/**
		 * データの読み込み処理
		 */
		public function ready():Command
		{
			//読み込み済み
			if (_isReady)
			{
				return new Func(dispatchEvent, [new Event(READY)]);
			}
			
			//読み込み中
			if (_isReadyProgress)
			{
				return new Listen(this, READY);
			}
			
			//読み込み開始
			_readyCommand = new SerialList(null,
				function():void
				{
					_isReadyProgress = true;
				},
				_readyProcess(),
				function():void
				{
					_isReadyProgress = false;
					_isReady = true;
					Logger.info("ready : " + _this);
					dispatchEvent(new Event(READY));
				}
			);
			return _readyCommand;
		}
		
		
		
		
		
		/**
		 * 表示する
		 */
		public function show(useTransition:Boolean = true, execute:Boolean = true):Command
		{
			if (_isShowing) return new Command();
			_isShowing = true;
			
			if (_showCommand && _showCommand.state == ExecutorObjectState.EXECUTING) _showCommand.interrupt(true);
			_showCommand = _showProcess(useTransition);
			if (execute) _showCommand.execute();
			
			return _showCommand;
		}
		
		/**
		 * 非表示にする
		 */
		public function hide(useTransition:Boolean = true, execute:Boolean = true):Command
		{
			if (!_isShowing) return new Command();
			_isShowing = false;
			
			if (_showCommand && _showCommand.state == ExecutorObjectState.EXECUTING) _showCommand.interrupt(true);
			_showCommand = _hideProcess(useTransition);
			if (execute) _showCommand.execute();
			
			return _showCommand;
		}
		
		/**
		 * 一時停止する
		 */
		public function pause(useTransition:Boolean = true, execute:Boolean = true):Command
		{
			if (!_isShowing) return new Command();
			
			if (_isPausing) return new Command();
			_isPausing = true;
			
			if (_pauseCommand && _pauseCommand.state == ExecutorObjectState.EXECUTING) _pauseCommand.interrupt(true);
			_pauseCommand = _pauseProcess(useTransition);
			if (execute) _pauseCommand.execute();
			
			return _pauseCommand;
		}
		
		/**
		 * 再開する
		 */
		public function resume(useTransition:Boolean = true, execute:Boolean = true):Command
		{
			if (!_isShowing) return new Command();
			
			if (!_isPausing) return new Command();
			_isPausing = false;
			
			if (_pauseCommand && _pauseCommand.state == ExecutorObjectState.EXECUTING) _pauseCommand.interrupt(true);
			_pauseCommand = _resumeProcess(useTransition);
			if (execute) _pauseCommand.execute();
			
			return _pauseCommand;
		}
		
		
		
		
		
		
		/**
		 * 表示コマンドを取得する
		 */
		protected function _showProcess(useTransition:Boolean = true):Command
		{
			return new Prop(this, { visible : true } );
		}
		
		/**
		 * 非表示コマンドを取得する
		 */
		protected function _hideProcess(useTransition:Boolean = true):Command
		{
			return new Prop(this, { visible : false } );
		}
		
		/**
		 * 一時停止コマンドを取得する
		 */
		protected function _pauseProcess(useTransition:Boolean = true):Command
		{
			return new Command();
		}
		
		/**
		 * 再開コマンドを取得する
		 */
		protected function _resumeProcess(useTransition:Boolean = true):Command
		{
			return new Command();
		}
		
		/**
		 * 準備コマンドを取得する
		 */
		protected function _readyProcess():Command
		{
			return new Command();
		}
	}
}