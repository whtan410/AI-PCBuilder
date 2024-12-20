<!-- MapBox.vue -->
<template>
    <v-card 
      class="map-box" 
      color="#001655"
      rounded="xl"
    >
      <v-divider class="border-opacity-100" color="#e324bd" thickness="3" />
      <v-row no-gutters>
        <!-- Content will stack on mobile -->
        <v-col cols="12" md="6">
          <div class="text-content">
            <h1 class="headline">{{ headline }}</h1>
            <h4 class="subtitle-1">{{ address1 }}</h4>
            <h4 class="subtitle-1">{{ address2 }}</h4>
            <h4 class="subtitle-1">{{ address3 }}</h4>
            <h4 class="subtitle-1">HP: +{{ phone }}</h4>
            <h4 class="subtitle-1">Email: {{ email }}</h4>
          </div>
        </v-col>
        <v-col cols="12" md="6" class="map-col">
            <!-- ask api key-->
          <GMap 
            :mapId="'map-' + index" 
            :address="address"
            :options="{
              zoom: 15,
              styles: darkMapStyle,
              mapTypeControl: false
            }"
          />
        </v-col>
      </v-row>
      <v-divider class="border-opacity-100" color="#e324bd" thickness="3" />
    </v-card>
</template>
  
<script setup>
    import GMap from './GMap.vue'
    
    // Add dark map style configuration
    const darkMapStyle = [
        { elementType: "geometry", stylers: [{ color: "#242f3e" }] },
        { elementType: "labels.text.stroke", stylers: [{ color: "#242f3e" }] },
        { elementType: "labels.text.fill", stylers: [{ color: "#746855" }] },
        {
            featureType: "road",
            elementType: "geometry",
            stylers: [{ color: "#38414e" }],
        },
        {
            featureType: "road",
            elementType: "geometry.stroke",
            stylers: [{ color: "#212a37" }],
        },
        {
            featureType: "road",
            elementType: "labels.text.fill",
            stylers: [{ color: "#9ca5b3" }],
        },
        {
            featureType: "water",
            elementType: "geometry",
            stylers: [{ color: "#17263c" }],
        },
    ];
    
    const props = defineProps({
        address: {
            type: String,
            required: true,
        },
        headline: {
            type: String,
            required: true,
        },
        address1: {
            type: String,
            required: true,
        },
        address2: {
            type: String,
            required: true,
        },
        address3: {
            type: String,
            required: true,
        },
        phone: {
            type: String,
            required: true,
        },
        email: {
            type: String,
            required: true,
        },
        index: {
            type: Number,
            required: true,
        },
    })
</script>
  
<style scoped>
  .map-box {
    width: 90%;
    max-width: 1200px;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    overflow: hidden;
    border-radius: 30px !important;
    box-shadow: 0 0 20px rgba(255, 75, 183, 0.7);
  }
  
  .text-content {
    padding: 20px;
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
  }
  
  .map-col {
    height: 300px;
    padding: 0 !important;
    position: relative;
    overflow: hidden;
  }
  
  .map-col :deep(.map-container) {
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    height: 100% !important;
  }
  
  .headline {
    font-size: 1.5rem;
    margin-bottom: 1rem;
    color: #ffffff;
    font-weight: bold;
  }
  
  .subtitle-1 {
    font-size: 1rem;
    margin: 0.5rem 0;
    color: #ffffff;
  }
  
  @media (min-width: 960px) {
    .text-content {
      text-align: right;
    }
  }
  
  @media (max-width: 959px) {
    .map-box {
      width: 95%;
    }
    
    .text-content {
      text-align: center;
      padding: 15px;
    }
  
    .headline {
      font-size: 1.2rem;
    }
  
    .subtitle-1 {
      font-size: 0.9rem;
    }
  }
</style>