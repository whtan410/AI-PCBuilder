<template>
    <!-- Left sidebar with icons -->
    <v-navigation-drawer
      permanent
      width="50"
      class="left-sidebar"
    >
      <v-list nav> 
        <v-list-item> 
          <v-btn 
            @click="drawer = !drawer" 
            icon 
            variant="text" 
          > 
            <v-tooltip 
              activator="parent" 
              location="right" 
            > 
              <span class="bitstream">Item List</span> 
            </v-tooltip> 
            <v-icon>{{ drawer ? 'mdi-chevron-left' : 'mdi-chevron-right' }}</v-icon> 
          </v-btn> 
        </v-list-item> 
      </v-list>
    </v-navigation-drawer>
  
    <!-- Right info drawer -->
    <v-navigation-drawer
      v-model="infoDrawer"
      location="right"
      width="300"
      class="info-drawer"
      floating
      :scrim="false"
      persistent
    >
      <!-- Info Panel -->
      <div v-if="!showProducts">
        <v-card color="#3e0054" flat class="pa-4">
          <v-row no-gutters align="center">
            <v-col cols="10">
              <p class="text-subtitle-1 text-white text-center bitstream">What is this?</p>
            </v-col>
            <v-col cols="2" class="text-right">
              <v-btn
                icon="mdi-chevron-right"
                variant="text"
                color="white"
                @click="infoDrawer = false"
              ></v-btn>
            </v-col>
          </v-row>
        </v-card>
  
        <div v-if="selectedPart" class="pa-4" :style="{ backgroundColor: '#000000' }">
          <div class="text-h6 mb-4 bitstream">{{ selectedPart.title }}</div>
          <v-img
            :src="selectedPart.image"
            height="200"
            cover
            class="rounded-lg mb-4"
          ></v-img>
          <p class="text-body-1 mb-4 description-text bitstream">{{ selectedPart.description }}</p>
          
          <v-btn
            color="#e324bd"
            block
            class="mb-4 bitstream"
            @click="showProducts = true"
          >
            Show Products
          </v-btn>
        </div>
        <!-- Add scroll space -->
        <div class="drawer-scroll-space"></div>
      </div>
  
      <!-- Choose Products Panel -->
      <div v-else>
        <v-card color="#3e0054" flat class="pa-4">
          <v-row no-gutters align="center">
            <!-- <v-col cols="2">
              <v-btn
                icon="mdi-arrow-left"
                variant="text"
                color="white"
                @click="showProducts = false"
              ></v-btn>
            </v-col> -->
            <v-col cols="8">
              <p class="text-subtitle-1 text-white text-center bitstream">Our Products</p>
            </v-col>
            <v-col cols="2" class="text-right">
              <v-btn
                icon="mdi-chevron-right"
                variant="text"
                color="white"
                @click="infoDrawer = false"
              ></v-btn>
            </v-col>
          </v-row>
        </v-card>

        <div class="pa-4">
          <div class="d-flex justify-end mb-2">
            <v-menu>
              <template v-slot:activator="{ props }">
                <v-btn
                  v-bind="props"
                  variant="text"
                  class="bitstream d-flex align-center"
                >
                  <span class="me-2">Sort</span>
                  <v-icon>mdi-sort</v-icon>
                </v-btn>
              </template>
              <v-list>
                <v-list-item
                  v-for="(sort, index) in productSortOptions"
                  :key="index"
                  @click="sortProducts(sort.value)"
                >
                  <v-list-item-title class="bitstream">{{ sort.text }}</v-list-item-title>
                </v-list-item>
              </v-list>
            </v-menu>
          </div>
        </div>
  
        <div class="pa-4">
          <v-card
            v-for="product in sortedProducts"
            :key="product.product_id"
            class="mb-4 "
            variant="outlined"
          >
            <v-card-text>
              <div class="d-flex justify-space-between align-center">
                <div>
                  <div class="text-body-1 font-weight-medium bitstream"> {{ product.product_name  }}</div>
                  <div class="text-subtitle-4 bitstream">RM{{ product.product_price }}</div>
                  <div class="text-caption text-grey bitstream">Stock: {{ product.product_stock }}</div>
                  <div class="text-caption text-grey bitstream" v-if="getSavedQuantity(product)">
                    In Cart: {{ getSavedQuantity(product) }}
                  </div>
                </div>
                <div class="d-flex align-center">
                  <v-btn
                    color="#FFFFFF"
                    variant="text"
                    density="comfortable"
                    icon="mdi-minus"
                    size="small"
                    class="quantity-btn"
                    @click="decrementStockQuantity(product)"
                    :disabled="!getStockQuantity(product)"
                  ></v-btn>
                  <span class="mx-2">{{ getStockQuantity(product) }}</span>
                  <v-btn
                    color="#FFFFFF"
                    variant="text"
                    density="comfortable"
                    icon="mdi-plus"
                    size="small"
                    class="quantity-btn"
                    @click="incrementStockQuantity(product)"
                  ></v-btn>
                </div>
              </div>
              <v-btn
                v-if="getStockQuantity(product) > 0"
                color="#e324bd"
                class="mt-2 bitstream"
                size="small"
                block
                @click="addToCart(product)"
              >
                Add to Build
              </v-btn>
            </v-card-text>
          </v-card>
        </div>
        <!-- Add scroll space -->
        <div class="drawer-scroll-space"></div>
      </div>
    </v-navigation-drawer>
  
    <!-- Main expandable drawer -->
    <v-navigation-drawer
      v-model="drawer"
      :width="300"
      class="main-drawer"
      :temporary="false"
      location="left"
      :style="{ left: '50px' }"
      :permanent="false"
      :visibility="drawer"
      :scrim="false"
      persistent
    >
      <v-card color="#3e0054" flat class="pa-4">
        <div class="d-flex justify-space-between align-center">
          <p class="text-subtitle-1 text-white text-center bitstream">Your Build</p>
        </div>
      </v-card>
      <v-list>
        <v-list-item
          v-for="(item, index) in items"
          :key="index"
          class="px-4 py-2"
        >
          <div class="d-flex flex-column">
            <div class="d-flex justify-space-between align-center mb-2">
              <div>
                <div class="text-body-1 font-weight-medium bitstream">{{ item.product_name.toUpperCase() }}</div>
                <div class="text-caption text-grey bitstream">{{ item.product_category.toUpperCase() || 'T0ASB-2S' }}</div>
              </div>
              <div class="text-body-1 bitstream">RM{{ item.product_price }}</div>
            </div>
  
            <div class="d-flex align-center justify-space-between">
              <div class="d-flex align-center">
                <v-btn
                  color="#FFFFFF"
                  variant="text"
                  density="comfortable"
                  icon="mdi-minus"
                  size="small"
                  class="quantity-btn"
                  @click="decrementQuantity(index)"
                >
                </v-btn>
                
                <span class="mx-4 text-body-1 bitstream">{{ item.quantity.toString().padStart(2, '0') }}</span>
                
                <v-btn
                  color="#FFFFFF"
                  variant="text"
                  density="comfortable"
                  icon="mdi-plus"
                  size="small"
                  class="quantity-btn"
                  @click="incrementQuantity(index)"
                >
                </v-btn>
              </div>
              <div class="bitstream text-body-1">RM{{ calculateSubtotal(item,index) }}</div>
            </div>
          </div>
          <v-divider class="mt-4"></v-divider>
        </v-list-item>
  
        <v-card color="#001655" class="pa-4">
          <v-row no-gutters align="center" class="mb-2">
            <v-col cols="6">
              <span class="text-subtitle-1 text-grey bitstream">Sub-Total</span>
              <div class="text-caption text-grey bitstream">{{ items.reduce((total, item) => total + item.quantity, 0) }} items</div>
            </v-col>
            <v-col cols="6" class="text-right">
              <span class="text-h6 bitstream">RM{{ calculateTotal() }}</span>
            </v-col>
          </v-row>
          
          <v-btn 
            color="#e324bd" 
            block 
            class="mt-2 bitstream"
            @click="navigateToCart"
            :disabled="items.length === 0"
          >
            Save Build to Cart
          </v-btn>
          <!-- Add scroll space -->
          <div class="drawer-scroll-space"></div>
        </v-card>
      </v-list>
      </v-navigation-drawer>
    
    <!-- Main content area -->
    <div :class="{ 
      'drawer-open': drawer,
      'info-drawer-open': infoDrawer 
    }" class="pa-0">
      <Canvas 
        :drawer="drawer" 
        :items="items"
        class="fill-height"
        @point-clicked="handlePointClick"
        @item-added="drawer = true"
      >
      </Canvas>
    </div>

    <ChatBox />

