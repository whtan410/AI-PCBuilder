<template>
    <div ref="SceneContainer" class="scene-container">
      <!-- Loading animation with transition -->
      <transition name="fade">
        <div v-if="isLoading" class="loading-container">
          <div class="loading-circle"></div>
          <span class="loading-text">Loading Model...</span>
        </div>
      </transition>
  
      <!-- Model content with transition -->
      <transition name="fade">
        <div class="points-container" v-show="!isLoading">
          <div v-for="(point, index) in data" 
               :key="index" 
               :class="[
                 'point', 
                 { 
                   'active': activePoint === index,
                   'selected': isPartSelected(point.title),
                   'hovered': hoveredPoint === index
                 }
               ]"
               :style="{ zIndex: hoveredPoint === index ? 10001 : 100 }"
               :ref="'point-' + index"
               @click="handlePointClick(point, index)"
               @mouseenter="showTooltip(point, index)"
               @mouseleave="hideTooltip">
            <v-icon v-if="isPartSelected(point.title)" 
              class="success-icon" 
              size="x-large"
              color="#e324bd">
              mdi-check-circle
            </v-icon>
            
            <!-- Add image tooltip -->
            <div v-show="hoveredPoint === index" 
              class="image-tooltip"
              :class="getTooltipPositionClass(index)">
              <img :src="point.image" :alt="point.title">
              <div class="tooltip-title">{{ point.title }}</div>
            </div>
          </div>
        </div>
      </transition>
    </div>
</template>
  
