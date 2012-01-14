package
{
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import net.alumican.as3.algorithm.random.SFMT;
	
	/**
	 * exp01
	 * 
	 * @author Yukiya Okuda <alumican.net>
	 */
	public class exp01 extends Sprite
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * Constructor
		 */
		[SWF(width="900", height="800", backgroundColor="x0xffffff", frameRate="30")]
		public function exp01():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var list:Array = [
				{ f : ""             , a : null },
				{ f : "nextUnif"     , a : null },
				{ f : "nextInt"      , a : null },
				{ f : "nextUint"     , a : ["n", [0, 100]] },
				{ f : "nextBit"      , a : null },
				{ f : "nextByte"     , a : null },
				{ f : "nextIntEx"    , a : ["range", [0, 100]] },
				{ f : "nextChisq"    , a : ["n", [0, 1]] },
				{ f : "nextGamma"    , a : ["a", [0, 1]] },
				{ f : "nextGeometric", a : ["p", [0, 1]] },
				{ f : "nextTriangle" , a : null },
				{ f : "nextExp"      , a : null },
				{ f : "nextNormal"   , a : null },
			//	{ f : "nextUnitVect" , a : ["n", [1, 3]] },
				{ f : "nextBinomial" , a : ["n", [0, 50], "p", [0, 1]] },
			//	{ f : "nextBinormal" , a : ["r", [0, 1]] },
				{ f : "nextBeta"     , a : ["a", [0, 1], "b", [0, 1]] },
				{ f : "nextPower"    , a : ["n", [0, 1]] },
				{ f : "nextLogistic" , a : null },
				{ f : "nextCauchy"   , a : null },
				{ f : "nextFDist"    , a : ["n1", [0, 1], "n2", [0, 1]] },
				{ f : "nextPoisson"  , a : ["lambda", [0, 1]] },
				{ f : "nextTDist"    , a : ["n", [0, 1]] },
				{ f : "nextWeibull"  , a : ["alpha" , [0, 1]] }
			];
			
			var ox:int = 20;
			var oy:int = 20;
			var mx:int = 50;
			var my:int = 100;
			var x:int = ox;
			var y:int = oy;
			var w:int = 100;
			var h:int = 100;
			var n:int = list.length;
			for (var i:int = 0; i < n; ++i)
			{
				_attachBitmap(x, y, w, h, list[i]["f"], list[i]["a"]);
				if (i % 7 == 6)
				{
					x  = ox;
					y += h + my;
				}
				else
				{
					x += w + mx;
				}
			}
		}
		
		private function _attachBitmap(x:int, y:int, w:int, h:int, funcName:String, args:Array):void
		{
			var s:Sprite = Sprite(addChild(new Sprite()));
			
			var image:Sprite = Sprite(s.addChild(new Sprite()));
			image.x = x;
			image.y = y;
			
			var bmd:BitmapData = new BitmapData(w, h, false, 0x0);
			var bmp:Bitmap = Bitmap(image.addChild(new Bitmap(bmd)));
			
			var label:String;
			
			var argLength:int = args == null ? 0 : (args.length / 2);
			
			var sliders:Vector.<HUISlider> = new Vector.<HUISlider>(argLength);
			var nameLabel:Label = new Label(s, x, y + h);
			var timeLabel:Label = new Label(s, x, y + h + 10);
			var rangeLabel:Label = new Label(s, x, y + h + 20);
			
			var func:Function;
			var funcArgs:Array;
			if (funcName == "")
			{
				func = Math.random;
				label = "Math.random";
			}
			else
			{
				var mt:SFMT = new SFMT(1);
				func = mt[funcName];
				label = "MT." + funcName;
			}
			
			if (argLength == 0)
			{
				label += "()";
				funcArgs = null;
			}
			else
			{
				label += "(";
				var argName:String;
				var argRange:Array;
				funcArgs = new Array(argLength);
				for (var i:int = 0; i < argLength; ++i)
				{
					argName = args[i * 2];
					argRange = args[i * 2 + 1];
					funcArgs[i] = (argRange[0] + argRange[1]) * 0.5;
					label += argName;
					if (i < argLength - 1) label += ", ";
					
					var slider:HUISlider = new HUISlider(s, x, y + h + 50 + i * 15, argName);
					_getPlotFunc(slider, i, bmd, func, funcArgs, timeLabel, rangeLabel);
					slider.width = 150;
					slider.value = funcArgs[i];
					slider.minimum = argRange[0];
					slider.maximum = argRange[1];
					sliders[i] = slider;
				}
				label += ")";
			}
			
			nameLabel.text = label;
			
			image.buttonMode = true;
			image.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				_plot(bmd, func, funcArgs, timeLabel, rangeLabel);
			});
			
			_plot(bmd, func, funcArgs, timeLabel, rangeLabel);
		}
		
		private function _getPlotFunc(slider:HUISlider, i:int, bmd:BitmapData, func:Function, funcArgs:Array, timeLabel:Label, rangeLabel:Label):void
		{
			slider.addEventListener(MouseEvent.MOUSE_DOWN, function(e0:MouseEvent):void
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, function(e1:MouseEvent):void
				{
					e1.target.removeEventListener(e1.type, arguments.callee);
					if (funcArgs[i] != slider.value)
					{
						funcArgs[i] = slider.value;
						_plot(bmd, func, funcArgs, timeLabel, rangeLabel);
					}
				});
			});
		}
		
		private function _plot(bmd:BitmapData, func:Function, funcArgs:Array, timeLabel:Label, rangeLabel:Label):void
		{
			var o:Object = _plotBitmapData(bmd, func, funcArgs);
			timeLabel.text = o["time"] + " ms";
			rangeLabel.text = "min : " + String(o["min"]).substr(0, 13) + "\nmax : " + String(o["max"]).substr(0, 13);
		}
		
		private function _plotBitmapData(bmd:BitmapData, func:Function, args:Array):Object
		{
			var i:int;
			var j:int;
			var p:int;
			var value:Number;
			var w:int = bmd.width;
			var h:int = bmd.height;
			var n:int = w * h;
			var datas:Vector.<Number> = new Vector.<Number>(n);
			
			var time:int = getTimer();
			for (i = 0; i < n; ++i)
			{
				datas[i] = func.apply(null, args);
			}
			time = getTimer() - time;
			
			var min:Number = Number.MAX_VALUE;
			var max:Number = Number.MIN_VALUE;
			for (i = 0; i < n; ++i)
			{
				value = datas[i];
				if (value < min) min = value;
				if (value > max) max = value;
			}
			
			bmd.lock();
			bmd.fillRect(bmd.rect, 0x0);
			p = 0;
			for (i = 0; i < h; ++i)
			{
				for (j = 0; j < w; ++j)
				{
					value = datas[p];
					value = _map(value, min, max, 0, 255);
					bmd.setPixel(j, i, (value << 16) | (value << 8) | value);
					++p;
				}
			}
			bmd.unlock();
			
			return { time : time, min : min, max : max };
		}
		
		private function _map(x:Number, srcMin:Number, srcMax:Number, dstMin:Number, dstMax:Number):Number
		{
			//value = value < srcMin ? srcMin : value > srcMax ? srcMax : value;
			return dstMin + (dstMax - dstMin) * (x - srcMin) / (srcMax - srcMin);
		}
	}
}