![alt text](images/logo.png "logo")

# WaveDrom editor

[WaveDromEditor](http://wavedrom.com/editor.html) is real-time editor of digital timing diagrams based on [WaveDrom](https://github.com/wavedrom/wavedrom) engine and [WaveJSON](https://github.com/wavedrom/schema/blob/master/WaveJSON.md) format.

See [Tutorial](http://wavedrom.com/tutorial.html) for more examples.

[Online editor](http://wavedrom.com/editor.html)

![alt text](images/firefox_22.gif "firefox") 4+
![alt text](images/chrome_22.gif "chrome") 10+
![alt text](images/safari_22.gif "safari") 5.1+
![alt text](images/opera_22.gif "opera") 12+
![alt text](images/ie_22.gif "ie") 11+

[Download editor](https://github.com/wavedrom/wavedrom.github.io/releases)  (Windows, Mac, Linux)

## Development

* Install `nodejs` (v18+ recommended) from https://nodejs.org/ or via [nvm](https://github.com/nvm-sh/nvm)
* `npm install` to install the development environment
* `npm test` to lint `editor.js` and `init.js`

### Updating the bundled WaveDrom engine

The rendering engine (`wavedrom.min.js`) and skins (`skins/*.js`) served by
`editor.html` are vendored copies of the `wavedrom` npm package. After bumping
the `wavedrom` dependency in `package.json`, refresh the vendored copies:

```sh
npm install
cp node_modules/wavedrom/wavedrom.min.js wavedrom.min.js
cp node_modules/wavedrom/skins/*.js skins/
```

## How to Build the Desktop Application

The desktop app is packaged with [NW.js](https://nwjs.io/) for Windows, Mac
and Linux.

* `npm run build` (or `./build-wde.sh`) stages the app sources into `src/`,
  downloads the matching NW.js runtimes, and produces distributable packages
  under `build/`:
  * `wavedrom-editor-v<version>-linux-x64.tar.gz`
  * `wavedrom-editor-v<version>-win-x64.zip`
  * `wavedrom-editor-v<version>-osx-x64.zip`
  * `wavedrom-editor-v<version>-osx-arm64.zip`

The NW.js version and app version are set at the bottom of `build-wde.sh`:

```sh
bash build.sh --name wavedrom-editor --nwversion v0.115.0 --version v3.7.0
```

Update both values when bumping versions.

## Releasing the Desktop Application (CLI)

1. Bump the version in `package.json` and `WaveDromEditor/package.json`, and
   update the `--version` (and `--nwversion` if needed) in `build-wde.sh`.
2. Build the packages:
   ```sh
   npm run build
   ```
3. Tag the release:
   ```sh
   git tag v3.7.0
   git push origin v3.7.0
   ```
4. Publish the artifacts to [GitHub Releases](https://github.com/wavedrom/wavedrom.github.io/releases)
   using the [`gh` CLI](https://cli.github.com/):
   ```sh
   gh release create v3.7.0 \
     build/wavedrom-editor-v3.7.0-*.tar.gz \
     build/wavedrom-editor-v3.7.0-*.zip \
     --title "v3.7.0" \
     --notes "Release notes here"
   ```

## Community

Please use [WaveDrom user group](http://groups.google.com/group/wavedrom) for discussions, questions, ideas, whatever.

## License

See [LICENSE](LICENSE).
