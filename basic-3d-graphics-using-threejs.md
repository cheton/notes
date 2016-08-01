# Three.js

http://helloracer.com/racer-s/


# Basic 3D Graphics Using Three.js


http://helloracer.com/racer-s/

## Demo

https://jsfiddle.net/cheton/y9w0v1bq/

[![image](https://cloud.githubusercontent.com/assets/447801/17285107/2b1555e6-57f3-11e6-9b7a-a7b9802215e0.png)](https://jsfiddle.net/cheton/y9w0v1bq/)

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
		<script src="js/three.js"></script>
		<script>
			// Our Javascript will go here.
		</script>
	</body>
</html>
```

### Creating the scene

To actually be able to display anything with Three.js, we need three things: A scene, a camera, and a renderer so we can render the scene with the camera.

```js
var scene = new THREE.Scene();
var camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
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
var geometry = new THREE.BoxGeometry(2, 2, 2);
var material = new THREE.MeshBasicMaterial({
    color: 0x00ff00,
    wireframe: true
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
var controls = new THREE.TrackballControls(camera);
controls.rotateSpeed = 1.0;
controls.zoomSpeed = 1.2;
controls.panSpeed = 0.8;
controls.staticMoving = true;
controls.dynamicDampingFactor = 0.3;

// Geometry / Material
var geometry = new THREE.BoxGeometry(2, 2, 2);
var material = new THREE.MeshBasicMaterial({
    color: 0xefefef,
    wireframe: true
});
var cube = new THREE.Mesh( geometry, material);
cube.position.x = 0;
scene.add(cube);

var render = function () {
    requestAnimationFrame(render);
    
    controls.update();
    cube.rotation.z += 0.01;

    renderer.render(scene, camera);
};

render();
```
