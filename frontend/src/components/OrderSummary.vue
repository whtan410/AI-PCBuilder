<template>
  <v-card style="background-color:#001655" class="ma-5">
    <v-divider class="border-opacity-75" :thickness="4" color="#E324BD"></v-divider>
    <v-card-title class="text-center text-h5 bitstream">ORDER LIST</v-card-title>
    <v-divider class="border-opacity-50"></v-divider>
    
    <!-- Cart Items List -->
    <div class="scrollable-list">
      <v-list variant="tonal" style="background-color:#001655">
        <v-list-item v-for="item in cartItems" :key="item.cart_item_id">
          <v-row align="center" no-gutters>
            <v-col cols="3">
              <v-img :src="item.img_url ?? ''" height="50" width="50" cover></v-img>
            </v-col>

            <v-col cols="6">
              <v-list-item-title class="mt-5">{{ item.product_name }}</v-list-item-title>
            </v-col>

            <v-col cols="3" class="text-right">
              <v-list-item-subtitle>
                {{ item.quantity }} x RM {{ item.price?.toFixed(2) }}
              </v-list-item-subtitle>
            </v-col>

          </v-row>
        </v-list-item>
      </v-list>
    </div>

    <!-- Total Amount -->
    <v-divider class="border-opacity-75"></v-divider>
    <v-row>
      <v-col cols="4" class="text-left ml-4" style="color: #E324BD;">
        <div class="text-h6">Total: </div>
      </v-col>
      <v-spacer></v-spacer>
      <v-col cols="4" class="text-right mr-4" style="color: #E324BD;">
        <div class="text-h6">RM {{ cartTotal.toFixed(2) }}</div>
      </v-col>
    </v-row>
    <v-divider class="border-opacity-75"></v-divider>

    <!-- Payment Method Section -->
    <v-card-title class="text-subtitle-1 bitstream my-5">Payment Method</v-card-title>
    <v-radio-group v-model="paymentMethod" class="ma-4" color="#E324BD">
      <v-radio label="Visa & Mastercard" value="card"></v-radio>
      <v-radio label="Bank Transfer" value="bank"></v-radio>
      <v-radio label="E-Wallet" value="ewallet"></v-radio>
    </v-radio-group>

    <!-- Terms and Conditions -->
    <v-checkbox
      v-model="termsAccepted"
      :rules="[v => !!v || 'You must agree to continue']"
      class="ma-4"
      color="#E324BD"
    >
      <template v-slot:label>
        <div>
          I have read and agree to the
          <v-tooltip location="bottom">
            <template v-slot:activator="{ props }">
              <a 
                href="#" 
                class="terms-link" 
                v-bind="props"
                @click.prevent="showTermsDialog = true"
              >
                Terms and Conditions
              </a>
            </template>
            <span>Click to read terms</span>
          </v-tooltip>
        </div>

      </template>
    </v-checkbox>


    <!-- Terms Dialog -->
    <v-dialog v-model="showTermsDialog" max-width="600px">
      <v-card>
        <v-card-title>Terms and Conditions</v-card-title>
        <v-card-text>
          <!-- Add your terms and conditions content here -->
          <p>Your terms and conditions text goes here...</p>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="primary" @click="showTermsDialog = false">Close</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-divider class="border-opacity-75" :thickness="4" color="#E324BD"></v-divider>
  </v-card>
</template>

<script lang="ts" setup>
  import { ref } from 'vue'
  import type { CartItem } from '@/stores/cartstore'
  

// Props
  defineProps({
    cartItems: {
      type: Array as () => CartItem[],
      required: true
    },
    cartTotal: {
      type: Number,
      required: true
    }
  })

  // State
  const paymentMethod = ref('card')
  const termsAccepted = ref(false)
  const showTermsDialog = ref(false)

  defineExpose({
    paymentMethod,
    termsAccepted
  })
</script>

<style scoped>
  .scrollable-list {
    overflow-y: auto;
    max-height: 300px;
    overflow-x: hidden;
    padding: 16px;
    border-radius: 8px;
    background-color: #001655;
  }

  .scrollable-list::-webkit-scrollbar {
    width: 8px;
  }

  .scrollable-list::-webkit-scrollbar-thumb {
    background-color: #E324BD;
    border-radius: 10px;
  }

  .scrollable-list::-webkit-scrollbar-track {
    background: transparent;
  }

  .terms-link {
    color: #E324BD;
    text-decoration: none;
  }

  .terms-link:hover {
    text-decoration: underline;
  }
</style>