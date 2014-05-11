![alt text](images/logo.png "logo")

| [EDITOR](http://wavedrom.github.io/editor.html) | [TUTORIAL](http://wavedrom.github.io/tutorial.html) |

[WaveDrom] is Free and Open Source online digital timing diagram (waveform) rendering engine that uses javascript, HTML5 and SVG to convert [WaveJSON] input text description into SVG vector graphics.

[WaveJSON] is an application of the [JSON (JavaScript Object Notation)](http://json.org/) format. The purpose of WaveJSON is to provide a compact exchange format for digital timing diagrams utilized by digital HW / IC engineers.

[WaveDromEditor](http://wavedrom.github.io/editor.html) is online real-time editor of digital timing diagrams based on [WaveDrom] engine and [WaveJSON] format. The engine using [WaveDromSkin] skin mechanism to render complete picture. Multiple timing diagrams can be embedded into your HTML page as described in [WaveDromPlugins].

![alt text](images/firefox_22.gif "firefox") 4+
![alt text](images/chrome_22.gif "chrome") 10+
![alt text](images/safari_22.gif "safari") 5.1+
![alt text](images/opera_22.gif "opera") 12+
![alt text](images/ie_22.gif "ie") 11

## Screenshot

![alt text](images/screenshot.png "screenshot")

## Introduction

WaveDrom timing diagrams can be embedded into the web pages, blogs, wiki pages.

## HTML pages

There are 3 steps to insert WaveDrom diagrams directly into your page:

 1) Put following line into your HTML page ```<header>``` or ```<body>```:

```html
<script src="http://wavedrom.github.io/skins/default.js" type="text/javascript"></script>
<script src="http://wavedrom.github.io/WaveDrom.js" type="text/javascript"></script>
```

 2) Set ``onload`` event for HTML body.

```html
<body onload="WaveDrom.ProcessAll()">
```

 3) Insert Put [[WaveJSON]] source inside HTML ``<body>`` wrapped with ``<script>`` tag:

```html
<script type="WaveDrom">
{ signal : [
  { name: "clk",  wave: "p......" },
  { name: "bus",  wave: "x.34.5x",   data: "head body tail" },
  { name: "wire", wave: "0.1..0." },
]}
</script>
```

Script will find all ``<script type="WaveDrom">`` instances and insert timing diagram at that point.

[jsbin](http://jsbin.com/uderuw/3/) [jsfiddle](http://jsfiddle.net/H7nBn/1/)

## Presentation engines

### impress.js

(http://wavedrom.github.io/impress.html)


## Blogs & Wikis

Blogger integration: (http://wavedrom.blogspot.com/2011/08/wavedrom-digital-timing-diagram-in-your.html)

## Community

Please use [WaveDrom user group](http://groups.google.com/group/wavedrom) for discussions, questions, ideas, whatever.

## License

See [LICENSE](LICENSE).
