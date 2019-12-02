'use strict';

self.addEventListener('install', function () {
    self.skipWaiting();
});

self.addEventListener('activate', function () {
    return self.clients.claim();
});

self.addEventListener('fetch', function () {

});

/* global self */
