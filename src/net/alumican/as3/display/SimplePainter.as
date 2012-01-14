package net.alumican.as3.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	
	/**
	 * SimplePainter
	 * 
	 * @author Yukiya Okuda
	 */
	public class SimplePainter extends Sprite
	{
		private var _stage:Stage;
		
		private var _canvas:Shape;
		private var _pen:Shape;
		
		private var _cover:Sprite;
		
		private var _isDrawing:Boolean;
		
		public function get color():int { return _color; }
		public function set color(value:int):void { if (value == _color) return; _color = value; _updatePen(); }
		private var _color:int;
		
		public function get mode():String { return _mode; }
		public function set mode(value:String):void { if (value == _mode) return; _mode = value; _updateMode(); }
		private var _mode:String;
		
		public function get thickness():int { return _thickness; }
		public function set thickness(value:int):void { if (value == _thickness) return; _thickness = value; _updatePen(); }
		private var _thickness:int;
		
		
		
		
		
		public function SimplePainter(color:int = 0xff0000, thickness:int = 3):void
		{
			_cover = addChild( new Sprite() ) as Sprite;
			_canvas = addChild( new Shape() ) as Shape;
			_pen = new Shape();
			
			_mode = "none";
			_cover.visible = false;
			this.color = color;
			this.thickness = thickness;
			
			//mouseEnabled = mouseChildren = false;
			
			_cover.addEventListener(MouseEvent.CLICK, _nullHandler);
			
			addEventListener(Event.ADDED_TO_STAGE, _init);
		}
		
		private function _nullHandler(e:MouseEvent):void 
		{
		}
		
		private function _init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, _init);
			
			_stage = stage;
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, _startDraw);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, _update);
			_stage.addEventListener(Event.RESIZE, _resize);
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, _keyDownHandler);
			
			_resize(null);
		}
		
		private function _resize(e:Event):void 
		{
			var g:Graphics = _cover.graphics;
			g.clear();
			g.beginFill(0x0, 0);
			g.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
			g.endFill();
		}
		
		private function _keyDownHandler(e:KeyboardEvent):void 
		{
			//if (!e.ctrlKey) return;
			
			//var tf:TextField = addChild( new TextField() ) as TextField;
			//tf.text = e.keyCode.toString();
			//trace(e.keyCode);
			
			switch (e.keyCode)
			{
				case 80:
					mode = (mode == "pen") ? "none" : "pen";
					break;
				
				case 67:
					if (mode == "pen") clear();
					break;
			}
		}
		
		private function _updateMode():void
		{
			if (_mode == "pen")
			{
				addChild(_pen);
				_pen.x = mouseX;
				_pen.y = mouseY;
				visible = true;
			//	_canvas.visible = true;
				Mouse.hide();
			}
			else
			{
				removeChild(_pen);
				visible = false;
			//	_canvas.visible = false;
				Mouse.show();
			}
		}
		
		private function _updatePen():void
		{
			var g:Graphics = _pen.graphics;
			g.clear();
			g.beginFill(_color, 1);
			g.drawCircle(0, 0, _thickness);
			
			_canvas.graphics.lineStyle(_thickness, _color, 1);
		}
		
		private function _startDraw(e:MouseEvent):void 
		{
			if (_mode != "pen") return;
			
			if (_isDrawing) return;
			_isDrawing = true;
			
			color = _color;
			
			var g:Graphics = _canvas.graphics;
			g.moveTo(mouseX, mouseY);
			
			_stage.addEventListener(MouseEvent.MOUSE_UP, _stopDraw);
		}
		
		private function _stopDraw(e:MouseEvent):void 
		{
			if (!_isDrawing) return;
			_isDrawing = false;
			
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _stopDraw);
		}
		
		private function _update(e:MouseEvent):void 
		{
			if (_mode != "pen") return;
			_pen.x = mouseX;
			_pen.y = mouseY;
			
			if (!_isDrawing) return;
			
			var g:Graphics = _canvas.graphics;
			g.lineTo(mouseX, mouseY);
		}
		
		public function clear():void
		{
		//	return;
			
			var g:Graphics = _canvas.graphics;
			g.clear();
			
			_updatePen();
		}
	}
}