<script lang="ts" >
	import * as THREE from 'three'
	import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
	import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js'
	import { defineComponent } from 'vue';

  import { useProductStore } from '../stores/productstore';
  import type { ComponentResponse } from '../stores/productstore'; // Import the interfaces
  // import { storeToRefs } from 'pinia';
  
  interface PartData extends ComponentResponse {
    position: THREE.Vector3;
  }
  
  export default defineComponent({
    name: 'Canvas',
    props: {
      drawer: {
        type: Boolean,
        required: true 
      },
      items: {
        type: Array,
        required: true
      }
    },

    data() {
      return {
        isLoading: true,
        mouseDownTime: 0,
        activePoint: null as number | null,
        camera: null as THREE.PerspectiveCamera | null,
        controls: null as OrbitControls | null,
        renderer: null as THREE.WebGLRenderer | null,
        scene: null as THREE.Scene | null,
        resizeHandler: null as (() => void) | null,
        resizeObserver: null as ResizeObserver | null,
        data: [] as PartData[],
        hoveredPoint: null,
      }
    },

    emits: ['point-clicked'],
    methods: {
      async fetchComponentData() {
        try {
          const store = useProductStore();  
          await store.fetchAllComponents();
          
          console.log('Store components:', store.components); // Debug log
          
          // Use Vue.set or direct array assignment for reactivity
          const mappedData = store.components.map(component => ({
            title: component.title,
            image: component.image,
            description: component.description,
            position: this.getPositionForComponent(component.title),
            product_list: [...component.product_list] // Create a new array for reactivity
          }));
          
          console.log('About to assign mapped data:', mappedData);
          
          // Force reactivity by creating a new array
          this.data = [...mappedData];
          
          console.log('Data after assignment:', this.data);
        } catch (error) {
          console.error('Error fetching component data:', error);
        }
      },

    getPositionForComponent(title: string): THREE.Vector3 {
      // Map of predefined positions for each component
      const positionMap = {
        'casing': new THREE.Vector3(8.538, 2.040, 2.722),
        'fan': new THREE.Vector3(8.509, -0.554, 2.764),
        'cpu': new THREE.Vector3(9.292, 0.580, -0.116),
        'ram': new THREE.Vector3(9.113, 0.618, 0.537),
        'hdd': new THREE.Vector3(8.598, -1.958, 1.938),
        'ssd': new THREE.Vector3(9.335, 0.007, -0.143),
        'gpu': new THREE.Vector3(8.694, -0.546, -0.282),
        'motherboard': new THREE.Vector3(9.303, -1.162, 0.777),
        'psu': new THREE.Vector3(8.605, -2.155, -0.667),
        'all in one cooler': new THREE.Vector3(8.400, 1.900, 0.374),
      };

      const normalizedTitle = title.toLowerCase();
      return positionMap[normalizedTitle] || new THREE.Vector3(0, 0, 0);
    },

      handlePointClick(point: PartData, index: number) {
        this.activePoint = this.activePoint === index ? null : index;
        if (this.activePoint !== null) {
          // Find the exact point data from our data array
          const selectedPoint = this.data.find(p => p.title === point.title);
          
          this.$emit('point-clicked', {
            title: point.title,
            image: selectedPoint?.image || point.image, // Ensure image is passed
            description: point.description,
            product_list: point.product_list
          });
        } else {
          this.$emit('point-clicked', null);
        }
      },
      //Detect Panning and prevent closing while clicking after panning
      handleClickOutside(event: MouseEvent) {
        const clickDuration = Date.now() - this.mouseDownTime;
        if (clickDuration < 200) {
          const target = event.target as HTMLElement;
          if (!target.closest('.point') && !target.closest('.tooltip')) {
            this.activePoint = null;
          }
        }
      },
      getTooltipPositionClass(index: number) {
        const pointRef = this.$refs[`point-${index}`] as HTMLElement[];
        if (!pointRef || !pointRef[0]) return '';
        
        const point = pointRef[0];
        const rect = point.getBoundingClientRect();
        const sceneContainer = this.$refs.SceneContainer as HTMLElement;
        const containerRect = sceneContainer.getBoundingClientRect();
        
        const TOOLTIP_WIDTH = 200;  // Match your CSS width
        const TOOLTIP_HEIGHT = 160; // Approximate height based on content
        
        // Calculate tooltip edges for each possible position
        const positions = {
          top: {
            left: rect.left - (TOOLTIP_WIDTH / 2),
            right: rect.left + (TOOLTIP_WIDTH / 2),
            top: rect.top - TOOLTIP_HEIGHT - 10,
            bottom: rect.top - 10
          },
          bottom: {
            left: rect.left - (TOOLTIP_WIDTH / 2),
            right: rect.left + (TOOLTIP_WIDTH / 2),
            top: rect.bottom + 10,
            bottom: rect.bottom + TOOLTIP_HEIGHT + 10
          },
          left: {
            left: rect.left - TOOLTIP_WIDTH - 10,
            right: rect.left - 10,
            top: rect.top - (TOOLTIP_HEIGHT / 2),
            bottom: rect.top + (TOOLTIP_HEIGHT / 2)
          },
          right: {
            left: rect.right + 10,
            right: rect.right + TOOLTIP_WIDTH + 10,
            top: rect.top - (TOOLTIP_HEIGHT / 2),
            bottom: rect.top + (TOOLTIP_HEIGHT / 2)
          }
        };
  
        // Check if each position fits within container
        const fits = {
          top: positions.top.left >= 0 && 
               positions.top.right <= containerRect.width && 
               positions.top.top >= 0,
          bottom: positions.bottom.left >= 0 && 
                  positions.bottom.right <= containerRect.width && 
                  positions.bottom.bottom <= containerRect.height,
          left: positions.left.left >= 0 && 
                positions.left.top >= 0 && 
                positions.left.bottom <= containerRect.height,
          right: positions.right.right <= containerRect.width && 
                 positions.right.top >= 0 && 
                 positions.right.bottom <= containerRect.height
        };
  
        // Choose best position
        if (fits.top) return [];           // Default top position
        if (fits.bottom) return ['tooltip-bottom'];
        if (fits.left) return ['tooltip-left'];
        if (fits.right) return ['tooltip-right'];
        
        // If no position fits perfectly, choose the one that's most visible
        return ['tooltip-bottom']; // Fallback to bottom
      },

      async init() {
        await this.fetchComponentData();
        // Wait for the next tick to ensure DOM is ready
        this.$nextTick(() => {
          const sceneContainer = this.$refs.SceneContainer as HTMLElement;
          if (!sceneContainer) return;
  
          const scene = new THREE.Scene();
          const containerRect = sceneContainer.getBoundingClientRect();
         
          scene.background = new THREE.Color('#130227');
  
          this.camera = new THREE.PerspectiveCamera(50, containerRect.width / containerRect.height, 0.1, 120);
          this.camera.position.set(0, 0, 15);
          this.camera.updateProjectionMatrix();
  
          // Renderer setup
          const renderer = new THREE.WebGLRenderer({
            antialias: true
          });
          this.renderer = renderer;
          renderer.setSize(containerRect.width, containerRect.height);
          renderer.setClearColor('#001655');
          renderer.setPixelRatio(window.devicePixelRatio);
          sceneContainer.appendChild(renderer.domElement);
  
          // Lights
          const ambientLight = new THREE.AmbientLight('#ffffff', 2);
          scene.add(ambientLight);
          const directionalLight = new THREE.DirectionalLight('#ffffff', 2);
          directionalLight.position.set(-1, 1, 0);
          scene.add(directionalLight);
  
          // Controls
          this.controls = new OrbitControls(this.camera, renderer.domElement);
          this.controls.enableDamping = true;
          this.controls.dampingFactor = 0.05;
          this.controls.rotateSpeed = 0.5;
          this.controls.minDistance = 5;
          this.controls.maxDistance = 20;
          this.controls.target.set(8.485, -0.68, -0.31);
  
          // Use RAF for smoother updates
          this.controls.addEventListener('change', () => {
            requestAnimationFrame(this.updatePointPositions);
          });
  
          // Modify the controls event listeners
          this.controls.addEventListener('start', () => {
            // Remove temporary to prevent conflicts during drag
            document.removeEventListener('click', this.handleClickOutside);
          });
  
          this.controls.addEventListener('end', () => {
            // Reattach immediately after control operation ends
            document.addEventListener('click', this.handleClickOutside);
          });
  
          // Load 3D Model
          const loader = new GLTFLoader();
          loader.load(
            '/models/scene.gltf',
            (gltf) => {
              const model = gltf.scene;
              model.position.set(0, 0, 0);
              model.scale.set(1, 1, 1);
              scene.add(model);
              // Wait for next tick before updating points
              this.$nextTick(() => {
                this.updatePointPositions();
                this.isLoading = false;
              });
            },
            (xhr: { loaded: number; total: number }) => {
              console.log((xhr.loaded / xhr.total * 100) + '% loaded');
            },
            (error) => {
              console.error('Error loading model:', error);
              this.isLoading = false;
            }
          );
  
          // Animation loop without point updates
          const animate = () => {
            requestAnimationFrame(animate);
            if (this.camera) {
              renderer.render(scene, this.camera);
              this.controls?.update();
            }
          };
  
          animate();
  
          // Add this helper method
          const calculateCameraDistance = (width: number, height: number) => {
            // Base distance for a reference size (e.g., 1000px width)
            const baseDistance = 10;
            const referenceWidth = 1000;
            // Scale factor based on container width
            const scale = Math.max(referenceWidth / width, 1);
            return baseDistance * scale;
          };
  
          // Store the resize handler as a class property so we can remove it later
          this.resizeHandler = () => {
            if (!this.camera || !this.controls || !this.$refs.SceneContainer) return;
            
            const sceneContainer = this.$refs.SceneContainer as HTMLElement;
            if (!sceneContainer) return;
  
            const newRect = sceneContainer.getBoundingClientRect();
            
            // Update camera
            this.camera.aspect = newRect.width / newRect.height;
            this.camera.updateProjectionMatrix();
            
            // Calculate new distance based on container size
            const newDistance = calculateCameraDistance(newRect.width, newRect.height);
            
            // Update controls distance limits
            this.controls.minDistance = newDistance * 0.5;
            this.controls.maxDistance = newDistance * 1.5;
            
            // Update camera position while maintaining current viewing angle
            const spherical = new THREE.Spherical().setFromVector3(
              this.camera.position.clone().sub(this.controls.target)
            );
            spherical.radius = newDistance;
            
            this.camera.position.setFromSpherical(spherical).add(this.controls.target);
            
            renderer.setSize(newRect.width, newRect.height);
            this.controls.update();
            this.updatePointPositions();
          };
  
          // Add resize event listener
          window.addEventListener('resize', this.resizeHandler);
  
          // Add mousedown listener to track click start time
          document.addEventListener('mousedown', () => {
            this.mouseDownTime = Date.now();
          });
        });
      },

      updatePointPositions() {
        if (!this.camera || !this.$refs.SceneContainer) return;
        
        const container = this.$refs.SceneContainer as HTMLElement;
        const width = container.clientWidth;
        const height = container.clientHeight;
        const matrix = new THREE.Matrix4();
        
        // Get camera matrix
        matrix.multiplyMatrices(
          this.camera.projectionMatrix,
          this.camera.matrixWorldInverse
        );
  
        this.data.forEach((point, index) => {
          const pointRef = this.$refs[`point-${index}`] as HTMLElement[];
          if (!pointRef?.[0]) return;
  
          const element = pointRef[0];
          const position = point.position.clone();
          
          // Apply matrix transformation
          position.applyMatrix4(matrix);
  
          if (position.z > 1) {
            element.style.display = 'none';
            return;
          }
  
          const x = (position.x * 0.5 + 0.5) * width;
          const y = (-position.y * 0.5 + 0.5) * height;
  
          element.style.display = '';
          element.style.transform = `translate3d(${~~x}px, ${~~y}px, 0)`;
        });
      },

      updateLayout() {
        if (this.camera && this.controls) {
          const container = this.$refs.SceneContainer as HTMLElement;
          const width = container.clientWidth;
          const height = container.clientHeight;
          
          // Update camera
          this.camera.aspect = width / height;
          this.camera.updateProjectionMatrix();
          
          // Update renderer size
          if (this.renderer) {
            this.renderer.setSize(width, height, true);
          }
          
          // Recalculate camera position to maintain view
          const distance = this.calculateCameraDistance();
          if (this.camera.position.z !== distance) {
            this.camera.position.z = distance;
          }
          
          // Update point positions
          this.updatePointPositions();
          this.controls.update();
        }
      },

      calculateCameraDistance() {
        // Adjust this calculation based on your model size
        const container = this.$refs.SceneContainer as HTMLElement;
        const width = container.clientWidth;
        return 15 * (800 / width); // Adjust multiplier based on your needs
      },

      setupControls() {
        if (this.camera && this.scene) {
          this.controls = new OrbitControls(this.camera, this.$refs.SceneContainer as HTMLElement);
          this.controls.addEventListener('change', () => {
            this.updatePointPositions();
          });
          // Add end event listener
          this.controls.addEventListener('end', () => {
            this.updateLayout();
          });
        }
      },

      // Add cleanup in beforeUnmount
      beforeUnmount() {
        // Remove resize event listener
        if (this.resizeHandler) {
          window.removeEventListener('resize', this.resizeHandler);
        }
  
        // Remove click listener
        document.removeEventListener('click', this.handleClickOutside);
  
        // Cleanup Three.js resources
        if (this.renderer) {
          this.renderer.dispose();
        }
        if (this.controls) {
          this.controls.dispose();
        }
      },

      isPartSelected(partTitle: string) {
        return this.items.some(item => {
          // Normalize both strings for comparison (lowercase and trim)
          const normalizedItemCategory = (item.product_category || '').toLowerCase().trim();
          const normalizedPartTitle = partTitle.toLowerCase().trim();

          // Handle special cases
          if (normalizedItemCategory === 'case' && normalizedPartTitle === 'casing') {
            return item.quantity > 0;
          } 
    
          if (normalizedItemCategory === 'cooler' && normalizedPartTitle.includes('all in one cooler')) {
            return item.quantity > 0;
          }
          
          // Check if the part title is included in the item name
          const match = normalizedItemCategory.includes(normalizedPartTitle) && item.quantity > 0;
    
          return match;
        });
      },

      showTooltip(point, index) {
        this.hoveredPoint = index;
      },

      hideTooltip() {
        this.hoveredPoint = null;
      }
    },

    watch: {
      drawer: {
        handler() {
          // First immediate update
          this.updateLayout();
          
          // Second update after a very short delay to ensure DOM has updated
          requestAnimationFrame(() => {
            this.updateLayout();
          });
          
          // Final update to catch any remaining layout changes
          requestAnimationFrame(() => {
            this.updateLayout();
          });
        }
      }
    },

    mounted() {
      this.init();
      // Add click listener to close tooltip when clicking outside
      document.addEventListener('click', this.handleClickOutside);
    },
    unmounted() {
      // Clean up listener
      document.removeEventListener('click', this.handleClickOutside);
    }
  });
