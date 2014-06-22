/*
 PureMVC AS3 Demo - Flex Application Skeleton 
 Copyright (c) 2007 Daniele Ugoletti <daniele.ugoletti@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package section.DEMO.module.Reader
{	

	/*import：Flash內建元件庫*/
	/*external import：外部元件庫、開發人員自定元件庫*/
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	// 物理運動引擎 Tweener
	import caurina.transitions.Tweener;
	// 物理運動引擎 TweenMax
	import com.greensock.TweenMax;
	// Game rule architecture Import
	import org.gra.ApplicationFacade;
	import org.gra.model.RuleModel.Core.RMModule;
	import org.gra.model.RuleModel.Core.RMNotify;
	import org.gra.model.RuleModel.Core.RMNotification;
	
	public class ReaderModule extends RMModule
	{		
		/*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		/*display object variable：顯示物件變數，如MovieClip等*/
		/*constructor：建構值*/
		public function ReaderModule() : void
		{
			super( "ReaderModule" );			
			// 登記Application事件
			//this.AddNotify( RMNotify.UPDATE, this.Update );
		}
		/*public function：對外公開函數*/
		public override function onRegister() : void
		{
			// Initial model notify relationship
			/*
			本範例的Module註冊是在內部完成，但實際上註冊也可在InitialModelCommand中完成。
			在ApplicationFacade的關係是屬於同管理層，但在執行期間仍需依據Module關係設定階層式架構的Module樹。
			*/
			var app : ApplicationFacade = ApplicationFacade.getInstance();
			var module : RMModule = null;
		}
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		/*read/write：讀寫*/
		/*private event function：私用事件函數*/
		private function NotifyTarget( a_notification : RMNotification ) : void
		{
			switch( a_notification.getType() )
			{
				
			}
		}
		/*private function：私用函數*/
	}
}