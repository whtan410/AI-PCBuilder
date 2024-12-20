<template>
    <v-list-item>
      <v-radio-group v-model="localSelectedPaymentMethod" color="#E324BD">
        <v-radio label="Payment Method A" value="A"></v-radio>
        <v-radio label="Payment Method B" value="B"></v-radio>
        <v-radio label="Payment Method C" value="C"></v-radio>
      </v-radio-group>
    </v-list-item>
  </template>
  
  <script>
import { ref } from 'vue';
  
  export default {
    name: 'PaymentMethod',
    props: {
      selectedPaymentMethod: {
        type: String,
        default: null,
      },
    },
    data() {
      return {
        localSelectedPaymentMethod: this.selectedPaymentMethod,
      };
    },
    watch: {
      localSelectedPaymentMethod(newValue) {
        this.$emit('update:selectedPaymentMethod', newValue);
      },
    },
  };
  </script>