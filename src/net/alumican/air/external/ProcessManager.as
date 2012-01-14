package net.alumican.air.external
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	/**
	 * 外部プロセスの起動と終了
	 */
	public class ProcessManager
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * プロセスid
		 */
		public function get id():String { return _id; }
		private var _id:String;
		
		/**
		 * 現在プロセスが起動していればtrue
		 */
		public function get isRunning():Boolean { return _process ? _process.running : false; }
		
		/**
		 * プロセス
		 */
		public function get process():NativeProcess { return _process; }
		private var _process:NativeProcess;
		
		/**
		 * プロセスの起動情報
		 */
		public function get startupInfo():NativeProcessStartupInfo { return _startupInfo; }
		private var _startupInfo:NativeProcessStartupInfo;
		
		/**
		 * コールバック
		 */
		public var onExit:Function;
		public var onStandardOutputData:Function;
		public var onStandardErrorData:Function;
		public var onStandardOutputIOError:Function;
		public var onStandardErrorIOError:Function;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 * @param	executablePath
		 * @param	args
		 * @param	workingDirectoryPath
		 */
		public function ProcessManager(id:String, executablePath:String, args:Vector.<String> = null, workingDirectoryPath:String = null):void
		{
			_id = id;
			
			//プロセス情報の生成
			_startupInfo                  = new NativeProcessStartupInfo();
			_startupInfo.executable       = new File(executablePath);
			_startupInfo.workingDirectory = new File(workingDirectoryPath ? workingDirectoryPath : File.applicationStorageDirectory.nativePath);
			_startupInfo.arguments        = args;
			
			//プロセスの生成
			_process = new NativeProcess();
			_process.addEventListener(NativeProcessExitEvent.EXIT          , _processExitHandler);
			_process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA   , _processStandardOutputDataHandler);
			_process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA    , _processStandardErrorDataHandler);
			_process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, _processStandardOutputIOErrorHandler);
			_process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR , _processStandardErrorIOErrorHandler);
		}
		
		/**
		 * プロセスの起動
		 * @return
		 */
		public function start():Boolean
		{
			try
			{
				_process.start(_startupInfo);
			}
			catch (error:IllegalOperationError)
			{
				trace("[ERROR] ProcessManager : (Illegal Operation) " + error.toString());
				return false;
			}
			catch (error:ArgumentError)
			{
				trace("[ERROR] ProcessManager : (Argument Error) " + error.toString());
				return false;
			}
			catch (error:Error)
			{
				trace("[ERROR] ProcessManager : (Error) " + error.toString());
				return false;
			}
			
			if (!_process.running) return false;
			
			return true;
		}
		
		/**
		 * プロセスの終了
		 */
		public function exit():void
		{
			if (_process)
			{
				_process.exit();
			}
			else
			{
				_dispose();
			}
		}
		
		/**
		 * 破棄
		 */
		private function _dispose():void
		{
			if (_process)
			{
				_process.removeEventListener(NativeProcessExitEvent.EXIT, _processExitHandler);
				_process = null;
			}
			
			if (_startupInfo)
			{
				_startupInfo = null;
			}
		}
		
		
		
		
		
		//----------------------------------------
		//EVENT HANDLERS
		
		/**
		 * プロセスの終了ハンドラ
		 * @param	e
		 */
		private function _processExitHandler(e:NativeProcessExitEvent):void 
		{
			e.target.removeEventListener(e.type, arguments.callee);
			
			//リストから削除
			if (_processManagerList[_id]) delete _processManagerList[_id];
			
			//イベントの発行
			if (onExit != null) onExit(e);
			
			//破棄
			_dispose();
		}
		
		/**
		 * プロセスの標準出力ハンドラ
		 * @param	e
		 */
		private function _processStandardOutputDataHandler(e:ProgressEvent):void 
		{
			//イベントの発行
			if (onStandardOutputData != null) onStandardOutputData(e);
		}
		
		/**
		 * プロセスの標準エラーハンドラ
		 * @param	e
		 */
		private function _processStandardErrorDataHandler(e:ProgressEvent):void 
		{
			//イベントの発行
			if (onStandardErrorData != null) onStandardErrorData(e);
		}
		
		/**
		 * プロセスのIOエラーハンドラ
		 * @param	e
		 */
		private function _processStandardOutputIOErrorHandler(e:IOErrorEvent):void 
		{
			//イベントの発行
			if (onStandardOutputIOError != null) onStandardOutputIOError(e);
		}
		
		/**
		 * プロセスのIOエラーハンドラ
		 * @param	e
		 */
		private function _processStandardErrorIOErrorHandler(e:IOErrorEvent):void
		{
			//イベントの発行
			if (onStandardErrorIOError != null) onStandardErrorIOError(e);
		}
		
		
		
		
		
		//----------------------------------------
		//STATIC VARIABLES
		
		/**
		 * ProcessManagerリスト
		 */
		static public function getProcessManagerById(id:String):ProcessManager { return _processManagerList[id]; }
		static private var _processManagerList:Dictionary;
		
		/**
		 * プロセス起動がサポートされていればtrue
		 */
		static public function get isSupported():Boolean { return NativeProcess.isSupported; }
		
		
		
		
		
		//----------------------------------------
		//STATIC METHODS
		
		/**
		 * プロセスの起動
		 * @param	id
		 * @param	executablePath
		 * @param	args
		 * @param	workingDirectoryPath
		 * @return
		 */
		static public function executeNativeProcess(id:String, executablePath:String, args:Vector.<String> = null, workingDirectoryPath:String = null):ProcessManager 
		{
			if (!_processManagerList) _processManagerList = new Dictionary();
			
			//既に同じidのプロセスが登録されている場合は既存のを返す
			if (_processManagerList[id]) return ProcessManager(_processManagerList[id]);
			
			//プロセスの生成
			var manager:ProcessManager = new ProcessManager(id, executablePath, args, workingDirectoryPath);
			
			//リストに登録
			if (manager) _processManagerList[id] = manager;
			
			return manager;
		}
		
		/**
		 * プロセスの終了
		 * @param	id
		 * @return
		 */
		static public function exitNativeProcess(id:String):Boolean 
		{
			//リストにない場合は何もしない
			if (!_processManagerList || !_processManagerList[id]) return false;
			
			//プロセスの終了
			ProcessManager(_processManagerList[id]).exit();
			
			return true;
		}
	}
}