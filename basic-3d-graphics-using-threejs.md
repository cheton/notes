# Three.js

http://helloracer.com/racer-s/



# Basic 3D Graphics Using Three.js


http://helloracer.com/racer-s/

## Demo

https://jsfiddle.net/y9w0v1bq/

[![image](https://cloud.githubusercontent.com/assets/447801/17282441/6ab8cbda-57d8-11e6-84bf-766f5f60ff4c.png)](https://jsfiddle.net/y9w0v1bq/)

## Getting Started

### Before we start

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
const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);

const renderer = new THREE.WebGLRenderer(); // or new THREE.CanvasRenderer();
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);
```

#### PerspectiveCamera( fov, aspect, near, far )

fov - The camera's vertical field of view, in degrees (from the bottom to the top of the view).<br>
aspect - The camera's aspect ratio.<br>
near - The near camera frustum plane.<br>
far - The far camera frustum plane.<br>

![image](https://cloud.githubusercontent.com/assets/447801/17282736/99ccb578-57db-11e6-84eb-d5af9905ee5a.png)



