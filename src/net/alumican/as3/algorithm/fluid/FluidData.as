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
	import net.alumican.as3.algorithm.fluid.*;
	
	/**
	 * FluidData
	 * Each cell structure of grid
	 * @author alumican.net<Yukiya Okuda>
	 */
	internal class FluidData
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// variable
		//--------------------------------------
		
		/**
		 * x index of grid
		 */
		public function get x():uint { return _x; }
		public function set x(value:uint):void { _x = value; }
		private var _x:uint;
		
		/**
		 * y index of grid
		 */
		public function get y():uint { return _y; }
		public function set y(value:uint):void { _y = value; }
		private var _y:uint;
		
		/**
		 * x velocity
		 */
		public function get vx():Number { return _vx; }
		public function set vx(value:Number):void { _vx = value; }
		private var _vx:Number;
		
		/**
		 * y velocity
		 */
		public function get vy():Number { return _vy; }
		public function set vy(value:Number):void { _vy = value; }
		private var _vy:Number;
		
		/**
		 * pressure
		 */
		public function get pressure():Number { return _pressure; }
		public function set pressure(value:Number):void { _pressure = value; }
		private var _pressure:Number;
		
		/**
		 * compound color for DisplacementMapFilter
		 */
		public function get color():uint { return _color; }
		public function set color(value:uint):void { _color = value; }
		private var _color:uint;
		
		/**
		 * x color for DisplacementMapFilter
		 */
		public function get colorX():uint { return _colorX; }
		public function set colorX(value:uint):void { _colorX = value; }
		private var _colorX:uint;
		
		/**
		 * y color for DisplacementMapFilter
		 */
		public function get colorY():uint { return _colorY; }
		public function set colorY(value:uint):void { _colorY = value; }
		private var _colorY:uint;
		
		/**
		 * cell for link list (to loop grid)
		 */
		public function get next():FluidData { return _next; }
		public function set next(value:FluidData):void { _next = value; }
		private var _next:FluidData;
		
		public function get prev():FluidData { return _prev; }
		public function set prev(value:FluidData):void { _prev = value; }
		private var _prev:FluidData;
		
		/**
		 * cell for link list (to search around grid)
		 */
		private var _n00:FluidData;
		private var _n01:FluidData;
		private var _n02:FluidData;
		private var _n10:FluidData;
		private var _n12:FluidData;
		private var _n20:FluidData;
		private var _n21:FluidData;
		private var _n22:FluidData;
		
		public function get n00():FluidData { return _n00; }
		public function get n01():FluidData { return _n01; }
		public function get n02():FluidData { return _n02; }
		public function get n10():FluidData { return _n10; }
		public function get n12():FluidData { return _n12; }
		public function get n20():FluidData { return _n20; }
		public function get n21():FluidData { return _n21; }
		public function get n22():FluidData { return _n22; }
		
		public function set n00(value:FluidData):void { _n00 = value; }
		public function set n01(value:FluidData):void { _n01 = value; }
		public function set n02(value:FluidData):void { _n02 = value; }
		public function set n10(value:FluidData):void { _n10 = value; }
		public function set n12(value:FluidData):void { _n12 = value; }
		public function set n20(value:FluidData):void { _n20 = value; }
		public function set n21(value:FluidData):void { _n21 = value; }
		public function set n22(value:FluidData):void { _n22 = value; }
		
		
		
		
		
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTER
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 */
		public function FluidData(x:uint, y:uint):void
		{
			_x        = x;
			_y        = y;
			_vx       = 0;
			_vy       = 0;
			_pressure = 0;
			_color    = 0x008080;
			_colorX   = 128;
			_colorY   = 128;
		}
		
		
		
		
		
		//--------------------------------------
		// METHODS
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// EVENT HANDLER
		//--------------------------------------
	}
}