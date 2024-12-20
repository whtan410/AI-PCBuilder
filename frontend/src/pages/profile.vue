<template>
  <div class="profile-container">
    <div class="profile-content">
      <v-tabs
        v-model="tab"
        color="#E324BD"
        direction="vertical"
        class="tabs"
      >
        <v-tab 
          prepend-icon="mdi-account" 
          value="info"
          class="tab-btn"
          :class="{ 'active': tab === 'info' }"
        >
          User Information
        </v-tab>
        <v-tab 
          prepend-icon="mdi-history" 
          value="orders"
          class="tab-btn"
          :class="{ 'active': tab === 'orders' }"
        >
          Order History
        </v-tab>
      </v-tabs>

      <v-window 
        v-model="tab" 
        class="tab-content"
        transition="slide-x-transition"
        reverse-transition="slide-x-reverse-transition"
      >
        <!-- User Information Tab -->
        <v-window-item value="info">
          <div class="account-info">
            <h1 class="white--text mb-6 text-center">User Information</h1>
            <ProfileForm 
              :isProfilePage="true"
              v-model:showSuccessAlert="showSuccessAlert"
              @showPasswordModal="showPasswordModal = true"
              class="custom-form"
            />
          </div>
        </v-window-item>

        <!-- Order History Tab -->
        <v-window-item value="orders">
          <v-alert
            v-if="showRatingSuccessAlert"
            type="success"
            class="mt-4"
            closable
            @click:close="showRatingSuccessAlert = false"
          >
            Rating submitted successfully!
          </v-alert>

          <h1 class="white--text mb-6 text-center">Order History</h1>
          <v-card flat>
            <v-card-text style="background-color: #3e0054;">
              <div v-if="ordersInfo.length">
                <v-expansion-panels class="custom-panels">
                  <v-expansion-panel
                    v-for="order in ordersInfo"
                    :key="order.order_id"
                    class="custom-panels"
                  >
                    <v-expansion-panel-title>
                      <v-row align="center" no-gutters>
                        <v-col cols="6">
                          <span>Order #{{ order.order_id }}</span>
                        </v-col>
                        
                        <v-col cols="2">
                          <span>{{ formatDate(order.order_time) }}</span>
                        </v-col>
                        
                        <v-col cols="2">
                          <v-chip
                            :color="getStatusColor(order.order_status)"
                            text-color="white"
                          >
                            {{ order.order_status }}
                          </v-chip>
                        </v-col>
                        
                        <v-col cols="2">
                          <v-btn
                            :color="order.feedback ? 'success' : 'primary'"
                            v-if="order.order_status === 'Completed'" 
                            @click.stop="openRatingDialog(order)"
                            size="small"
                          >
                            {{ order.feedback ? 'View Rating' : 'Rate Order' }}
                          </v-btn>
                        </v-col>
                      </v-row>
                    </v-expansion-panel-title>

                    <v-expansion-panel-text>
                      <OrderItemsTable v-if="order.items && order.items.length" :items="order.items" />
                    </v-expansion-panel-text>
                  </v-expansion-panel>
                </v-expansion-panels>
              </div>
              <v-alert
                v-else
                type="info"
                text="No orders found"
              ></v-alert>
            </v-card-text>
          </v-card>
        </v-window-item>
      </v-window>
    </div>

      <!-- Add Rating Dialog -->
    <v-dialog v-model="showRatingDialog" max-width="500px">
      <v-card>
        <v-card-title class="text-center ma-3">{{ currentOrder?.feedback ? 'Your Rating' : 'Rate Your Order' }}</v-card-title>
        <v-card-text>
          <v-form @submit.prevent="submitRating" v-if="!currentOrder?.feedback">
            <div class="d-flex align-center mb-4 justify-center">
              <span class="mr-4">Rating:</span>
              <v-rating
                v-model="ratingInfo.rating"
                color="warning"
                hover
                :readonly="!!currentOrder?.feedback"
              ></v-rating>
            </div>

            <v-select
              v-model="ratingInfo.platform"
              :items="platforms"
              label="How did you hear about us?"
              :readonly="!!currentOrder?.feedback"
              required
            ></v-select>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="error" type="button" @click="showRatingDialog = false">Cancel</v-btn>
              <v-btn 
                color="primary" 
                :disabled="!ratingInfo.rating || !ratingInfo.platform"
                type="submit"
              >
                Submit Rating
              </v-btn>
            </v-card-actions>
          </v-form>

          <!-- View only mode -->
          <div v-else>
            <div class="d-flex align-center mb-4 justify-space-around">
              <span class="mr-4">Your Rating:</span>
              <v-rating
                v-model="currentOrder.feedback.rating"
                color="warning"
                readonly
              ></v-rating>
            </div>

            <div class="d-flex align-center justify-space-around">
              <span class="mr-4">Platform:</span>
              <v-select
                v-model="currentOrder.feedback.platform"
                :items="platforms"
                readonly
                variant="outlined"
                density="compact"
                hide-details
                class="max-width-200" 
              ></v-select>
            </div>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="primary" @click="showRatingDialog = false">Close</v-btn>
            </v-card-actions>
          </div>
        </v-card-text>
      </v-card>
    </v-dialog>
  </div>
