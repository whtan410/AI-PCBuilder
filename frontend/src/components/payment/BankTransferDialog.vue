<template>
    <v-dialog v-model="show" max-width="500px">
        <v-card class="pa-4">
            <v-card-title class="text-h5 mb-4">Bank Transfer Payment</v-card-title>
            
            <!-- Bank Details Section -->
            <v-card-text>
                <v-alert
                    type="info"
                    variant="tonal"
                    class="mb-4"
                >
                    Please transfer the exact amount to the following bank account:
                </v-alert>

                <v-list lines="one">
                    <v-list-item>
                        <template v-slot:prepend>
                            <v-icon icon="mdi-bank"></v-icon>
                        </template>
                        <v-list-item-title>Bank Name</v-list-item-title>
                        <v-list-item-subtitle>MoonArch Bank</v-list-item-subtitle>
                    </v-list-item>

                    <v-list-item>
                        <template v-slot:prepend>
                            <v-icon icon="mdi-card"></v-icon>
                        </template>
                        <v-list-item-title>Account Number</v-list-item-title>
                        <v-list-item-subtitle class="d-flex align-center">
                            1234-5678-9012
                            <v-btn
                                density="compact"
                                variant="text"
                                icon="mdi-content-copy"
                                size="small"
                                @click="copyToClipboard('1234-5678-9012')"
                            ></v-btn>
                        </v-list-item-subtitle>
                    </v-list-item>

                    <v-list-item>
                        <template v-slot:prepend>
                            <v-icon icon="mdi-account"></v-icon>
                        </template>
                        <v-list-item-title>Account Name</v-list-item-title>
                        <v-list-item-subtitle>MoonArch Enterprise</v-list-item-subtitle>
                    </v-list-item>

                    <v-list-item>
                        <template v-slot:prepend>
                            <v-icon icon="mdi-cash"></v-icon>
                        </template>
                        <v-list-item-title>Amount to Transfer</v-list-item-title>
                        <v-list-item-subtitle class="font-weight-bold">
                            RM {{ total.toFixed(2) }}
                        </v-list-item-subtitle>
                    </v-list-item>
                </v-list>

                <!-- Upload Payment Proof -->
                <v-divider class="my-4"></v-divider>
                
                <div class="mb-4">
                    <div class="text-subtitle-1 mb-2">Upload Payment Proof</div>
                    <v-file-input
                        v-model="paymentProof"
                        :rules="proofRules"
                        accept="image/*"
                        placeholder="Select your payment receipt"
                        prepend-icon="mdi-camera"
                        label="Payment Receipt"
                        :show-size="true"
                        density="compact"
                        :error-messages="paymentProof?.size > 5000000 ? 'File size should be less than 5MB' : ''"
                    ></v-file-input>
                </div>

                <!-- Reference Number -->
                <v-text-field
                    v-model="referenceNumber"
                    :rules="referenceRules"
                    label="Transfer Reference Number"
                    placeholder="Enter your bank transfer reference"
                    density="compact"
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
                    @click="confirmTransfer"
                    :loading="processing"
                    
                >
                    Confirm Transfer
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

    const show = ref(props.modelValue)
    const paymentProof = ref(null)
    const referenceNumber = ref('')

    // Validation rules
    const proofRules = [
        v => {
            if (!v) return 'Payment proof is required'
            if (v.size > 5000000) return 'File size should be less than 5MB'
            return true
        }
    ]

    const referenceRules = [
        v => !!v || 'Reference number is required',
        v => v.length >= 6 || 'Reference number should be at least 6 characters'
    ]

    // Updated isValid computed property
    const isValid = computed(() => {
        if (!paymentProof.value || !referenceNumber.value) return false
        return paymentProof.value.size <= 5000000 && referenceNumber.value.length >= 6
    })

    // Watch for dialog state changes
    watch(() => props.modelValue, (newVal) => {
        show.value = newVal
    })

    watch(show, (newVal) => {
        emit('update:modelValue', newVal)
    })

    // Methods
    const copyToClipboard = async (text) => {
        try {
            await navigator.clipboard.writeText(text)
            snackbarMessage.value = 'Account number copied to clipboard'
            showSnackbar.value = true
        } catch (err) {
            console.error('Failed to copy text: ', err)
        }
    }

    const processing = ref(false)
    const snackbarColor = ref('success')
    const showSnackbar = ref(false)
    const snackbarMessage = ref('')

    const confirmTransfer = async () => {
        if (!isValid.value) return

        processing.value = true
        try {
            // Simulate initial processing
            await new Promise(resolve => setTimeout(resolve, 1500))
            
            // Emit event and wait for parent to process
            await new Promise((resolve, reject) => {
                emit('payment-processed', {
                    status: 'success',
                    method: 'bank_transfer',
                    refnum: referenceNumber.value,
                    resolve,
                    reject
                })
            })

            // Only show success if parent processing succeeded
            snackbarColor.value = 'success'
            snackbarMessage.value = 'Transfer confirmation submitted successfully and order placed.'
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
        paymentProof.value = null
        referenceNumber.value = ''
    }
</script>

<style scoped>
    .v-list-item-subtitle {
        opacity: 1 !important;
    }
</style>