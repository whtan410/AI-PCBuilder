<template>
    <v-btn
      color="error"
      variant="tonal"
      :icon="icon"
      :class="{ 'text-none': !icon }"
      @click="handleLogout"
    >
      <v-icon v-if="icon">mdi-logout</v-icon>
      <span v-else>Logout</span>
    </v-btn>
  </template>
  
  <script setup lang="ts">
  import { useAuthStore } from '@/stores/auth'
  import { useRouter } from 'vue-router'
  
  defineProps({
    icon: {
      type: Boolean,
      default: false
    }
  })
  
  const router = useRouter()
  const authStore = useAuthStore()
  
  const handleLogout = () => {
    authStore.logout()
    router.push('/login')
  }
  </script>