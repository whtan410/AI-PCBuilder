<template>
    <v-carousel 
      class="carousel-size" 
      hide-delimiters 
      show-arrows="hover"
      :height="carouselHeight"
      cycle
      interval="5000"
    >
      <v-carousel-item
        v-for="(image, index) in images"
        :key="index"
        :src="image"
        cover
      ></v-carousel-item>
    
    </v-carousel>
</template>
  
<script setup>
    import { ref, onMounted, onBeforeUnmount, computed } from 'vue'

    // Integrated carousel functionality
    const windowWidth = ref(window.innerWidth)
    const images = ref([
        'https://ik.imagekit.io/yz1n0vis7/14.png?updatedAt=1730642531693',
        'https://ik.imagekit.io/yz1n0vis7/16.png?updatedAt=1730642531356',
        'https://ik.imagekit.io/yz1n0vis7/15.png?updatedAt=1730642531262',
        'https://ik.imagekit.io/yz1n0vis7/12.png?updatedAt=1730642531168',
        'https://ik.imagekit.io/yz1n0vis7/11.png?updatedAt=1730642531079',
        'https://ik.imagekit.io/yz1n0vis7/2.png?updatedAt=1730642528098'
    ])

    const carouselHeight = computed(() => {
        if (windowWidth.value <= 600) return 300
        if (windowWidth.value <= 960) return 400
        return 607
    })  

    const onResize = () => {
        windowWidth.value = window.innerWidth   
    }

    onMounted(() => {
        window.addEventListener('resize', onResize)
        onResize()
    })

    onBeforeUnmount(() => {
        window.removeEventListener('resize', onResize)
    })
</script>

<style scoped>
    .carousel-size {
        border-radius: 20px;
        box-shadow: 0 0 20px rgba(255, 75, 183, 0.7);
        overflow: hidden;
        height: 100% !important;
        width: 100% !important;
    }

    .v-carousel {
        height: 100% !important;
    }

    .v-carousel__item {
        height: 100% !important;
    }
</style>