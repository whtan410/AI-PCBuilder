<template>
  <v-card :style="{ backgroundColor: isProfilePage ? '#3e0054' : '#001655' }"  class="ma-5 bitstream">
    <v-divider class="border-opacity-75" :thickness="4" color="#E324BD"></v-divider>
    
    <v-alert
      v-if="showSuccessAlert && isProfilePage"
      type="success"
      class="ma-4"
      closable
      @click:close="$emit('update:showSuccessAlert', false)"
      >
      Profile information updated successfully!
    </v-alert>

    <v-form ref="form" @submit.prevent="isProfilePage && handleSubmit" class="profile-form">
      <v-row class="ma-auto px-2 pt-5">
        <v-text-field 
        v-model="formData.email" 
        label="Email address*" 
        type="email" 
        placeholder="user_id@domain.com" 
        variant="outlined"
        readonly
        disabled
        required
        ></v-text-field>
      </v-row>

      <v-row>
        <v-col cols="6" class="ma-auto pa-5">
          <v-text-field 
            v-model="formData.full_name" 
            label="Full Name*" 
            placeholder="John Doe" 
            variant="outlined"
            clearable 
            required
            :rules="[v => !!v || 'Full name is required']"
          ></v-text-field>
        </v-col>

        <v-col cols="6" class="ma-auto pa-5">
          <v-text-field 
            v-model="formData.phone_number" 
            label="Phone Number*" 
            placeholder="+60123456789" 
            variant="outlined"
            clearable 
            required
            :rules="[v => !!v || 'Phone number is required']"
          ></v-text-field>
        </v-col>
      </v-row>

      <v-row class="ma-auto pa-2">
        <v-textarea 
          v-model="formData.street_address" 
          label="Street Address*" 
          placeholder="Enter Address" 
          variant="outlined"
          clearable   
          required
          :rules="[v => !!v || 'Street address is required']"
          rows="2"
        ></v-textarea>
      </v-row>
  
      <v-row>
        <v-col cols="6" class="ma-auto pa-5">
          <v-text-field 
            v-model="formData.city" 
            label="City*" 
            placeholder="City" 
            variant="outlined"
            required
            :rules="[v => !!v || 'City is required']"
            clearable
          ></v-text-field>
        </v-col>

        <v-col cols="6" class="ma-auto pa-5">
          <v-text-field
            v-model="formData.postcode"
            label="Postcode/ZIP*"
            placeholder="Enter Postcode/ZIP"
            variant="outlined"
            :rules="postCodeRules"
            maxlength="5"
            required
            clearable
          ></v-text-field>
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="6" class="ma-auto pa-5">
          <v-select
          v-model="formData.state"
          :items="states"
          label="State/Province*"
          variant="outlined"
          required
          :rules="[v => !!v || 'State is required']"
          clearable
          ></v-select>
        </v-col>

        <v-col cols="6" class="ma-auto pa-5">
          <v-text-field 
            v-model="formData.country" 
            label="Country"
            variant="outlined"
            readonly
            disabled
            value="Malaysia"
          ></v-text-field>
        </v-col>
      </v-row>

      <v-row class="ma-auto pa-5 justify-center">
        <v-card-actions v-if="isProfilePage">
          <v-spacer></v-spacer>
          <v-btn
            class="custom-btn mx-5"
            type="submit"
            @click="handleSubmit"
          >
            Update Profile
          </v-btn>
          <v-btn
            class="custom-btn mx-5"
            @click="showPasswordModal = true"
          >
            Change Password
          </v-btn>
        </v-card-actions>
      </v-row>
    </v-form>

    <!-- Password Change Dialog -->
    <v-dialog v-if='isProfilePage' v-model="showPasswordModal" max-width="500px">
      <v-card>
        <v-card-title>Change Password</v-card-title>
        <v-card-text>
          <!-- Add error alert -->
          <v-alert
            v-if="showPasswordErrorAlert"
            type="error"
            class="mb-4"
            closable
            @click:close="showPasswordErrorAlert = false"
          >
            {{ passwordErrorMessage }}
          </v-alert>

          <v-alert
            v-if="showPasswordSuccessAlert"
            type="success"
            class="mb-4"
            closable
            @click:close="showPasswordSuccessAlert = false"
          >
            Password updated successfully!
          </v-alert>

          <v-form @submit.prevent="updateUserPassword">
            <v-text-field
              v-model="passwordInfo.old_password"
              label="Current Password"
              :type="showPassword.old ? 'text' : 'password'"
              variant="outlined"
              :rules="[v => !!v || 'Current password is required']"
              :append-inner-icon="showPassword.old ? 'mdi-eye-off' : 'mdi-eye'"
              @click:append-inner="showPassword.old = !showPassword.old"
            ></v-text-field>

            <v-text-field
              v-model="passwordInfo.new_password"
              label="New Password"
              :type="showPassword.new ? 'text' : 'password'"
              variant="outlined"
              :rules="[v => !!v || 'New password is required']"
              :append-inner-icon="showPassword.new ? 'mdi-eye-off' : 'mdi-eye'"
              @click:append-inner="showPassword.new = !showPassword.new"
            ></v-text-field>

            <v-text-field
              v-model="passwordInfo.confirm_password"
              label="Confirm New Password"
              :type="showPassword.confirm ? 'text' : 'password'"
              variant="outlined"
              :rules="[
                v => !!v || 'Password confirmation is required',
                v => v === passwordInfo.new_password || 'Passwords do not match'
              ]"
              :append-inner-icon="showPassword.confirm ? 'mdi-eye-off' : 'mdi-eye'"
              @click:append-inner="showPassword.confirm = !showPassword.confirm"
            ></v-text-field>

            <!-- Add success alert for password change -->
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="error" type="button" @click="closePasswordModal">Cancel</v-btn>
              <v-btn color="primary" type="submit">Update Password</v-btn>
            </v-card-actions>
          </v-form>
        </v-card-text>
      </v-card>
    </v-dialog>

    
    <v-divider class="border-opacity-75" :thickness="4" color="#E324BD"></v-divider>
  </v-card>
