<template>
    <v-card style="background-color:#001655" class="ma-5 bitstream">
      <v-divider class="border-opacity-75" :thickness="4" color="#E324BD"></v-divider>
      <v-form>
        <v-row class="ma-auto pa-2">
          <v-text-field label="Email address*" v-model="email" type="email" placeholder="user_id@domain.com" clearable required></v-text-field>
        </v-row>
        <v-divider class="border-opacity-25 mb-3 mx-2"></v-divider>
        <v-row>
          <v-col cols="6" class="ma-auto pa-5">
            <v-text-field label="First Name*" v-model="firstName" placeholder="John" clearable required></v-text-field>
          </v-col>
          <v-col cols="6" class="ma-auto pa-5">
            <v-text-field label="Last Name*" v-model="lastName" placeholder="Doe" clearable required></v-text-field>
          </v-col>
        </v-row>
        <v-row class="ma-auto pa-2">
          <v-text-field label="Company Name" v-model="companyName" placeholder="optional" clearable></v-text-field>
        </v-row>
        <v-row class="ma-auto pa-2">
          <v-textarea label="Delivery Address" v-model="address" placeholder="Enter Address" clearable required></v-textarea>
        </v-row>
        <v-row>
          <v-col cols="6" class="ma-auto pa-5">
            <v-text-field label="City*" v-model="city" placeholder="City"></v-text-field>
          </v-col>
          <v-col cols="6" class="ma-auto pa-5">
            <v-text-field
              :rules="postCodeRules"
              label="Postcode/ZIP*"
              v-model="postcode"
              placeholder="Enter Postcode/ZIP"
              maxlength="5"
            ></v-text-field>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="6" class="ma-auto pa-5">
            <v-select
              label="State/Province*"
              v-model="state"
              :items="states"
            ></v-select>
          </v-col>
          <v-col cols="6" class="ma-auto pa-5">
            <v-text-field v-model="country" readonly>Malaysia</v-text-field>
          </v-col>
        </v-row>
      </v-form>
      <v-divider class="border-opacity-75" :thickness="4" color="#E324BD"></v-divider>
    </v-card>
  </template>
  
  <script>
  import { ref } from 'vue';
  import { usePostcodeRules } from '@/composables/unused/postCodeRules.js';
  
  export default {
    name: 'BillingForm',
    setup() {
      const email = ref('');
      const firstName = ref('');
      const lastName = ref('');
      const companyName = ref('');
      const address = ref('');
      const city = ref('');
      const postcode = ref('');
      const state = ref('');
      const states = ref(['Johor', 'Kedah', 'Kelantan', 'Kuala Lumpur', 'Labuan', 'Melaka', 'Negeri Sembilan', 'Pahang', 'Penang', 'Perak', 'Perlis',
        'Putrajaya', 'Sabah', 'Sarawak', 'Selangor',]);
      const country = ref('');
      const postCodeRules = usePostcodeRules();
  
      return {
        email,
        firstName,
        lastName,
        companyName,
        address,
        city,
        postcode,
        state,
        states,
        country,
        postCodeRules,
      };
    },
  };
  </script>