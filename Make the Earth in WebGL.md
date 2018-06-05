http://learningthreejs.com/blog/2013/09/16/how-to-make-the-earth-in-webgl/

https://jsfiddle.net/14but7n5/6/

![image](https://user-images.githubusercontent.com/447801/40910319-6607e686-681e-11e8-9202-67c5d4ca12d8.png)

#### Galaxy Starfield

```js
const createGalaxy = () => {
    const texture = new THREE.TextureLoader().load(baseURL + 'images/galaxy_starfield.png');
    const material = new THREE.MeshBasicMaterial({
        map: texture,
        side: THREE.BackSide
    });
    const radius = 99999;
    const geometry = new THREE.SphereGeometry(radius * zoomFactor, 32, 32);
    const mesh = new THREE.Mesh(geometry, material);
    return mesh;
};
```

##### Diffuse Texture
![image](https://raw.githubusercontent.com/jeromeetienne/threex.planets/master/images/galaxy_starfield.png)

### Earth

```js
const EARTH_EQUATORIAL_ROTATION_VELOCITY = (4651 * 0.001); // km/s
const EARTH_RADIUS = 6371; // km

const createEarth = () => {
    const geometry = new THREE.SphereGeometry(EARTH_RADIUS * zoomFactor, 32, 32);
    const material    = new THREE.MeshPhongMaterial({
        // Diffuse Texture
        map: new THREE.TextureLoader().load(baseURL + 'images/earthmap1k.jpg'),

        // Bump Texture
        bumpMap: new THREE.TextureLoader().load(baseURL + 'images/earthbump1k.jpg'),
        bumpScale: 0.05,

        // Specular Texture
        specularMap: new THREE.TextureLoader().load(baseURL + 'images/earthspec1k.jpg'),
        specular: new THREE.Color('grey'),
    });
    const mesh = new THREE.Mesh(geometry, material);
    return mesh;
};
```

#### Diffuse Texture
![image](https://raw.githubusercontent.com/jeromeetienne/threex.planets/master/images/earthmap1k.jpg)

#### Bump Texture
![image](https://raw.githubusercontent.com/jeromeetienne/threex.planets/master/images/earthbump1k.jpg)

#### Specular Texture
![image](https://raw.githubusercontent.com/jeromeetienne/threex.planets/master/images/earthspec1k.jpg)

### Earth Cloud

```js
const EARTH_CLOUD_EQUATORIAL_ROTATION_VELOCITY = (EARTH_EQUATORIAL_ROTATION_VELOCITY / 2);
const EARTH_CLOUD_RADIUS = (EARTH_RADIUS * 1.02);

const createEarthCloud = () => {
    const canvasCloud = document.createElement('canvas');
    canvasCloud.width = 1024;
    canvasCloud.height = 512;
    const contextCloud = canvasCloud.getContext('2d');

    // Load earthcloudmap
    const imageMap    = new Image();
    imageMap.addEventListener('load', function() {
        // Create dataMap ImageData for earthcloudmap
        const canvasMap = document.createElement('canvas');
        canvasMap.width = imageMap.width;
        canvasMap.height = imageMap.height;
        const contextMap = canvasMap.getContext('2d');
        contextMap.drawImage(imageMap, 0, 0);
        const dataMap = contextMap.getImageData(0, 0, canvasMap.width, canvasMap.height);

        // Load earthcloudmaptrans
        const imageTrans = new Image();
        imageTrans.addEventListener('load', function () {
            // Create dataTrans ImageData for earthcloudmaptrans
            const canvasTrans = document.createElement('canvas');
            canvasTrans.width = imageTrans.width;
            canvasTrans.height = imageTrans.height;
            const contextTrans = canvasTrans.getContext('2d');
            contextTrans.drawImage(imageTrans, 0, 0);
            const dataTrans = contextTrans.getImageData(0, 0, canvasTrans.width, canvasTrans.height);

            // Merge dataMap + dataTrans into dataResult
            const dataResult = contextMap.createImageData(canvasMap.width, canvasMap.height);
            for (let y = 0, offset = 0; y < imageMap.height; y++) {
                for (let x = 0; x < imageMap.width; x++, offset += 4) {
                    // The array contains (height x width x 4 bytes) of data
                    dataResult.data[offset + 0] = dataMap.data[offset + 0]; // Red channel
                    dataResult.data[offset + 1] = dataMap.data[offset + 1]; // Green channel
                    dataResult.data[offset + 2] = dataMap.data[offset + 2]; // Blue channel
                    dataResult.data[offset + 3] = 255 - dataTrans.data[offset + 0]; // Alpha channel
                }
            }

            // Update texture with the result
            contextCloud.putImageData(dataResult,0,0);
            material.map.needsUpdate = true;
        });
        imageTrans.crossOrigin = 'Anonymous';
        imageTrans.src = baseURL + 'images/earthcloudmaptrans.jpg';
    }, false);
    imageMap.crossOrigin = 'Anonymous';
    imageMap.src = baseURL + 'images/earthcloudmap.jpg';

    const geometry = new THREE.SphereGeometry(EARTH_CLOUD_RADIUS * zoomFactor, 32, 32);
    const material = new THREE.MeshPhongMaterial({
        map: new THREE.Texture(canvasCloud),
        side: THREE.DoubleSide,
        opacity: 0.8,
        transparent: true,
        depthWrite: false
    });
    const mesh = new THREE.Mesh(geometry, material);
    return mesh;
};
```

#### Texture for the Color
![image](https://raw.githubusercontent.com/jeromeetienne/threex.planets/master/images/earthcloudmap.jpg)

#### Texture for the Transparency
![image](https://raw.githubusercontent.com/jeromeetienne/threex.planets/master/images/earthcloudmaptrans.jpg)

### Moon

```js
const MOON_EQUATORIAL_ROTATION_VELOCITY = (4.627 * 0.001); // km/s
const MOON_RADIUS = 1737; // km

const createMoon = () => {
    const geometry = new THREE.SphereGeometry(MOON_RADIUS * zoomFactor, 32, 32);
    const material = new THREE.MeshPhongMaterial({
        // Diffuse Texture
        map: THREE.ImageUtils.loadTexture(baseURL + 'images/moonmap1k.jpg'),
        
        // Bump Texture
        bumpMap: THREE.ImageUtils.loadTexture(baseURL + 'images/moonbump1k.jpg'),
        bumpScale: 0.002,
    });
    const mesh = new THREE.Mesh(geometry, material);
    return mesh;
};
```

#### Diffuse Texture
![image](https://raw.githubusercontent.com/jeromeetienne/threex.planets/master/images/moonmap1k.jpg)

#### Bump Texture
![image](https://raw.githubusercontent.com/jeromeetienne/threex.planets/master/images/moonbump1k.jpg)


```js
//
// How to Make the Earth in WebGL?
// http://learningthreejs.com/blog/2013/09/16/how-to-make-the-earth-in-webgl/
//

const EARTH_EQUATORIAL_ROTATION_VELOCITY = (4651 * 0.001); // km/s
const EARTH_RADIUS = 6371; // km
const EARTH_CLOUD_EQUATORIAL_ROTATION_VELOCITY = (EARTH_EQUATORIAL_ROTATION_VELOCITY / 2);
const EARTH_CLOUD_RADIUS = (EARTH_RADIUS * 1.02);
const MOON_EQUATORIAL_ROTATION_VELOCITY = (4.627 * 0.001); // km/s
const MOON_RADIUS = 1737; // km

const baseURL = 'https://raw.githubusercontent.com/jeromeetienne/threex.planets/master/';
const zoomFactor = 0.001;

// Galaxy
const createGalaxy = () => {
    const texture    = new THREE.TextureLoader().load(baseURL + 'images/galaxy_starfield.png');
    const material    = new THREE.MeshBasicMaterial({
        map: texture,
        side: THREE.BackSide
    });
    const radius = 99999;
    const geometry = new THREE.SphereGeometry(radius * zoomFactor, 32, 32);
    const mesh = new THREE.Mesh(geometry, material);
    return mesh;
};

// Earth
const createEarth = () => {
    const geometry = new THREE.SphereGeometry(EARTH_RADIUS * zoomFactor, 32, 32);
    const material    = new THREE.MeshPhongMaterial({
        // Diffuse Texture
        map: new THREE.TextureLoader().load(baseURL + 'images/earthmap1k.jpg'),

        // Bump Texture
        bumpMap: new THREE.TextureLoader().load(baseURL + 'images/earthbump1k.jpg'),
        bumpScale: 0.05,

        // Specular Texture
        specularMap: new THREE.TextureLoader().load(baseURL + 'images/earthspec1k.jpg'),
        specular: new THREE.Color('grey'),
    });
    const mesh = new THREE.Mesh(geometry, material);
    return mesh;
};

// Earth Cloud
const createEarthCloud = () => {
    const canvasCloud = document.createElement('canvas');
    canvasCloud.width = 1024;
    canvasCloud.height = 512;
    const contextCloud = canvasCloud.getContext('2d');

    // Load earthcloudmap
    const imageMap    = new Image();
    imageMap.addEventListener('load', function() {
        // Create dataMap ImageData for earthcloudmap
        const canvasMap = document.createElement('canvas');
        canvasMap.width = imageMap.width;
        canvasMap.height = imageMap.height;
        const contextMap = canvasMap.getContext('2d');
        contextMap.drawImage(imageMap, 0, 0);
        const dataMap = contextMap.getImageData(0, 0, canvasMap.width, canvasMap.height);

        // Load earthcloudmaptrans
        const imageTrans = new Image();
        imageTrans.addEventListener('load', function () {
            // Create dataTrans ImageData for earthcloudmaptrans
            const canvasTrans = document.createElement('canvas');
            canvasTrans.width = imageTrans.width;
            canvasTrans.height = imageTrans.height;
            const contextTrans = canvasTrans.getContext('2d');
            contextTrans.drawImage(imageTrans, 0, 0);
            const dataTrans = contextTrans.getImageData(0, 0, canvasTrans.width, canvasTrans.height);

            // Merge dataMap + dataTrans into dataResult
            const dataResult = contextMap.createImageData(canvasMap.width, canvasMap.height);
            for (let y = 0, offset = 0; y < imageMap.height; y++) {
                for (let x = 0; x < imageMap.width; x++, offset += 4) {
                    dataResult.data[offset + 0] = dataMap.data[offset + 0];
                    dataResult.data[offset + 1] = dataMap.data[offset + 1];
                    dataResult.data[offset + 2] = dataMap.data[offset + 2];
                    dataResult.data[offset + 3] = 255 - dataTrans.data[offset + 0];
                }
            }

            // Update texture with the result
            contextCloud.putImageData(dataResult,0,0);
            material.map.needsUpdate = true;
        });
        imageTrans.crossOrigin = 'Anonymous';
        imageTrans.src = baseURL + 'images/earthcloudmaptrans.jpg';
    }, false);
    imageMap.crossOrigin = 'Anonymous';
    imageMap.src = baseURL + 'images/earthcloudmap.jpg';

    const geometry = new THREE.SphereGeometry(EARTH_CLOUD_RADIUS * zoomFactor, 32, 32);
    const material = new THREE.MeshPhongMaterial({
        map: new THREE.Texture(canvasCloud),
        side: THREE.DoubleSide,
        opacity: 0.8,
        transparent: true,
        depthWrite: false
    });
    const mesh = new THREE.Mesh(geometry, material);
    return mesh;
};

// Moon
const createMoon = () => {
    const geometry = new THREE.SphereGeometry(MOON_RADIUS * zoomFactor, 32, 32);
    const material = new THREE.MeshPhongMaterial({
        map: THREE.ImageUtils.loadTexture(baseURL + 'images/moonmap1k.jpg'),
        bumpMap: THREE.ImageUtils.loadTexture(baseURL + 'images/moonbump1k.jpg'),
        bumpScale: 0.002,
    });
    const mesh = new THREE.Mesh(geometry, material);
    return mesh;
};

// Scene
const scene = new THREE.Scene();

// Camera
const camera = new THREE.PerspectiveCamera(
    15, // fov, in degrees
    window.innerWidth / window.innerHeight, // aspect ratio
    0.01, // near
    1000 // far
);
camera.position.x = 0;
camera.position.y = 0;
camera.position.z = 100;

// AmbientLight - This light globally illuminates all objects in the scene equally.
const ambientLight = new THREE.AmbientLight(0x888888);
scene.add(ambientLight);

// DirectionalLight
const directionalLight = new THREE.DirectionalLight(0xcccccc, 1); // color, intensity
directionalLight.position.set(5, 5, 5);
scene.add(directionalLight);

// WebGL Renderer
const renderer = new THREE.WebGLRenderer();
renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);

// Trackball Controls
const controls = new THREE.TrackballControls(camera);

// Galaxy
const galaxy = createGalaxy();
scene.add(galaxy);

// Earth
const earth = createEarth();
earth.position.x = 0;
earth.position.y = 0;
earth.position.z = 0;
scene.add(earth);

// EarthCloud
const earthCloud = createEarthCloud();
earthCloud.position.x = earth.position.x;
earthCloud.position.y = earth.position.y;
earthCloud.position.z = earth.position.z;
scene.add(earthCloud);

// Moon
const moon = createMoon();
moon.position.x = earth.position.x + 20;
moon.position.y = earth.position.y + 20;
moon.position.z = earth.position.z;
scene.add(moon);

// Render
const delta = ((1 / 60) / 86400) * 3600;

const render = () => {
    requestAnimationFrame(render);

    controls.update();

    earth.rotation.y += EARTH_EQUATORIAL_ROTATION_VELOCITY * delta;
    earthCloud.rotation.y += EARTH_CLOUD_EQUATORIAL_ROTATION_VELOCITY * delta;
    moon.rotation.y += MOON_EQUATORIAL_ROTATION_VELOCITY * delta;

    renderer.render(scene, camera);
};
render();

// Resize
window.addEventListener('resize', function() {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
}, false);
```