</template>
  
<script setup lang="ts">
  import { ref, onMounted } from 'vue';
  import { useProductStore } from '@/stores/productstore';
  import { useCartStore } from '@/stores/cartstore';
  import { useRouter } from 'vue-router';

  import Canvas from '@/components/ThreeCanvas.vue';
  import ChatBox from '@/components/ChatBox.vue';

  const productStore = useProductStore();
  const cartStore = useCartStore();
  const router = useRouter();

  const drawer = ref(false);
  const infoDrawer = ref(false);
  const showProducts = ref(false);
  const selectedPart = ref<{
      title: string;
      image: string;
      description: string;
      product_list: any[];
    } | null>(null);

  const items = ref<any[]>(cartStore.loadBuildFromLocal() as any[]);

   // Add these with your other refs
   const productSortOptions = [
    { text: 'Name (A-Z)', value: 'name-asc' },
    { text: 'Name (Z-A)', value: 'name-desc' },
    { text: 'Price (Low-High)', value: 'price-asc' },
    { text: 'Price (High-Low)', value: 'price-desc' }
  ];

  const currentSort = ref('name-asc');

  // Add computed property for sorted products
  const sortedProducts = computed(() => {
    if (!selectedPart.value?.product_list) return [];
    
    const products = [...selectedPart.value.product_list];
    
    switch (currentSort.value) {
      case 'name-asc':
        return products.sort((a, b) => 
          a.product_name.localeCompare(b.product_name)
        );
      case 'name-desc':
        return products.sort((a, b) => 
          b.product_name.localeCompare(a.product_name)
        );
      case 'price-asc':
        return products.sort((a, b) => 
          Number(a.product_price) - Number(b.product_price)
        );
      case 'price-desc':
        return products.sort((a, b) => 
          Number(b.product_price) - Number(a.product_price)
        );
      default:
        return products;
    }
  });

  // Add sort method
  const sortProducts = (sortType: string) => {
    currentSort.value = sortType;
  };

  const getSavedQuantity = (product: any) => {
    const buildItem = cartStore.buildItems.find(item => item.product_id === product.product_id);
    return buildItem?.quantity || 0;
  };

  // Methods for quantity management
  const getStockQuantity = (product: any) => {
    return productStore.stockQuantities[product.product_id] || 0;
  };

  const incrementStockQuantity = (product: any) => {
    const currentQty = getStockQuantity(product);
    if (currentQty < product.product_stock) {
      productStore.updateStockQuantities(product.product_id, currentQty + 1);
    }
  };

  const decrementStockQuantity = (product: any) => {
    const currentQty = getStockQuantity(product);
    if (currentQty > 0) {
      productStore.updateStockQuantities(product.product_id, currentQty - 1);
    }
  };

  const incrementQuantity = (index: number) => {
    const item = items.value[index];
    if (item) {
        const product = productStore.components
            .flatMap(comp => comp.product_list)
            .find(p => p.product_id === item.product_id);
        
        if (product && getSavedQuantity(item) < product.product_stock) {
            cartStore.updateBuildQuantity({
                ...item,
                quantity: getSavedQuantity(item) + 1
            });
        }
    }
};  

  const decrementQuantity = (index: number) => {
    const item = items.value[index];
    if (item) {
        const newQuantity = getSavedQuantity(item) - 1;
        cartStore.updateBuildQuantity({
            ...item,
            quantity: newQuantity
        });
    }
  };

  const addToCart = (product: any) => {
    const quantity = getStockQuantity(product);
    if (quantity > 0) {
        cartStore.updateBuildQuantity({
            product_id: product.product_id,
            product_name: product.product_name,
            product_category: product.product_category,
            product_price: product.product_price,
            quantity: quantity
        });
        productStore.updateStockQuantities(product.product_id, 0);
        drawer.value = true;
    }
  };

  const navigateToCart = async () => {
    try {
        await cartStore.saveBuildToCart(cartStore.buildItems);
        router.push('/cart');
    } catch (error: any) {
        if (error.message === 'Please login to save your build to cart') {
            alert('Please login to save your build to cart');
            router.push({
                path: '/login',
                query: { 
                    redirect: '/customise',
                    from: 'customise',
                    drawer: 'open'  // Add this to indicate drawer should be open
                }
            });
        } else {
            console.error('Error saving build:', error);
        }
    }
};

  const handlePointClick = (pointData: any) => {
    selectedPart.value = pointData;
    showProducts.value = false;
    infoDrawer.value = !!pointData;
  };

  const calculateSubtotal = (item: any, index: number) => {
    return (item.product_price * item.quantity).toFixed(2);
  };

  const calculateTotal = () => {
    const total = items.value.reduce((total, item) => {
      const price = Number(item.product_price) || 0;
      return total + (price * item.quantity);
  }, 0);
    return total.toFixed(2);
  };

  // Add a storage event listener
  const handleStorageChange = () => {
    items.value = cartStore.loadBuildFromLocal() as any[];
  };

  // Add watchers for drawer states
  watch(drawer, (newVal) => {
    requestAnimationFrame(() => {
      window.dispatchEvent(new Event('resize'));
      setTimeout(() => {
        window.dispatchEvent(new Event('resize'));
      }, 100);
    });
  });

  watch(infoDrawer, (newVal) => {
    requestAnimationFrame(() => {
      window.dispatchEvent(new Event('resize'));
      setTimeout(() => {
        window.dispatchEvent(new Event('resize'));
      }, 100);
    });
  });

  // Watch items for localStorage persistence
  watch(items, (newItems) => {
    localStorage.setItem('customBuildItems', JSON.stringify(newItems));
  }, { deep: true });

  // Add a watcher for cartStore's buildItems
  watch(() => cartStore.buildItems, (newItems) => {
    items.value = newItems;
  }, { deep: true });


    // Load saved build from localStorage on mount
  onMounted(async () => {
    await productStore.fetchAllComponents();
    window.addEventListener('storage', handleStorageChange);
    items.value = cartStore.loadBuildFromLocal() as any[];
  });
