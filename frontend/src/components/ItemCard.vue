<template>
    <v-card class="mx-auto bitstream card-content border-radius-10" max-width="500" style="background-color: #001655">
      <v-card-title class="text-h6 text-center d-flex justify-center text-white bitstream my-2">
        {{ build.build_name }}
      </v-card-title>
      <v-img
        :src="build.build_img_url"
        height="400"
        cover
        class="product-image"
      >
        <template v-slot:placeholder>
          <v-row class="fill-height ma-0" align="center" justify="center">
            <v-progress-circular indeterminate></v-progress-circular>
          </v-row>
        </template>
      </v-img>
  
      <v-card-subtitle class="pt-4 d-flex justify-center">
        <span class="text-h6 text-white bitstream">
          RM {{ build.build_price.toLocaleString('en-MY', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}
        </span>
      </v-card-subtitle>
  
      <v-card-text>
        <v-expansion-panels>
          <v-expansion-panel>
            <v-expansion-panel-title>
              <div class="d-flex justify-center w-100 align-center">
                <v-icon start icon="mdi-cog-outline" class="mr-2"></v-icon>
                <span class="text-white bitstream">System Specifications</span>
              </div>
            </v-expansion-panel-title>
            <v-expansion-panel-text>
              <v-list>
                <v-list-item v-for="(part, key) in build.build_parts" 
                            :key="key"
                            :title="formatPartType(part.part_type)"
                            :subtitle="part.name"
                            class="mb-2">
                  <template v-slot:prepend>
                    <v-icon :icon="getPartIcon(part.part_type)"    
                           color="white"
                           class="mr-3"
                           size="large"></v-icon>
                  </template>
                </v-list-item>
              </v-list>
            </v-expansion-panel-text>
          </v-expansion-panel>
        </v-expansion-panels>
      </v-card-text>
  
      <v-card-actions class="ma-3">
        <v-btn
          color="primary"
          variant="elevated"
          block
          size="large"
          @click="$emit('add-to-cart', build)"
        >
          <span class="text-white">Add to Cart</span>
          <v-icon end icon="mdi-cart-plus" class="ml-2"></v-icon>
        </v-btn>
      </v-card-actions>
    </v-card>
</template>
  
<script setup lang="ts">
  defineProps({
    build: {
      type: Object,
      required: true
    },
    isCustomer: {
      type: Boolean,
      required: true
    }
  })
  
  defineEmits(['add-to-cart'])
  
  const getPartIcon = (partType: string) => {
    const icons = {
      cpu: 'mdi-cpu-64-bit',
      gpu: 'mdi-video',
      ram: 'mdi-memory',
      motherboard: 'mdi-developer-board',
      ssd: 'mdi-database',
      hdd: 'mdi-harddisk',
      psu: 'mdi-power-plug',
      case: 'mdi-desktop-tower',
      cooler: 'mdi-coolant-temperature',
      fan: 'mdi-fan'
    }
    return icons[partType as keyof typeof icons] || 'mdi-desktop-tower'
  }
  
  const formatPartType = (partType: string) => {
    const partTypes = {
      cpu: 'Processor',
      gpu: 'Graphics Card',
      ram: 'Memory',
      motherboard: 'Motherboard',
      ssd: 'Solid State Drive',
      hdd: 'Hard Drive',
      psu: 'Power Supply',
      case: 'Case',
      cooler: 'CPU Cooler',
      fan: 'System Fan'
    }
    return partTypes[partType as keyof typeof partTypes] || partType
  }
</script>
  
<style scoped>
/* Move all the card-related styles here */
@import url('../assets/BitStreamFont/stylesheet.css');
@import url('../assets/BPdotsFont/stylesheet.css');

.v-card {
    transition: transform 0.2s;
    background: linear-gradient(145deg, #001040, #001655) !important; /* Deep blue background */
    border: 1px solid rgba(255, 255, 255, 0.1);
}

.v-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 30px rgba(0, 22, 85, 0.5) !important;
}

.v-list-item {
    padding: 12px !important;
}

.v-list-item__title {
    font-weight: bold !important;
    color: white !important;
    font-size: 0.5rem !important;  /* Added this line */

}

.v-list-item__subtitle {
    font-size: 0.5rem !important;
    white-space: normal !important;
    line-height: 1.5 !important;
    color: rgba(255, 255, 255, 0.7) !important;
}

.v-expansion-panel {
    background-color: rgba(30, 30, 30, 0.9) !important;
}

.v-list {
    background-color: transparent !important;
}

:deep(.v-expansion-panel-title) {
    color: white !important;
}

:deep(.v-expansion-panel-text) {
    color: white !important;
}

:deep(.v-expansion-panel) {
background: linear-gradient(145deg, #001655, #001e6f) !important;
border: 1px solid rgba(255, 255, 255, 0.1);
}

:deep(.v-list-item) {
background: transparent !important;
border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.custom-button {
background: linear-gradient(145deg, #e324bd, #c71da2) !important;
border: 1px solid rgba(255, 255, 255, 0.2) !important;
transition: all 0.3s ease !important;
}

.custom-button:hover:not(:disabled) {
background: linear-gradient(145deg, #f035ce, #e324bd) !important;
box-shadow: 0 0 15px rgba(227, 36, 189, 0.4) !important;
}

.custom-button:disabled {
opacity: 0.6;
background: linear-gradient(145deg, #a11b87, #891873) !important;
}

/* Override Vuetify's default button styles */
:deep(.v-btn.v-btn--variant-elevated) {
background: linear-gradient(145deg, #e324bd, #c71da2) !important;
border: 1px solid rgba(255, 255, 255, 0.2);
}

:deep(.v-btn.v-btn--variant-elevated:hover:not(:disabled)) {
background: linear-gradient(145deg, #f035ce, #e324bd) !important;
}

.product-image {
    width: 100% !important;
    height: 300px !important;
    object-fit: contain !important;
}

:deep(.v-img__img) {
    object-fit: contain !important;
    object-position: center !important;
}

/* Optional: Add a subtle transition effect */
:deep(.v-img__img) {
    transition: transform 0.3s ease;
}

.v-card:hover :deep(.v-img__img) {
    transform: scale(1.05);
}

</style>