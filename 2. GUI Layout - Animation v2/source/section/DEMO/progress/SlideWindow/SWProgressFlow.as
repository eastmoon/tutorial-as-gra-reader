/*
 PureMVC AS3 Demo - Flex Application Skeleton 
 Copyright (c) 2007 Daniele Ugoletti <daniele.ugoletti@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/

package section.DEMO.progress.SlideWindow
{
	/*external import：外部元件庫、開發人員自定元件庫*/
    import org.puremvc.as3.interfaces.*;
	import org.gra.view.WindowSection.Interface.*;
	import org.gra.controller.Progress.Progress;
	import org.gra.controller.WSProgressFlow.WSProgressFlow;

	// 物理運動引擎 TweenMax
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.display.Sprite;

    /**
     * 
     */
    public class SWProgressFlow extends Progress
    {
		/*static const variable : 靜態常數變數*/		
		// 流程名稱
		public static const SLIDE_LOADING = "SWPFSetLoadingWindow";
		public static const SLIDE_INITIAL = "SWPFInitialSlideWindow";
		public static const SLIDE_WINDOW = "SWPFSlideWindow";
		public static const SLIDE_COMPLETE = "SWPFSlideComplete";
		
		// 事件稱呼
		public static const EVENT_PROGRESS_FLOW = "SlideWindowProgressFlowCommand";
		/*const variable：常數變數*/
		/*function variable：函數變數*/
		/*member variable：物件內部操作變數*/
		/*display object variable：顯示物件變數，如MovieClip等*/
		/*constructor：建構值*/
		public function SWProgressFlow() : void
		{
			// 重建立控制器
			this.setController( new SWPFController( "", "", "", "", "", "", null, this ) );
						
			// 設定流程
			// 0. 上個流程為結束前不可執行
			// 1. 載入
			//	- Loader Section, Display
			//	- Loader Section, Loading
			//	- Loader Section, Disappear
			// 2. 放至Target Section到Slide Window
			//	- Source Section, PreProcess
			//	- Source Section, Disappear
			//	- Target Section, Initial
			//	- Target Section, Display
			// 3. 移動Window
			//	- Source Section, Close
			//	- Target Section, CompleteProcess
			// 4. Source Window遺除Source Section
			// 5. Slide Window遺除Target Section
			// 6. 放至Target Section到Source Window
			this.AddProgress(SWProgressFlow.SLIDE_LOADING, this.SetLoadingWindow);
			
			this.AddProgress(WSProgressFlow.LOADING_PREPARATION, this.StepProgress);
			this.AddProgress(WSProgressFlow.LOADING, this.StepProgress);
			this.AddProgress(WSProgressFlow.LOADING_COMPLETE, this.StepProgress);
			
			this.AddProgress(SWProgressFlow.SLIDE_INITIAL, this.InitialSlide);
			
			this.AddProgress(WSProgressFlow.DISAPPEAR_PREPARATION, this.StepProgress);
			this.AddProgress(WSProgressFlow.DISAPPEAR, this.StepProgress);
			this.AddProgress(WSProgressFlow.DISPLAY_PREPARATION, this.StepProgress);
			this.AddProgress(WSProgressFlow.DISPLAY, this.StepProgress);
			
			this.AddProgress(SWProgressFlow.SLIDE_WINDOW, this.SlideProgress);
			
			this.AddProgress(WSProgressFlow.DISAPPEAR_COMPLETE, this.StepProgress);
			this.AddProgress(WSProgressFlow.DISPLAY_COMPLETE, this.StepProgress);
			
			this.AddProgress(SWProgressFlow.SLIDE_COMPLETE, this.SlideComplete);
		}
		/*public function：對外公開函數*/
		override public function execute( note:INotification ) : void    
		{
			// 處理程序
			// 依據傳入參數取得相對的Window與Section關聯
			if( note.getBody() != null && note.getBody() is SWPFController )
			{
				var info : SWPFController = note.getBody() as SWPFController;
				var controller : SWPFController = this.getController() as SWPFController;
				
				if( info.getSource() != null && info.getTarget() != null &&
				   info.getSource().getMediatorName() == info.getTarget().getMediatorName())
				   return ;				
				
				// 複製資訊 Window
				if( info.getWindow() != null )
					controller.setWindowName( info.getWindow().getName() );
				// 複製資訊 Slide Window
				if( info.getSlideWindow() != null )
					controller.setSlideWindowName( info.getSlideWindow().getName() );
				// 複製資訊 Loader Window
				if( info.getLoaderWindow() != null )
					controller.setLoaderWindowName( info.getLoaderWindow().getName() );
				// 複製資訊 Source
				if( info.getSource() != null )
					controller.setSourceName( info.getSource().getMediatorName() );
				// 複製資訊 Target
				if( info.getTarget() != null )
					controller.setTargetName( info.getTarget().getMediatorName() );
				// 複製資訊 Loader
				if( info.getLoader() != null )
					controller.setLoaderName( info.getLoader().getMediatorName() );
				// 複製資訊 Params
				if( info.getParams() != null )
					controller.setParams( info.getParams() );
					
			}
			
			// 父層執行
			super.execute( note );
        }
		/**public event function：公開事件函數*/
		/*public get/set function：變數存取介面*/
		/*write only：唯寫*/
		/*read only：唯讀*/
		/*read/write：讀寫*/
		/*private event function：私用事件函數*/
		/*private function：私用函數*/
		protected function StepProgress( a_controller : SWPFController ) : void
		{
			//trace( a_controller.getCurrentStepName() );
			switch( a_controller.getCurrentStepName() )
			{
				case WSProgressFlow.LOADING_PREPARATION :
				case WSProgressFlow.LOADING :
				case WSProgressFlow.LOADING_COMPLETE :
				{
					if( a_controller.getLoader() != null )
					{
						switch( a_controller.getCurrentStepName() )
						{
							case WSProgressFlow.LOADING_PREPARATION :
								a_controller.getLoader().Display( a_controller );
							break;
							case WSProgressFlow.LOADING :
								a_controller.getLoader().Loading( a_controller );
							break;
							case WSProgressFlow.LOADING_COMPLETE :
								a_controller.getLoader().Disappear( a_controller );
							break;
						}
					}
					else
						a_controller.Next();
				}
				break;
				case WSProgressFlow.DISAPPEAR_PREPARATION :
				case WSProgressFlow.DISAPPEAR :
				case WSProgressFlow.DISAPPEAR_COMPLETE :
				{
					if( a_controller.getSource() != null )
					{
						switch( a_controller.getCurrentStepName() )
						{
							case WSProgressFlow.DISAPPEAR_PREPARATION :
								a_controller.getSource().PreProcess( a_controller );
							break;
							case WSProgressFlow.DISAPPEAR :
								a_controller.getSource().Disappear( a_controller );
							break;
							case WSProgressFlow.DISAPPEAR_COMPLETE :
								a_controller.getSource().Close( a_controller );
							break;
						}
					}
					else
						a_controller.Next();
				}
				break;
				case WSProgressFlow.DISPLAY_PREPARATION :
				case WSProgressFlow.DISPLAY :
				case WSProgressFlow.DISPLAY_COMPLETE :
				{
					if( a_controller.getTarget() != null )
					{
						switch( a_controller.getCurrentStepName() )
						{
							case WSProgressFlow.DISPLAY_PREPARATION :
								a_controller.getTarget().Initial( a_controller );
							break;
							case WSProgressFlow.DISPLAY :
								a_controller.getTarget().Display( a_controller );
							break;
							case WSProgressFlow.DISPLAY_COMPLETE :
								a_controller.getTarget().CompleteProcess( a_controller );
							break;
						}
					}
					else
						a_controller.Next();
				}
				break;
			}
		}
		protected function SetLoadingWindow( a_controller : SWPFController ) : void
		{
			// 1. 載入，讀取界面放至於讀取視窗
			if( a_controller.getLoader() != null && a_controller.getLoaderWindow() != null )
			{
				a_controller.getLoaderWindow().setSection( a_controller.getLoader() as ISection );
			}
			a_controller.Next();
		}
		protected function InitialSlide( a_controller : SWPFController ) : void
		{
			// 預設Slide Window參數
			var window : IWindow = null;
			var rect : Rectangle = null;
			if( a_controller.getSlideWindow() != null )
			{
				window = a_controller.getSlideWindow();
				rect = window.getCurrentViewport();				
				(window as DisplayObject).x = rect.width;
			}
			// 2. 放至Target Section到Slide Window
			if( a_controller.getTarget() != null && a_controller.getSlideWindow() != null )
			{
				a_controller.getSlideWindow().setSection( a_controller.getTarget() as ISection );
			}
			a_controller.Next();
		}
		protected function SlideProgress( a_controller : SWPFController ) : void
		{
			//trace( "SP", a_controller.getCurrentStepName() );
			// 3. 移動Window
			var window : IWindow = null;
			var rect : Rectangle = null;
			var param : Object = null;
			var isCallNext : Boolean = false;
			
			if( a_controller.getWindow() != null )
			{
				window = a_controller.getWindow();
				rect = window.getCurrentViewport();
				
				param = new Object();
				param.time = .5;
				param.vars = new Object();
				param.vars.x = -rect.width;
				if( !isCallNext )
				{
					param.vars.onComplete = a_controller.Next;
					isCallNext = true;
				}
				
				TweenMax.to( window as DisplayObject, param.time, param.vars );
			}
			
			if( a_controller.getSlideWindow() != null )
			{
				window = a_controller.getSlideWindow();
				rect = window.getCurrentViewport();
				
				param = new Object();
				param.time = .5;
				param.vars = new Object();
				param.vars.x = 0;
				if( !isCallNext )
				{
					param.vars.onComplete = a_controller.Next;
					isCallNext = true;
				}
				
				TweenMax.to( window as DisplayObject, param.time, param.vars );
			}
		}
		protected function SlideComplete( a_controller : SWPFController ) : void
		{
			// 4. Source Window遺除Source Section
			// 5. Slide Window遺除Target Section
			// 6. 放至Target Section到Source Window
			if( a_controller.getSource() != null )
				(a_controller.getSource() as ISection).setWindow( null );
			if( a_controller.getTarget() != null )
				(a_controller.getTarget() as ISection).setWindow( a_controller.getWindow() );
			if( a_controller.getWindow() != null )
			{
				(a_controller.getWindow() as DisplayObject).x = 0;
			}
		}
    }
}