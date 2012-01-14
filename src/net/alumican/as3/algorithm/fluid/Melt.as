/**
 * Licensed under the MIT License
 * 
 * Copyright (c) 2008 BeInteractive! (www.be-interactive.org) and 
 *               2009 alumican.net (www.alumican.net) and 
 *               Spark project (www.libspark.org)
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
 */
package net.alumican.as3.algorithm.fluid
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.alumican.as3.algorithm.fluid.*;
	
	/**
	 * Melt
	 * addChild(new Melt(target));
	 * 
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class Melt extends Sprite
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		/**
		 * overflowing pixels around fluid target.
		 * change before doing addChild(new Melt(target)).
		 */
		static public var DEFAULT_MARGIN:Number = 100;
		
		/**
		 * each cell size of fluid grid
		 * change before doing addChild(new Melt(target)).
		 */
		static public var GRID_SIZE:Number      = 20;
		
		
		
		
		
		/**
		 * fluid intensity 1
		 * it is revokable by fluid.intensity
		 */
		private const INTENSITY:Number      = 0.25;
		
		/**
		 * fluid intensity 2
		 * it is revokable by fluid.mapScale
		 */
		private const SCALE:Number          = 150;
		
		/**
		 * fluid roundness
		 * it is revokable by fluid.blurIntensity
		 */
		private const BLUR_INTENSITY:uint   = 32;
		
		/**
		 * accuracy of fluid roundness
		 * it is revokable by fluid.blurQuality
		 */
		private const BLUR_QUALITY:uint     = 2;
		
		
		
		
		
		/**
		 * zeros
		 */
		private const ZERO_POINT:Point = new Point(0,0);
		
		
		
		
		
		//--------------------------------------
		// variable
		//--------------------------------------
		
		/**
		 * whether it gradually returns it to shape in the origin or not
		 */
		public function get useDecay():Boolean { return _useDecay; }
		public function set useDecay(value:Boolean):void { _useDecay = value; }
		private var _useDecay:Boolean;
		
		/**
		 * whether it accept mouse motion as external force.
		 * if it is false, you can add external force to fluid by fluid.addOrientedForce(x, y, forceX, forceY, flowSize).
		 */
		public function get useMouse():Boolean { return _useMouse; }
		public function set useMouse(value:Boolean):void { _useMouse = value; }
		private var _useMouse:Boolean;
		
		/**
		 * core fluid class
		 */
		public function get fluid():Fluid { return _fluid; }
		private var _fluid:Fluid;
		
		/**
		 * fluid width
		 */
		public function get fluidWidth():uint { return _fluidWidth; }
		private var _fluidWidth:uint;
		
		/**
		 * fluid height
		 */
		public function get fluidHeight():uint { return _fluidHeight; }
		private var _fluidHeight:uint;
		
		/**
		 * magnitude of mouse influence
		 */
		public function get flowSize():uint { return _flowSize; }
		public function set flowSize(value:uint):void { _flowSize = value; }
		private var _flowSize:uint;
		
		/**
		 * ColorMatrixFilter for erasing overflowing fluid gradually
		 */
		public function get canvasTone():ColorMatrixFilter { return _canvasTone; }
		public function set canvasTone(value:ColorMatrixFilter):void { _canvasTone = value; }
		private var _canvasTone:ColorMatrixFilter;
		
		/**
		 * fluid target
		 */
		private var _target:DisplayObject;
		
		/**
		 * bounds fluid target
		 */
		private var _clipRect:Rectangle;
		
		/**
		 * display BitmapData
		 */
		private var _canvas:BitmapData;
		
		/**
		 * bitmap for add to stage
		 */
		private var _container:Bitmap;
		
		/**
		 * matrix for centering fluid target on container
		 */
		private var _centering:Matrix;
		
		/**
		 * map of fluid DisplacementMapFilter
		 */
		private var _mapBmd:BitmapData;
		
		/**
		 * fluid DisplacementMapFilter
		 */
		private var _mapFilter:DisplacementMapFilter;
		
		/**
		 * transparent
		 */
		private var _transparent:Boolean;
		
		/**
		 * old mouse x
		 */
		private var _oldX:Number = 0;
		
		/**
		 * old mouse y
		 */
		private var _oldY:Number = 0;
		
		/**
		 * whether mouse is moving or not
		 */
		private var _isMouseMove:Boolean = false;
		
		
		
		
		
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 */
		public function Melt(
			target:DisplayObject,
			transparent:Boolean = false,
			useDecay:Boolean    = true,
			useMouse:Boolean    = true,
			fluidWidth:uint     = 0,
			fluidHeight:uint    = 0,
			clipRect:Rectangle  = null
		):void
		{
			//fluid target
			_target = target;
			_target.visible = false;
			
			_transparent = transparent;
			_useDecay    = useDecay;
			_useMouse    = useMouse;
			_clipRect    = (clipRect    != null) ? clipRect    : _target.getRect(_target);
			_fluidWidth  = (fluidWidth  != 0   ) ? fluidWidth  : (_target.width  + DEFAULT_MARGIN * 2);
			_fluidHeight = (fluidHeight != 0   ) ? fluidHeight : (_target.height + DEFAULT_MARGIN * 2);
			
			x = _target.x;
			y = _target.y;
			
			_initialize();
		}
		
		
		
		
		
		//--------------------------------------
		// METHODS
		//--------------------------------------
		
		/**
		 * initialize
		 */
		private function _initialize():void
		{
			//create flow
			_fluid = new Fluid(
				_fluidWidth, 
				_fluidHeight, 
				GRID_SIZE, 
				INTENSITY, 
				SCALE, 
				BLUR_INTENSITY, 
				BLUR_QUALITY
			);
			
			//get DisplacementMapFilter applied to canvas
			_mapFilter = _fluid.mapFilter;
			
			//ColorMatrixFilter for erasing overflowing fluid gradually
			_canvasTone = (_transparent) ?
				new ColorMatrixFilter([
					1, 0, 0, 0  , 5,
					0, 1, 0, 0  , 5,
					0, 0, 1, 0  , 5,
					0, 0, 0, .98, -1
				])
				:
				new ColorMatrixFilter([
					1, 0, 0, 0, 5,
					0, 1, 0, 0, 5,
					0, 0, 1, 0, 5,
					0, 0, 0, 0, 0
				])
			;
			
			_centering = new Matrix();
			_centering.tx = uint(_fluidWidth  - _clipRect.width ) / 2 - _clipRect.x;
			_centering.ty = uint(_fluidHeight - _clipRect.height) / 2 - _clipRect.y;
			
			//bitmap for add to stage
			_container = new Bitmap();
			_container.x = -_centering.tx;
			_container.y = -_centering.ty;
			addChild(_container);
			
			_clipRect.x += _centering.tx;
			_clipRect.y += _centering.ty;
			
			/*
			var rect:Sprite = new Sprite();
			rect.graphics.lineStyle(1, 0x000000, 1);
			rect.graphics.drawRect(_clipRect.x, _clipRect.y, _clipRect.width, _clipRect.height);
			rect.x = -_centering.tx;
			rect.y = -_centering.ty;
			addChild(rect);
			*/
			
			//bitmap data for draw
			_canvas = new BitmapData(_fluidWidth, _fluidHeight, _transparent, 0xffffff);
			_container.bitmapData = _canvas;
			
			//default flow size
			_flowSize = 2;
			
			//add event handler
			addEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveHandler);
			addEventListener(Event.ENTER_FRAME, _update);
		}
		
		/**
		 * kill events
		 */
		private function kill():void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveHandler);
			removeEventListener(Event.ENTER_FRAME, _update);
		}
		
		/**
		 * update canvas
		 * @param	e
		 */
		private function _update(e:Event):void
		{
			//apply mouse velocity to force
			if (_useMouse && _isMouseMove)
			{
				var speedX:Number = _container.mouseX - _oldX;
				var speedY:Number = _container.mouseY - _oldY;
				
				_fluid.addOrientedForce(_container.mouseX, _container.mouseY, speedX, speedY, _flowSize);
				
				_isMouseMove = false;
			}
			
			//update flow
			_fluid.updateFlow(_useDecay);
			
			//update displacement map
			_fluid.updateMap();
			
			//draw
			_canvas.lock();
			_canvas.applyFilter(_canvas, _canvas.rect, ZERO_POINT, _canvasTone);
			_canvas.draw(_target, _centering, null, null, _clipRect);
			_canvas.applyFilter(_canvas, _canvas.rect, ZERO_POINT, _mapFilter);
			_canvas.unlock();
			
			//save mouse position
			_oldX = _container.mouseX;
			_oldY = _container.mouseY;
		}
		
		/**
		 * event handler called when mouse move
		 * @param	e
		 */
		private function _mouseMoveHandler(e:MouseEvent):void
		{
			_isMouseMove = true;
		}
	}
}