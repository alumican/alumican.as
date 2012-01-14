package
{
	import com.bit101.components.Label;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import net.alumican.as3.algorithm.kmeans.KMeans2;
	
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
		
		private var _K:int;
		private var _N:int;
		
		
		
		
		
		//----------------------------------------
		//STAGE INSTANCES
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * Constructor
		 */
		[SWF(width="800", height="600", backgroundColor="x0xffffff", frameRate="30")]
		public function exp01():void
		{
			new Label(this, 0, 0,
				"CLICK    : resampling\n" +
				"RIGHT Key: cluster + 1\n" +
				"LEFT  Key: cluster - 1\n" +
				"UP    Key: sample + 100\n" +
				"DOWN  Key: sample - 100"
			);
			
			stage.addEventListener(MouseEvent.CLICK, _stageMouseClickHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _stageKeyDownhandler);
			
			_K = 3;
			_N = 500;
			_run(_K, _N);
		}
		
		private function _stageKeyDownhandler(e:KeyboardEvent):void 
		{
			switch (e.keyCode)
			{
				case Keyboard.RIGHT:
					_K = Math.min(6, _K + 1);
					_run(_K, _N);
					break;
				
				case Keyboard.LEFT:
					_K = Math.max(2, _K - 1);
					_run(_K, _N);
					break;
				
				case Keyboard.UP:
					_N = Math.min(2000, _N + 100);
					_run(_K, _N);
					break;
				
				case Keyboard.DOWN:
					_N = Math.max(100, _N - 100);
					_run(_K, _N);
					break;
			}
		}
		
		private function _stageMouseClickHandler(e:MouseEvent):void 
		{
			_run(_K, _N);
		}
		
		private function _run(k:int, n:int):void
		{
			var datas:Vector.<Point> = _createSamples(k, n);
			var km:KMeans2 = new KMeans2();
			km.calc(datas, k);
			_plot(km);
		}
		
		private function _createSamples(k:int, n:int):Vector.<Point>
		{
			var datas:Vector.<Point> = new Vector.<Point>();
			var m:Point;
			var s:Point;
			var p:Point;
			var i:int;
			var j:int;
			
			for (i = 0; i < k; ++i)
			{
				m = new Point(
					Math.random() * (stage.stageWidth  - 100) + 50,
					Math.random() * (stage.stageHeight - 100) + 50
				);
				s = new Point(50, 50);
				for (j = 0; j < n; ++j)
				{
					p = new Point(_gauss(m.x, s.x), _gauss(m.y, s.y));
					datas.push(p);
				}
			}
			return datas;
		}
		
		private function _gauss(m:Number, s:Number):Number
		{
			var a:Number = 0;
			var i:int;
			for (i = 0; i < 12; ++i) a += Math.random();
			return (a - 6) * s + m;
		}
		
		private function _plot(km:KMeans2):void
		{
			var datas:Vector.<Point> = km.datas;
			var labels:Vector.<int>  = km.labels;
			var means:Vector.<Point> = km.means;
			var counts:Vector.<int>  = km.counts;
			var k:int                = km.k;
			var n:int                = km.n;
			
			var colors:Vector.<uint> = Vector.<uint>([0xff0000, 0x0000ff, 0x00ff00, 0x00ffff, 0xff00ff, 0xffff00]);
			var g:Graphics = graphics;
			
			var i:int;
			var l:int;
			var p:Point;
			var px:Number;
			var py:Number;
			
			trace("----------");
			trace("k: " + k);
			trace("n: " + n);
			
			g.clear();
			for (i = 0; i < n; ++i)
			{
				p = datas[i];
				l = labels[i];
				g.beginFill(colors[l]);
				g.drawCircle(p.x, p.y, 1);
				g.endFill();
			}
			
			g.lineStyle(2, 0x0);
			for (i = 0; i < k; ++i)
			{
				p = means[i];
				px = p.x;
				py = p.y;
				g.moveTo(px - 4, py);
				g.lineTo(px + 4, py);
				g.moveTo(px, py - 4);
				g.lineTo(px, py + 4);
				
				trace("label[" + i + "]: " + counts[i] + ", (" + px + ", " + py + ")");
			}
		}
	}
}