</template>


<script setup>
  import { ref, onMounted } from 'vue'
  import { storeToRefs } from 'pinia'
  import { useUserProfileStore } from '@/stores/profile'
  import OrderItemsTable from '@/components/OrderItemsTable.vue'
  import ProfileForm from '@/components/ProfileForm.vue'

  const platforms = [
    'Facebook',
    'Youtube',
    'Twitter',
    'Instagram',
    'Tiktok'
  ]

  const userProfileStore = useUserProfileStore();
  const { ordersInfo, ratingInfo } = storeToRefs(userProfileStore);
  const tab = ref('orders')

  //Feedback dialog 
  const showRatingDialog = ref(false)
  const currentOrder = ref(null)
  const showRatingSuccessAlert = ref(false)

  const openRatingDialog = async (order) => {
    currentOrder.value = order
    showRatingDialog.value = true
    
    if (!order.feedback) {
      // Reset rating data for new rating
      ratingInfo.value = {
        rating: 0,
        platform: ''
      }
    }
  }

  const submitRating = async () => {
    try {
      await userProfileStore.submitOrderRating(currentOrder.value.order_id, ratingInfo.value)
      await userProfileStore.fetchOrders()

      showRatingDialog.value = false
      showRatingSuccessAlert.value = true

      setTimeout(() => {
        showRatingSuccessAlert.value = false
      }, 3000)
    } catch (error) {
      console.error('Failed to submit rating:', error)
      }
    }

  // Functionality of page
  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString()
  }

  const getStatusColor = (status) => {
    if (!status) return 'grey' 

    const colors = {
      'pending': 'warning',
      'processing': 'info',
      'completed': 'success',
      'cancelled': 'error'
    }
    return colors[status.toLowerCase()] || 'grey'
  }

  onMounted(async() => {
    await userProfileStore.fetchOrders()
  })

</script>

<style scoped>
  @import url('@/assets/BitStreamFont/stylesheet.css');
  @import url('@/assets/BPdotsFont/stylesheet.css');

  .profile-container {
    min-height: 92vh;
    padding: 2rem;
    background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.6)), 
                url("https://mir-s3-cdn-cf.behance.net/project_modules/fs/223e6792880429.5e569ff84ebef.gif");
    background-attachment: fixed;
    background-size: cover;
    background-position: center;
  }

  .profile-content {
    display: flex;
    gap: 2rem;
    max-width: 1800px;
    margin: 0 auto;
    background: #3e0054;
    padding: 2rem;
    border-radius: 30px;
    box-shadow: 0px 0px 15px #E324BD;
    backdrop-filter: blur(5px);
  }

  .tabs {
    width: 300px;
    font-family: 'bitstream';
    background: transparent !important;
  }

  .tab-btn {
    color: white !important;
    font-size: 1.2rem !important;
    opacity: 0.8;
    transition: all 0.3s;
  }

  .tab-btn.active {
    color: #E324BD !important;
    opacity: 1;
    background: rgba(227, 36, 189, 0.1);
  }

  .tab-content {
    flex: 1;
    padding: 0 1rem;
    font-family: 'bitstream';
  }

  /* Custom styling for ProfileForm component */
  :deep(.custom-form) {
    .v-label {
      color: white !important;
    }

    .v-field {
      background: rgba(255, 255, 255, 0.1) !important;
      border: 1px solid rgba(227, 36, 189, 0.5) !important;
      border-radius: 8px !important;
      transition: all 0.3s;

      &:hover, &:focus-within {
        border-color: #E324BD !important;
        box-shadow: 0 0 10px rgba(227, 36, 189, 0.3);
      }
    }

    .v-field__input {
      color: white !important;
    }

    .v-btn {
      background: #001655 !important;
      box-shadow: 0 0px 5px #E324BD !important;
      transition: all 0.3s;

      &:hover {
        background: #E324BD !important;
      }
    }
  }

  /* Keep your existing order history styles */
  .order-card {
    border: 1px solid #ffffff;
    border-radius: 8px;
    padding: 1rem;
    margin-bottom: 1rem;
  }

  .v-window {
    height: 100%;
  }

  .max-width-200 {
    max-width: 200px;
  }

  :deep(.custom-panels) {
  /* Panel background */
  .v-expansion-panel {
    background-color: #3e0054 !important;
    color: white !important;
  }

  /* Panel title */
  .v-expansion-panel-title {
    background-color: #3e0054 !important;
    color: white !important;
  }

  /* Panel content */
  .v-expansion-panel-text {
    background-color: #3e0054 !important;
    color: white !important;
  }

  /* Remove default borders if needed */
  .v-expansion-panel {
    border: none !important;
  }

  /* Optional: Style the expansion indicator (arrow) */
  .v-expansion-panel-title__icon {
    color: white !important;
  }

  /* Optional: Add hover effect */
  .v-expansion-panel:hover {
    background-color: #4e0068 !important;
  }

  
}
</style>