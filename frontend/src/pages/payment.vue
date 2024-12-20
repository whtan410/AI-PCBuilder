<template>
    <div class="container">
        <v-container fluid class="pa-0">
            <v-row class="text-h2 ml-10 bpdots saturation text-shadow" :style="{ textShadow: '2px 2px 5px #FF66FF' }">
                <div>BILLING DETAILS </div>
                <v-divider class="border-opacity-50 mr-12" :thickness="3"></v-divider>
            </v-row>

            <v-row class="ma-0">
                <v-col cols="12" md="6" class="pa-4">
                    <ProfileForm
                        ref="profileFormRef"
                        :isProfilePage="false"
                    />
                </v-col>

                <v-col cols="12" md="6" class="pa-4 bitstream">
                    <OrderSummary
                        ref="orderSummaryRef"
                        :cart-items="cartStore.cartItems"
                        :cart-total="cartStore.cartTotal"
                    />
                </v-col>
            </v-row>

            <!-- Payment Button -->
            <v-row>
                <v-col cols="12" class="text-center mb-2">
                    <v-btn
                    color="#E324BD"
                    :disabled="!isFormValid"
                    @click="handleSubmit"
                    elevated="12"
                    prepend-icon="mdi-check-circle-outline"
                    rounded="100"
                    >
                    Pay Now
                    </v-btn>
                </v-col>
            </v-row>

            <CardPaymentDialog
                v-model="showCardDialog"
                :total="cartStore.cartTotal"
                @payment-processed="handlePaymentSuccess"
            />

            <BankTransferDialog
                v-model="showBankDialog"
                :total="cartStore.cartTotal"
                @payment-processed="handlePaymentSuccess"
            />

            <EWalletDialog
                v-model="showEWalletDialog"
                :total="cartStore.cartTotal"
                @payment-processed="handlePaymentSuccess"
            />

        </v-container>
    </div>
</template>
  
<script setup>
    import { ref, computed, onMounted } from 'vue'
    import { useRouter } from 'vue-router'

    import { useCartStore } from '@/stores/cartstore'
    import { useCheckoutStore } from '@/stores/checkoutStore'
    import { useOrderStore } from '@/stores/orderStore'

    import ProfileForm from '@/components/ProfileForm.vue'
    import OrderSummary from '@/components/OrderSummary.vue'
    import CardPaymentDialog from '@/components/payment/CardPaymentDialog.vue'
    import BankTransferDialog from '@/components/payment/BankTransferDialog.vue'
    import EWalletDialog from '@/components/payment/EWalletDialog.vue'
    
    const router = useRouter()
    const cartStore = useCartStore()
    const checkoutStore = useCheckoutStore()
    const orderStore = useOrderStore()

    // Form and payment states
    const profileFormRef = ref(null)
    const orderSummaryRef = ref(null)

    const isFormValid = computed(() => {
        if (!profileFormRef.value || !orderSummaryRef.value) return false
        
        // Profile form validation
        const hasValidProfile = profileFormRef.value.formData &&
            profileFormRef.value.formData.full_name &&
            profileFormRef.value.formData.phone_number &&
            profileFormRef.value.formData.street_address &&
            profileFormRef.value.formData.city &&
            profileFormRef.value.formData.state &&
            profileFormRef.value.formData.postcode

        // Order summary validation
        const hasValidOrder = orderSummaryRef.value.paymentMethod &&
            orderSummaryRef.value.termsAccepted &&
            cartStore.cartItems.length > 0

        return hasValidProfile && hasValidOrder
    })

    const showCardDialog = ref(false)
    const showBankDialog = ref(false)
    const showEWalletDialog = ref(false)

    const handleSubmit = async () => {
        if (!isFormValid.value) return

        switch(orderSummaryRef.value.paymentMethod) {
            case 'card':
                showCardDialog.value = true
                break
            case 'bank':
                showBankDialog.value = true
                break
            case 'ewallet':
                showEWalletDialog.value = true
                break
        }
    }

    const handlePaymentSuccess = async (paymentDetails) => {
        const { resolve, reject, ...paymentInfo } = paymentDetails

        try {   
            const result = await orderStore.createOrder(
                profileFormRef.value.formData,
                paymentInfo,
                orderSummaryRef.value
        )

        // If successful, resolve the promise from dialog
        resolve()

        // Wait 5 seconds before redirecting (giving time for dialog close and snackbar)
        await new Promise(resolve => setTimeout(resolve, 5000))

        // Redirect to home with success message
        router.push({
            path: '/profile',
            query: {    
                payment: 'success',
                ref: paymentInfo.reference 
            }       
        })
        } catch (error) {
            console.error('Payment processing failed:', error)
            let errorMessage = 'Payment processing failed'
            if (error.response && error.response.data) {
                errorMessage = error.response.data.detail || error.response.data.message || errorMessage
            }
            reject(errorMessage)
        }
    }


    //fetch cart data
    onMounted(async () => {

        if (!checkoutStore.isCheckoutInitiated) {
            router.push('/cart')
        }
        await cartStore.fetchCartItems()
    })

</script>


<style>
    @import url('../assets/BitStreamFont/stylesheet.css');
    @import url('../assets/BPdotsFont/stylesheet.css');

    .container {
    background: linear-gradient(rgba(0, 0, 0, 0.8), rgba(0, 0, 0, 0.2)), url("https://mir-s3-cdn-cf.behance.net/project_modules/fs/223e6792880429.5e569ff84ebef.gif");
    }

    .saturation{
    filter:saturate(10);
    }
</style>