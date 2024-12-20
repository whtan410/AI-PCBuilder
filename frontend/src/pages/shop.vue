<template>
  <v-parallax src="https://mir-s3-cdn-cf.behance.net/project_modules/fs/223e6792880429.5e569ff84ebef.gif" class="dimmed-background">
      <v-container class="mt-10">
          <!-- Add this alert at the top of your container -->
          <v-container-title class="text-h1 bpdots shop-title mb-5" :style="{ textShadow: '2px 2px 5px #FF66FF'}">
              SHOP LISTING
          </v-container-title>

          <v-row justify="center">
              <v-col cols="12" sm="12" md="5">
                  <v-select
                      v-model="filterOption"
                      :items="filterOptions"
                      label="Filter by Price"
                      class="bitstream mt-5"
                      bg-color="#3E0054"
                  ></v-select>
              </v-col>

              <v-col cols="12" sm="12" md="5">
                  <v-select
                      v-model="sortOption"
                      :items="sortOptions"
                      label="Sort by"
                      class="bitstream mt-5"
                      bg-color="#3E0054"
                  ></v-select>
              </v-col>
          </v-row>
          
          <v-row class="mt-5">
              <v-col v-for="build in filteredAndSortedBuilds" 
                  :key="build.build_id" 
                  cols="12" 
                  md="6" 
                  lg="4">
                  <ItemCard :build="build" :isCustomer="isCustomer" @add-to-cart="addToCart" />
              </v-col>
          </v-row>

          <Snackbar 
              v-model:show="showSnackbar"
              :message="snackbarMessage"
          />
      </v-container>
  </v-parallax>
</template>

<script setup lang="ts">
  import { ref, computed, onMounted } from 'vue'
  import { storeToRefs } from 'pinia'

  import { useBuildStore } from '@/stores/build'
  import { useAuthStore } from '@/stores/auth'
  import { useCartStore } from '@/stores/cartstore'

  import ItemCard from '@/components/ItemCard.vue'
  import Snackbar from '@/components/Snackbar.vue'

  const buildStore = useBuildStore()
  const authStore = useAuthStore()
  const cartStore = useCartStore()

  const { prebuiltPC } = storeToRefs(buildStore)

  // Computed property to check if user is a customer
  const isCustomer = computed(() => authStore.isCustomer)

  //sort Options
  const sortOption = ref('price-asc')
  const sortOptions = [
      { title: 'Price: Low to High', value: 'price-asc' },
      { title: 'Price: High to Low', value: 'price-desc' },
      { title: 'Name: A to Z', value: 'name-asc' },
      { title: 'Name: Z to A', value: 'name-desc' },
  ]

  const filterOption = ref('all')
  const filterOptions = [
      { title: 'All Prices', value: 'all' },
      { title: 'Under RM3000', value: 'under-3000' },
      { title: 'RM3000 - RM4000', value: '3000-4000' },
      { title: 'RM4000 - RM5000', value: '4000-5000' },
      { title: 'Above RM5000', value: 'above-5000' },
  ]

  // Updated computed property to handle both filtering and sorting
  const filteredAndSortedBuilds = computed(() => {
      let builds = [...prebuiltPC.value]
      
      // Apply filtering
      if (filterOption.value !== 'all') {
          builds = builds.filter(build => {
              switch (filterOption.value) {
                  case 'under-3000':
                      return build.build_price < 3000
                  case '3000-4000':
                      return build.build_price >= 3000 && build.build_price <= 4000
                  case '4000-5000':
                      return build.build_price >= 4000 && build.build_price <= 5000
                  case 'above-5000':
                      return build.build_price > 5000
                  default:
                      return true
              }
          })
      }
      
      // Apply sorting
      switch (sortOption.value) {
          case 'price-asc':
              return builds.sort((a, b) => a.build_price - b.build_price)
          case 'price-desc':
              return builds.sort((a, b) => b.build_price - a.build_price)
          case 'name-asc':
              return builds.sort((a, b) => a.build_name.localeCompare(b.build_name))
          case 'name-desc':
              return builds.sort((a, b) => b.build_name.localeCompare(a.build_name))
          default:
              return builds
      }
  })

  // Optional: Add a computed property to show number of results

  onMounted(async () => {
      await buildStore.fetchPrebuiltPCs()
    //   const a =prebuiltPC.value.sort((a, b) => a.build_price - b.build_price)
  })

  const showSnackbar = ref(false)
  const snackbarMessage = ref('')

  const addToCart = async (build: any) => {
    if (!authStore.isAuthenticated) {
        snackbarMessage.value = 'Please login to add items to cart'
        showSnackbar.value = true
        return
    }

    if (!isCustomer.value) {
        snackbarMessage.value = 'Only customers can add items to cart'
        showSnackbar.value = true
        return
    }

    try {
        await cartStore.addPrebuiltToCart({
            build_id: build.build_id,
            quantity: 1
        })
        snackbarMessage.value = `${build.build_name} added to cart successfully!`
        showSnackbar.value = true
    } catch (error) {
        snackbarMessage.value = 'Failed to add item to cart. Please try again.'
        showSnackbar.value = true
    }
}
</script>

<route lang="yaml">
  meta:
  layout: default
  name: shop
  path: /shop
  component: shop
</route>

<style scoped>

  @import url('../assets/BitStreamFont/stylesheet.css');
  @import url('../assets/BPdotsFont/stylesheet.css');

  .dimmed-background::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.5); /* Adjust opacity for dimming */
      z-index: 1;
  }

  .v-parallax {
  position: relative;
  overflow: hidden;
  }

  .v-container {
  position: relative;
  z-index: 2; /* Ensure content is above the overlay */
  text-align: center; /* Center content */
  }

  .v-alert {
  position: fixed;
  top: 20px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 1000;
  width: 90%;
  max-width: 500px;
  }

</style>