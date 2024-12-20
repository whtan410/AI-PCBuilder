<template>
    <div :id="mapId" class="map-container"></div>
</template>
  
<script setup>
  import { onMounted } from 'vue'
  
  const props = defineProps({
    mapId: {
      type: String,
      required: true
    },
    address: {
      type: String,
      required: true
    },
    options: {
      type: Object,
      default: () => ({})
    }
  })
  
  // Integrated map functionality
  const initMap = async (mapId, address, options = {}) => {
    const geocoder = new google.maps.Geocoder()
    
    // SVG marker with hollow center
    const markerSvg = {
      path: 'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
      fillColor: '#e324bd',  // Purple color matching your theme
      fillOpacity: 1,
      strokeWeight: 0,
      rotation: 0,
      scale: 2,
      anchor: new google.maps.Point(12, 22)
    }
  
    const defaultOptions = {
      zoom: 15,
      styles: [],
      mapTypeControl: false,
      streetViewControl: false,
      clickableIcons: true
    }
  
    // Merge default options with provided options
    const mapOptions = { ...defaultOptions, ...options }
  
    geocoder.geocode({ address: address }, (results, status) => {
      if (status === 'OK') {
        const map = new google.maps.Map(
          document.getElementById(mapId),
          {
            ...mapOptions,
            center: results[0].geometry.location,
          }
        )
  
        const marker = new google.maps.Marker({
          map: map,
          position: results[0].geometry.location,
          icon: markerSvg
        })
  
        // Click handlers
        map.addListener('click', () => {
          const url = `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(address)}`
          window.open(url, '_blank')
        })
  
        marker.addListener('click', () => {
          const url = `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(address)}`
          window.open(url, '_blank')
        })
      }
    })
  }
  
  onMounted(() => {
    initMap(props.mapId, props.address, props.options)
  })
</script>
  
<style scoped>
  .map-container {
    width: 100%;
    height: 100%;
    cursor: pointer;
    transition: opacity 0.3s ease;
  }
  
  .map-container:hover {
    opacity: 0.9;
  }
</style>