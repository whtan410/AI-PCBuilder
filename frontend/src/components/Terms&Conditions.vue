<template>
    <v-checkbox
        v-model="localIsAgreed"
        :rules="[rules.required]"
        required
        hide-details
    >
    <template v-slot:label>
        <div>
            I have read and agree to the
            <v-tooltip location="bottom">
                <template v-slot:activator>
                    <a
                        href="#"
                        class="link"
                    >
                    Terms and Conditions
                    </a>
                </template>
            </v-tooltip>
        </div>
    </template>
    </v-checkbox>
  </template>
  
  <script>
  import { ref } from 'vue';
  
  export default {
    name: 'TermsAndConditions',
    props: {
      isAgreed: {
        type: Boolean,
        default: false,
      },
    },
    data() {
      return {
        localIsAgreed: this.isAgreed,
        rules: {
          required: (value) => !!value || 'You must agree to the terms and conditions',
        },
      };
    },
    watch: {
      localIsAgreed(newValue) {
        this.$emit('update:isAgreed', newValue);
      },
    },
  };
  </script>