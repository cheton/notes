# Basic 3D Graphics Using Three.js

### Featured Projects
http://threejs.org/

### Samsung Racer S
http://helloracer.com/racer-s/

## WebGL

### What's WebGL

https://www.khronos.org/webgl/wiki/Getting_Started

### Key Advantages

Because it is based on OpenGL and will be integrated across popular browsers, WebGL offers a number of advantages, among them:

* An API that is based on a familiar and widely accepted 3D graphics standard
* Cross-browser and cross-platform compatibility
* Tight integration with HTML content, including layered compositing, interaction with other HTML elements, and use of the standard HTML event handling mechanisms
* Hardware-accelerated 3D graphics for the browser environment
* A scripting environment that makes it easy to prototype 3D graphics—you don't need to compile and link before you can view and debug the rendered graphics

### Browser Support

* https://get.webgl.org/
* https://caniuse.com/#feat=webgl

## Renderers

### WebGLRenderer
https://threejs.org/docs/#api/renderers/WebGLRenderer

The WebGL renderer displays your beautifully crafted scenes using [WebGL](https://en.wikipedia.org/wiki/WebGL).

#### Constructor

##### WebGLRenderer(parameters : Object)

```js
renderer = new THREE.WebGLRenderer({ antialias: true });
renderer.setPixelRatio(window.devicePixelRatio);
renderer.setSize(window.innerWidth, window.innerHeight);
document.getElementById('container').appendChild(renderer.domElement);
```


### CanvasRenderer

The Canvas renderer displays your beautifully crafted scenes not using WebGL, but draws it using the (slower) Canvas 2D Context API.

**NOTE: The Canvas renderer has been deprecated and is no longer part of the three.js core.** If you still need to use it you can find it here: [examples/js/renderers/CanvasRenderer.js](https://github.com/mrdoob/three.js/blob/master/examples/js/renderers/CanvasRenderer.js).

This renderer can be a nice fallback from WebGLRenderer for simple scenes:

```js
function webglAvailable() {
    try {
        var canvas = document.createElement('canvas');
        return !!(window.WebGLRenderingContext && (
            canvas.getContext('webgl') ||
            canvas.getContext('experimental-webgl'))
        );
    } catch (e) {
        return false;
    }
}

if (webglAvailable()) {
    renderer = new THREE.WebGLRenderer();
} else {
    renderer = new THREE.CanvasRenderer();
}
```

### CSS2DRenderer

CSS2DRenderer is a simplified version of CSS3DRenderer. The only transformation that is supported is translation.

The renderer is very useful if you want to combine HTML based labels with 3D objects. Here too, the respective DOM elements are wrapped into an instance of CSS2DObject and added to the scene graph.

```js
labelRenderer = new THREE.CSS2DRenderer();
labelRenderer.setSize( window.innerWidth, window.innerHeight );
labelRenderer.domElement.style.position = 'absolute';
labelRenderer.domElement.style.top = '0';
labelRenderer.domElement.style.pointerEvents = 'none';
document.getElementById( 'container' ).appendChild( labelRenderer.domElement );
```

#### Examples

[css2d molecules](https://threejs.org/examples/webgl_loader_pdb.html) - [source](https://github.com/mrdoob/three.js/blob/master/examples/webgl_loader_pdb.html)

![image](https://user-images.githubusercontent.com/447801/40714904-6f545508-6436-11e8-8331-bc55ff56dc1a.png)

### CSS3DRenderer

CSS3DRenderer can be used to apply hierarchical 3D transformations to DOM elements via the CSS3 transform property. This renderer is particular interesting if you want to apply 3D effects to a website without canvas based rendering. It can also be used in order to combine DOM elements with WebGL content.

There are, however, some important limitations:

* It's not possible to use the material system of three.js.
* It's also not possible to use geometries.

So CSS3DRenderer is just focused on ordinary DOM elements. These elements are wrapped into special objects (CSS3DObject or CSS3DSprite) and then added to the scene graph.

```js
renderer = new THREE.CSS3DRenderer();
renderer.setSize(window.innerWidth, window.innerHeight);
document.getElementById('container').appendChild(renderer.domElement);
```

#### Examples

[css3d molecules](https://threejs.org/examples/css3d_molecules.html) - [source](https://github.com/mrdoob/three.js/blob/master/examples/css3d_molecules.html)

![image](https://user-images.githubusercontent.com/447801/40715187-523f3e28-6437-11e8-92af-fd6e4502e680.png)

### SVGRenderer

SVGRenderer can be used to render geometric data using SVG. The produced vector graphics are particular useful in the following use cases:

* Animated logos or icons
* Interactive 2D/3D diagrams or graphs
* Interactive maps
* Complex or animated user interfaces

SVGRenderer has various advantages. It produces crystal-clear and sharp output which is independet of the actual viewport resolution.
SVG elements can be styled via CSS. And they have good accessibility since it's possible to add metadata like title or description (useful for search engines or screen readers).

There are, however, some important limitations:

* No advanced shading
* No texture support
* No shadow support

#### Examples

[svg_lines](https://threejs.org/examples/svg_lines.html) - [source](https://github.com/mrdoob/three.js/blob/master/examples/svg_lines.html)

![image](https://user-images.githubusercontent.com/447801/40715878-a608aa88-6439-11e8-8040-6ae6d22c0d16.png)

## Creating Your First 3D Scene with Three.js

https://jsfiddle.net/cheton/pj1kmdb0/

[![image](https://cloud.githubusercontent.com/assets/447801/17285949/bd9ebdf8-57f8-11e6-8404-96cc3b47e7ed.png)](https://jsfiddle.net/cheton/pj1kmdb0/)

## Getting Started

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>My first Three.js app</title>
<style>
  body { margin: 0; }
  canvas { width: 100%; height: 100% }
</style>
</head>
<body>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r79/three.js"></script>
  <script src="https://rawgit.com/mrdoob/three.js/dev/examples/js/controls/TrackballControls.js"></script>
</body>
</html>
```

### Creating the scene

To actually be able to display anything with Three.js, we need three things: A scene, a camera, and a renderer so we can render the scene with the camera.

```js
var scene = new THREE.Scene();
var camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
camera.position.x = 2;
camera.position.y = -2;
camera.position.z = 5;

var renderer = new THREE.WebGLRenderer(); // or new THREE.CanvasRenderer();
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);
```

### Camera

![image](https://cloud.githubusercontent.com/assets/447801/23149011/06e82f14-f824-11e6-8b99-d74d80bcd3d6.png)

#### Orthographic Projection

![image](https://cloud.githubusercontent.com/assets/447801/23883266/d1961d0c-08a0-11e7-90d3-181d5dd41f58.png)

```js
const zoom = Math.min(visibleWidth / width, visibleHeight / height);
camera.setZoom(zoom);
```

#### Perspective Projection

![image](https://cloud.githubusercontent.com/assets/447801/23883274/dae2d63e-08a0-11e7-8944-a8b8d5f0a425.png)

```js
const { x, y, z } = this.camera.position;
const eye = new THREE.Vector3(x, y, z);
const target = new THREE.Vector3(0, 0, 0);
// Find the distance from the camera to the closest face of the object
const distance = target.distanceTo(eye);
// The aspect ratio of the canvas (width / height)
const aspect = visibleHeight > 0 ? (visibleWidth / visibleHeight) : 1;

const fov = Math.max(
    // to fit the viewport height
    2 * Math.atan(height / (2 * distance)) * (180 / Math.PI),
    // to fit the viewport width
    2 * Math.atan((width / aspect) / (2 * distance)) * (180 / Math.PI)
);

camera.setFov(Math.max(fov, FOV_MIN));
```

#### Viewport

https://github.com/cncjs/cncjs/blob/master/src/web/widgets/Visualizer/Viewport.js


#### PerspectiveCamera( fov, aspect, near, far )
![image](https://cloud.githubusercontent.com/assets/447801/17282736/99ccb578-57db-11e6-84eb-d5af9905ee5a.png)

- fov - The camera's vertical field of view, in degrees (from the bottom to the top of the view).<br>
- aspect - The camera's aspect ratio.<br>
- near - The near camera frustum plane.<br>
- far - The far camera frustum plane.<br>

### Trackball controls

```js
var controls = new THREE.TrackballControls(camera);
controls.rotateSpeed = 1.0;
controls.zoomSpeed = 1.2;
controls.panSpeed = 0.8;
```

### Creating the cube

![image](https://cloud.githubusercontent.com/assets/447801/17285107/2b1555e6-57f3-11e6-9b7a-a7b9802215e0.png)

```js
// BoxGeometry(width, height, depth, widthSegments, heightSegments, depthSegments)
var geometry = new THREE.BoxGeometry(1, 1, 1, 1, 1, 1);
var material = new THREE.MeshBasicMaterial({
    color: 0x00ff00,
    wireframe: true
});
var cube = new THREE.Mesh(geometry, material);
scene.add(cube);
```

#### Face segmentation

![image](https://cloud.githubusercontent.com/assets/447801/17289270/8c165ed6-580b-11e6-9ab9-e624869409c3.png)

```js
var geometry = new THREE.BoxGeometry(1, 1, 1, 10, 10, 10);
```

### Applying textures to the cube

![image](https://cloud.githubusercontent.com/assets/447801/17288669/ce358fb0-5808-11e6-8d10-5787478c3ee1.png)

```js
var geometry = new THREE.BoxGeometry(1, 1, 1);
var texture = new THREE.TextureLoader().load('https://stemkoski.github.io/Three.js/images/crate.gif');
var material = new THREE.MeshBasicMaterial({
    map: texture
});
var cube = new THREE.Mesh(geometry, material);
scene.add(cube);
```

### Rendering the scene

```js
function render() {
    requestAnimationFrame(render);
    renderer.render(scene, camera);
}
render();
```

### Animating the cube

Add the following right above the renderer.render call in your render function:

```js
cube.rotation.z += 0.01;
```

This will be run every frame (60 times per second), and give the cube a nice rotation animation.

### The result

```js
var scene = new THREE.Scene();

// Camera
var camera = new THREE.PerspectiveCamera( 75, window.innerWidth/window.innerHeight, 0.1, 1000 );
camera.position.x = 2;
camera.position.y = -2;
camera.position.z = 5;

// WebGL Renderer
var renderer = new THREE.WebGLRenderer();
renderer.setSize( window.innerWidth, window.innerHeight );
document.body.appendChild( renderer.domElement );

// Trackball controls
controls = new THREE.TrackballControls( camera );
controls.rotateSpeed = 1.0;
controls.zoomSpeed = 1.2;
controls.panSpeed = 0.8;
controls.noZoom = false;
controls.noPan = false;
controls.staticMoving = true;
controls.dynamicDampingFactor = 0.3;

// Geometry / Material
var geometry = new THREE.BoxGeometry(1, 1, 1, 10, 10, 10);
var texture = new THREE.TextureLoader().load('https://stemkoski.github.io/Three.js/images/crate.gif');
var material = new THREE.MeshBasicMaterial({ map: texture });
var cube = new THREE.Mesh(geometry, material);
cube.position.set(0, 0, 0);
scene.add(cube);

var render = function () {
	requestAnimationFrame( render );

    controls.update();
	cube.rotation.z += 0.01;

	renderer.render(scene, camera);
};
render();

window.addEventListener('resize', function() {
	camera.aspect = window.innerWidth / window.innerHeight;
	camera.updateProjectionMatrix();
	renderer.setSize(window.innerWidth, window.innerHeight);
}, false);
```
