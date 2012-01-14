package net.alumican.as3.algorithm.ga
{
	import flash.events.EventDispatcher;
	
	import net.alumican.as3.algorithm.ga.events.*;
	import net.alumican.as3.algorithm.ga.packets.*;
	
	/**
	 * World
	 *
	 * @author alumican.net<Yukiya Okuda>
	 */
	public class World extends EventDispatcher
	{
		//----------------------------------------
		//CLASS CONSTANTS
		
		
		
		
		
		//----------------------------------------
		//VARIABLES
		
		/**
		 * 現在世代評価待ちの場合はtrue
		 */
		public function get isWaitingEvaluation():Boolean { return __isWaitingEvaluation; }
		private var __isWaitingEvaluation:Boolean;
		
		
		
		
		
		//----------------------------------------
		//METHODS
		
		/**
		 * コンストラクタ
		 */
		public function World():void 
		{
			__isWaitingEvaluation = false;
		}
		
		/**
		 * 世代を評価する
		 * @param generation
		 * @param eliteCount
		 * @return
		 */
		internal function _evaluate(generation:Generation):void
		{
			//エリート主義を使用する場合は全個体のフラグを降ろす
			if (generation.eliteCount > 0)
			{
				var agent:Agent = generation.head;
				do {
					agent._isElite = false;
				}
				while (agent = agent.next);
			}
			
			__isWaitingEvaluation = true;
			
			//評価要求イベントの発行
			dispatchEvent( new EvaluateEvent(EvaluateEvent.REQUEST, generation, null) );
			
			//世代評価関数
			_evaluateGeneration(generation);
		}
		
		/**
		 * 世代を評価する
		 * generationが格納する個体のfitnessを書き換える
		 * @param generation 評価対象となる世代
		 */
		protected function _evaluateGeneration(generation:Generation):void
		{
			if (!isWaitingEvaluation) return;
			
			//個体毎の評価関数
			var evaluateChromosome:Function = function(chromosome:Array):Number
			{
				var fitness:Number = 0;
				var n:uint = chromosome.length;
				var old:uint = chromosome[0];
				for (var i:uint = 1; i < n; ++i)
				{
					if (chromosome[i] != old)
					{
						++fitness;
						old = chromosome[i];
					}
				}
				return fitness;
			}
			
			//各個体を評価
			var agent:Agent = generation.head;
			do {
				//未評価の場合のみ評価する
				if ( isNaN(agent.fitness) )
				{
					agent.fitness = evaluateChromosome(agent.chromosome);
				}
			}
			while (agent = agent.next);
			
			//評価完了通知
			notifyEvaluateGenerationComplete(generation);
		}
		
		/**
		 * 世代評価の完了時に呼び出される
		 * @param generation 評価対象となる世代
		 */
		public function notifyEvaluateGenerationComplete(generation:Generation):void
		{
			if (!__isWaitingEvaluation) return;
			__isWaitingEvaluation = false;
			
			//個体を適合度でソート
			var agents:Array = generation.agents;
			agents.sortOn("fitness", Array.NUMERIC | Array.DESCENDING);
			
			//エリート主義を使用する場合は各個体にフラグを立てる
			var eliteCount:uint = generation.eliteCount;
			if (eliteCount > 0)
			{
				if (eliteCount == 1)
				{
					Agent(agents[0])._isElite = true;
				}
				else
				{
					for (var i:uint = 0; i < eliteCount; ++i) Agent(agents[i])._isElite = true;
				}
			}
			
			//評価完了イベントの発行
			dispatchEvent( new EvaluateEvent(EvaluateEvent.COMPLETE, generation, Agent(agents[0])) );
		}
	}
}