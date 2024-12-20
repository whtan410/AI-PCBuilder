<template>
  <v-container>
    <v-row>
      <v-col>
        <v-card class="pa-4">
          <h1 class="text-h4 mb-4 bitstream">Welcome back, Admin!</h1>
          <p class="text-body-1 bitstream">Here's your admin dashboard. You can manage products and prebuilt PCs.</p>
        </v-card>
      </v-col>
    </v-row>
    
    <v-row class="mt-4">
      <v-col cols="12" md="6">
        <v-card class="pa-4" color="#3e0054">
          <h3 class="text-h6 bitstream text-white">Total Components</h3>
          <p class="text-h4 bitstream text-white">{{ totalComponents }}</p>
        </v-card>
      </v-col>
      <v-col cols="12" md="6">
        <v-card class="pa-4" color="#e324bd">
          <h3 class="text-h6 bitstream text-white">Prebuilt PCs</h3>
          <p class="text-h4 bitstream text-white">{{ totalPrebuilts }}</p>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup lang="ts">
import { useProductStore } from '../stores/productstore';
import { useBuildStore } from '../stores/build';
import { computed } from 'vue';

const productStore = useProductStore();
const buildStore = useBuildStore();

// Compute total components
const totalComponents = computed(() => {
  return Object.values(productStore.components).reduce((total, category) => {
    return total + category.product_list.length;
  }, 0);
});

// Get total prebuilt PCs
const totalPrebuilts = computed(() => {
  return buildStore.prebuiltPC.length;
});

// Fetch data when component mounts
onMounted(async () => {
  await Promise.all([
    productStore.fetchAllComponents(),
    buildStore.fetchPrebuiltPCs()
  ]);
});
</script>

<style scoped>
  @import url('../assets/BitStreamFont/stylesheet.css');
  @import url('../assets/BPdotsFont/stylesheet.css');
</style>