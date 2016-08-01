# Basic 3D Graphics Using Three.js

#### Featured Projects
http://threejs.org/

#### Samsung Racer S
http://helloracer.com/racer-s/


## First Project

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

![image](https://cloud.githubusercontent.com/assets/447801/17282736/99ccb578-57db-11e6-84eb-d5af9905ee5a.png)

#### PerspectiveCamera( fov, aspect, near, far )
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
