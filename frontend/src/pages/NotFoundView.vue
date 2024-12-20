<template>
    <v-container class="d-flex flex-column align-center justify-center" style="height: 70vh;">
      <v-row class="text-center">
        <v-col cols="12">
          <h1 class="text-h2 font-weight-bold mb-4">404</h1>
          <h2 class="text-h4 mb-6">Page Not Found</h2>
          <p class="text-body-1 mb-8">
            The page you're looking for doesn't exist or has been moved.
          </p>
          <v-btn
            color="primary"
            size="large"
            to="/"
            prepend-icon="mdi-home"
          >
            Return to Home
          </v-btn>
        </v-col>
      </v-row>
    </v-container>
  </template>
  
  
  <script setup lang="ts">
  // No additional logic needed
  </script>

<route lang="yaml">
    name: not-found
</route>