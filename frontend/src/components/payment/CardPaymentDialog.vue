<template>
    <v-dialog v-model="show" max-width="500px">
        <v-card class="pa-4">
            <v-card-title class="text-h5 text-center">Credit/Debit Card Payment</v-card-title>

            <v-card-text>
                <v-form v-model="cardFormValid">
                    <v-text-field
                        v-model="cardNumber"
                        label="Card Number"
                        placeholder="1234 5678 9012 3456"
                        maxlength="19"
                        :rules="cardNumberRules"  
                        @input="formatCardNumber"
                    />
                    <v-row>
                        <v-col cols="6">
                            <v-text-field
                                v-model="expiryDate"
                                label="MM/YY"
                                placeholder="MM/YY"
                                maxlength="5"
                                :rules="expiryDateRules"
                                @input="formatExpiryDate"
                            />
                        </v-col>

                        <v-col cols="6">
                            <v-text-field
                                v-model="cvv"
                                label="CVV"
                                type="password"
                                maxlength="3"
                                :rules="cvvRules"
                                @input="validateCvv"
                            />
                        </v-col>
                    </v-row>
                </v-form>
            </v-card-text>
            <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn 
                    :style="{ 
                        backgroundColor: '#E324BD',
                        color: 'white'  // This sets the text color
                    }"
                    @click="closeDialog"
                    :disabled="processing"
                >
                    Cancel
                </v-btn>
                <v-btn 
                    :style="{ 
                        backgroundColor: '#3E0054',
                        color: 'white'  // This sets the text color
                    }"
                    :disabled="!cardFormValid"
                    @click="processPayment"
                    :loading="processing"
                >
                    Pay RM {{ total.toFixed(2) }}
                </v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>

    <!-- Add Snackbar -->
    <v-snackbar
        v-model="showSnackbar"
        :color="snackbarColor"
        timeout="3000"
        location="top"
    >
    {{ snackbarMessage }}
    </v-snackbar>
</template>

<script setup>
    import { ref, watch } from 'vue'

    const props = defineProps({
        modelValue: Boolean,
        total: Number
    })

    const emit = defineEmits(['update:modelValue', 'payment-processed'])

    const show = ref(props.modelValue)
    const cardFormValid = ref(false)
    const cardNumber = ref('')
    const expiryDate = ref('')
    const cvv = ref('')

    // Validation Rules
    const cardNumberRules = [
        v => !!v || 'Card number is required',
        v => {
            const num = v.replace(/\s/g, '')
            return /^[3-5]\d{15}$/.test(num) || 'Card number must start with 3, 4, or 5 and be 16 digits'
        },
        v => {
            const num = v.replace(/\s/g, '')
            return num.length === 16 || 'Card number must be 16 digits'
        }
    ]

    // Format helpers
    const formatCardNumber = (event) => {
        let value = cardNumber.value.replace(/\s/g, '').replace(/\D/g, '')
        
        // Format with spaces every 4 digits
        if (value.length > 0) {
            value = value.match(new RegExp('.{1,4}', 'g')).join(' ')
        }
        
        // Limit to 16 digits (19 chars including spaces)
        cardNumber.value = value.substring(0, 19)
    }

    const expiryDateRules = [
        v => !!v || 'Expiry date is required',
        v => {
            if (!v) return true
            const [month, year] = v.split('/')
            const currentYear = new Date().getFullYear() % 100 // Get last 2 digits of current year
            const currentMonth = new Date().getMonth() + 1 // Get current month (1-12)
            
            // Check month is valid
            if (!/^\d{2}$/.test(month) || parseInt(month) < 1 || parseInt(month) > 12) {
                return 'Invalid month'
            }
            
            // Check year is valid
            if (!/^\d{2}$/.test(year) || parseInt(year) < currentYear) {
                return 'Year must be greater than or equal to current year'
            }
            
            // If same year, check month is not in past
            if (parseInt(year) === currentYear && parseInt(month) < currentMonth) {
                return 'Card has expired'
            }
            
            return true
        }
    ]

    const formatExpiryDate = (event) => {
        let value = expiryDate.value.replace(/\D/g, '')
        
        if (value.length >= 2) {
            const month = value.substring(0, 2)
            const year = value.substring(2, 4)
            
            // Ensure month is not greater than 12
            if (parseInt(month) > 12) {
                value = '12' + year
            }
            
            value = month + (year.length ? '/' + year : '')
        }
        
        expiryDate.value = value
    }

    const cvvRules = [
        v => !!v || 'CVV is required',
        v => /^\d{3}$/.test(v) || 'CVV must be 3 digits'
    ]

    const validateCvv = (event) => {
        cvv.value = cvv.value.replace(/\D/g, '').substring(0, 3)
    }

    const processing = ref(false)
    const snackbarColor = ref('success')
    const showSnackbar = ref(false)
    const snackbarMessage = ref('')

    const processPayment = async () => {
        if (!cardFormValid.value) return

        processing.value = true
        try {
            // Simulate initial processing
            await new Promise(resolve => setTimeout(resolve, 1500))
            // Emit event first and wait for parent to process
            const result = await new Promise((resolve, reject) => {
                emit('payment-processed', {
                    status: 'success',
                    method: 'card',
                    refnum: cardNumber.value.slice(-4),
                    resolve,
                    reject
                })
            })

            // Only show success if parent processing succeeded
            snackbarColor.value = 'success'
            snackbarMessage.value = 'Payment processed successfully and order placed.'
            showSnackbar.value = true

            setTimeout(() => { closeDialog() }, 3000)

        } catch (error) {
            snackbarColor.value = 'error'
            snackbarMessage.value = typeof error === 'string' ? error : 'Payment failed. Please try again.'
            showSnackbar.value = true
            
            // Keep dialog open on error
            setTimeout(() => {
                showSnackbar.value = false
                closeDialog()
            }, 3000)
        } finally {
            processing.value = false
        }
    }

    const closeDialog = () => {
        show.value = false
        cardNumber.value = ''
        expiryDate.value = ''
        cvv.value = ''
        cardFormValid.value = false
        processing.value = false
    }

    watch(() => props.modelValue, (newVal) => {
        show.value = newVal
    })

    watch(show, (newVal) => {
        emit('update:modelValue', newVal)
    })
    </script>