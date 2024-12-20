<template>
  <div>
    <v-list v-if="cartItems.length > 0">
      <v-list-item v-for="item in cartItems" :key="item.cart_item_id" class="mb-2">
        <v-card width="100%" color="rgba(62, 0, 84, 0.7)">
          <v-card-text>
            <v-row align="center" no-gutters>
              <!-- Item Image -->
              <v-col cols="3" v-if="item.img_url">
                <v-img 
                  :src="item.img_url" 
                  height="100" 
                  width="100" 
                  cover
                  class="rounded"
                ></v-img>
              </v-col>
              
              <!-- Item Details -->
              <v-col :cols="item.img_url ? 6 : 9">
                <v-list-item-title class="text-h6 mb-1 bitstream">{{ item.product_name.toUpperCase() }}</v-list-item-title>
                <v-list-item-subtitle class="bitstream"> {{ item.category.toUpperCase() }} </v-list-item-subtitle>
                <v-list-item-subtitle class="bitstream"> {{ item.quantity }} x RM {{ item.price?.toFixed(2) }} </v-list-item-subtitle>
              </v-col>

              <!-- Quantity Controls -->
              <v-col cols="3" class="text-right">
                <v-btn icon @click="decreaseQuantity(item.cart_item_id)">
                  <v-icon>mdi-minus</v-icon>
                </v-btn>
                <span class="mx-2 bitstream" style="font-size: 1.2em;">{{ item.quantity }}</span>
                <v-btn icon @click="increaseQuantity(item.cart_item_id)">
                  <v-icon>mdi-plus</v-icon>
                </v-btn>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
        <v-divider class="my-2"></v-divider>
      </v-list-item>
    </v-list>
    <div v-else class="text-center pa-4 bitstream">
      Your cart is empty
    </div>
  </div>
</template>

<script setup lang="ts">
import type { CartItem } from '@/stores/cartstore';

defineProps<{
  cartItems: CartItem[];
  increaseQuantity: (cartItemId: number) => void;
  decreaseQuantity: (cartItemId: number) => void;
}>();
</script>

<style scoped>
.v-list-item {
  background-color: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  margin-bottom: 8px;
}

.bitstream {
  font-family: 'Bitstream Vera Sans Mono', monospace;
}
</style>
  