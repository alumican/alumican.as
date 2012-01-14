package net.alumican.component.imageslice
{
	import com.adobe.images.PNGEncoder;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	
	/**
	 * ImageSlice_live
	 * 
	 * @author Yukiya Okuda<alumican.net>
	 */
	public class ImageSlice_live extends Sprite
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * ファイル名
		 */
		[Inspectable(defaultValue = "image", name = "File Name")]
		public function get filename():String { return _filename; }
		public function set filename(value:String):void { _filename = value; }
		private var _filename:String;
		
		override public function get x():Number { return super.x; }
		override public function set x(value:Number):void { super.x = Math.round(value); }
		
		override public function get y():Number { return super.y; }
		override public function set y(value:Number):void { super.y = Math.round(value); }
		
		override public function get width():Number { return _area.width; }
		override public function set width(value:Number):void { _area.width = value; }
		
		override public function get height():Number { return _area.height; }
		override public function set height(value:Number):void { _area.height = value; }
		
		override public function get scaleX():Number { return _area.scaleX; }
		override public function set scaleX(value:Number):void { _area.scaleX = value; }
		
		override public function get scaleY():Number { return _area.scaleY; }
		override public function set scaleY(value:Number):void { _area.scaleY = value; }
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		/**
		 * ファイル名
		 */
		public var _filenameField:TextField;
		
		/**
		 * スライス領域
		 */
		public var _area:Sprite;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function ImageSlice_live():void
		{
			trace("construct");
			
			//右クリックメニュー
			var context:ContextMenu = new ContextMenu();
			_addContextMenuItem(context, "このスライスを書き出す", _contexrSaveImageHandler);
			_addContextMenuItem(context, "全てのスライスを書き出す", _contexrSaveAllImagesHandler);
			contextMenu = context;
		}
		
		private function _addContextMenuItem(context:ContextMenu, caption:String, listener:Function = null, separatorBefore:Boolean = false, enabled:Boolean = true, visible:Boolean = true):ContextMenuItem
		{
			var item:ContextMenuItem = new ContextMenuItem(caption, separatorBefore, enabled, visible);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, listener);
			context.customItems.push(item);
			return item;
		}
		
		private function _contexrSaveImageHandler(e:ContextMenuEvent):void
		{
			trace("このスライスを書き出す");
			save();
		}
		
		private function _contexrSaveAllImagesHandler(e:ContextMenuEvent):void
		{
			trace("全てのスライスを書き出す");
		}
		
		public function saveAll(container:DisplayObjectContainer):void
		{
		}
		
		/**
		 * 画像の保存
		 */
		public function save():void
		{
			if (!parent) return;
			
			var data:BitmapData;
			var byte:ByteArray;
			try
			{
				visible = false;
				var matrix:Matrix = transform.matrix;
				matrix.invert();
				data = new BitmapData(width, height, true, 0x0);
				data.draw(parent, matrix, null, null, new Rectangle(0, 0, data.width, data.height), true);
				byte = PNGEncoder.encode(data);
				new FileReference().save(byte, _filename + ".png");
			}
			catch (error:Error)
			{
				trace("SliceImage: save failure, " + _filename);
			}
			finally
			{
				if (data) data.dispose();
				if (byte) byte.clear();
				visible = true;
			}
		}
	}
}