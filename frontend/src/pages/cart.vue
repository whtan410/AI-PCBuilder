<template>
  <v-main class="container parallax-background" style="min-height: 50rem;">
    <div class="overlay"></div>
    <v-container>
      <v-card style="background-color: rgba(62, 0, 84, 0.9); padding: 16px; min-height: 100%;">
        <v-card-title class="d-flex justify-space-between align-center mb-4 bpdots text-h2" :style="{ textShadow: '2px 2px 5px #FF66FF'}">
          SHOPPING CART
          <v-btn
            color="red"
            @click="clearCart"
            class="bitstream"
            :disabled="cartItems.length === 0"
            style="margin-left: auto;"
          >
            <v-icon>mdi-delete</v-icon>
          </v-btn>
        </v-card-title>
        
        <!-- Debug info -->
        <div class="debug-info text-center bitstream">
          Total Items: {{ cartItemCount }}
        </div>

        <div class="scrollable-list bitstream" style="overflow-y: auto; max-height: 40vh;">
          <v-row>
            <v-col cols="12">
              <CartList
                :cartItems="cartItems"
                :increaseQuantity="increaseQuantity"
                :decreaseQuantity="decreaseQuantity"
              />
            </v-col>
          </v-row>
        </div>

        <v-row class="mt-4">
          <v-col cols="12" class="text-right">
            <div v-if="cartItems.length > 0" class="text-h5 bitstream mr-5">
              Total: RM {{ totalPrice }}
            </div>
          </v-col>
          <v-col cols="12" class="text-right bitstream">
            <v-btn 
              color="#E324BD" 
              @click="checkout" 
              class="bitstream mr-2"
              :disabled="cartItems.length === 0"
            >
              Checkout
            </v-btn>
            <v-btn color="primary" @click="continueShopping" class="bitstream">
              Continue Shopping
            </v-btn>
          </v-col>
        </v-row>
      </v-card>
    </v-container>
  </v-main>
</template>
  
<script setup lang="ts">
  import { computed, onMounted } from 'vue';
  import { useRouter } from 'vue-router';

  import { useCartStore } from '@/stores/cartstore';
  import { useCheckoutStore } from '@/stores/checkoutStore';

  import CartList from '@/components/CartList.vue';
  
  const router = useRouter();
  const cartStore = useCartStore();
  const checkoutStore = useCheckoutStore();
  // Fetch cart items when component mounts
  onMounted(async () => {
    await cartStore.fetchCartItems();
  });
  
  // Use store's getters
  const cartItems = computed(() => cartStore.cartItems);
  const totalPrice = computed(() => cartStore.cartTotal.toFixed(2));
  const cartItemCount = computed(() => cartStore.totalItems);
  
  // Cart actions
  const clearCart = async () => {
    await cartStore.clearCart();
  };
  
  const checkout = () => {
    // Store cart data in checkout store
    checkoutStore.initiateCheckout({
        items: cartStore.cartItems,
        total: cartStore.cartTotal
    })
    router.push('/payment')
  };
  
  const continueShopping = () => {
    router.push('/shop');
  };
  
  const increaseQuantity = async (cartItemId: number) => {
    const item = cartStore.cartItems.find(item => item.cart_item_id === cartItemId);
    if (item) {
      await cartStore.updateCartItemQuantity(cartItemId, item.quantity + 1);
    }
  };
  
  const decreaseQuantity = async (cartItemId: number) => {
    const item = cartStore.cartItems.find(item => item.cart_item_id === cartItemId);
    if (item) {
      if (item.quantity > 1) {
        await cartStore.updateCartItemQuantity(cartItemId, item.quantity - 1);
      } else {
        await cartStore.removeCartItem(cartItemId);
      }
    }
  };
</script>
  
<style>
  @import url('../assets/BitStreamFont/stylesheet.css');
  @import url('../assets/BPdotsFont/stylesheet.css');

  .parallax-background {
    background-image: url('https://mir-s3-cdn-cf.behance.net/project_modules/fs/223e6792880429.5e569ff84ebef.gif');
    background-attachment: fixed;
    background-size: cover;
    background-position: center;
  }

  .overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 0;
  }

  .scrollable-list {
    overflow-y: auto;
    max-height: 300px; /* Adjust the height as needed */
    overflow-x: hidden; /* Remove horizontal scrollbar */
    padding: 16px; /* Optional: Add padding to match card */
    border-radius: 8px; /* Optional: Add border-radius to match card */
  }

  .scrollable-list::-webkit-scrollbar {
    width: 8px;
  }

  .scrollable-list::-webkit-scrollbar-thumb {
    background-color: #E324BD; /* Pink color */
    border-radius: 10px;
  }

  .scrollable-list::-webkit-scrollbar-track {
    background: transparent;
  }

  .scrollable-list .v-list {
    background-color: #3e0054 !important;
  }
</style>