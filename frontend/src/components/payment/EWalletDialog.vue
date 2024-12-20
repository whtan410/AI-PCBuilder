<template>
    <v-dialog v-model="show" max-width="500px">
        <v-card class="pa-4">
            <v-card-title class="text-h5 text-center mb-4">Touch 'n Go eWallet Payment</v-card-title>
            
            <v-card-text>
                <v-alert
                    type="info"
                    variant="tonal"
                    class="mb-4"
                >
                    Please scan the QR code to make payment:
                </v-alert>

                <!-- Amount Display -->
                <div class="text-center mb-4">
                    <div class="text-h6">Amount to Pay</div>
                    <div class="text-h4 font-weight-bold">RM {{ total.toFixed(2) }}</div>
                </div>

                <!-- TnG Logo -->
                <div class="text-center mb-4">
                    <v-img
                        src="https://ik.imagekit.io/yz1n0vis7/Tan_Han_blue_background,_touchngo_white_font_,_eWallet_yel_6f7f621f-acbb-41de-b0ec-7a293999a82d.png"
                        class="mx-auto"
                        max-width="150"
                    ></v-img>
                </div>

                <!-- QR Code Section -->
                <div class="text-center mb-6">
                    <v-img
                        src="https://ik.imagekit.io/yz1n0vis7/moonarch.png"
                        class="mx-auto"
                        max-width="200"
                    ></v-img>
                </div>

                <!-- Reference Number -->
                <v-text-field
                    v-model="referenceNumber"
                    :rules="referenceRules"
                    label="TNG Transaction ID"
                    placeholder="Enter your TNG transaction reference"
                    density="compact"
                    class="mt-4"
                ></v-text-field>
            </v-card-text>

            <!-- Action Buttons -->
            <v-card-actions>
                <v-spacer></v-spacer>
                <v-btn 
                    bg-color="#E324BD"
                    color="white"
                    @click="closeDialog"
                    :disabled="processing"
                >
                    Cancel
                </v-btn>
                <v-btn 
                    bg-color="#3E0054"
                    color="white"
                    :disabled="!isValid"
                    @click="confirmPayment"
                    :loading="processing"
                >
                    Confirm Payment
                </v-btn>
            </v-card-actions>

        </v-card>
    </v-dialog>

    <!-- Success Snackbar -->
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
    import { ref, watch, computed } from 'vue'

    const props = defineProps({
        modelValue: Boolean,
        total: Number
    })

    const emit = defineEmits(['update:modelValue', 'payment-processed'])

    // State
    const show = ref(props.modelValue)
    const referenceNumber = ref('')
    const processing = ref(false)
    const showSnackbar = ref(false)
    const snackbarMessage = ref('')
    const snackbarColor = ref('success')

    // Validation rules
    const referenceRules = [
        v => !!v || 'Transaction ID is required',
        v => v.length >= 6 || 'Transaction ID should be at least 6 characters'
    ]

    // Computed
    const isValid = computed(() => {
        return referenceNumber.value.length >= 6
    })

    // Watchers
    watch(() => props.modelValue, (newVal) => {
        show.value = newVal
    })

    watch(show, (newVal) => {
        emit('update:modelValue', newVal)
    })

    const confirmPayment = async () => {
        if (!isValid.value) return

        processing.value = true
        try {
            // Simulate initial processing
            await new Promise(resolve => setTimeout(resolve, 1500))
            
            // Emit event and wait for parent to process
            await new Promise((resolve, reject) => {
                emit('payment-processed', {
                    status: 'success',
                    method: 'tng_ewallet',
                    refnum: referenceNumber.value,
                    resolve,
                    reject
                })
            })

            // Only show success if parent processing succeeded
            snackbarColor.value = 'success'
            snackbarMessage.value = 'Touch n Go payment confirmed successfully and order placed.'
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

    // Methods
    const closeDialog = () => {
        show.value = false
        referenceNumber.value = ''
        processing.value = false
    }

</script>