</script>
  
<style >
  @import url('@/assets/BitStreamFont/stylesheet.css');
  @import url('@/assets/BPdotsFont/stylesheet.css');

  .left-sidebar {
    background-color: #001655!important; /* Add your original dark color */

  z-index: 3;
  position: fixed !important;
  left: 0 !important;
  top: 0 !important;
  height: 100vh !important;
  border-right: 0px solid rgba(0, 0, 0, 0.12);
  padding-top: 85px;
  box-shadow: 2px 0 4px rgba(0, 0, 0, 0.1) !important;
  border-right: none !important;
  }
  
  .main-drawer {
  z-index: 4 !important;
  background-color: #001655 !important;
  position: fixed !important;
  top: 0 !important;
  height: 100vh !important;
  padding-top: 85px;
  box-shadow: 2px 0 4px rgba(0, 0, 0, 0.1) !important;
  border-left: none !important;
  }

  .info-drawer {
  z-index: 4 !important;
  background-color: #001655!important; /* Add your original dark color */
  position: fixed !important;
  top: 0 !important;
  height: 100vh !important;
  padding-top: 85px;
  box-shadow: -2px 0 4px rgba(0, 0, 0, 0.1) !important;
  border-left: none !important;
}
  
  .fill-height {
  height: 100vh;
  width: calc(100vw - 50px);
  position: relative;
  overflow: visible;
  padding-top: 85px;
  min-height: 100vh;
  margin-left: 50px;
  transition: none; /* Remove transition */
  z-index: 1;
  background-color: #f8f9fa;
  transition: width 0.2s ease-in-out, margin 0.2s ease-in-out !important;
  }
  
  .drawer-open .fill-height,
  .info-drawer-open .fill-height,
  .drawer-open.info-drawer-open .fill-height {
  transition: width 0.2s ease-in-out, margin 0.2s ease-in-out !important;
  }
  
  .v-navigation-drawer {
  transition: none !important;
  }
  
  .v-text-field input {
  font-size: 0.8em;
  }
  
  .v-list-item {
  padding: 12px;
  }
  
  .row {
  margin: 0;
  }
  
  .quantity-btn {
  border: 1px solid rgba(0, 0, 0, 0.12) !important;
  height: 32px !important;
  width: 32px !important;
  }
  
  canvas {
  position: absolute;
  top: 0;
  left: 0;
  width: 100% !important;
  height: 100% !important;
  display: block;
  margin: 0 !important;
  z-index: 1;
  }
  
  .info-drawer {
  z-index: 4 !important;
  background-color: white;
  position: fixed !important;
  top: 0 !important;
  height: 100vh !important;
  padding-top: 85px;
  box-shadow: -2px 0 4px rgba(0, 0, 0, 0.1) !important;
  border-left: none !important;
  }
  
  .drawer-open.info-drawer-open .fill-height {
  width: calc(100vw - 650px);
  margin-left: 350px;
  margin-right: 300px;
  }
  
  .info-drawer-open .fill-height {
  width: calc(100vw - 350px);
  margin-right: 300px;
  }
  
  /* Keep all existing styles and add/modify these */
  
  /* Ensure proper stacking context */
  .v-main {
    position: relative;
    z-index: 1;
  }
  
  /* Update z-index hierarchy */
  .left-sidebar {
    z-index: 1000 !important;
  }
  
  .main-drawer {
    z-index: 999 !important;
  }
  
  .info-drawer {
    z-index: 999 !important;
  }
  
  /* Add pointer-events handling */
  .fill-height {
    pointer-events: auto !important;
    z-index: 1;
  }
  
  /* Ensure canvas and its container can receive events */
  canvas {
    pointer-events: auto !important;
  }
  
  /* Add styles for drawer content */
  .v-navigation-drawer__content {
    pointer-events: auto !important;
  }
  
  /* Remove any overlay that might block interactions */
  /* .v-overlay {
    display: none !important;
  } */
  
  .v-navigation-drawer__scrim {
    display: none !important;
  }
  
  /* Add styles for quantity input */
  :deep(.v-text-field) {
    .v-field__input {
      text-align: center;
      padding: 0;
    }
    .v-field__outline {
      --v-field-border-width: 1px !important;
    }
  }
  
  /* Scene container should exactly match parent size */
  .scene-container {
    position: relative;
    width: 100% !important; /* Force full width */
    height: 100%;
    overflow: hidden;
    left: 0 !important; /* Prevent any automatic margins */
    margin: 0 !important; /* Remove any margins */
  }
  
  .description-text {
    white-space: pre-line;
  }
  
  /* Update transition duration to match the setTimeout delay */
  .fill-height {
    height: 100vh;
    width: calc(100vw - 50px);
    position: relative;
    overflow: visible;
    padding-top: 85px;
    min-height: 100vh;
    margin-left: 50px;
    transition: none; /* Remove transition */
    z-index: 1;
  }
  
  /* Make sure all drawer-related transitions use the same duration */
  .drawer-open .fill-height,
  .info-drawer-open .fill-height,
  .drawer-open.info-drawer-open .fill-height {
    transition: none; /* Remove transition */
  }
  
  /* Add new styles for the points container */
  .points-container {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: 10;
  }
  
  .point {
    position: absolute;
    transform-origin: center;
    pointer-events: auto;
    z-index: 11;
    cursor: pointer;
  }
  
  /* Add this to your styles */
  .drawer-scroll-space {
    height: 100px; /* Adjust this value to control scroll space */
    flex-shrink: 0; /* Prevent space from shrinking */
  }
  
  /* Update drawer content styles */
  .v-navigation-drawer__content {
    height: 100%;
    overflow-y: auto
  }
  
  /* Add these styles to your existing <style> section */
  
  /* Padding for Choose Your Parts header card */
  .main-drawer .v-card {
    padding: 24px 20px !important;
  }
  
  /* Padding for items in the main drawer */
  .main-drawer .v-list-item {
    padding: 16px 20px !important;
  }
  
  /* Padding for Sub-Total card */
  .main-drawer .v-card[color="#001655"] {
    padding: 24px 20px !important;
    margin-top: 16px;
  }
  
  /* Padding for Part Information header and content */
  .info-drawer .v-card {
    padding: 24px 20px !important;
  }
  
  .info-drawer .pa-4 {
    padding: 24px 20px !important;
  }
  
  /* Padding for product cards in info drawer */
  .info-drawer .v-card-text {
    padding: 16px 20px !important;
  }
  
  /* Adjust list container padding */
  .v-list {
    padding: 0 !important;
  }
  
  /* Remove any conflicting padding classes */
  .pa-4 {
    padding: 24px 20px !important;
  }
  
  /* Add subtle border radius to cards */
  .v-card {
    border-radius: 8px !important;
    overflow: hidden;
  }
  
  /* Add subtle border radius to buttons */
  .v-btn {
    border-radius: 6px !important;
  }
  
  /* Add subtle hover effect to interactive elements */
  .v-btn:hover {
    transform: translateY(-1px);
    transition: transform 0.2s ease;
  }
  
  /* Add smooth scrolling to drawers */
  .v-navigation-drawer__content {
    scroll-behavior: smooth;
  }

  .clear-btn:hover {
    color: #ff4444 !important;
  }

  .clear-btn {
    transition: color 0.2s ease;
  } 
</style>