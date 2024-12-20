<template>
  <v-app>
    <AppHeader />
    
    <!-- Main Content -->
    <v-main>
      <router-view />
    </v-main>

    <AppFooter />
  </v-app>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useAuthStore } from '@/stores/auth'
import AppHeader from '@/components/AppHeader.vue'
import AppFooter from '@/components/AppFooter.vue'

const authStore = useAuthStore()

onMounted(() => {
  authStore.checkAuth()
})
</script>

<style>
@font-face {
  font-family: 'vera-sans-mono';
  src: url("../src/assets/Bitstream-Vera-Sans-Mono/VeraMono.ttf");
}
</style>