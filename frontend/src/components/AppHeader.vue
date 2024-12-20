<template>
  <v-app-bar
    class="d-flex flex-row align-center bpdots"
    height="80px"
    scroll-behavior="hide"
    scroll-threshold="100"
    :style="{ textShadow: '2px 2px 5px #FF66FF'}"
  >
    <div class="logo-container">
      <v-img
        aspect-ratio="1"
        src="../assets/moonarch.png"
        :width="logoSize"
        class="pixel-logo"
      />
    </div>

    <v-spacer />
    <v-btn-toggle
      v-model="toggle"
      color="#3e0054"
      class="button-container"
    >
      <v-btn
        to="/"
        size="large"
        class="nav-button"
        rounded="lg"
      >
        About
      </v-btn>
      <v-btn
        to="/shop"
        size="large"
        class="nav-button"
        rounded="lg"
      >
        Shop Now
      </v-btn>
      <v-btn
        to="/customise"
        size="large"
        class="nav-button"
        rounded="lg"
      >
        Customise
      </v-btn>
    </v-btn-toggle>

    <v-spacer />

    <!-- Show these buttons based on user type -->
    <template v-if="authStore.isAuthenticated">
      <v-btn
        v-if="authStore.isMaster"
        to="/dashboard"
        icon="mdi-view-dashboard"
        :size="cartSize"
        class="mr-2"
      />
      <v-btn
        v-if="authStore.isCustomer"
        to="/cart"
        icon="mdi-cart"
        :size="cartSize"
        class="cart-btn"
      />
    </template>

    <v-menu>
      <template #activator="{ props }">
        <v-btn 
          icon="mdi-account" 
          :size="cartSize" 
          v-bind="props"
          :style="{ textShadow: '2px 2px 5px #FF66FF'}"
        />
      </template>

      <v-list>
        <template v-if="!authStore.isAuthenticated">
          <v-list-item to="/login">
            <v-list-item-title>
              <v-btn prepend-icon="mdi-login">Login/Signup</v-btn>
            </v-list-item-title>
          </v-list-item>
        </template>

        <template v-else>
          <v-list-item to="/profile" v-if="authStore.isCustomer">
            <v-list-item-title>
              <v-btn prepend-icon="mdi-account-cog">Profile</v-btn>
            </v-list-item-title>
          </v-list-item>
          <v-list-item>
            <v-list-item-title>
              <LogoutButton :icon="false" prepend-icon="mdi-logout" />
            </v-list-item-title>
          </v-list-item>
        </template>
      </v-list>
    </v-menu>
  </v-app-bar>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useAuthStore } from '@/stores/auth'
// import { useRouter } from 'vue-router'
import LogoutButton from '@/components/LogoutButton.vue'

const authStore = useAuthStore()
const toggle = ref(null)

// Computed properties for responsive sizes
const logoSize = computed(() => {
  if (window.innerWidth <= 400) return '40'
  if (window.innerWidth <= 600) return '50'
  return '80'
})

const cartSize = computed(() => {
  if (window.innerWidth <= 400) return 'x-small'
  if (window.innerWidth <= 600) return 'small'
  return 'x-large'
})
</script>

<style scoped>
@import url('../assets/BitStreamFont/stylesheet.css');
@import url('../assets/BPdotsFont/stylesheet.css');

.v-app-bar {
  padding: 0 5px;
  height: auto !important;
  min-height: 60px !important;
}

.nav-button {
  font-size: clamp(0.6rem, 1.2vw, 1.5rem) !important;
  margin: 0 clamp(2px, 0.5vw, 20px);
  padding: 0 clamp(4px, 1vw, 20px) !important;
  height: 32px !important;
  transition: background-color 0.3s ease;
  white-space: nowrap;
  font-weight: 800;
}

.button-container {
  display: flex;
  align-items: center;
  gap: 2px;
}

.nav-button:hover {
  background-color: #5e0054;
}

.pixel-logo {
  image-rendering: pixelated;
  filter: drop-shadow(0 0 8px #00ffff);
  transition: filter 0.3s ease;
}

.pixel-logo:hover {
  filter: drop-shadow(0 0 12px #ff00ff);
}

.logo-container {
  margin-left: clamp(5px, 1vw, 30px);
}

.cart-btn {
  margin-right: clamp(5px, 1vw, 30px);
}

/* Tablet styles */
@media (min-width: 601px) and (max-width: 960px) {
  .nav-button {
    font-size: 0.9rem !important;
    padding: 0 8px !important;
    height: 36px !important;
  }
}

/* Mobile styles */
@media (max-width: 600px) {
  .nav-button {
    font-size: 0.7rem !important;
    padding: 0 6px !important;
    margin: 0 1px;
    height: 28px !important;
  }

  .v-app-bar {
    padding: 0 2px;
    min-height: 50px !important;
  }

  .button-container {
    gap: 1px;
  }
}

/* Extra small screens */
@media (max-width: 400px) {
  .nav-button {
    font-size: 0.6rem !important;
    padding: 0 4px !important;
    margin: 0;
    height: 24px !important;
  }

  .v-app-bar {
    padding: 0 1px;
    min-height: 40px !important;
  }

  .logo-container {
    margin-left: 2px;
  }

  .cart-btn {
    margin-right: 2px;
  }
}
</style>