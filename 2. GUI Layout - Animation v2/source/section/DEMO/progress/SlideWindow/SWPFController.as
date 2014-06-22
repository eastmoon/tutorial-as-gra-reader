/*
 PureMVC AS3 Demo - Flex Application Skeleton 
 Copyright (c) 2007 Daniele Ugoletti <daniele.ugoletti@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/

package section.DEMO.progress.SlideWindow
{
	import org.puremvc.as3.patterns.observer.Notification;
	import org.gra.controller.Progress.*;
	import org.gra.controller.WSProgressFlow.WSPFController;
	import org.gra.view.WindowSection.Interface.IWindow;
	import org.gra.view.WindowSection.Interface.ISection;
	import org.gra.ApplicationFacade;

    /**
	 * 掌管Progress目前狀態與下個狀態為何。
     */
    public class SWPFController extends WSPFController
    {
        /*static const variable : 靜態常數變數*/
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		// 控制稱呼 
		private var m_slideWindowName : String;
		private var m_loaderWindowName : String;
		
		// 控制項參數
		private var m_slideWindow : IWindow;
		private var m_loaderWindow : IWindow;
		
		// GRA Facade
		private var m_app : ApplicationFacade;
		
		/*display object variable：顯示物件變數，如MovieClip等*/
		/*constructor：建構值*/
		public function SWPFController( a_windowName : String = "", 
									   a_targetName : String = "",
									   a_slideWindowName : String = "",
									   a_loaderName : String = "",
									   a_loaderWindowName : String = "",
									   a_sourceName : String = "",
									   a_params : Array = null, 
									   a_progress : IProgress = null ) : void
		{
			// 取得Application Facade
			this.m_app = ApplicationFacade.getInstance();
			// 父層宣告
			super( a_windowName, a_targetName, a_sourceName, a_loaderName, a_params, a_progress );
			// 通告型態
			this.setType("SWProgressFlowController");
			
			// 儲存參數
			this.setSlideWindowName( a_slideWindowName );
			this.setLoaderWindowName( a_loaderWindowName );
		}
	
		/**public function：對外公開函數*/
		public override function Clone( a_clone : IProgressController = null ) : IProgressController
		{				
			var clone : SWPFController = null;
			if( a_clone != null )
			{
				clone = a_clone as SWPFController;
				clone.setSlideWindowName( this.m_slideWindowName );
				clone.setLoaderWindowName( this.m_loaderWindowName );
			}
			else
			{
				clone = new SWPFController( "",
										   "",
										   this.m_slideWindowName,
										   "",
										   this.m_loaderWindowName,
										   "",
										   this.getParams(),
										   this.getProgress() );
			}
			// 複製父層資訊
			super.Clone( clone );
			
			// 複製本層資訊			
			
			// 回傳複製體
			return clone;
		}
		/*public event function：公開事件函數*/
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		public function setSlideWindowName( a_name : String ) : void
		{
			this.m_slideWindowName = a_name;
			// 取得Window實體
			if( this.m_app != null )
			{
				this.m_slideWindow = this.m_app.retrieveWindow( this.m_slideWindowName );
			}
		}
		
		public function setLoaderWindowName( a_name : String ) : void
		{
			this.m_loaderWindowName = a_name;
			// 取得Window實體
			if( this.m_app != null )
			{
				this.m_loaderWindow = this.m_app.retrieveWindow( this.m_loaderWindowName );
			}
		}
		/*read only：唯讀*/
		public function getSlideWindow() : IWindow
		{
			return this.m_slideWindow;
		}
		public function getLoaderWindow() : IWindow
		{
			return this.m_loaderWindow;
		}
		
		/*read/write：讀寫*/
		
		/*private event function：私用事件函數*/
		/*private function：私用函數*/
    }
}