</script>
  
<style scoped>
  .scene-container {
    position: relative;
    width: 100%;
    height: 100%;
    overflow: hidden;
    background-color: #001655;
  }
  
  .points-container {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    transform-style: preserve-3d;
  }
  
  .point {
    position: absolute;
    width: 24px;
    height: 24px;
    background-color: rgba(255, 255, 255, 0.9);
    border: 2px solid #e324bd;
    border-radius: 50%;
    cursor: pointer;
    pointer-events: auto;
    transform-origin: center;
    will-change: transform;
    backface-visibility: hidden;
    -webkit-backface-visibility: hidden;
    transform: translate(-50%, -50%);
    transition: all 0s cubic-bezier(0.4, 0, 0.2, 1);
    z-index: 100;
  }
  
  .point.selected {
    background-color: #e324bd;
    animation: success-bounce 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  }
  
  .point.hovered {
    z-index: 10001;
  }
  
  /* Remove any transition delays */
  .fade-enter-active, .fade-leave-active {
    transition: opacity 0.2s;
  }
  
  .loading-container {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background-color: rgba(255, 255, 255, 0.95);
    z-index: 1000;
    backdrop-filter: blur(5px);
  }
  
  .loading-circle {
    width: 50px;
    height: 50px;
    border: 4px solid #f3f3f3;
    border-top: 4px solid #e324bd;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin-bottom: 16px;
  }
  
  .loading-text {
    color: #e324bd;
    font-size: 16px;
    font-weight: 500;
  }
  
  @keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }
  
  /* Style the success icon */
  .success-icon {
    font-size: 20px !important;
    color: white;
  }
  
  @keyframes success-bounce {
    0%, 100% { transform: scale(1.2); }
    50% { transform: scale(1.4); }
  }
  
  .image-tooltip {
    position: absolute;
    background: white;
    padding: 8px;
    border-radius: 8px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.15);
    z-index: inherit;
    pointer-events: none;
    width: 200px;
    /* Default top position */
    transform: translate(-50%, -100%) translateY(-20px);
  }
  
  /* Position variants */
  .tooltip-bottom {
    transform: translate(-50%, 20px);
    top: 100%;
  }
  
  .tooltip-left {
    transform: translate(-100%, -50%) translateX(-20px);
    top: 50%;
    left: 0;
  }
  
  .tooltip-right {
    transform: translate(20px, -50%);
    top: 50%;
    left: 100%;
  }
  
  .image-tooltip img {
    width: 100%;
    height: 120px;
    object-fit: cover;
    border-radius: 4px;
  }
  
  .tooltip-title {
    margin-top: 8px;
    text-align: center;
    font-size: 14px;
    color: #333;
  }
</style>