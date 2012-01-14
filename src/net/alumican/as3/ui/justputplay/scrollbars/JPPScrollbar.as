/**
 * Licensed under the MIT License
 * 
 * Copyright (c) 2009 alumican.net (www.alumican.net) and Spark project (www.libspark.org)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 * In Japanese, http://sourceforge.jp/projects/opensource/wiki/licenses%2FMIT_license
 */
package net.alumican.as3.ui.justputplay.scrollbars {
	
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import net.alumican.as3.ui.justputplay.events.JPPScrollbarEvent;
	import org.libspark.ui.SWFWheel;
	
	
	//SWFWheel (http://www.libspark.org/wiki/SWFWheel)
	
	/**
	 * @eventType net.alumican.as3.ui.justputplay.events.JPPScrollbarEvent.SCROLL_START
	 */
	[Event(name = "onScrollStart", type = "net.alumican.as3.ui.justputplay.events.JPPScrollbarEvent")]
	
	/**
	 * @eventType net.alumican.as3.ui.justputplay.events.JPPScrollbarEvent.SCROLL_PROGRESS
	 */
	[Event(name = "onScrollProgress", type = "net.alumican.as3.ui.justputplay.events.JPPScrollbarEvent")]
	
	/**
	 * @eventType net.alumican.as3.ui.justputplay.events.JPPScrollbarEvent.SCROLL_COMPLETE
	 */
	[Event(name = "onScrollComplete", type = "net.alumican.as3.ui.justputplay.events.JPPScrollbarEvent")]
	
	/**
	 * JPPScrollbar.as
	 * 
	 * <p>ActionScript3.0で簡単に設置できるスクロールバーのコアクラスです. </p>
	 * 
	 * 09.05.18         overShootを切った状態でアローボタンを押し続けた場合にずっとisScrollingプロパティがtrueになる問題を修正
	 * 09.05.18         スクロールの開始時，終了時にイベントを発行するように修正
	 * 09.05.26         baseのスケールが1以外の時にbaseクリックでのスクロール位置が狂う問題を修正
	 * 09.07.28         スクロール進捗時のイベントを追加
	 * 09.07.28         バージョン情報を追加
	 * 09.07.28 1.02    overshootPixelsの値が正しく反映されていなかった問題を解消
	 * 10.05.10 1.03    パッケージを変更
	 *                  継承元をSpriteからEventDispatcherへ変更
	 *                  stageへの参照をコンストラクタもしくはプロパティで渡すように変更
	 * 10.07.04 1.04    MagicMouseの慣性スクロール中にdelta=0のMouseEvent.MOUSE_WHEELイベントが発生する問題に対処
	 *                  SWFWheelを最新版(1.5 pre)に更新
	 * 10.08.02 1.05pre 変数isReadyのgetterを追加
	 *                  destroyメソッドを追加
	 *                  sliderを無効化するときにstopDragするように修正
	 * 10.09.17 1.06pre マウスホイール検出エリア(mouseWheelArea)のgetter/setterを追加
	 *                  destroyメソッドを最適化
	 *                  SWFWheelの使用/不使用を設定できるように変更
	 * 10.09.17 1.06    SWFWheelを最新版(1.5 RC2)に更新
	 * 11.10.14 1.07    sliderよりも下のbase座標をクリックしたとき，slierの下端がマウスに揃うように修正
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 * @link http://alumican.net/
	 */
	
	public class JPPScrollbar extends EventDispatcher {
		
		/*--------------------------------------------------------------------------
		 * VERSION
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>バージョン情報を取得します. </p>
		 */
		public const VERSION:String = "1.07";
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// 初期化に関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * isReady
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>setupが完了している場合はtrueとなります.</p>
		 * <p>falseの場合は全ての動作を受け付けません.</p>
		 */
		public function get isReady():Boolean { return _isReady; }
		private var _isReady:Boolean = false;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * stage
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>stageへの参照を設定します. </p>
		 * <p>JPPScrollbarの動作には, setup関数もしくはstageセッターによってstageへの参照を渡す必要があります. </p>
		 */
		public function get stage():Stage { return _stage; }
		public function set stage(value:Stage):void 
		{
			if (_stage || value == null) return;
			_stage = value;
			
			if (_stage)
			{
				//SWFWheelの初期化
				if (_useSWFWheel) SWFWheel.initialize(_stage);
				
				//マウスホイールの検出エリアが設定されていない場合はstageに設定する
				if (_mouseWheelArea == null) mouseWheelArea = _stage;
				
				//ボタンアクションをバインドする
				up     = up;
				down   = down;
				base   = base;
				slider = slider;
			}
		}
		private var _stage:Stage;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * mouseWheelArea
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>マウスホイールの検出エリアを設定します. </p>
		 * <p>特に指定しない場合, stageが設定されます. </p>
		 */
		public function get mouseWheelArea():InteractiveObject { return _mouseWheelArea; }
		public function set mouseWheelArea(value:InteractiveObject):void 
		{
			if (_mouseWheelArea) _mouseWheelArea.removeEventListener(MouseEvent.MOUSE_WHEEL, _mouseWheelHandler);
			_mouseWheelArea = value;
			if (_mouseWheelArea) _mouseWheelArea.addEventListener(MouseEvent.MOUSE_WHEEL, _mouseWheelHandler);
		}
		private var _mouseWheelArea:InteractiveObject;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * useSWFWheel
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>マウスホイールの検出にSWFWheelを使用するかどうかを設定します. </p>
		 * <p>stageをsetterで設定する場合は, stageを設定する前にこのプロパティを変更する必要があります. </p>
		 * <p>また, stageを設定後はこのプロパティをtrueにすることで自動的にSWFWheelを初期化します. </p>
		 * 
		 * @default true
		 */
		public function get useSWFWheel():Boolean { return _useSWFWheel; }
		public function set useSWFWheel(value:Boolean):void 
		{
			_useSWFWheel = value;
			if (_useSWFWheel && _stage) SWFWheel.initialize(_stage);
		}
		private var _useSWFWheel:Boolean = true;
		
		
		
		
		
		//==========================================================================
		// スクロールバーのパーツとしてバインドされるインスタンスに関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * up
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>上向きアローボタンとしてバインドするインスタンスを設定します. </p>
		 */
		public function get up():Sprite { return _up; }
		public function set up(value:Sprite):void {
			_bindArrowUpButton(false);
			_up = value;
			_bindArrowUpButton(true);
		}
		private var _up:Sprite;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * down
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>下向きアローボタンとしてバインドするインスタンスを設定します. </p>
		 */
		public function get down():Sprite { return _down; }
		public function set down(value:Sprite):void {
			_bindArrowDownButton(false);
			_down = value;
			_bindArrowDownButton(true);
		}
		private var _down:Sprite;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * base
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロールエリアとしてバインドするインスタンスを設定します. </p>
		 */
		public function get base():Sprite { return _base; }
		public function set base(value:Sprite):void {
			_bindBaseButton(false);
			_base = value;
			_bindBaseButton(true);
			resizeSlider();
		}
		private var _base:Sprite;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * slider
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダとしてバインドするインスタンスを設定します. </p>
		 */
		public function get slider():Sprite{ return _slider; }
		public function set slider(value:Sprite):void {
			_bindSliderButton(false);
			_slider = value;
			_bindSliderButton(true);
			resizeSlider();
		}
		private var _slider:Sprite;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * isUpPressed
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>上方向アローボタンが現在押下されているかどうかを取得します. </p>
		 */
		public function get isUpPressed():Boolean { return _isUpPressed; }
		private var _isUpPressed:Boolean;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * isDownPressed
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>下方向アローボタンが現在押下されているかどうかを取得します. </p>
		 */
		public function get isDownPressed():Boolean { return _isDownPressed; }
		private var _isDownPressed:Boolean;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * isBasePressed
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロールエリアが現在押下されているかどうかを取得します. </p>
		 */
		public function get isBasePressed():Boolean { return _isBasePressed; }
		private var _isBasePressed:Boolean;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * isSliderPressed
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーが現在押下されているかどうかを取得します. </p>
		 */
		public function get isSliderPressed():Boolean { return _isSliderPressed; }
		private var _isSliderPressed:Boolean;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _isScrollingByUser
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>ユーザアクションによるスクロールが現在進行中であるかどうかを取得します. </p>
		 * <p>スクロールが進行中である場合, trueを返します. </p>
		 */
		private var _isScrollingByUser:Boolean;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// スクロールの対象となるコンテンツに関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * contentSize
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール対象コンテンツの総計サイズを設定します. </p>
		 * <p>このプロパティは伸縮スライドバーを使用する場合のスライドバーのサイズ計算に用いられます. </p>
		 */
		public function get contentSize():Number { return _contentSize; }
		public function set contentSize(value:Number):void {
			_contentSize = value;
			resizeSlider();
		}
		private var _contentSize:Number;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * maskSize
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール対象コンテンツの表示部分のサイズを設定します. </p>
		 * <p>このプロパティは伸縮スライドバーを使用する場合のスライドバーのサイズ計算に用いられます. </p>
		 */
		public function get maskSize():Number { return _maskSize; }
		public function set maskSize(value:Number):void {
			_maskSize = value;
			resizeSlider();
		}
		private var _maskSize:Number;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * isOverFlow
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>contentSizeがmaskSizeよりも大きい場合にtrueを返します. </p>
		 */
		public function get isOverFlow():Boolean { return !_isUnderFlow; }
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * isUnderFlow
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>contentSizeがmaskSize以下の場合にtrueを返します. </p>
		 */
		public function get isUnderFlow():Boolean { return _isUnderFlow; }
		private var _isUnderFlow:Boolean;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _content
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>_content[_key]=propertyを保持している, スクロール対象コンテンツを表します. </p>
		 */
		private var _content:*;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _key
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール対象コンテンツが保持している, スクロールによって実際に変化させたいプロパティ名を表します. </p>
		 */
		private var _key:String;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * property
		 *---------------------------------------------------------------------*//**
		 * @private
		 * 
		 * <p>スクロール対象コンテンツが保持している, スクロールによって実際に変化させたいプロパティ値を設定します. </p>
		 */
		private function get property():Number { return _content[_key]; }
		private function set property(value:Number):void { _content[_key] = value; }
		
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * upperBound
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーが上限に達したときの変化対象プロパティの値を設定します. </p>
		 */
		public function get upperBound():Number { return _upperBound; }
		public function set upperBound(value:Number):void {
			_upperBound = value;
			resizeSlider();
			
			//コンテンツの位置補正
			if ((_upperBound - property) / (_upperBound - _lowerBound) > 1) {
				_terminateScrollFlag = true;
				_targetScroll = _lowerBound;
				property = _lowerBound;
			}
		}
		private var _upperBound:Number;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * lowerBound
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーが下限に達したときの変化対象プロパティの値を設定します. </p>
		 */
		public function get lowerBound():Number { return _lowerBound; }
		public function set lowerBound(value:Number):void {
			_lowerBound = value;
			resizeSlider();
			
			//コンテンツの位置補正
			if ((_upperBound - property) / (_upperBound - _lowerBound) > 1) {
				_terminateScrollFlag = true;
				_targetScroll = _lowerBound;
				property = _lowerBound;
			}
		}
		private var _lowerBound:Number;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// スクロールの基本動作に関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * useSmoothScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>減速スクロールを使用するかどうかを設定します. </p>
		 * <p>使用する場合にはtrueを設定します. </p>
		 * 
		 * @default true
		 */
		public function get useSmoothScroll():Boolean { return _useSmoothScroll; }
		public function set useSmoothScroll(value:Boolean):void {
			_useSmoothScroll = value;
			if (!value && _isScrolling) _startScroll();
		}
		private var _useSmoothScroll:Boolean = true;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * smoothScrollEasing
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>減速スクロールを使用する場合の, 減速の緩やかさを設定します. </p>
		 * <p>1以上の数値を設定し, 数値が大きくなるほど緩やかに戻るようになります.</p>
		 * 
		 * @default 6
		 */
		public function get smoothScrollEasing():Number { return _smoothScrollEasing; }
		public function set smoothScrollEasing(value:Number):void { _smoothScrollEasing = (value < 1) ? 1 : value; }
		private var _smoothScrollEasing:Number = 6;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * isScrolling
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>減速スクロールを使用する場合, 現在スクロールが進行中であるかどうかを取得します. </p>
		 * <p>スクロールが進行中の場合isScrollingプロパティはtrueを返します.</p>
		 */
		public function get isScrolling():Boolean { return _isScrolling; }
		private var _isScrolling:Boolean;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * targetScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>減速スクロールを使用する場合, スクロール完了時に対象プロパティが到達する目標値を表します. </p>
		 */
		public function get targetScroll():Number { return _targetScroll; }
		private var _targetScroll:Number;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _prevProperty
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>減速スクロールを使用する場合, 前フレームで更新した対象プロパティの値を保存します. </p>
		 * <p>Flashの演算精度上の問題により目標スクロール値へ到達できない場合, 減速スクロールを打ち切るために使用します.</p>
		 */
		private var _prevProperty:Number;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _terminateScrollFlag
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール進行中にもかかわらず, 前フレームからプロパティ値が変化していない場合にtrueとなります. </p>
		 * <p>Flashの演算精度上の問題により目標スクロール値へ到達できない場合, 減速スクロールを打ち切るために使用します.</p>
		 */
		private var _terminateScrollFlag:Boolean;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _isStartedScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>前回の終了イベントから，JPPScrollbarEvent.SCROLL_STARTが発行されたかどうかを示します．</p>
		 */
		private var _isStartedScroll:Boolean;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _ticker
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>ENTER_FRAMEイベントを発行させます．</p>
		 */
		/**
		 * 
		 */
		private var _ticker:Shape;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// スライダーに関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * useFlexibleSlider
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>コンテンツ量に応じて伸縮するスライダーを使用するかどうかを設定します. </p>
		 * <p>使用する場合にはtrueを設定します. </p>
		 * 
		 * @default true
		 */
		public function get useFlexibleSlider():Boolean { return _useFlexibleSlider; }
		public function set useFlexibleSlider(value:Boolean):void {
			_useFlexibleSlider = value;
			resizeSlider();
		}
		private var _useFlexibleSlider:Boolean = true;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * minSliderHeight
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>コンテンツ量に応じて伸縮するスライダーを使用する場合, スライダーの最小サイズをピクセル値で設定します. </p>
		 * 
		 * @default 10
		 */
		public function get minSliderHeight():Number { return _minSliderHeight; }
		public function set minSliderHeight(value:Number):void {
			_minSliderHeight = value;
			resizeSlider();
		}
		private var _minSliderHeight:Number = 10;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _useIgnoreSliderHeight
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーの高さを常に0として扱うかどうかを設定します. </p>
		 */
		public function get useIgnoreSliderHeight():Boolean { return _useIgnoreSliderHeight; }
		public function set useIgnoreSliderHeight(value:Boolean):void {
			_useIgnoreSliderHeight = value;
			resizeSlider();
		}
		private var _useIgnoreSliderHeight:Boolean = false;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * sliderHeight
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>useOvershootDeformationSlider=true時のオーバーシュート演出によって変形していないときのスライダーの高さを取得します. </p>
		 */
		public function get sliderHeight():Number { return _sliderHeight; }
		private var _sliderHeight:Number;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _isDragging
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーがユーザによって現在ドラッグされているかどうかを取得します. </p>
		 * <p>ドラッグされている場合, trueを返します. </p>
		 */
		private var _isDragging:Boolean;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _isScrollingByDrag
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>ユーザのスライダードラッグ動作によるスクロールが現在進行中であるかどうかを取得します. </p>
		 * <p>スクロールが進行中である場合, trueを返します. </p>
		 */
		private var _isScrollingByDrag:Boolean;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// スライダーおよび対象プロパティの整数値吸着に関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * usePixelFittingSlider
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール完了時にスライダーをピクセルに吸着させるかどうかを設定します. </p>
		 * <p>吸着させる場合にはtrueを設定します. </p>
		 * 
		 * @default false
		 */
		public function get usePixelFittingSlider():Boolean { return _usePixelFittingSlider; }
		public function set usePixelFittingSlider(value:Boolean):void {
			_usePixelFittingSlider = value;
			if (value && !_isScrolling && !_useIgnoreSliderHeight) {
				_slider.y = Math.round(_slider.y);
				_slider.height = Math.round(_sliderHeight);
			}
		}
		private var _usePixelFittingSlider:Boolean = false;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * usePixelFittingContent
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール完了時に対象プロパティを整数値に吸着させるかどうかを設定します. </p>
		 * <p>吸着させる場合にはtrueを設定します. </p>
		 */
		public function get usePixelFittingContent():Boolean { return _usePixelFittingContent; }
		public function set usePixelFittingContent(value:Boolean):void {
			_usePixelFittingContent = value;
			if (value && !_isScrolling) property = Math.round(property);
		}
		private var _usePixelFittingContent:Boolean = false;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// スクロールバーの有効化/無効化に関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * buttonEnabled
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタン, スライダー, ベースボタンの有効/無効を一括して切り替えます. </p>
		 * <p>ボタンを有効化させる場合はtrueを設定します. </p>
		 * <p>mouseChildrenプロパティは変更されません. </p>
		 * <p>このプロパティは書き込み専用です. </p>
		 * <p>初期設定時にtrueが設定されます. </p>
		 */
		public function set buttonEnabled(value:Boolean):void {
			upEnabled = downEnabled = sliderEnabled = baseEnabled = value;
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * upEnabled
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>上方向アローボタンの有効/無効を切り替えます. </p>
		 * <p>ボタンを有効化させる場合はtrueを設定します. </p>
		 * <p>mouseChildrenプロパティは変更されません. </p>
		 * <p>このプロパティは書き込み専用です. </p>
		 * <p>setup時にtrueが設定されます. </p>
		 */
		public function set upEnabled(value:Boolean):void {
			if (_up) _up.mouseEnabled = _up.buttonMode = value;
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * downEnabled
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>下方向アローボタンの有効/無効を切り替えます. </p>
		 * <p>ボタンを有効化させる場合はtrueを設定します. </p>
		 * <p>mouseChildrenプロパティは変更されません. </p>
		 * <p>このプロパティは書き込み専用です. </p>
		 * <p>setup時にtrueが設定されます. </p>
		 */
		public function set downEnabled(value:Boolean):void {
			if (_down) _down.mouseEnabled = _down.buttonMode = value;
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * sliderEnabled
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーの有効/無効を切り替えます. </p>
		 * <p>ボタンを有効化させる場合はtrueを設定します. </p>
		 * <p>mouseChildrenプロパティは変更されません. </p>
		 * <p>このプロパティは書き込み専用です. </p>
		 * <p>setup時にtrueが設定されます. </p>
		 */
		public function set sliderEnabled(value:Boolean):void {
			if (_slider) {
				_slider.mouseEnabled = _slider.buttonMode = value;
				if (!value) _slider.stopDrag();
			}
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * baseEnabled
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロールエリアの有効/無効を切り替えます. </p>
		 * <p>ボタンを有効化させる場合はtrueを設定します. </p>
		 * <p>mouseChildrenプロパティは変更されません. </p>
		 * <p>このプロパティは書き込み専用です. </p>
		 * <p>setup時にtrueが設定されます. </p>
		 */
		public function set baseEnabled(value:Boolean):void {
			if (_base) _base.mouseEnabled = _base.buttonMode = value;
		}
		
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * useMouseWheel
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>マウスホイールの使用/不使用を切り替えます. </p>
		 * <p>マウスホイールを使用する場合はtrueを設定します. </p>
		 * 
		 * @default	true
		 */
		public function get useMouseWheel():Boolean { return _useMouseWheel; }
		public function set useMouseWheel(value:Boolean):void { _useMouseWheel = value; }
		private var _useMouseWheel:Boolean = true;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// アローボタンのスクロールに関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * arrowScrollAmount
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを1回クリックしたときのスクロール量を設定します. </p>
		 * <p>scrollUp(), scrollDown()メソッドを呼び出した際のスクロール量もこの値に従います. </p>
		 * 
		 * @default	200
		 */
		public function get arrowScrollAmount():Number { return _arrowScrollAmount; }
		public function set arrowScrollAmount(value:Number):void { _arrowScrollAmount = value; }
		private var _arrowScrollAmount:Number = 200;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * useArrowScrollUsingRatio
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>continuousArrowScrollAmountおよびarrowScrollAmountに使用するスクロール単位を切り替えます. </p>
		 * <p>trueの場合はスクロール量をコンテンツ全体に対する割合で設定します(0より大きく1以下の数値). </p>
		 * <p>falseの場合はスクロール量をピクセル数で設定します(0以上の数値). </p>
		 * 
		 * @default	false
		 */
		public function get useArrowScrollUsingRatio():Boolean { return _useArrowScrollUsingRatio; }
		public function set useArrowScrollUsingRatio(value:Boolean):void { _useArrowScrollUsingRatio = value; }
		private var _useArrowScrollUsingRatio:Boolean = false;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * useContinuousArrowScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを押し続けた場合に, 連続スクロールを発生させるかどうかを切り替えます. </p>
		 * <p>連続スクロールを使用する場合はtrueを設定します. </p>
		 * 
		 * @default	true
		 */
		public function get useContinuousArrowScroll():Boolean { return _useContinuousArrowScroll; }
		public function set useContinuousArrowScroll(value:Boolean):void { _useContinuousArrowScroll = value; }
		private var _useContinuousArrowScroll:Boolean = true;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * continuousArrowScrollInterval
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを押し続けた場合に発生する連続スクロールを使用する場合, 連続スクロールが始まるまでの時間(ミリ秒)を設定します．</p>
		 * 
		 * @default	300
		 */
		public function get continuousArrowScrollInterval():uint { return _continuousArrowScrollInterval; }
		public function set continuousArrowScrollInterval(value:uint):void { _continuousArrowScrollInterval = value; }
		private var _continuousArrowScrollInterval:uint = 300;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * continuousArrowScrollAmount
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを押し続けた場合に発生する連続スクロールを使用する場合, 毎フレームのスクロール量を設定します. </p>
		 * 
		 * @default	10
		 */
		public function get continuousArrowScrollAmount():Number { return _continuousArrowScrollAmount; }
		public function set continuousArrowScrollAmount(value:Number):void { _continuousArrowScrollAmount = value; }
		private var _continuousArrowScrollAmount:Number = 10;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _continuousArrowScrollTimer
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを押し続けた場合に発生する連続スクロールを使用する場合, 連続スクロールが発生するまでのタイムラグを管理するためのTimerです. </p>
		 */
		private var _continuousArrowScrollTimer:Timer;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// オーバーシュート演出に関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * useOvershoot
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オーバーシュート(iPhoneのように, 端まで行くとちょっと行き過ぎて戻る演出)を加えるかどうかを切り替えます. </p>
		 * <p>オーバーシュートを使用する場合はtrueを設定します. </p>
		 * 
		 * @default	false
		 */
		public function get useOvershoot():Boolean { return _useOvershoot; }
		public function set useOvershoot(value:Boolean):void { _useOvershoot = value; }
		private var _useOvershoot:Boolean = false;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * overshootPixels
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オーバーシュートを使用する場合, オーバーシュートの最大行き過ぎ量をピクセル数で設定します. </p>
		 * 
		 * @default	50
		 */
		public function get overshootPixels():Number { return _overshootPixels; }
		public function set overshootPixels(value:Number):void { _overshootPixels = value; }
		private var _overshootPixels:Number = 100;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * overshootEasing
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オーバーシュートを使用する場合, オーバーシュートから本来のスクロール座標へ戻る際の緩やかさを設定します. </p>
		 * <p>1以上の数値を設定し, 数値が大きくなるほど緩やかに戻るようになります.</p>
		 * 
		 * @default 6
		 */
		public function get overshootEasing():Number { return _overshootEasing; }
		public function set overshootEasing(value:Number):void { _overshootEasing = value; }
		private var _overshootEasing:Number = 6;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * useOvershootDeformationSlider
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オーバーシュートを使用する場合, オーバーシュート時にスクロールバーが縮む演出を加えるかどうかを切り替えます. </p>
		 * <p>演出を使用する場合はtrueを設定します. </p>
		 * 
		 * @default true
		 */
		public function get useOvershootDeformationSlider():Boolean { return _useOvershootDeformationSlider; }
		public function set useOvershootDeformationSlider(value:Boolean):void { _useOvershootDeformationSlider = value; }
		private var _useOvershootDeformationSlider:Boolean = true;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * isOvershooting
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>現在オーバーシュートをしている場合はtrueを返します. </p>
		 */
		public function get isOvershooting():Boolean { return _isOvershooting; }
		private var _isOvershooting:Boolean = false;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _overShootTargetScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オーバーシュートを使用する場合, スクロール目標値が最終的に到達する値を表します. </p>
		 * <p>上にオーバーシュートしている場合はスライダ座標の上限値, 下にオーバーシュートしている場合はスライダ座標の下限値となります. </p>
		 */
		private var _overShootTargetScroll:Number;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// オートスクロールに関する事項
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * useAutoScrollCancelable
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オートスクロールの強制力を切り替えます. </p>
		 * <p>trueの場合は, 何らかのユーザーアクションによるスクロールが発生した時点でオートスクロールを終了します. </p>
		 * <p>falseの場合は, ユーザーアクションによるスクロールが優先されますが, ユーザーアクションが終了するとオートスクロールは再開します. </p>
		 * 
		 * @default	true
		 */
		public function get useAutoScrollCancelable():Boolean { return _useAutoScrollCancelable; }
		public function set useAutoScrollCancelable(value:Boolean):void { _useAutoScrollCancelable = value; }
		private var _useAutoScrollCancelable:Boolean = true;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * isAutoScrolling
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>現在オートスクロールを実行中である場合はtrueを返します. </p>
		 */
		public function get isAutoScrolling():Boolean { return _isAutoScrolling; }
		private var _isAutoScrolling:Boolean;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * useAutoScrollUsingRatio
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オートスクロールに使用するスクロール単位を切り替えます. </p>
		 * <p>trueの場合はスクロール量をコンテンツ全体に対する割合で設定します(0より大きく1以下の数値). </p>
		 * <p>falseの場合はスクロール量をピクセル数で設定します(0以上の数値). </p>
		 * 
		 * @default	false
		 */
		public function get useAutoScrollUsingRatio():Boolean { return _useAutoScrollUsingRatio; }
		public function set useAutoScrollUsingRatio(value:Boolean):void { _useAutoScrollUsingRatio = value; }
		private var _useAutoScrollUsingRatio:Boolean = false;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * useAutoScrollAmount
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オートスクロールの毎フレームのスクロール量を設定します. </p>
		 * 
		 * @default	10
		 */
		public function get autoScrollAmount():Number { return _autoScrollAmount; }
		public function set autoScrollAmount(value:Number):void { _autoScrollAmount = value; }
		private var _autoScrollAmount:Number = 5;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * autoScrollDirection
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>実行中のオートスクロールの方向を取得します. </p>
		 * <p>trueの場合は下方向, falseの場合は上方向へスクロールしています. </p>
		 */
		public function get autoScrollDirection():Boolean { return _autoScrollDirection; }
		private var _autoScrollDirection:Boolean;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * autoScrollVelocity
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>実行中のオートスクロールの速度を表します. </p>
		 * 
		 * @default	0
		 */
		private var _autoScrollVelocity:Number = 0;
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _calledFromUpdateAutoScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール実行メソッドが. updateAutoScrollメソッドから呼び出されたことを示すフラグです. </p>
		 */
		private var _calledFromUpdateAutoScroll:Boolean;
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// CONSTRUCTOR
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * JPPScrollbar
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>コンストラクタです. </p>
		 * @param stage <p>stageへの参照です. コンストラクタで渡せない場合にはインスタンス生成後にstageプロパティへ代入する必要があります. </p>
		 * @param useSWFWheel <p>マウスホイール検出にSWFWheelを使用するかどうかを設定します. </p>
		 */
		public function JPPScrollbar(stage:Stage = null, useSWFWheel:Boolean = true):void {
			this.useSWFWheel = useSWFWheel;
			this.stage = stage;
		}
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// METHODS
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * setup
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>初期化関数. </p>
		 * <p>スクロールバーのアクティベーションをおこないます. </p>
		 * 
		 * @param content     <p>スクロール対象のオブジェクト(コンテンツ)です. </p>
		 * @param key         <p>スクロールによって実際に変化させたいプロパティ名です. </p>
		 * @param contentSize <p>スクロール対象オブジェクトの総計サイズです. </p>
		 * @param maskSize    <p>実際に表示されるスクロール対象オブジェクトのサイズです. </p>
		 * @param upperBound  <p>スライダーが上限に達したときの変化対象プロパティの値です. </p>
		 * @param lowerBound  <p>スライダーが下限に達したときの変化対象プロパティの値です. </p>
		 */
		public function setup(content:*,
		                      key:String,
		                      contentSize:Number,
		                      maskSize:Number,
		                      upperBound:Number,
		                      lowerBound:Number):void {
			
			if (_isReady) {
				_stopUserActionScroll();
				stopAutoScroll();
			}
			_isReady = true;
			
			//各種引数を受け取る
			_content     = content;
			_key         = key;
			_contentSize = contentSize;
			_maskSize    = maskSize;
			_upperBound  = upperBound;
			_lowerBound  = lowerBound;
			
			//Tickerの生成
			if (!_ticker) _ticker = new Shape();
			
			//スクロール完了時に対象プロパティが到達する目標値を現在のプロパティ値に設定する
			_targetScroll = property;
			
			//現在スクロールが進行中であるかどうかのフラグを初期化する
			_isScrolling = false;
			
			//オートスクロール中でない
			_isAutoScrolling = false;
			
			//スライダーがユーザによって現在ドラッグされているかどうかのフラグを初期化する
			_isDragging = false;
			
			//ユーザのスライダードラッグ動作によるスクロールが現在進行中であるかどうかのフラグを初期化する
			_isScrollingByDrag = false;
			
			//ユーザの動作によるスクロールが現在進行中であるかどうかのフラグを初期化する
			_isScrollingByUser = false;
			
			//オーバーシュートしていない
			_isOvershooting = false;
			
			//前回のスクロール時から，開始イベントが発行されていない場合はfalse
			_isStartedScroll = false;
			
			//コンテンツサイズがマスクサイズ以下である場合はtrue
			_isUnderFlow = (_contentSize <= _maskSize) ? true : false;
			
			//スクロール実行メソッドの呼び出し振り分けフラグ
			_calledFromUpdateAutoScroll = false;
			
			//ボタンアクションをバインドする
			_isUpPressed     = false;
			_isDownPressed   = false;
			_isBasePressed   = false;
			_isSliderPressed = false;
			
			if (_stage)
			{
				_bindArrowUpButton(true);
				_bindArrowDownButton(true);
				_bindBaseButton(true);
				_bindSliderButton(true);
			}
			
			//ボタンを有効化する
			buttonEnabled = true;
			
			//スライダーのリサイズを実行する
			resizeSlider();
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * destroy
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>破棄関数. </p>
		 * <p>スクロールバーを破棄します. </p>
		 */
		public function destroy():void
		{
			buttonEnabled = false;
			
			up     = null;
			down   = null;
			base   = null;
			slider = null;
			
			if (_stage)
			{
				_mouseWheelArea.removeEventListener(MouseEvent.MOUSE_WHEEL, _mouseWheelHandler);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, _moveSliderHandler);
				_stage = null;
			}
			
			if (_ticker)
			{
				_ticker.removeEventListener(Event.ENTER_FRAME, _updateAutoScroll);
				_ticker.removeEventListener(Event.ENTER_FRAME, _continuousArrowScrollTimerUpdater);
				_ticker.removeEventListener(Event.ENTER_FRAME, _updateScroll);
				_ticker = null;
			}
			
			if (_continuousArrowScrollTimer)
			{
				_continuousArrowScrollTimer.removeEventListener(TimerEvent.TIMER, _continuousArrowScrollTimerHandler);
				_continuousArrowScrollTimer.reset();
				_continuousArrowScrollTimer = null;
			}
			
			_content = null;
			
			_isScrolling = false;
			_isDragging = false;
			_isScrollingByDrag = false;
			_isScrollingByUser = false;
			_isOvershooting = false;
			_isStartedScroll = false;
			_isAutoScrolling = false;
			_isUpPressed = false;
			_isDownPressed = false;
			_isBasePressed = false;
			_isSliderPressed = false;
			_terminateScrollFlag = false;
			_prevProperty = NaN;
			_isReady = false;
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * scrollUp
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>arrowScrollAmountプロパティに設定された量だけコンテンツをスクロールさせる関数です. </p>
		 * <p>スライダーは上方向へと移動します. </p>
		 */
		public function scrollUp():void {
			if (!_isReady) return;
			
			_isScrollingByDrag = false;
			
			(_useArrowScrollUsingRatio) ? scrollByRelativeRatio(_arrowScrollAmount) :
			                              scrollByRelativePixel(_arrowScrollAmount);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * scrollDown
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>arrowScrollAmountプロパティに設定された量だけコンテンツをスクロールさせる関数です. </p>
		 * <p>スライダーは下方向へと移動します. </p>
		 */
		public function scrollDown():void {
			if (!_isReady) return;
			
			_isScrollingByDrag = false;
			
			(_useArrowScrollUsingRatio) ? scrollByRelativeRatio(-_arrowScrollAmount) :
			                              scrollByRelativePixel(-_arrowScrollAmount);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * scrollByRelativeRatio
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>現在のプロパティ値からの相対的なスクロール量を, 割合として指定してスクロールを実行する関数です. </p>
		 * 
		 * @param ratio
		 * 	<p>スクロールさせる割合の相対値です. </p>
		 * 	<p>0を指定するとスライダーは動かず, 0.5を指定するとスライダが基準値から全可動域の半分下へ移動します.</p>
		 *  <p>また, -0.5を指定するとスライダが全可動域の半分上へ移動します.</p>
		 * 
		 * @param fromTargetPosition
		 * 	<p>減速スクロールの目標値を基準値として割合を指定する場合はtrueを,現在の暫定プロパティ値を基準値とする場合はfalseを指定します. </p>
		 * 	@default true
		 */
		public function scrollByRelativeRatio(ratio:Number, fromTargetPosition:Boolean = true):void {
			if (!_isReady) return;
			
			var o:Number = (fromTargetPosition) ? _targetScroll : property;
			
			var pixel:Number = o - (_lowerBound - _upperBound) * ratio;
			
			scrollByAbsolutePixel(pixel);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * scrollByAbsoluteRatio
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール位置を指定し, スクロールを実行する関数です. </p>
		 * <p>値の指定には割合を指定します. </p>
		 * 
		 * @param ratio
		 * 	<p>スクロールさせる割合です. </p>
		 * 	<p>0を指定するとスライダーが一番上へ, 1を指定するとスライダーが一番下へ移動します. </p>
		 */
		public function scrollByAbsoluteRatio(ratio:Number):void {
			if (!_isReady) return;
			
			var pixel:Number = (_lowerBound - _upperBound) * ratio + _upperBound;
			
			scrollByAbsolutePixel(pixel);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * scrollByRelativePixel
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>現在のプロパティ値からの相対的なスクロール量を, ピクセル数として指定してスクロールを実行する関数です. </p>
		 * 
		 * @param pixel
		 * 	<p>スクロールさせるピクセル数の相対値です. </p>
		 * 	<p>0を指定するとスライダーは動かず, 100を指定するとスライダーが対象コンテンツ100ピクセル分上へ移動します.</p>
		 *  <p>また, -100を指定するとスライダーが対象コンテンツ100ピクセル分上へ移動します.</p>
		 * 
		 * @param fromTargetPosition
		 * 	<p>減速スクロールの目標値を基準値として割合を指定する場合はtrueを,現在の暫定プロパティ値を基準値とする場合はfalseを指定します. </p>
		 * 	@default true
		 */
		public function scrollByRelativePixel(pixel:Number, fromTargetPosition:Boolean = true):void {
			if (!_isReady) return;
			
			var o:Number = (fromTargetPosition) ? _targetScroll : property;
			
			scrollByAbsolutePixel(o + pixel);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * scrollByAbsolutePixel
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール位置を指定し, スクロールを実行する関数です. </p>
		 * <p>値の指定にはピクセルを指定します. </p>
		 * 
		 * @param ratio
		 * 	<p>スクロール後の位置です. </p>
		 * 	<p>upperBoundを指定するとスライダーが一番上へ, lowerBoundを指定するとスライダーが一番下へ移動します. </p>
		 */
		public function scrollByAbsolutePixel(pixel:Number):void {
			if (!_isReady) return;
			
			_targetScroll = pixel;
			
			_overShootTargetScroll = (_targetScroll > _upperBound) ? _upperBound :
			                         (_targetScroll < _lowerBound) ? _lowerBound :
			                                                         _targetScroll;
			
			if (_useOvershoot && _useSmoothScroll && !_calledFromUpdateAutoScroll) {
				_targetScroll = (_targetScroll > _upperBound + _overshootPixels) ? _upperBound + _overshootPixels :
				                (_targetScroll < _lowerBound - _overshootPixels) ? _lowerBound - _overshootPixels :
				                 _targetScroll;
			} else {
				_targetScroll = _overShootTargetScroll;
			}
			
			//スクロールを開始する
			_startScroll();
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * startAutoScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オートスクロールを開始します. </p>
		 * 
		 * @param isDown
		 * 	<p>スクロール方向です.</p>
		 * 	<p>trueの場合は下方向へ, falseの場合は上方向へスクロールします. </p>
		 * 	@default 10
		 */
		public function startAutoScroll(isDown:Boolean = true):void {
			if (!_isReady) return;
			
			//スクロール方向
			_autoScrollDirection = isDown;
			
			//スクロール速度
			_autoScrollVelocity = ((isDown) ? -1 : 1) * _autoScrollAmount;
			
			if(!_isAutoScrolling) {
				_ticker.addEventListener(Event.ENTER_FRAME, _updateAutoScroll);
			}
			
			_isAutoScrolling = true;
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * stopAutoScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オートスクロールを停止します. </p>
		 */
		public function stopAutoScroll():void {
			if (!_isReady || !_isAutoScrolling) return;
			
			_isAutoScrolling = false;
			
			_ticker.removeEventListener(Event.ENTER_FRAME, _updateAutoScroll);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * resizeSlider
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>現在の対象コンテンツ総計サイズ, 対象コンテンツ表示領域サイズ, スライダのベースエリアのサイズに合わせて, スライダーをリサイズする関数です. </p>
		 */
		public function resizeSlider():void {
			_isUnderFlow = (_contentSize <= _maskSize) ? true : false;
			
			if (!_isReady || !_slider) return;
			
			//スライダーの高さ0として扱う
			if (_useIgnoreSliderHeight) {
				_slider.scaleY = 1;
				_sliderHeight = 0;
				_updateSlider();
				return;
			}
			
			//バーを伸縮させない場合
			if (!_useFlexibleSlider) {
				_slider.scaleY = 1;
				_sliderHeight = _slider.height;
				_updateSlider();
				return;
			}
			
			if (!base) return;
			
			var contentRatio:Number = _maskSize / _contentSize;
			
			//コンテンツサイズがマスクサイズに満たない場合
			if (_isUnderFlow) {
				//buttonEnabled = false;
				
				_slider.height = _base.height;
				_sliderHeight = _base.height;
				
				_updateSlider();
				return;
			}
			
			var h:Number = contentRatio * _base.height;
			
			//_sliderHeight = (h < _minSliderHeight) ? _minSliderHeight : h;
			//_sliderHeight = (_usePixelFittingSlider) ? Math.round(_sliderHeight) : _sliderHeight;
			
			_sliderHeight = Math.round( (h < _minSliderHeight) ? _minSliderHeight : h );
			
			_slider.height = _sliderHeight;
			
			//位置合わせをおこなう
			_updateSlider();
		}
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// PRIVATE METHODS
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * _bindArrowUpButton
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>上向きアローボタンのボタンアクションを設定する関数です. </p>
		 * 
		 * @param bind
		 *  <p>trueの場合はイベントハンドラの登録, falseの場合はイベントハンドラの削除をします. </p>
		 */
		private function _bindArrowUpButton(bind:Boolean):void {
			if (_up) {
				if (bind) {
					_up.addEventListener(MouseEvent.MOUSE_DOWN , _arrowUpButtonMouseDownHandler);
					if (_stage) _stage.addEventListener(MouseEvent.MOUSE_UP, _arrowUpButtonMouseUpHandler  );
					
					upEnabled = _isReady;
					
				} else {
					_up.removeEventListener(MouseEvent.MOUSE_DOWN , _arrowUpButtonMouseDownHandler);
					if (_stage) _stage.removeEventListener(MouseEvent.MOUSE_UP, _arrowUpButtonMouseUpHandler  );
					
					upEnabled = false;
				}
			}
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _bindArrowDownButton
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>下向きアローボタンのボタンアクションを設定する関数です. </p>
		 * 
		 * @param bind
		 *  <p>trueの場合はイベントハンドラの登録, falseの場合はイベントハンドラの削除をします. </p>
		 */
		private function _bindArrowDownButton(bind:Boolean):void {
			if (_down) {
				if (bind) {
					_down.addEventListener(MouseEvent.MOUSE_DOWN, _arrowDownButtonMouseDownHandler);
					if (_stage) _stage.addEventListener(MouseEvent.MOUSE_UP , _arrowDownButtonMouseUpHandler  );
					
					downEnabled = _isReady;
					
				} else {
					_down.removeEventListener(MouseEvent.MOUSE_DOWN, _arrowDownButtonMouseDownHandler);
					if (_stage) _stage.removeEventListener(MouseEvent.MOUSE_UP , _arrowDownButtonMouseUpHandler  );
					
					downEnabled = false;
				}
			}
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _bindBaseButton
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーのベースエリアのボタンアクションを設定する関数です. </p>
		 * 
		 * @param bind
		 *  <p>trueの場合はイベントハンドラの登録, falseの場合はイベントハンドラの削除をします. </p>
		 */
		private function _bindBaseButton(bind:Boolean):void {
			if (_base) {
				if (bind) {
					_base.addEventListener(MouseEvent.MOUSE_DOWN, _baseButtonMouseDownHandler);
					if (_stage) _stage.addEventListener(MouseEvent.MOUSE_UP , _baseButtonMouseUpHandler  );
					
					baseEnabled = _isReady;
					
				} else {
					_base.removeEventListener(MouseEvent.MOUSE_DOWN, _baseButtonMouseDownHandler);
					if (_stage) _stage.removeEventListener(MouseEvent.MOUSE_UP , _baseButtonMouseUpHandler  );
					
					baseEnabled = false;
				}
			}
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _bindSliderButton
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーのボタンアクションを設定する関数です. </p>
		 * 
		 * @param bind
		 *  <p>trueの場合はイベントハンドラの登録, falseの場合はイベントハンドラの削除をします. </p>
		 */
		private function _bindSliderButton(bind:Boolean):void {
			if (_slider) {
				if (bind) {
					_slider.addEventListener(MouseEvent.MOUSE_DOWN, _sliderButtonMouseDownHandler);
					if (_stage) _stage.addEventListener(MouseEvent.MOUSE_UP   , _sliderButtonMouseUpHandler  );
					
					sliderEnabled = _isReady;
					
				} else {
					_slider.removeEventListener(MouseEvent.MOUSE_DOWN, _sliderButtonMouseDownHandler);
					if (_stage) _stage.removeEventListener(MouseEvent.MOUSE_UP   , _sliderButtonMouseUpHandler  );
					
					sliderEnabled = false;
				}
			}
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _pressArrow
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンが押されたときに呼び出される関数です. </p>
		 * <p>_arrowDownButtonMouseDownHandlerもしくは_arrowUpButtonMouseDownHandlerイベントハンドラを通じて呼び出されます. </p>
		 */
		private function _pressArrow():void {
			
			//目標値が端に到達している状態での，さらに外側にスクロールしようとする動作を無効化する
			if (!_useOvershoot)
			{
				if ( (_targetScroll == _upperBound && _isUpPressed  ) ||
				     (_targetScroll == _lowerBound && _isDownPressed) ) return;
			}
			
			//オートスクロールの中断
			if (_useAutoScrollCancelable) stopAutoScroll();
			
			//ユーザーアクションによるスクロールであることを示す
			_isScrollingByUser = true;
			
			//ドラッグ以外のスクロールであることを示す
			_isScrollingByDrag = false;
			
			//1回目のスクロール処理を実行する
			(_isUpPressed) ? scrollUp() : scrollDown();
			
			//2回目移行のスクロール処理を実行する
			if (_useContinuousArrowScroll) {
				
				if (_continuousArrowScrollInterval == 0) {
					//タイムラグ無しで毎フレームの連続スクロールを開始する
					
					if(_continuousArrowScrollTimer) {
						_continuousArrowScrollTimer.stop();
						_continuousArrowScrollTimer.removeEventListener(TimerEvent.TIMER, _continuousArrowScrollTimerHandler);
						_continuousArrowScrollTimer = null;
					}
					
					_ticker.addEventListener(Event.ENTER_FRAME, _continuousArrowScrollTimerUpdater);
					
				} else {
					//タイムラグの後, 毎フレームの連続スクロールを開始する
					_continuousArrowScrollTimer = new Timer(_continuousArrowScrollInterval, 1);
					_continuousArrowScrollTimer.addEventListener(TimerEvent.TIMER, _continuousArrowScrollTimerHandler);
					_continuousArrowScrollTimer.start();
				}
			}
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _releaseArrow
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンが離されたときに呼び出される関数です. </p>
		 * <p>_arrowDownButtonMouseUpHandlerもしくは_arrowUpButtonMouseUpHandlerイベントハンドラを通じて呼び出されます. </a>
		 */
		private function _releaseArrow():void {
			if(_continuousArrowScrollTimer) {
				_continuousArrowScrollTimer.stop();
				_continuousArrowScrollTimer.removeEventListener(TimerEvent.TIMER, _continuousArrowScrollTimerHandler);
				_continuousArrowScrollTimer = null;
			}
			
			_ticker.removeEventListener(Event.ENTER_FRAME, _continuousArrowScrollTimerUpdater);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _prsssBase
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーのベースエリアが押されたときに呼び出される関数です. </p>
		 * <p>_baseButtonMouseDownHandlerイベントハンドラを通じて呼び出されます. </a>
		 */
		private function _prsssBase():void {
			//オートスクロールの中断
			if (_useAutoScrollCancelable) stopAutoScroll();
			
			//ユーザーアクションによるスクロールであることを示す
			_isScrollingByUser = true;
			
			//ドラッグ以外のスクロールであることを示す
			_isScrollingByDrag = false;
			
			//マウス座標
			var mousePosition:Number = _base.scaleY * _base.mouseY;
			
			var ratio:Number;
			if (_slider && !_useIgnoreSliderHeight)
			{
				if (mousePosition < _slider.y + _slider.height * 0.5)
				{
					//スライダーよりも上を押下
					ratio = mousePosition / (_base.height - _slider.height);
				}
				else
				{
					//スライダーよりも下を押下
					ratio = (mousePosition - _slider.height) / (_base.height - _slider.height);
				}
			}
			else
			{
				//スライダーのサイズを無視
				ratio = mousePosition / (_base.height - 1);
			}
			
			//var ratio:Number = (_slider && !_useIgnoreSliderHeight) ? _base.scaleY * _base.mouseY / (_base.height - _slider.height) :
			//                                                          _base.scaleY * _base.mouseY / (_base.height - 1);
			
			//スクロール処理を実行する
			scrollByAbsoluteRatio(ratio);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _pressSlider
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーが押されたときに呼び出される関数です. </p>
		 * <p>_sliderButtonMouseDownHandlerイベントハンドラを通じて呼び出されます. </a>
		 */
		private function _pressSlider():void {
			if (!_base) return;
			
			//オートスクロールの中断
			if (_useAutoScrollCancelable) stopAutoScroll();
			
			//ユーザーアクションによるスクロールであることを示す
			_isScrollingByUser = true;
			
			_isDragging = true;
			
			var boundHeight:Number = (_useIgnoreSliderHeight) ?  _base.height :
			                                                    (_base.height - _slider.height);
			
			var bound:Rectangle = new Rectangle(_base.x, _base.y, 0, boundHeight);
			
			Sprite(_slider).startDrag(false, bound);
			
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, _moveSliderHandler);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _releaseSlider
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダーが離されたときに呼び出される関数です. </p>
		 * <p>_sliderButtonMouseUpHandlerイベントハンドラを通じて呼び出されます. </a>
		 */
		private function _releaseSlider():void {
			_isDragging = false;
			
			Sprite(_slider).stopDrag();
			
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, _moveSliderHandler);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _continuousScrollUp
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを押し続けたときの連続スクロールを実行する関数です. </p>
		 * <p>スライダーは上方向へと移動します. </p>
		 */
		private function _continuousScrollUp():void {
			//ユーザーアクションによるスクロールであることを示す
			_isScrollingByUser = true;
			
			//ドラッグ以外のスクロールであることを示す
			_isScrollingByDrag = false;
			
			//スクロールを実行する
			(_useArrowScrollUsingRatio) ? scrollByRelativeRatio(_continuousArrowScrollAmount) :
			                              scrollByRelativePixel(_continuousArrowScrollAmount);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _continuousScrollDown
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを押し続けたときの連続スクロールを実行する関数です. </p>
		 * <p>スライダーは下方向へと移動します. </p>
		 */
		private function _continuousScrollDown():void {
			//ユーザーアクションによるスクロールであることを示す
			_isScrollingByUser = true;
			
			//ドラッグ以外のスクロールであることを示す
			_isScrollingByDrag = false;
			
			//スクロールを実行する
			(_useArrowScrollUsingRatio) ? scrollByRelativeRatio(-_continuousArrowScrollAmount) :
			                              scrollByRelativePixel(-_continuousArrowScrollAmount);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _startScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロール処理を開始する関数です. </p>
		 */
		private function _startScroll():void {
			if (_usePixelFittingContent) _targetScroll = Math.round(_targetScroll);
			
			if (_useSmoothScroll) {
				//減速スクロールの開始
			//	_isScrolling = true;
				_prevProperty = NaN;
				_terminateScrollFlag = false;
				_ticker.addEventListener(Event.ENTER_FRAME, _updateScroll);
				
			} else {
				//ダイレクトスクロール
				if (_isScrolling) _ticker.removeEventListener(Event.ENTER_FRAME, _updateScroll);
				if (_isOvershooting) {
					_targetScroll = _overShootTargetScroll;
					_isOvershooting = false;
				}
				
				if (property != _targetScroll) {
					//スクロール開始イベント発行
					dispatchEvent(new JPPScrollbarEvent(JPPScrollbarEvent.SCROLL_START));
					
					//スクロール進捗イベント発行
					dispatchEvent(new JPPScrollbarEvent(JPPScrollbarEvent.SCROLL_PROGRESS));
					
					//スクロール完了イベント発行
					dispatchEvent(new JPPScrollbarEvent(JPPScrollbarEvent.SCROLL_COMPLETE));
				}
				
				_isScrolling = false;
				_isScrollingByUser = false;
				_isScrollingByDrag = false;
				property = _targetScroll;
				_updateSlider();
			}
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _stopUserActionScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>ボタンアクション, マウスホイールによるスクロール処理を停止する関数です. </p>
		 */
		private function _stopUserActionScroll():void {
			_targetScroll =  (_usePixelFittingContent) ? Math.round(property) : property;
			if (_isScrolling) {
				_ticker.removeEventListener(Event.ENTER_FRAME, _updateScroll);
				
				//スクロール終了イベント発行
				dispatchEvent(new JPPScrollbarEvent(JPPScrollbarEvent.SCROLL_COMPLETE));
			}
			_isScrolling = false;
			_updateSlider();
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _updateTargetScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オーバーシュート時に, スクロール目標点が到達する値を計算する関数です. </p>
		 */
		private function _updateTargetScroll():void {
			var d:Number = _overShootTargetScroll - _targetScroll;
			var a:Number = (d > 0) ? d : -d;
			
			if (a < 0.01) {
				_targetScroll = _overShootTargetScroll;
			} else {
				_targetScroll += d / _overshootEasing;
			}
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _updateSlider
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>コンテンツのスクロール量に応じてスライダーの形状と位置を計算する関数です. </p>
		 */
		private function _updateSlider():void {
			if (!_slider || !_base || !_content) return;
			
			if (_contentSize <= _maskSize) return;
			
			//var contentRatio:Number = (_isUnderFlow) ? (_upperBound - property) / (_maskSize   - _contentSize) : 
			//                                          (_upperBound - property) / (_upperBound - _lowerBound);
			
			var contentRatio:Number = (_upperBound - property) / (_upperBound - _lowerBound);
			
			var h:Number = (_useIgnoreSliderHeight) ?  _base.height : 
			                                          (_base.height - _slider.height);
			
			var p:Number = contentRatio * h;
			
			//スライダーを変形させる
			if (_useOvershoot && _useOvershootDeformationSlider && !_useIgnoreSliderHeight) {
				if (_useSmoothScroll) {
					
					_isOvershooting = false;
					
					//上側にオーバーシュートしている
					if (contentRatio < 0) {
						_isOvershooting = true;
						_slider.height += ((_sliderHeight + p) - _slider.height) / 3;
					}
					
					//下側にオーバーシュートしている
					if (contentRatio > 1) {
						_isOvershooting = true;
						_slider.height += ((_sliderHeight - p + h) - _slider.height) / 3;
					}
					
					//オーバーシュートしていない
					if (!_isOvershooting) {
						_slider.height += (_sliderHeight - _slider.height) / 10;
					}
					
				} else {
					
					_slider.height = _sliderHeight;
				}
				
				//座標の再計算
				h = _base.height - _slider.height;
				p = contentRatio * h;
				
				//ドラッグ中であればドラッグ可能領域を再計算する
				if (_isDragging) {
					var bound:Rectangle = new Rectangle(_base.x, _base.y, 0, h);
					Sprite(_slider).startDrag(false, bound);
					return;
				}
				
				if (_isScrollingByDrag) return;
			} else {
				
				_isOvershooting = false;
				
				//上側にオーバーシュートしている
				if (contentRatio < 0) {
					_isOvershooting = true;
				}
				
				//下側にオーバーシュートしている
				if (contentRatio > 1) {
					_isOvershooting = true;
				}
			}
			
			if (_isDragging || _isScrollingByDrag) return;
			
			//スライダーの座標を補正する
			_slider.y = (p < 0) ? 0 :
						(p > h) ? h :
								  p;
		}
		
		
		
		
		
		
		
		
		
		
		//==========================================================================
		// EVENT HANDLER
		//==========================================================================
		
		
		/*--------------------------------------------------------------------------
		 * button event handlers
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>各パーツのボタンアクションにバインドされるイベントハンドラです. </p>
		 * 
		 * @param e
		 *  <p>MouseEvent</p>
		 */
		private function _arrowUpButtonMouseDownHandler(e:MouseEvent):void {
			_isUpPressed = true;
			if (!_isReady) return;
			_pressArrow();
		}
		
		private function _arrowUpButtonMouseUpHandler(e:MouseEvent):void {
			if (!_isUpPressed) return;
			_isUpPressed = false;
			if (!_isReady) return;
			_releaseArrow();
		}
		
		private function _arrowDownButtonMouseDownHandler(e:MouseEvent):void {
			_isDownPressed = true;
			if (!_isReady) return;
			_pressArrow();
			
		}
		
		private function _arrowDownButtonMouseUpHandler(e:MouseEvent):void {
			if (!_isDownPressed) return;
			_isDownPressed = false;
			if (!_isReady) return;
			_releaseArrow();
		}
		
		private function _baseButtonMouseDownHandler(e:MouseEvent):void {
			_isBasePressed = true;
			if (!_isReady) return;
			_prsssBase();
		}
		
		private function _baseButtonMouseUpHandler(e:MouseEvent):void {
			if (!_isBasePressed) return;
			_isBasePressed = false;
		}
		
		private function _sliderButtonMouseDownHandler(e:MouseEvent):void {
			_isSliderPressed = true;
			if (!_isReady) return;
			_pressSlider();
		}
		
		private function _sliderButtonMouseUpHandler(e:MouseEvent):void {
			if (!_isSliderPressed) return;
			_isSliderPressed = false;
			if (!_isReady) return;
			_releaseSlider();
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _mouseWheelHandler
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>マウスホイールの動作時に呼び出されるイベントハンドラです. </p>
		 * 
		 * @param e
		 *  <p>MouseEvent</p>
		 */
		private function _mouseWheelHandler(e:MouseEvent):void {
			if (!_isReady || !_useMouseWheel || e.delta == 0) return;
			
			//目標値が端に到達している状態での，さらに外側にスクロールしようとする動作を無効化する
			if (!_useOvershoot)
			{
				if ( (_targetScroll == _upperBound && e.delta > 0) ||
				     (_targetScroll == _lowerBound && e.delta < 0) ) return;
			}
			
			//オートスクロールの中断
			if (_useAutoScrollCancelable) stopAutoScroll();
			
			//ユーザーアクションによるスクロールであることを示す
			_isScrollingByUser = true;
			
			//ドラッグ以外のスクロールであることを示す
			_isScrollingByDrag = false;
			
			//(e.delta > 0) ? scrollUp() : scrollDown();
			
			if (e.delta > 0) {
				(_useArrowScrollUsingRatio) ? scrollByRelativeRatio(_arrowScrollAmount, true) :
											  scrollByRelativePixel(_arrowScrollAmount, true);
				
			} else {
				(_useArrowScrollUsingRatio) ? scrollByRelativeRatio(-_arrowScrollAmount, true) :
											  scrollByRelativePixel(-_arrowScrollAmount, true);
			}
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _continuousArrowScrollTimerHandler
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを押し続けたときの連続スクロールを発生させるまでの遅延完了時に呼び出されるイベントハンドラです. </p>
		 * 
		 * @param e
		 *  <p>TimerEvent</p>
		 */
		private function _continuousArrowScrollTimerHandler(e:TimerEvent):void {
			_continuousArrowScrollTimer.removeEventListener(TimerEvent.TIMER, _continuousArrowScrollTimerHandler);
			
			//2回目以降のスクロールは毎フレーム実行する
			_ticker.addEventListener(Event.ENTER_FRAME, _continuousArrowScrollTimerUpdater);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _continuousArrowScrollTimerUpdater
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>アローボタンを押し続けたときの連続スクロールを実行するために毎フレーム呼び出されるイベントハンドラです. </p>
		 * 
		 * @param e
		 *  <p>Event</p>
		 */
		private function _continuousArrowScrollTimerUpdater(e:Event):void {
			//2回目以降のスクロール
			(_isUpPressed) ? _continuousScrollUp() : _continuousScrollDown();
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _moveSliderHandler
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スライダのドラッグ時に呼び出されるイベントハンドラです. </p>
		 * 
		 * @param e
		 *  <p>TimerEvent</p>
		 */
		private function _moveSliderHandler(e:MouseEvent):void {
			_isScrollingByDrag = true;
			
			var h:Number = (_useIgnoreSliderHeight) ?  _base.height : 
			                                          (_base.height - _slider.height);
			
			var ratio:Number = _slider.y / h;
			
			scrollByAbsoluteRatio(ratio);
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _updateScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>スクロールアクションが始まってから完了するまで毎フレーム呼び出されるイベントハンドラです. </p>
		 * <p>対象プロパティ, スライダの更新をおこないます. </p>
		 * 
		 * @param e
		 *  <p>Event</p>
		 */
		private function _updateScroll(e:Event):void {
			if (!_terminateScrollFlag && (_useOvershoot || _useSmoothScroll)) {
				_updateTargetScroll();
			}
			
			var d:Number = _targetScroll - property;
			//var a:Number = (d > 0) ? d : -d;
			
			//if (a < 0.001 || _terminateScrollFlag) {
			if (_terminateScrollFlag) {
				_isScrolling = false;
				_isScrollingByUser = false;
				_isScrollingByDrag = false;
				_isOvershooting = false;
				
				property = _targetScroll;
				
				_updateSlider();
				
				//スライダーの最終調整
				if (_slider && !_useIgnoreSliderHeight) {
					if (_usePixelFittingSlider) {
						_slider.y = Math.round(_slider.y);
					}
					_slider.height = _sliderHeight;
					
					/*
					if (_usePixelFittingSlider) {
						_slider.y = Math.round(_slider.y);
						_slider.height = Math.round(_sliderHeight);
					} else {
						_slider.height = _sliderHeight;
					}
					*/
				}
				
				_ticker.removeEventListener(Event.ENTER_FRAME, _updateScroll);
				
			} else {
				_prevProperty = property;
				
				property += d / _smoothScrollEasing;
				
				_updateSlider();
				
				//前回から計算結果が変化していない場合は計算精度が限界なので次フレームで打ち切り
				_terminateScrollFlag = (property == _prevProperty && !_isOvershooting) ? true : false;
				
				//スクロール開始イベント発行
				if (!_isScrolling && !_terminateScrollFlag ) {
					_isStartedScroll = true;
					dispatchEvent(new JPPScrollbarEvent(JPPScrollbarEvent.SCROLL_START));
					dispatchEvent(new JPPScrollbarEvent(JPPScrollbarEvent.SCROLL_PROGRESS));
				}
				
				if (_isScrolling && !_terminateScrollFlag ) {
					//スクロール進捗イベント発行
					dispatchEvent(new JPPScrollbarEvent(JPPScrollbarEvent.SCROLL_PROGRESS));
				}
				
				//スクロール終了イベント発行
				if (_isScrolling && _terminateScrollFlag ) {
					_isStartedScroll = false;
					dispatchEvent(new JPPScrollbarEvent(JPPScrollbarEvent.SCROLL_PROGRESS));
					dispatchEvent(new JPPScrollbarEvent(JPPScrollbarEvent.SCROLL_COMPLETE));
				}
				
				_isScrolling = !_terminateScrollFlag;
			}
		}
		
		
		
		
		
		/*--------------------------------------------------------------------------
		 * _updateAutoScroll
		 *---------------------------------------------------------------------*//**
		 * 
		 * <p>オートスクロールを実行中の場合に毎フレーム更新します. </p>
		 * 
		 * @param e
		 *  <p>Event</p>
		 */
		private function _updateAutoScroll(e:Event):void {
			if (_isScrollingByUser || isBasePressed) return;
			
			_isScrollingByDrag = false;
			
			_calledFromUpdateAutoScroll = true;
			
			(_useAutoScrollUsingRatio) ? scrollByRelativeRatio(_autoScrollVelocity) :
			                             scrollByRelativePixel(_autoScrollVelocity);
			
			_calledFromUpdateAutoScroll = false;
		}
	}
}