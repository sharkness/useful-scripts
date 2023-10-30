// Pop this into the console of the browser and run

function adjustEmbeddedVideoPlaybackRate(frame, playbackRate) {
  var i;
  for (i=0; i<frame.frames.length; i++) {
    try {
      adjustEmbeddedVideoPlaybackRate(frame.frames[i], playbackRate);
      frame.frames[i].document.querySelector('video').playbackRate = playbackRate;
    }
    catch(e) {};
  }
}
adjustEmbeddedVideoPlaybackRate(window, 1.5);
