package net.alumican.as3.framework.progression4.pages
{
	import flash.display.DisplayObject;
	import jp.progression.casts.CastSprite;
	import jp.progression.commands.Break;
	import jp.progression.commands.Command;
	import jp.progression.commands.CommandList;
	import jp.progression.commands.lists.SerialList;
	import jp.progression.commands.Prop;
	import net.alumican.as3.framework.progression4.events.ActionEvent;
	import net.alumican.as3.framework.progression4.events.DisplayEvent;
	
	/**
	 * 汎用ビューオブジェクト
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class GeneralViewSprite extends CastSprite
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 現在表示中であればtrue
		 */
		public function get isShowing():Boolean { return _isShowing; }
		protected var _isShowing:Boolean;
		
		/**
		 * 表示コマンド
		 */
		public function get showCommandImpl():Function { return __showCommandImpl || _showCommandImpl; }
		public function set showCommandImpl(value:Function):void { __showCommandImpl = value; }
		private var __showCommandImpl:Function;
		
		/**
		 * 非表示コマンド
		 */
		public function get hideCommandImpl():Function { return __hideCommandImpl || _hideCommandImpl; }
		public function set hideCommandImpl(value:Function):void { __hideCommandImpl = value; }
		private var __hideCommandImpl:Function;
		
		/**
		 * カスタムアクションコマンド
		 */
		public function get doActionCommandImpl():Function { return __doActionCommandImpl || _doActionCommandImpl; }
		public function set doActionCommandImpl(value:Function):void { __doActionCommandImpl = value; }
		private var __doActionCommandImpl:Function;
		
		/**
		 * トランジション実行中であればtrue
		 */
		public function get isShowProcessing():Boolean { return _isShowProcessing; }
		public function get isHideProcessing():Boolean { return _isHideProcessing; }
		private var _isShowProcessing:Boolean;
		private var _isHideProcessing:Boolean;
		
		/**
		 * thisポインタ
		 */
		public function get instance():DisplayObject { return _instance; }
		private var _instance:DisplayObject;
		
		
		
		
		
		//----------------------------------------
		//METHODS AS PUBLIC
		
		/**
		 * コンストラクタ
		 */
		public function GeneralViewSprite(id:String = null, initObject:Object = null):void
		{
			this.id = id;
			_instance = this;
			_isShowing = true;
			_isShowProcessing = false;
			_isHideProcessing = false;
			super(initObject);
		}
		
		/**
		 * 表示コマンド
		 */
		public function getShowCommand(useTween:Boolean = true, args:Array = null):Command
		{
			return new SerialList(null,
				
				//前処理
				function():void
				{
					if (_isShowing)
					{
						CommandList(this.parent).insertCommand( new Break() );
						return;
					}
					else
					{
						_isShowing = true;
						_isShowProcessing = true;
						dispatchEvent( new DisplayEvent(DisplayEvent.SHOW_START, false, false) );
					}
				},
				
				//トランジション
				showCommandImpl(useTween, (args != null) ? args : []),
				
				//後処理
				function():void
				{
					if (_isShowing)
					{
						_isShowProcessing = false;
						dispatchEvent( new DisplayEvent(DisplayEvent.SHOW_COMPLETE, false, false) );
					}
				}
			);
		}
		
		/**
		 * 非表示コマンド
		 */
		public function getHideCommand(useTween:Boolean = true, args:Array = null):Command
		{
			return new SerialList(null,
				
				//前処理
				function():void
				{
					if (!_isShowing)
					{
						CommandList(this.parent).insertCommand( new Break() );
						return;
					}
					else
					{
						_isShowing = false;
						_isHideProcessing = true;
						dispatchEvent( new DisplayEvent(DisplayEvent.HIDE_START, false, false) );
					}
				},
				
				//トランジション
				hideCommandImpl(useTween, (args != null) ? args : []),
				
				//後処理
				function():void
				{
					if (!_isShowing)
					{
						_isHideProcessing = false;
						dispatchEvent( new DisplayEvent(DisplayEvent.HIDE_COMPLETE, false, false) );
					}
				}
			);
		}
		
		/**
		 * カスタムアクションコマンド
		 */
		public function getDoActionCommand(action:String, args:Array = null):Command
		{
			return new SerialList(null,
				
				//前処理
				function():void
				{
					dispatchEvent( new ActionEvent(ActionEvent.START, false, false) );
				},
				
				//カスタムアクション
				doActionCommandImpl(action, (args != null) ? args : []),
				
				//後処理
				function():void
				{
					dispatchEvent( new ActionEvent(ActionEvent.COMPLETE, false, false) );
				}
			);
		}
		
		
		
		
		
		/**
		 * 表示
		 */
		public function show(useTween:Boolean = true, args:Array = null):void
		{
			getShowCommand(useTween, args).execute();
		}
		
		/**
		 * 非表示
		 */
		public function hide(useTween:Boolean = true, args:Array = null):void
		{
			getHideCommand(useTween, args).execute();
		}
		
		/**
		 * カスタムアクション
		 */
		public function doAction(action:String, args:Array = null):void
		{
			getDoActionCommand(action, args).execute();
		}
		
		
		
		
		
		//----------------------------------------
		//METHODS AS OVERRIDED
		
		/**
		 * 表示コマンド
		 */
		protected function _showCommandImpl(useTween:Boolean, args:Array):Command
		{
			return new Prop(this, { visible : true } );
		}
		
		/**
		 * 非表示コマンド
		 */
		protected function _hideCommandImpl(useTween:Boolean, args:Array):Command
		{
			return new Prop(this, { visible : false } );
		}
		
		/**
		 * カスタムアクションコマンド
		 */
		protected function _doActionCommandImpl(action:String, args:Array):Command
		{
			var func:Function = this[action];
			if (func == null)
			{
				throw new ArgumentError("GeneralViewSprite#_doActionCommand : 関数 " + action + "はインスタンスID " + id + " 内に定義されていないため実行できませんでした");
			}
			return func.apply(null, (args.length > 0) ? args : null);
		}
	}
}
