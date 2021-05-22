---
title: Parallel chunk requests in a browser via Service Workers
excerpt: >-
  I encountered an issue where I needed to multiplex the downloading of
  extensive files in separate parallel chunk requests. In this post, I’m trying
  to implement it via Service Workers, they are not only for offline-first
  applications after all.
categories:
  - Thoughts
tags:
  - javascript
  - browser
  - service
  - worker
  - parallel
  - download
  - multiplex
header:
  overlay_image: assets/uploads/2016-09-30/worker.jpg
  overlay_filter: 0.5
  caption: Photo by Ricardo Gomez Angel on Unsplash
  teaser: assets/uploads/2016-09-30/worker.jpg
---

## Scenario

First, let me describe the scenario and a use-case for it.
Imagine your site has a lot of video and audio files (_it can be any resource you have_).
When the browser fetches these resources, it will do it in one request per resource.
So, your network requests look like this:

{% include figure image_path="assets/uploads/2016-09-30/request-per-file.png" alt="One Request per File" caption="Network Tab in Google Chrome" %}

As you can see, there are a lot of resources and each resource is downloaded by a separate request, no matter how big the file is.

But, what if **we could load one resource in a few separate requests at once, improving loading time?**

## First Steps

It all began with this tweet:

{% include figure image_path="assets/uploads/2016-09-30/tweet-1.png" alt="Tweet" caption="https://twitter.com/ghaiklor/status/762256070299574272" %}

I was trying to intercept these resource requests, after a while, I realized that I can only do this in the same origin, so I switched to video files, located under the same origin.

Intercepting all requests can easily be achieved via _fetch_ events in Service Worker.

```javascript
self.addEventListener('fetch', function(event) {
  // Do your stuff here
});
```

From now on, all the requests in your application will be intercepted by Service Worker, where you can handle all the stuff and do what you want with the request.

The question here is **how to make parallel requests?**

## Parallel requests

**_Content-Range_** and **_Range_** headers come in handy here.

> Since all HTTP entities are represented in HTTP messages as sequences of bytes, the concept of a byte range is meaningful for any HTTP entity.
>
> HTTP retrieval requests using conditional or unconditional GET methods MAY request one or more sub-ranges of the entity, instead of the entire entity, using the Range request header, which applies to the entity returned as the result of the request.
>
> The Content-Range entity-header is sent with a partial entity-body to specify where in the full entity-body the partial body should be applied.

You can send **_Range_** header to a server, and it will respond with a partial body of requested resource.

I got a successful solution for it within a few lines of code, applying custom headers in a request, specifying **_Range_**.

```javascript
fetch(url, {
  headers: {
    Range: 'bytes=-/'
  }
});
```

The server responds to me with a chunk of a resource, so **_Range_** header is working, hooray.

Now, we need to build separate requests with different byte ranges and run them.
But… wait… how can we build separate requests for a file when we don’t know how big this file?

That’s where **_HEAD_** requests comes in handy.
We can ask server about the file size — **_Content-Length_**.

```javascript
self.addEventListener('fetch', function(event) {
  fetch(new Request(event.request, {method: 'HEAD'}))
    .then(response => response.headers.get('content-length'))
    .then(contentLength => doSomething(contentLength));
});
```

Ok… we know how big the file is.
Now, we can build a loop, creating all the requests with different byte ranges and running them.

```javascript
const ourRequestsArray = Array
  .from({length: Math.ceil(contentLength / CHUNK_SIZE)})
  .map((_, i) => {
    const headers = new Headers();
    headers.append('Range', `bytes=${i * CHUNK_SIZE}-${i * CHUNK_SIZE + CHUNK_SIZE - 1}/${contentLength}`);

    return fetch(new Request(request, {headers}));
  });
```

Great, we have an array that stores all the requests to different byte ranges.
As a result, we can get these chunks by:

```javascript
Promise
  .all(ourRequestsArray)
  .then(responses => doSomethingWithResponses(responses));
```

The last thing here is — **how do we combine these into one?**

## Combining responses

We have all we need; the last thing is combining responses.

After some research, I came up with a solution, where we can use responses as an **_ArrayBuffer_**.

{% include figure image_path="assets/uploads/2016-09-30/tweet-2.png" alt="Tweet" caption="https://twitter.com/ghaiklor/status/762342437851389952" %}

We have responses to all chunks of a file.
We know how to combine them into one.
Let’s do this.

```javascript
function onHeadResponse(request, response) {
  const contentLength = response.headers.get('content-length');
  const promises = Array
    .from({length: Math.ceil(contentLength / CHUNK_SIZE)})
    .map((_, i) => {
      const headers = new Headers(request.headers);
      headers.append('Range', `bytes=${i * CHUNK_SIZE}-${i * CHUNK_SIZE + CHUNK_SIZE - 1}/${contentLength}`);
      return fetch(new Request(request, {headers}));
    });

  return Promise
    .all(promises)
    .then(responses => Promise.all(responses.map(res => res.arrayBuffer())))
    .then(buffers => new Response(buffers.reduce(concatArrayBuffer)));
}

function onFetch(event) {
  return event.respondWith(
    fetch(new Request(event.request, {method: 'HEAD'}))
      .then(onHeadResponse.bind(this, event.request)));
}

self.addEventListener('fetch', onFetch);
```

## Finally

And… we’re done here.

{% include figure image_path="assets/uploads/2016-09-30/tweet-3.png" alt="Tweet" caption="https://twitter.com/ghaiklor/status/765588363839737856" %}

Notice how only one file is being downloaded, but in separate requests.

Thanks for reading.
I hope this article helped you understand how Service Workers can be used in situations other than offline-first applications.

_Full source:_

{% gist aad48676cf4f356a87de34f15ef116b1 %}

---

*Eugene Obrezkov, Senior Node.js Developer at [Dev-Pro.net](https://www.dev-pro.net), Kharkov, Ukraine.*
