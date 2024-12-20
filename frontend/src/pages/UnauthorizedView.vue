<template>
    <v-container class="fill-height">
      <v-row justify="center" align="center">
        <v-col cols="12" sm="8" md="6" class="text-center">
          <h1 class="text-h3 mb-6">403 - Unauthorized</h1>
          <p class="text-body-1 mb-6">
            You don't have permission to access this page.
          </p>
          <v-btn color="primary" @click="router.push('/')">
            Go Home
          </v-btn>
        </v-col>
      </v-row>
    </v-container>
  </template>
  
  <script setup lang="ts">
  import { useRouter } from 'vue-router'
  
  const router = useRouter()
  </script>
  
  <route lang="yaml">
  name: unauthorized
  </route>