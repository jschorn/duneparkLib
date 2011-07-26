package com.dunepark.media
{
	import flash.display.Sprite;
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.elements.VideoElement;
	import org.osmf.events.BufferEvent;
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.events.TimelineMetadataEvent;
	import org.osmf.layout.ScaleMode;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.metadata.CuePoint;
	import org.osmf.metadata.TimelineMetadata;
	import org.osmf.net.NetLoader;
	import org.osmf.traits.MediaTraitType;
	
	public class OSMFVideoPlayer extends Sprite
	{
		public var player:MediaPlayer;
		private var container:MediaContainer;
		private var element:VideoElement;
		private var timelineMetadata:TimelineMetadata;
		private var cuePoints:Vector.<CuePoint>;
		private var _duration:Number;
		
		public function get duration():Number
		{
			return _duration;
		}
		
		private var _isPlaying:Boolean = false;
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		public function OSMFVideoPlayer()
		{
			init();
		}
		
		//////////////// PUBLIC METHODS ////////////////
		
		public function loadVideo( path:String, showBackground:Boolean = false, maxHeight:Number = 340, maxWidth:Number = 450 ):void
		{
			if (showBackground)
				container.backgroundAlpha = 1;

			else
				container.backgroundAlpha = 0;
			
			container.height = maxHeight;
			container.width = maxWidth;
			_duration = 0;
			
			var loader:NetLoader = new NetLoader();
			var resource:URLResource = new URLResource( path );
			element = new VideoElement( resource, loader );
			element.smoothing = true;
			player.media = element;
			container.addMediaElement( element );
		}

		public function pause():void
		{
			if (element && this.element.getTrait(MediaTraitType.PLAY) )
			{
				player.pause();
				this._isPlaying = false;
			}
		}  

		public function play():void
		{
			if (element && this.element.getTrait(MediaTraitType.PLAY) )
			{
				player.play();
				this._isPlaying = true;
			}
		}

		public function replay():void
		{
			if (element && this.element.getTrait(MediaTraitType.PLAY) )
			{
				seek(0);
				this._isPlaying = true;
			}
		}
		
		public function seek(time:Number):void
		{
			if (element && this.element.getTrait(MediaTraitType.SEEK) )
			{
				player.seek(time);
				player.play();
				this._isPlaying = true;
			}
		}
		
		public function setVolume(volume:Number):void
		{
			player.volume = volume;
		}
		
		//////////// PRIVATE METHODS //////////////////
		
		private function init():void
		{
			createMediaPlayer();
		}
		
		private function createMediaPlayer():void
		{	
			player = new MediaPlayer( );
			player.addEventListener(MediaErrorEvent.MEDIA_ERROR, onMediaErrorEvent);
			player.addEventListener(BufferEvent.BUFFERING_CHANGE, onBufferingChange);
			player.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoadStateChange);
			player.addEventListener(TimeEvent.COMPLETE, onPlayComplete);
			player.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, onTimeChange);
			
			container = new MediaContainer();	
			container.layoutMetadata.scaleMode = ScaleMode.LETTERBOX;
			container.width = 520;
			container.height = 390;
			container.backgroundColor = 0x000000;
			addChild(container);
		}
		
		public function addCuePoints( cuePoints:Vector.<CuePoint> ):void
		{			
			timelineMetadata = new TimelineMetadata(element);
			timelineMetadata.addEventListener(TimelineMetadataEvent.MARKER_TIME_REACHED, onCuePointHandler);
			
			for each (var point:CuePoint in cuePoints)
				timelineMetadata.addMarker( point );
		}
		
		////////// EVENT HANDLERS ////////////////
		
		private function onCuePointHandler(event:TimelineMetadataEvent):void
		{
			dispatchEvent(event);
		}
		
		private function onBufferingChange(event:BufferEvent):void
		{	
			if (!event.buffering)
				this._duration = player.duration;

			dispatchEvent(event);
		}
		
		private function onLoadStateChange(event:LoadEvent):void
		{
			_isPlaying = player.playing;
			dispatchEvent(event);
		}
		
		private function onMediaErrorEvent(event:MediaErrorEvent):void
		{
			trace("ERROR : OSMFVideoPlayer.onMediaErrorEvent :: " + event.error.message);
		}
		
		private function onPlayComplete(event:TimeEvent):void
		{	
			_isPlaying = false;
			dispatchEvent(event);
		}
			
		private function onTimeChange(event:TimeEvent):void
		{
			dispatchEvent(event);	
		}
				
	}
}