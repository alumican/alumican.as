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
	 * FluidCalculator
	 * Calculator of pressure value and velocity of each cell
	 * @author alumican.net<Yukiya Okuda>
	 */
	internal class FluidCalculator
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// variable
		//--------------------------------------
		
		
		
		
		
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
		public function FluidCalculator():void
		{
		}
		
		
		
		
		
		//--------------------------------------
		// METHODS
		//--------------------------------------
		
		/**
		 * calc velocity vecror of x
		 * 
		 * | +0.5, 0, -0.5 |
		 * | +1.0, 0, -1.0 |
		 * | +0.5, 0, -0.5 |
		 * 
		 * @param	data
		 * @return
		 */
		public function calcVelocityX(data:FluidData):Number
		{
			return (  data.n00.pressure * 0.5
					+ data.n01.pressure
					+ data.n02.pressure * 0.5
					
					- data.n20.pressure * 0.5
					- data.n21.pressure
					- data.n22.pressure * 0.5
					
					) * 0.25;
		}
		
		/**
		 * calc velocity vecror of y
		 * 
		 * | +0.5, +1.0, +0.5 |
		 * |  0  ,  0  ,  0   |
		 * | -0.5, -1.0, -0.5 |
		 * 
		 * @param	data
		 * @return
		 */
		public function calcVelocityY(data:FluidData):Number
		{
			return (  data.n00.pressure * 0.5
					+ data.n10.pressure
					+ data.n20.pressure * 0.5
					
					- data.n02.pressure * 0.5
					- data.n12.pressure
					- data.n22.pressure * 0.5
					
					) * 0.25;
		}
		
		/**
		 * calc pressure value
		 * 
		 * | +0.5, 0, -0.5 |   | +0.5, +1.0, +0.5 |
		 * | +1.0, 0, -1.0 | + |  0  ,  0  ,  0   |
		 * | +0.5, 0, -0.5 |   | -0.5, -1.0, -0.5 |
		 * 
		 * @param	data
		 * @return
		 */
		public function calcPressure(data:FluidData):Number
		{
			return (  data.n00.vx * 0.5
					+ data.n01.vx
					+ data.n02.vx * 0.5
					- data.n20.vx * 0.5
					- data.n21.vx
					- data.n22.vx * 0.5
					
					+ data.n00.vy * 0.5
					+ data.n10.vy
					+ data.n20.vy * 0.5
					- data.n02.vy * 0.5
					- data.n12.vy
					- data.n22.vy * 0.5
					
					) * 0.20;
		}
		
		
		
		
		
		//--------------------------------------
		// EVENT HANDLERS
		//--------------------------------------
	}
}