package {
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	[SWF(width="320", height="240", frameRate="30", backgroundColor="#000000")]
	public class FaceShow extends Sprite {
		private var cam:Camera = null;
		private var vid:Video = null;
		private const RESIZE_BORDER_WIDTH:int = 20;
		private var cameraIndex:int = 0;
		public function FaceShow() {
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			this.graphics.drawRect(0, 0, 320, 240);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.stage.addEventListener(Event.RESIZE, resizeHandler);
			this.stage.addEventListener(MouseEvent.RIGHT_CLICK, rightClickHandler);
			this.stage.nativeWindow.alwaysInFront = true;
			initCamera();
		}
		protected function mouseDownHandler(e:MouseEvent):void {
			var rightSide:Boolean = e.stageX > stage.stageWidth - RESIZE_BORDER_WIDTH;
			var leftSide:Boolean = e.stageX < RESIZE_BORDER_WIDTH && !rightSide;
			var bottomSide:Boolean = e.stageY > stage.stageHeight - RESIZE_BORDER_WIDTH;
			var topSide:Boolean = e.stageY < RESIZE_BORDER_WIDTH && !bottomSide;
			var resizeString:String = "";
			if (topSide) resizeString += "T";
			if (bottomSide) resizeString += "B";
			if (leftSide) resizeString += "L";
			if (rightSide) resizeString += "R";
			if (resizeString.length == 0) {
				this.stage.nativeWindow.startMove();
			} else {
				this.stage.nativeWindow.startResize(resizeString);
			}
		}
		protected function initCamera():void {
			cam = Camera.getCamera(Camera.names[cameraIndex]);
			if (cam == null) {
				trace("WTF - camera is null, this machine has no camera");
				return;
			}
			cam.setMode(stage.stageWidth, stage.stageHeight, 30);
			vid = new Video(stage.stageWidth, stage.stageHeight);
			vid.attachCamera(cam);
			addChild(vid);
		}
		protected function resizeHandler(e:Event):void {
			//if (cam == null) return;
			//removeChild(vid);
			//initCamera();
		}
		protected function rightClickHandler(e:MouseEvent):void {
			switchToNextCamera();
		}
		protected function switchToNextCamera():void {
			cameraIndex = (cameraIndex + 1) % Camera.names.length;
			trace("switch to cam " + cameraIndex.toString());
			cam = Camera.getCamera(Camera.names[cameraIndex]);
			if (cam == null) {
				trace("WTF - camera is null, this machine has no camera");
				return;
			}
			cam.setMode(stage.stageWidth, stage.stageHeight, 30);
			vid.attachCamera(cam);
		}
	}

}
