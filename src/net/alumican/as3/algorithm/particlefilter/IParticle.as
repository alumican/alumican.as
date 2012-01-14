package particlefilter
{
	
	/**
	 * IParticle
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	
	public interface IParticle 
	{
		function get weight():Number;
		function set weight(value:Number):void;
		
		function clone():IParticle;
	}
}