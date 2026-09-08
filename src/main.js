'use strict';
var Elm = require('./elm/App.elm').Elm;

var app = Elm.App.init({
  node: document.getElementById('app'),
  flags: {
    client_id: process.env.SOUNDCLOUD_CLIENT_ID,
  },
});

var audio = new Audio();

audio.onended = function() {
  app.ports.endSong.send(null);
};

app.ports.playSong.subscribe(function(songSrc) {
  if (songSrc !== audio.src) {
    audio.pause();
    audio.src = songSrc;
  }
  audio.play();
});

app.ports.pauseSong.subscribe(function() {
  audio.pause();
});

app.ports.stopSong.subscribe(function() {
  audio.pause();
  audio.src = '';
});

app.ports.seekSong.subscribe(function(time) {
  audio.currentTime = time / 1000;
});
