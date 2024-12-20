<template>
    <v-col cols="12" md="4">
      <v-card style="background-color: #001655;" class="bitstream - text-center">
        <v-card-title>{{ item.name }}</v-card-title>
        <v-card-text>
          <img :src="item.imageUrl" alt="Item Image" width="100%" class="fixed-size-image">
          <p>{{ item.description }}</p>
        </v-card-text>
          <v-card-actions>
            <v-row>
              <v-col cols="12" class="text-center">
                <v-btn>Add to Cart</v-btn>
              </v-col>
            </v-row>
          </v-card-actions>
      </v-card>
      <v-divider class="border-opacity-100" :thickness="3" color="#E324BD"></v-divider>
    </v-col>
  </template>
  
  <script>
  export default {
    name: 'ShopItem',
    props: {
      item: {
        type: Object,
        required: true,
      },
    },
  };
  </script>

<style>
@import url('../assets/BitStreamFont/stylesheet.css');
@import url('../assets/BPdotsFont/stylesheet.css');

.fixed-size-image {
    width: 300px; /* Set the desired width */
    height: 300px; /* Set the desired height */
    object-fit: cover; /* Maintain aspect ratio and cover the entire area */
  }

</style>