</template>
  
<script setup>
  import { ref, computed, onMounted, watch, nextTick } from 'vue'
  import { storeToRefs } from 'pinia'
  import { useUserProfileStore } from '@/stores/profile'
  
  const props = defineProps({
    isProfilePage: {
      type: Boolean,
      default: false
    },
    showSuccessAlert: {
      type: Boolean,
      default: false
    }
  })

   // Update User Info
   const showSuccessAlert = ref(false)

  // Password Change - Dialog / Alert
  const showPasswordModal = ref(false)
  const showPassword = ref({
    old: false,
    new: false,
    confirm: false
  })

  const showPasswordSuccessAlert = ref(false)
  const showPasswordErrorAlert = ref(false)
  const passwordErrorMessage = ref('')

  const updateUserPassword = async () => {
    try {
      await userProfileStore.updateUserPassword(passwordInfo.value)
      showPasswordSuccessAlert.value = true

      setTimeout(() => {
        showPasswordSuccessAlert.value = false
        closePasswordModal()
      }, 3000)
      // Only close modal and reset form if update was successful

    } catch (error) {
      // Handle error response
      showPasswordErrorAlert.value = true
      passwordErrorMessage.value = error.response?.data?.message || 'Incorrect current password'
      setTimeout(() => {
        showPasswordErrorAlert.value = false
      }, 3000)
    }
  }

  const closePasswordModal = () => {
    showPasswordModal.value = false
    showPasswordErrorAlert.value = false // Reset error state
    showPasswordSuccessAlert.value = false // Reset success state
    passwordErrorMessage.value = '' // Reset error message
    passwordInfo.value = {
      old_password: '',
      new_password: '',
      confirm_password: ''
    }
  }
  
  const emit = defineEmits([
    'update:showSuccessAlert', 
    'showPasswordModal',
  ])
  
  const userProfileStore = useUserProfileStore()
  const { userInfo, passwordInfo } = storeToRefs(userProfileStore)
  const form = ref(null)
  
  const states = [
    'Johor', 
    'Kedah', 
    'Kelantan', 
    'Kuala Lumpur', 
    'Labuan', 
    'Melaka', 
    'Negeri Sembilan', 
    'Pahang', 
    'Penang', 
    'Perak', 
    'Perlis',
    'Putrajaya', 
    'Sabah', 
    'Sarawak', 
    'Selangor'
  ]

  const postCodeRules = [
    v => !!v || 'Postcode is required',
    v => /^.{5}$/.test(v) || 'Postcode must be 5 digits'
  ]
  
  // Form data that will be used in both contexts
  const formData = ref({
    email: '',
    full_name: '',
    phone_number: '',
    street_address: '',
    city: '',
    state: '',
    postcode: '',
    country: 'Malaysia'
  })
  
  // Handle submit only for profile page
  const handleSubmit = async () => {
    try {
      console.log('Submitting form data:', formData.value)
      await userProfileStore.updateUserInfo(formData.value)
      emit('update:showSuccessAlert', true)
      setTimeout(() => {
        emit('update:showSuccessAlert', false)
      }, 3000)
    } catch (error) {
        console.error('Error updating profile:', error)
    }
  }

  // Initialize form data
  onMounted(async () => {
    try {
      await userProfileStore.fetchUserInfo()
      formData.value = { ...userInfo.value }
    } catch (error) {
      console.error('Error fetching user info:', error)
    }
  })

  defineExpose({
    formData
  })

</script>
  
<style scoped>
    @import url('../assets/BitStreamFont/stylesheet.css');
    @import url('../assets/BPdotsFont/stylesheet.css');

    .custom-btn {
      background-color: #001655 !important;
      color: white !important;
    }

    /* Add hover effect (optional) */
    .custom-btn:hover {
      background-color: #4e0068 !important; /* slightly lighter shade for hover */
      box-shadow: 0 0 10px rgba(227, 36, 189, 0.5) !important;
    }
</style>